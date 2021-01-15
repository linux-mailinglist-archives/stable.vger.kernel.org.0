Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B35F2F7B6C
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 14:02:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733027AbhAOMcx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:32:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:39656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733017AbhAOMcw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:32:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52EB8235F8;
        Fri, 15 Jan 2021 12:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610713931;
        bh=earb/xTFB38cqQE7OvLBkid4oTdP+Gzcbt67FueACao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wxvI6G8pmfuAK2Y5raGEiSJu/wmw0rr1235FliVEia6EvPG2vemvZxWHs54APb/P6
         oDTeOpp9ODk1XjbhEFW7z7N7OWxXITd1kdA/K5u5SDILcX1g4Os/B4SIN4r/wD37h/
         9Wr93OOAxKHdTou+NHAKJ2BQR5H++f2GHnx7qQzA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 14/43] chtls: Added a check to avoid NULL pointer dereference
Date:   Fri, 15 Jan 2021 13:27:44 +0100
Message-Id: <20210115121957.733857231@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121957.037407908@linuxfoundation.org>
References: <20210115121957.037407908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ayush Sawal <ayush.sawal@chelsio.com>

[ Upstream commit eade1e0a4fb31d48eeb1589d9bb859ae4dd6181d ]

In case of server removal lookup_stid() may return NULL pointer, which
is used as listen_ctx. So added a check before accessing this pointer.

Fixes: cc35c88ae4db ("crypto : chtls - CPL handler definition")
Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/chelsio/chtls/chtls_cm.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/crypto/chelsio/chtls/chtls_cm.c
+++ b/drivers/crypto/chelsio/chtls/chtls_cm.c
@@ -1432,6 +1432,11 @@ static int chtls_pass_establish(struct c
 			sk_wake_async(sk, 0, POLL_OUT);
 
 		data = lookup_stid(cdev->tids, stid);
+		if (!data) {
+			/* listening server close */
+			kfree_skb(skb);
+			goto unlock;
+		}
 		lsk = ((struct listen_ctx *)data)->lsk;
 
 		bh_lock_sock(lsk);


