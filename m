Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4968B408FE6
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240346AbhIMNrj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:47:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:46740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242295AbhIMNpd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:45:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED2D960F26;
        Mon, 13 Sep 2021 13:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539904;
        bh=lDcib7FFmXZ7UrSzzSuEI54ccpbD0GYHCnYbrpM6zVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ygRv7BE8SB0v77nxHVvxBe1CsD02erLGSatfZs6YcOGC3RJvEpK3VitcNMkdMZ6ff
         737QgsMuR/fOVzkZE1KqFpnAmpR7idAvQO6+ICc8pdDyojYGkUEARYmLAxELsK9WZv
         IgPz3gSDytQPbKILDBOfVFyP3CNNsaJWcMjPLydw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+be2baed593ea56c6a84c@syzkaller.appspotmail.com
Subject: [PATCH 5.10 175/236] Bluetooth: add timeout sanity check to hci_inquiry
Date:   Mon, 13 Sep 2021 15:14:40 +0200
Message-Id: <20210913131106.327002864@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
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
index 2f1868e426ab..a9097fb7eb82 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1336,6 +1336,12 @@ int hci_inquiry(void __user *arg)
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



