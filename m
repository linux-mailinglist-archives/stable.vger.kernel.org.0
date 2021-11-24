Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 211E745C0D5
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:08:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346493AbhKXNL4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:11:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:47544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343901AbhKXNJw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:09:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6C47613B1;
        Wed, 24 Nov 2021 12:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757661;
        bh=LWmrlAyRHjL2tMGB7OPivzvCmM5nO4jCdBzxwSyOBDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ql5hw2YEHwxg4FKqpHOJ7gYBk5SZGPWbn1nYt1vkJ6YKgIck2MHox8E76wlgX47MS
         bvjy8x0QNAadSFyUFiJT4wpeWWyq6hYYuLvmzUB+x70dwJt8Q4Fq3qJex2/Z2NcRot
         82kPlKg6d6iadiov0+vBMFWgN2peALOcoWQT2eaU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+06472778c97ed94af66d@syzkaller.appspotmail.com,
        Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH 4.19 236/323] 9p/net: fix missing error check in p9_check_errors
Date:   Wed, 24 Nov 2021 12:57:06 +0100
Message-Id: <20211124115726.888841089@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dominique Martinet <asmadeus@codewreck.org>

commit 27eb4c3144f7a5ebef3c9a261d80cb3e1fa784dc upstream.

Link: https://lkml.kernel.org/r/99338965-d36c-886e-cd0e-1d8fff2b4746@gmail.com
Reported-by: syzbot+06472778c97ed94af66d@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/9p/client.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -553,6 +553,8 @@ static int p9_check_errors(struct p9_cli
 		kfree(ename);
 	} else {
 		err = p9pdu_readf(&req->rc, c->proto_version, "d", &ecode);
+		if (err)
+			goto out_err;
 		err = -ecode;
 
 		p9_debug(P9_DEBUG_9P, "<<< RLERROR (%d)\n", -ecode);


