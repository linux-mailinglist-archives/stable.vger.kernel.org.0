Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9D66AF2D6
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233508AbjCGS4y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:56:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbjCGS4j (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:56:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FCDCCB656
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:44:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B034DB819CB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:43:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02D56C433D2;
        Tue,  7 Mar 2023 18:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214610;
        bh=UfHIndz2cS4jkv2lRnJmh+Q7YlgidVpoB6juTD78jg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q8Cxe7FzVdvLTMCF7XV3rk7ArRS4+CnZYpGo4VM9LgoZIExyqHGMLsXxZpHN8z0BY
         4rRdJ+6QygOiL7NGTdexiYv5UbJ99LIsnkeAWSdHh6ryV3yksek1ZsnLRS0bc71RXC
         fKsAlZSW2P+NJWj9mTen2MTxqcvM2e9f1IBiEOjw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Richard Gong <richard.gong@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 878/885] drm/amd: Fix initialization for nbio 7.5.1
Date:   Tue,  7 Mar 2023 18:03:32 +0100
Message-Id: <20230307170039.930248221@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

commit 65a24000808f70ac69bd2a96381fa0c7341f20c0 upstream.

A mistake has been made in the BIOS for some ASICs with NBIO 7.5.1
where some NBIO registers aren't properly setup.

Ensure that they're set during initialization.

Tested-by: Richard Gong <richard.gong@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/nbio_v7_2.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v7_2.c b/drivers/gpu/drm/amd/amdgpu/nbio_v7_2.c
index 31776b12e4c4..4b0d563c6522 100644
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v7_2.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v7_2.c
@@ -382,6 +382,11 @@ static void nbio_v7_2_init_registers(struct amdgpu_device *adev)
 		if (def != data)
 			WREG32_PCIE_PORT(SOC15_REG_OFFSET(NBIO, 0, regBIF1_PCIE_MST_CTRL_3), data);
 		break;
+	case IP_VERSION(7, 5, 1):
+		data = RREG32_SOC15(NBIO, 0, regRCC_DEV2_EPF0_STRAP2);
+		data &= ~RCC_DEV2_EPF0_STRAP2__STRAP_NO_SOFT_RESET_DEV2_F0_MASK;
+		WREG32_SOC15(NBIO, 0, regRCC_DEV2_EPF0_STRAP2, data);
+		fallthrough;
 	default:
 		def = data = RREG32_PCIE_PORT(SOC15_REG_OFFSET(NBIO, 0, regPCIE_CONFIG_CNTL));
 		data = REG_SET_FIELD(data, PCIE_CONFIG_CNTL,
-- 
2.39.2



