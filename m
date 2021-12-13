Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92AB7472A01
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:29:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240363AbhLMK3W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:29:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344506AbhLMK1Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:27:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B2D9C08EC0A;
        Mon, 13 Dec 2021 02:01:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE37EB80E7E;
        Mon, 13 Dec 2021 10:01:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18E35C34600;
        Mon, 13 Dec 2021 10:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389676;
        bh=9szTb82bYnaUXlo4Fvf9IM6pblElhsSanZAWt2gJk5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2XW49nY/MedDeedzeMlMW1a1Z47veQNBhdaWJSIHgn8g8n9umEeTaVq/PcM6As1Lc
         kg2evzS0ll64NSAc0U8+fT//AdWFNnvzMH9gp8kPfMWRozJNmA2l4aEd5p78yJm4ha
         09O1KqGG6WXzFySgW5d52j2Wly5AqZCI/6ciqVDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Manivannan Sadhasivam <mani@kernel.org>,
        Slark Xiao <slark_xiao@163.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 5.15 160/171] bus: mhi: pci_generic: Fix device recovery failed issue
Date:   Mon, 13 Dec 2021 10:31:15 +0100
Message-Id: <20211213092950.395700521@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Slark Xiao <slark_xiao@163.com>

commit e2022cbec9c2606514c4edc4a760e3acb7419d8a upstream.

For Foxconn T99W175 device(sdx55 platform) in some host platform,
it would be unavailable once the host execute the err handler.

After checking, it's caused by the delay time too short to
get a successful reset.

Please see my test evidence as bewlow(BTW, I add some extra test logs
in function mhi_pci_reset_prepare and mhi_pci_reset_done):
  When MHI_POST_RESET_DELAY_MS equals to 500ms:
   Nov  4 14:30:03 jbd-ThinkEdge kernel: [  146.222477] mhi mhi0: Device MHI is not in valid state
   Nov  4 14:30:03 jbd-ThinkEdge kernel: [  146.222628] mhi-pci-generic 0000:2d:00.0: mhi_pci_reset_prepare reset
   Nov  4 14:30:03 jbd-ThinkEdge kernel: [  146.222631] mhi-pci-generic 0000:2d:00.0: mhi_pci_reset_prepare mhi_soc_reset
   Nov  4 14:30:03 jbd-ThinkEdge kernel: [  146.222632] mhi mhi0:  mhi_soc_reset write soc to reset
   Nov  4 14:30:05 jbd-ThinkEdge kernel: [  147.839993] mhi-pci-generic 0000:2d:00.0: mhi_pci_reset_done
   Nov  4 14:30:05 jbd-ThinkEdge kernel: [  147.902063] mhi-pci-generic 0000:2d:00.0: reset failed

  When MHI_POST_RESET_DELAY_MS equals to 1000ms or 1500ms:
   Nov  4 19:07:26 jbd-ThinkEdge kernel: [  157.067857] mhi mhi0: Device MHI is not in valid state
   Nov  4 19:07:26 jbd-ThinkEdge kernel: [  157.068029] mhi-pci-generic 0000:2d:00.0: mhi_pci_reset_prepare reset
   Nov  4 19:07:26 jbd-ThinkEdge kernel: [  157.068032] mhi-pci-generic 0000:2d:00.0: mhi_pci_reset_prepare mhi_soc_reset
   Nov  4 19:07:26 jbd-ThinkEdge kernel: [  157.068034] mhi mhi0:  mhi_soc_reset write soc to reset
   Nov  4 19:07:29 jbd-ThinkEdge kernel: [  159.607006] mhi-pci-generic 0000:2d:00.0: mhi_pci_reset_done
   Nov  4 19:07:29 jbd-ThinkEdge kernel: [  159.607152] mhi mhi0: Requested to power ON
   Nov  4 19:07:51 jbd-ThinkEdge kernel: [  181.302872] mhi mhi0: Failed to reset MHI due to syserr state
   Nov  4 19:07:51 jbd-ThinkEdge kernel: [  181.303011] mhi-pci-generic 0000:2d:00.0: failed to power up MHI controller

  When MHI_POST_RESET_DELAY_MS equals to 2000ms:
   Nov  4 17:51:08 jbd-ThinkEdge kernel: [  147.180527] mhi mhi0: Failed to transition from PM state: Linkdown or Error Fatal Detect to: SYS ERROR Process
   Nov  4 17:51:08 jbd-ThinkEdge kernel: [  147.180535] mhi mhi0: Device MHI is not in valid state
   Nov  4 17:51:08 jbd-ThinkEdge kernel: [  147.180722] mhi-pci-generic 0000:2d:00.0: mhi_pci_reset_prepare reset
   Nov  4 17:51:08 jbd-ThinkEdge kernel: [  147.180725] mhi-pci-generic 0000:2d:00.0: mhi_pci_reset_prepare mhi_soc_reset
   Nov  4 17:51:08 jbd-ThinkEdge kernel: [  147.180727] mhi mhi0:  mhi_soc_reset write soc to reset
   Nov  4 17:51:11 jbd-ThinkEdge kernel: [  150.230787] mhi-pci-generic 0000:2d:00.0: mhi_pci_reset_done
   Nov  4 17:51:11 jbd-ThinkEdge kernel: [  150.230928] mhi mhi0: Requested to power ON
   Nov  4 17:51:11 jbd-ThinkEdge kernel: [  150.231173] mhi mhi0: Power on setup success
   Nov  4 17:51:14 jbd-ThinkEdge kernel: [  153.254747] mhi mhi0: Wait for device to enter SBL or Mission mode

I also tried big data like 3000, and it worked as well. 500ms may not be
enough for all support mhi device. We shall increase it to 2000ms
at least.

Link: https://lore.kernel.org/r/20211108113127.3938-1-slark_xiao@163.com
[mani: massaged commit message little bit, added Fixes tag and CCed stable]
Fixes: 8ccc3279fcad ("mhi: pci_generic: Add support for reset")
Cc: stable@vger.kernel.org
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Slark Xiao <slark_xiao@163.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20211126104951.35685-2-manivannan.sadhasivam@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/mhi/pci_generic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bus/mhi/pci_generic.c b/drivers/bus/mhi/pci_generic.c
index 59a4896a8030..4c577a731709 100644
--- a/drivers/bus/mhi/pci_generic.c
+++ b/drivers/bus/mhi/pci_generic.c
@@ -20,7 +20,7 @@
 
 #define MHI_PCI_DEFAULT_BAR_NUM 0
 
-#define MHI_POST_RESET_DELAY_MS 500
+#define MHI_POST_RESET_DELAY_MS 2000
 
 #define HEALTH_CHECK_PERIOD (HZ * 2)
 
-- 
2.34.1



