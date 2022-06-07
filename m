Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF806540673
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347396AbiFGRfG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347082AbiFGRcw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:32:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AD2A9C2CE;
        Tue,  7 Jun 2022 10:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5D4F614B2;
        Tue,  7 Jun 2022 17:30:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B654BC385A5;
        Tue,  7 Jun 2022 17:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623008;
        bh=dFjYUU0Nr4ALT4494VHLljO3OBlhwwcNO8YJ10YQGvI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2df1x2XWaXWHXgwa4TLRhPRi1baGAxijgN8e25RwfOL1fpWvBGI8lBVQMk6eHS/UM
         iH2BF16X9W7OqxPG5LZTHzG+fl8RgiJ5lXEkgu9/VTzrG4efBYgGjvIaD7Ykg5FB4g
         1aggO2ZEWbg7z4g3XBcOvZOf70HaIGPUKAk0SZyo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 245/452] NFC: hci: fix sleep in atomic context bugs in nfc_hci_hcp_message_tx
Date:   Tue,  7 Jun 2022 19:01:42 +0200
Message-Id: <20220607164915.860969771@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
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
index 0841e0e370a0..0194e80193d9 100644
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
@@ -364,6 +372,7 @@ int st21nfca_apdu_reader_event_received(struct nfc_hci_dev *hdev,
 	switch (event) {
 	case ST21NFCA_EVT_TRANSMIT_DATA:
 		del_timer_sync(&info->se_info.bwi_timer);
+		cancel_work_sync(&info->se_info.timeout_work);
 		info->se_info.bwi_active = false;
 		r = nfc_hci_send_event(hdev, ST21NFCA_DEVICE_MGNT_GATE,
 				ST21NFCA_EVT_SE_END_OF_APDU_TRANSFER, NULL, 0);
@@ -393,6 +402,7 @@ void st21nfca_se_init(struct nfc_hci_dev *hdev)
 	struct st21nfca_hci_info *info = nfc_hci_get_clientdata(hdev);
 
 	init_completion(&info->se_info.req_completion);
+	INIT_WORK(&info->se_info.timeout_work, st21nfca_se_wt_work);
 	/* initialize timers */
 	timer_setup(&info->se_info.bwi_timer, st21nfca_se_wt_timeout, 0);
 	info->se_info.bwi_active = false;
@@ -420,6 +430,7 @@ void st21nfca_se_deinit(struct nfc_hci_dev *hdev)
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



