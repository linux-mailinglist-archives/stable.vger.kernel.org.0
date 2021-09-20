Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE79411A72
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243968AbhITQty (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:49:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:37284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244167AbhITQtV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:49:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C8E561268;
        Mon, 20 Sep 2021 16:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156471;
        bh=U0ivsL+p/Bybv6MJJLx6mOVguINXSD7DdKyoaTp+NS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p7tK1s3q1PJIzPqxttxhrpMRkqGRPlGub8tytPPrw1iyx7jhdIbcPOTtnUwHAC4ff
         2QuLgkPub86+0PfPKX9mhesYG4Yek+t1r/EDIBcBfWbo+b13Ex/FQDcphiU4F80Yom
         hOg1JOmza+4QVyMft+0O6+qnAmTud7ngor4RHtXY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+be2baed593ea56c6a84c@syzkaller.appspotmail.com
Subject: [PATCH 4.4 057/133] Bluetooth: add timeout sanity check to hci_inquiry
Date:   Mon, 20 Sep 2021 18:42:15 +0200
Message-Id: <20210920163914.519398792@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163912.603434365@linuxfoundation.org>
References: <20210920163912.603434365@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit f41a4b2b5eb7872109723dab8ae1603bdd9d9ec1 ]

Syzbot hit "task hung" bug in hci_req_sync(). The problem was in
unreasonable huge inquiry timeout passed from userspace.
Fix it by adding sanity check for timeout value to hci_inquiry().

Since hci_inquiry() is the only user of hci_req_sync() with user
controlled timeout value, it makes sense to check timeout value in
hci_inquiry() and don't touch hci_req_sync().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-and-tested-by: syzbot+be2baed593ea56c6a84c@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index bf69bfd0b475..eefaa10c74db 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1357,6 +1357,12 @@ int hci_inquiry(void __user *arg)
 		goto done;
 	}
 
+	/* Restrict maximum inquiry length to 60 seconds */
+	if (ir.length > 60) {
+		err = -EINVAL;
+		goto done;
+	}
+
 	hci_dev_lock(hdev);
 	if (inquiry_cache_age(hdev) > INQUIRY_CACHE_AGE_MAX ||
 	    inquiry_cache_empty(hdev) || ir.flags & IREQ_CACHE_FLUSH) {
-- 
2.30.2



