Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 262671AC6C0
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 16:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391957AbgDPOoJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 10:44:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:47254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409416AbgDPOAL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 10:00:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C6FD2078B;
        Thu, 16 Apr 2020 14:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045610;
        bh=/MZG7D6frHE0UnnT/D1f/ogB9Ko41bQzTQea43xIACI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=abNdN6vxI/RhsEm32aQC3PYs9LFjVkr1lwJwGmvDenIzvZHt2zRqsOTGOpCwbarJj
         ap9wbEWvcSad7R4aUFHLFej5XUTYrDITDI/t+4TI4Q61WzXsMtFtfWjbhksaJcHEFe
         iKkggeljxCDSzKzVHF5Wjnwkgl9VDBz5D2027b9M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Prike Liang <Prike.Liang@amd.com>,
        Huang Rui <ray.huang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.6 205/254] drm/amd/powerplay: implement the is_dpm_running()
Date:   Thu, 16 Apr 2020 15:24:54 +0200
Message-Id: <20200416131351.692090182@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Prike Liang <Prike.Liang@amd.com>

commit 4ee2bb22ddb53a2eafc675690d0d67452029ca37 upstream.

As the pmfw hasn't exported the interface of SMU feature
mask to APU SKU so just force on all the features to driver
inquired interface at early initial stage.

Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Reviewed-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/powerplay/renoir_ppt.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/gpu/drm/amd/powerplay/renoir_ppt.c
+++ b/drivers/gpu/drm/amd/powerplay/renoir_ppt.c
@@ -887,6 +887,17 @@ static int renoir_read_sensor(struct smu
 	return ret;
 }
 
+static bool renoir_is_dpm_running(struct smu_context *smu)
+{
+	/*
+	 * Util now, the pmfw hasn't exported the interface of SMU
+	 * feature mask to APU SKU so just force on all the feature
+	 * at early initial stage.
+	 */
+	return true;
+
+}
+
 static const struct pptable_funcs renoir_ppt_funcs = {
 	.get_smu_msg_index = renoir_get_smu_msg_index,
 	.get_smu_clk_index = renoir_get_smu_clk_index,
@@ -928,6 +939,7 @@ static const struct pptable_funcs renoir
 	.mode2_reset = smu_v12_0_mode2_reset,
 	.set_soft_freq_limited_range = smu_v12_0_set_soft_freq_limited_range,
 	.set_driver_table_location = smu_v12_0_set_driver_table_location,
+	.is_dpm_running = renoir_is_dpm_running,
 };
 
 void renoir_set_ppt_funcs(struct smu_context *smu)


