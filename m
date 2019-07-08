Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68D87621AA
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733011AbfGHPST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:18:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:42040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733007AbfGHPSS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:18:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D500B21537;
        Mon,  8 Jul 2019 15:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599097;
        bh=BWQn4Y4qK6HbYLiSOpGlpq0TsqilyQe9mQ1+O4E9Qk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IUZeVz6HFh2BMrSSNRM8//lZIZMILlTFu94m9LjnNExMAh1rLJqc7aFiy12pUUp8G
         qeJzPUz4GtUdVhynvf4NjX1B6237e1vmU7fkwyQCyKlH1gAOMN//KqsGO7D+kQmvhC
         SD+JY4Ys2aUExTcF7k0kMTWFXY3V5MOkTLOeNDaQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominique Martinet <dominique.martinet@cea.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 34/73] 9p: p9dirent_read: check network-provided name length
Date:   Mon,  8 Jul 2019 17:12:44 +0200
Message-Id: <20190708150523.138424521@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150513.136580595@linuxfoundation.org>
References: <20190708150513.136580595@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit ef5305f1f72eb1cfcda25c382bb0368509c0385b ]

strcpy to dirent->d_name could overflow the buffer, use strscpy to check
the provided string length and error out if the size was too big.

While we are here, make the function return an error when the pdu
parsing failed, instead of returning the pdu offset as if it had been a
success...

Link: http://lkml.kernel.org/r/1536339057-21974-4-git-send-email-asmadeus@codewreck.org
Addresses-Coverity-ID: 139133 ("Copy into fixed size buffer")
Signed-off-by: Dominique Martinet <dominique.martinet@cea.fr>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/protocol.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/9p/protocol.c b/net/9p/protocol.c
index 7f1b45c082c9..ed1e39ccaebf 100644
--- a/net/9p/protocol.c
+++ b/net/9p/protocol.c
@@ -622,13 +622,19 @@ int p9dirent_read(struct p9_client *clnt, char *buf, int len,
 	if (ret) {
 		p9_debug(P9_DEBUG_9P, "<<< p9dirent_read failed: %d\n", ret);
 		trace_9p_protocol_dump(clnt, &fake_pdu);
-		goto out;
+		return ret;
 	}
 
-	strcpy(dirent->d_name, nameptr);
+	ret = strscpy(dirent->d_name, nameptr, sizeof(dirent->d_name));
+	if (ret < 0) {
+		p9_debug(P9_DEBUG_ERROR,
+			 "On the wire dirent name too long: %s\n",
+			 nameptr);
+		kfree(nameptr);
+		return ret;
+	}
 	kfree(nameptr);
 
-out:
 	return fake_pdu.offset;
 }
 EXPORT_SYMBOL(p9dirent_read);
-- 
2.20.1



