Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4B2676ED6
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbjAVPO5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:14:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbjAVPO4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:14:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D9602202F
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:14:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B27FB807E4
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:14:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5AA4C433D2;
        Sun, 22 Jan 2023 15:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400493;
        bh=BM3eL0XvHGSlr9KkB3a/goj15VyMf+UMa9JQ9c6RlP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XVnMTnSbzJ7dBY84Pz7oB+KWgJFP+F72B75rwXNsIWTMdhBKnreLKEPy/O0+OlQh+
         TszK+deGp8unepstE7sxAn/VfjIz7af/CotuScWOHV6XxIab3+y0j7ipv23V4qhTv7
         jtQ2A/jxnXx+7VHzeg2IOYkriVhVRfXsFKq20fqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Venkata Lakshmi Narayana Gubba <gubbaven@codeaurora.org>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 5.10 96/98] Bluetooth: hci_qca: Wait for SSR completion during suspend
Date:   Sun, 22 Jan 2023 16:04:52 +0100
Message-Id: <20230122150233.448751843@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150229.351631432@linuxfoundation.org>
References: <20230122150229.351631432@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Venkata Lakshmi Narayana Gubba <gubbaven@codeaurora.org>

commit ad3a9c0ec2d2baed936cfdd05870f9d1e1f40e0e upstream.

During SSR after memory dump collection,BT controller will be powered off,
powered on and then FW will be downloaded.During suspend if BT controller
is powered off due to SSR then we should wait until SSR is completed and
then suspend.

Fixes: 2be43abac5a8 ("Bluetooth: hci_qca: Wait for timeout during suspend")
Signed-off-by: Venkata Lakshmi Narayana Gubba <gubbaven@codeaurora.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/hci_qca.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -50,7 +50,8 @@
 #define IBS_HOST_TX_IDLE_TIMEOUT_MS	2000
 #define CMD_TRANS_TIMEOUT_MS		100
 #define MEMDUMP_TIMEOUT_MS		8000
-#define IBS_DISABLE_SSR_TIMEOUT_MS	(MEMDUMP_TIMEOUT_MS + 1000)
+#define IBS_DISABLE_SSR_TIMEOUT_MS \
+	(MEMDUMP_TIMEOUT_MS + FW_DOWNLOAD_TIMEOUT_MS)
 #define FW_DOWNLOAD_TIMEOUT_MS		3000
 
 /* susclk rate */
@@ -2111,7 +2112,12 @@ static int __maybe_unused qca_suspend(st
 
 	set_bit(QCA_SUSPENDING, &qca->flags);
 
-	if (test_bit(QCA_BT_OFF, &qca->flags))
+	/* During SSR after memory dump collection, controller will be
+	 * powered off and then powered on.If controller is powered off
+	 * during SSR then we should wait until SSR is completed.
+	 */
+	if (test_bit(QCA_BT_OFF, &qca->flags) &&
+	    !test_bit(QCA_SSR_TRIGGERED, &qca->flags))
 		return 0;
 
 	if (test_bit(QCA_IBS_DISABLED, &qca->flags)) {
@@ -2121,7 +2127,7 @@ static int __maybe_unused qca_suspend(st
 
 		/* QCA_IBS_DISABLED flag is set to true, During FW download
 		 * and during memory dump collection. It is reset to false,
-		 * After FW download complete and after memory dump collections.
+		 * After FW download complete.
 		 */
 		wait_on_bit_timeout(&qca->flags, QCA_IBS_DISABLED,
 			    TASK_UNINTERRUPTIBLE, msecs_to_jiffies(wait_timeout));
@@ -2133,10 +2139,6 @@ static int __maybe_unused qca_suspend(st
 		}
 	}
 
-	/* After memory dump collection, Controller is powered off.*/
-	if (test_bit(QCA_BT_OFF, &qca->flags))
-		return 0;
-
 	cancel_work_sync(&qca->ws_awake_device);
 	cancel_work_sync(&qca->ws_awake_rx);
 


