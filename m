Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2E9548DF0
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352400AbiFMLRj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353650AbiFMLQJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:16:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DD2138BD3;
        Mon, 13 Jun 2022 03:38:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF1B9611AD;
        Mon, 13 Jun 2022 10:38:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B55C4C34114;
        Mon, 13 Jun 2022 10:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116722;
        bh=Q7418weR5aIANbOqcDMKVymldyPPpy6W6UvIYG7jclI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DhOeCvIkXGPI5dzWBH0u3uHPurQPnrPShtqXjdt0GWpAVRvEIp4vW1S3XQizezmv1
         PFdNhYS7EQnJIYH5fTtJt+wePh8QojCVOqoPP+eClZicNwOYfwn0MJHjQzZkmJtXL7
         Gw7b7AtKQnzKxR7QxTOG5SmcUKRTAVaGtkzMoXVU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 149/411] NFC: hci: fix sleep in atomic context bugs in nfc_hci_hcp_message_tx
Date:   Mon, 13 Jun 2022 12:07:02 +0200
Message-Id: <20220613094933.135192479@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit b413b0cb008646e9f24ce5253cb3cf7ee217aff6 ]

There are sleep in atomic context bugs when the request to secure
element of st21nfca is timeout. The root cause is that kzalloc and
alloc_skb with GFP_KERNEL parameter and mutex_lock are called in
st21nfca_se_wt_timeout which is a timer handler. The call tree shows
the execution paths that could lead to bugs:

   (Interrupt context)
st21nfca_se_wt_timeout
  nfc_hci_send_event
    nfc_hci_hcp_message_tx
      kzalloc(..., GFP_KERNEL) //may sleep
      alloc_skb(..., GFP_KERNEL) //may sleep
      mutex_lock() //may sleep

This patch moves the operations that may sleep into a work item.
The work item will run in another kernel thread which is in
process context to execute the bottom half of the interrupt.
So it could prevent atomic context from sleeping.

Fixes: 2130fb97fecf ("NFC: st21nfca: Adding support for secure element")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20220518115733.62111-1-duoming@zju.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/st21nfca/se.c       | 17 ++++++++++++++---
 drivers/nfc/st21nfca/st21nfca.h |  1 +
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/nfc/st21nfca/se.c b/drivers/nfc/st21nfca/se.c
index a7ab6dab0f32..5256195f313b 100644
--- a/drivers/nfc/st21nfca/se.c
+++ b/drivers/nfc/st21nfca/se.c
@@ -241,7 +241,7 @@ int st21nfca_hci_se_io(struct nfc_hci_dev *hdev, u32 se_idx,
 }
 EXPORT_SYMBOL(st21nfca_hci_se_io);
 
-static void st21nfca_se_wt_timeout(struct timer_list *t)
+static void st21nfca_se_wt_work(struct work_struct *work)
 {
 	/*
 	 * No answer from the secure element
@@ -254,8 +254,9 @@ static void st21nfca_se_wt_timeout(struct timer_list *t)
 	 */
 	/* hardware reset managed through VCC_UICC_OUT power supply */
 	u8 param = 0x01;
-	struct st21nfca_hci_info *info = from_timer(info, t,
-						    se_info.bwi_timer);
+	struct st21nfca_hci_info *info = container_of(work,
+						struct st21nfca_hci_info,
+						se_info.timeout_work);
 
 	pr_debug("\n");
 
@@ -273,6 +274,13 @@ static void st21nfca_se_wt_timeout(struct timer_list *t)
 	info->se_info.cb(info->se_info.cb_context, NULL, 0, -ETIME);
 }
 
+static void st21nfca_se_wt_timeout(struct timer_list *t)
+{
+	struct st21nfca_hci_info *info = from_timer(info, t, se_info.bwi_timer);
+
+	schedule_work(&info->se_info.timeout_work);
+}
+
 static void st21nfca_se_activation_timeout(struct timer_list *t)
 {
 	struct st21nfca_hci_info *info = from_timer(info, t,
@@ -365,6 +373,7 @@ int st21nfca_apdu_reader_event_received(struct nfc_hci_dev *hdev,
 	switch (event) {
 	case ST21NFCA_EVT_TRANSMIT_DATA:
 		del_timer_sync(&info->se_info.bwi_timer);
+		cancel_work_sync(&info->se_info.timeout_work);
 		info->se_info.bwi_active = false;
 		r = nfc_hci_send_event(hdev, ST21NFCA_DEVICE_MGNT_GATE,
 				ST21NFCA_EVT_SE_END_OF_APDU_TRANSFER, NULL, 0);
@@ -394,6 +403,7 @@ void st21nfca_se_init(struct nfc_hci_dev *hdev)
 	struct st21nfca_hci_info *info = nfc_hci_get_clientdata(hdev);
 
 	init_completion(&info->se_info.req_completion);
+	INIT_WORK(&info->se_info.timeout_work, st21nfca_se_wt_work);
 	/* initialize timers */
 	timer_setup(&info->se_info.bwi_timer, st21nfca_se_wt_timeout, 0);
 	info->se_info.bwi_active = false;
@@ -421,6 +431,7 @@ void st21nfca_se_deinit(struct nfc_hci_dev *hdev)
 	if (info->se_info.se_active)
 		del_timer_sync(&info->se_info.se_active_timer);
 
+	cancel_work_sync(&info->se_info.timeout_work);
 	info->se_info.bwi_active = false;
 	info->se_info.se_active = false;
 }
diff --git a/drivers/nfc/st21nfca/st21nfca.h b/drivers/nfc/st21nfca/st21nfca.h
index 5e0de0fef1d4..0e4a93d11efb 100644
--- a/drivers/nfc/st21nfca/st21nfca.h
+++ b/drivers/nfc/st21nfca/st21nfca.h
@@ -141,6 +141,7 @@ struct st21nfca_se_info {
 
 	se_io_cb_t cb;
 	void *cb_context;
+	struct work_struct timeout_work;
 };
 
 struct st21nfca_hci_info {
-- 
2.35.1



