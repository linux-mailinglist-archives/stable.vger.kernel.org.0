Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6E5A40E7CA
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349688AbhIPRnI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:43:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:53746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353963AbhIPRh5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:37:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F0511615A2;
        Thu, 16 Sep 2021 16:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810984;
        bh=NHcXO79jXv10lKu0O6cfzY4KRkcVlLCMuWwriAIMQc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T9MV15ub3jFzJK0gkLGVDjMoKUmCAD0om3AEaACW5ta8AIvjxJJqsGJ8Z+yJm2+nb
         XsjnSSlsKE02LE/1ghBfsL1a/odSOuGrq1o2/4qq9Jr4LvW3gsY+7JaQQNm48Eo026
         dW+Ap/Cd/sfLbyQBoiBeSs2UH9MHzgb/LrwlNDMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kiran K <kiran.k@intel.com>,
        Chethan T N <chethan.tumkur.narayan@intel.com>,
        Srivatsa Ravishankar <ravishankar.srivatsa@intel.com>,
        Manish Mandlik <mmandlik@google.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 308/432] Bluetooth: Fix race condition in handling NOP command
Date:   Thu, 16 Sep 2021 18:00:57 +0200
Message-Id: <20210916155821.256941877@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kiran K <kiran.k@intel.com>

[ Upstream commit ecb71f2566673553bc067e5b0036756871d0b9d3 ]

For NOP command, need to cancel work scheduled on cmd_timer,
on receiving command status or commmand complete event.

Below use case might lead to race condition multiple when NOP
commands are queued sequentially:

hci_cmd_work() {
   if (atomic_read(&hdev->cmd_cnt) {
            .
            .
            .
      atomic_dec(&hdev->cmd_cnt);
      hci_send_frame(hdev,...);
      schedule_delayed_work(&hdev->cmd_timer,...);
   }
}

On receiving event for first NOP, the work scheduled on hdev->cmd_timer
is not cancelled and second NOP is dequeued and sent to controller.

While waiting for an event for second NOP command, work scheduled on
cmd_timer for the first NOP can get scheduled, resulting in sending third
NOP command (sending back to back NOP commands). This might
cause issues at controller side (like memory overrun, controller going
unresponsive) resulting in hci tx timeouts, hardware errors etc.

The fix to this issue is to cancel the delayed work scheduled on
cmd_timer on receiving command status or command complete event for
NOP command (this patch handles NOP command same as any other SIG
command).

Signed-off-by: Kiran K <kiran.k@intel.com>
Reviewed-by: Chethan T N <chethan.tumkur.narayan@intel.com>
Reviewed-by: Srivatsa Ravishankar <ravishankar.srivatsa@intel.com>
Acked-by: Manish Mandlik <mmandlik@google.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index f41bd5dfc313..0d0b958b7fe7 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3282,11 +3282,9 @@ static void hci_remote_features_evt(struct hci_dev *hdev,
 	hci_dev_unlock(hdev);
 }
 
-static inline void handle_cmd_cnt_and_timer(struct hci_dev *hdev,
-					    u16 opcode, u8 ncmd)
+static inline void handle_cmd_cnt_and_timer(struct hci_dev *hdev, u8 ncmd)
 {
-	if (opcode != HCI_OP_NOP)
-		cancel_delayed_work(&hdev->cmd_timer);
+	cancel_delayed_work(&hdev->cmd_timer);
 
 	if (!test_bit(HCI_RESET, &hdev->flags)) {
 		if (ncmd) {
@@ -3661,7 +3659,7 @@ static void hci_cmd_complete_evt(struct hci_dev *hdev, struct sk_buff *skb,
 		break;
 	}
 
-	handle_cmd_cnt_and_timer(hdev, *opcode, ev->ncmd);
+	handle_cmd_cnt_and_timer(hdev, ev->ncmd);
 
 	hci_req_cmd_complete(hdev, *opcode, *status, req_complete,
 			     req_complete_skb);
@@ -3762,7 +3760,7 @@ static void hci_cmd_status_evt(struct hci_dev *hdev, struct sk_buff *skb,
 		break;
 	}
 
-	handle_cmd_cnt_and_timer(hdev, *opcode, ev->ncmd);
+	handle_cmd_cnt_and_timer(hdev, ev->ncmd);
 
 	/* Indicate request completion if the command failed. Also, if
 	 * we're not waiting for a special event and we get a success
-- 
2.30.2



