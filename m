Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC906D4AAF
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234187AbjDCOt3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234032AbjDCOtN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:49:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ABDF29059
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:48:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B12F9B81D51
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:48:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25990C433EF;
        Mon,  3 Apr 2023 14:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533289;
        bh=//lb1NvM2T0ckJjYGmS1UZFhO1E7RtGtZoey5OEoRLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FU1Jvc8M6xGzo4RLTOl41HI+bCW+jd4WJWR4QfbuBph6nSeMORTeKVrWGismjNA9M
         nImQ8dFNEr5SunrDly8zeajnzD3SVy/uUE6ba0uzZ0NKkIS66MaErmONsD1Z8DGP/K
         iYsrPWuq/0Nn47a4UCyM1Eb9QZvIJvTlHRsJUSqA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Matthias Kaehlcke <mka@chromium.org>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 127/187] Revert "venus: firmware: Correct non-pix start and end addresses"
Date:   Mon,  3 Apr 2023 16:09:32 +0200
Message-Id: <20230403140420.161479149@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Javier Martinez Canillas <javierm@redhat.com>

[ Upstream commit f95b8ea79c47c0ad3d18f45ad538f9970e414d1f ]

This reverts commit a837e5161cff, which broke probing of the venus
driver, at least on the SC7180 SoC HP X2 Chromebook:

  qcom-venus aa00000.video-codec: Adding to iommu group 11
  qcom-venus aa00000.video-codec: non legacy binding
  qcom-venus aa00000.video-codec: failed to reset venus core
  qcom-venus: probe of aa00000.video-codec failed with error -110

Matthias Kaehlcke also reported that the same change caused a regression
in SC7180 and sc7280, that prevents AOSS from entering sleep mode during
system suspend.  So let's revert this commit for now to fix both issues.

Fixes: a837e5161cff ("venus: firmware: Correct non-pix start and end addresses")
Reported-by: Matthias Kaehlcke <mka@chromium.org>
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/firmware.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/firmware.c b/drivers/media/platform/qcom/venus/firmware.c
index 142d4c74017c0..d59ecf776715c 100644
--- a/drivers/media/platform/qcom/venus/firmware.c
+++ b/drivers/media/platform/qcom/venus/firmware.c
@@ -38,8 +38,8 @@ static void venus_reset_cpu(struct venus_core *core)
 	writel(fw_size, wrapper_base + WRAPPER_FW_END_ADDR);
 	writel(0, wrapper_base + WRAPPER_CPA_START_ADDR);
 	writel(fw_size, wrapper_base + WRAPPER_CPA_END_ADDR);
-	writel(0, wrapper_base + WRAPPER_NONPIX_START_ADDR);
-	writel(0, wrapper_base + WRAPPER_NONPIX_END_ADDR);
+	writel(fw_size, wrapper_base + WRAPPER_NONPIX_START_ADDR);
+	writel(fw_size, wrapper_base + WRAPPER_NONPIX_END_ADDR);
 
 	if (IS_V6(core)) {
 		/* Bring XTSS out of reset */
-- 
2.39.2



