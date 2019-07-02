Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78AFC5CB47
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727868AbfGBII6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:08:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:56676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727705AbfGBII6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:08:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C69E21841;
        Tue,  2 Jul 2019 08:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054937;
        bh=7+KiisQO44b+0B8ltKPR+aTQjmKfAoUAKi7Tw5GLKvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tlqcGE3RbyhQPUqLQ51WP4icD+QumADN1k7L+rCIvom7YmSI3AfmpcnWvlUuEzIGa
         lmHI+vwEN9mH4hoxoK3bJZ56dK/GMAFPO6GCVs2kRRFxFwl6lmgqbKSaxrXQtnuo2t
         bQoUff10e7rgI84DGh6UmiiHsfqt3lpfzuwOBxLk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominique Martinet <dominique.martinet@cea.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 12/43] 9p: p9dirent_read: check network-provided name length
Date:   Tue,  2 Jul 2019 10:01:52 +0200
Message-Id: <20190702080124.447367850@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080123.904399496@linuxfoundation.org>
References: <20190702080123.904399496@linuxfoundation.org>
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
index 766d1ef4640a..1885403c9a3e 100644
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



