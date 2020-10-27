Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67D6729B720
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1798635AbgJ0P3W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:29:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:45642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1798622AbgJ0P3S (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:29:18 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E31CB22202;
        Tue, 27 Oct 2020 15:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812557;
        bh=+oDV1cDTE0CXq2Ecxk6Ss5XcQr1jVoGwFy11UzW+Qu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B1vkHQHMQ7IG8I32sZY2w5RYBsmcg+Lm4D3EO5R2DZNkU5dDhdaMoCPdAk9YLsQg0
         tjyeRD2MERwV95vtY4afotXXi3vkJGPfwrt3ukCYB1oAi6tuR+QJ01LPjNc0dJvxda
         a8OGDMmhmG2sGZITsTdlzADnisxi3AZQ9g2drAHk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peilin Ye <yepeilin.cs@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+f7f6e564f4202d8601c6@syzkaller.appspotmail.com
Subject: [PATCH 5.9 252/757] Bluetooth: Fix memory leak in read_adv_mon_features()
Date:   Tue, 27 Oct 2020 14:48:22 +0100
Message-Id: <20201027135502.388692690@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peilin Ye <yepeilin.cs@gmail.com>

[ Upstream commit cafd472a10ff3bccd8afd25a69f20a491cd8d7b8 ]

read_adv_mon_features() is leaking memory. Free `rp` before returning.

Fixes: e5e1e7fd470c ("Bluetooth: Add handler of MGMT_OP_READ_ADV_MONITOR_FEATURES")
Reported-and-tested-by: syzbot+f7f6e564f4202d8601c6@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=f7f6e564f4202d8601c6
Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 5758ccb524ef7..12a7cc9840b4d 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -4162,7 +4162,7 @@ static int read_adv_mon_features(struct sock *sk, struct hci_dev *hdev,
 {
 	struct adv_monitor *monitor = NULL;
 	struct mgmt_rp_read_adv_monitor_features *rp = NULL;
-	int handle;
+	int handle, err;
 	size_t rp_size = 0;
 	__u32 supported = 0;
 	__u16 num_handles = 0;
@@ -4197,9 +4197,13 @@ static int read_adv_mon_features(struct sock *sk, struct hci_dev *hdev,
 	if (num_handles)
 		memcpy(&rp->handles, &handles, (num_handles * sizeof(u16)));
 
-	return mgmt_cmd_complete(sk, hdev->id,
-				 MGMT_OP_READ_ADV_MONITOR_FEATURES,
-				 MGMT_STATUS_SUCCESS, rp, rp_size);
+	err = mgmt_cmd_complete(sk, hdev->id,
+				MGMT_OP_READ_ADV_MONITOR_FEATURES,
+				MGMT_STATUS_SUCCESS, rp, rp_size);
+
+	kfree(rp);
+
+	return err;
 }
 
 static int add_adv_patterns_monitor(struct sock *sk, struct hci_dev *hdev,
-- 
2.25.1



