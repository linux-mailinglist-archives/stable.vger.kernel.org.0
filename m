Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63FB74C74A9
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:45:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238660AbiB1RqL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:46:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239623AbiB1RoZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:44:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D1819E9F6;
        Mon, 28 Feb 2022 09:36:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 490DFB815A6;
        Mon, 28 Feb 2022 17:36:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A69B6C340E7;
        Mon, 28 Feb 2022 17:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069801;
        bh=RLhiiZjzOzAtMK5b8A41Jkm+nudW8wUnzW1+qCkFNYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z5rSc13A2/rzJK64L1VFQujSxJvWIQy3DnD8gOZA/ikm1pTINyQTp9UViiKzEQLj2
         v5tOhGBgcSCrKAmgCrfpXhrcjl6rxmNvyuc0+shXUWOGZTkiZFjYbVPTiHdSD5IGcq
         +z9Vh+Zz1rXy1IJ6uAKdUMMadnlVOZPeFi/QpEQs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, koba.ko@canonical.com,
        Alex Deucher <alexander.deucher@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 5.15 017/139] drm/amd: Check if ASPM is enabled from PCIe subsystem
Date:   Mon, 28 Feb 2022 18:23:11 +0100
Message-Id: <20220228172349.509660439@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
References: <20220228172347.614588246@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

commit 7294863a6f01248d72b61d38478978d638641bee upstream.

commit 0064b0ce85bb ("drm/amd/pm: enable ASPM by default") enabled ASPM
by default but a variety of hardware configurations it turns out that this
caused a regression.

* PPC64LE hardware does not support ASPM at a hardware level.
  CONFIG_PCIEASPM is often disabled on these architectures.
* Some dGPUs on ALD platforms don't work with ASPM enabled and PCIe subsystem
  disables it

Check with the PCIe subsystem to see that ASPM has been enabled
or not.

Fixes: 0064b0ce85bb ("drm/amd/pm: enable ASPM by default")
Link: https://wiki.raptorcs.com/w/images/a/ad/P9_PHB_version1.0_27July2018_pub.pdf
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/1723
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/1739
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/1885
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/1907
Tested-by: koba.ko@canonical.com
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -1278,6 +1278,9 @@ static int amdgpu_pci_probe(struct pci_d
 	bool is_fw_fb;
 	resource_size_t base, size;
 
+	if (amdgpu_aspm == -1 && !pcie_aspm_enabled(pdev))
+		amdgpu_aspm = 0;
+
 	if (amdgpu_virtual_display ||
 	    amdgpu_device_asic_has_dc_support(flags & AMD_ASIC_MASK))
 		supports_atomic = true;


