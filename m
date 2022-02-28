Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0554C75B4
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235864AbiB1R4M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:56:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240790AbiB1Ryp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:54:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15446532DA;
        Mon, 28 Feb 2022 09:43:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A6A3F608C4;
        Mon, 28 Feb 2022 17:43:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C18FAC340E7;
        Mon, 28 Feb 2022 17:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070213;
        bh=hy8PdvQdBNc6m20A7AJTiF/QWo27iNFlxzFo5oLCz/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o4vEgjlqBVzAdMMOJ3t0doKM+TZhM43OCFV3zBFBUhGDY6ChdCy5n5Y42JJC4hVFR
         SnOpTjINdl0e01rbkroDGMO/XjvwoGqnWratFTywHeftq82kHkmpgesV0EwqdsP0Zz
         WNNEvtDqgcxW8HevMn9TOtDlc4/JPZcLkMm57CUE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, koba.ko@canonical.com,
        Alex Deucher <alexander.deucher@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 5.16 019/164] drm/amd: Check if ASPM is enabled from PCIe subsystem
Date:   Mon, 28 Feb 2022 18:23:01 +0100
Message-Id: <20220228172401.722576560@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
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
@@ -2014,6 +2014,9 @@ static int amdgpu_pci_probe(struct pci_d
 		return -ENODEV;
 	}
 
+	if (amdgpu_aspm == -1 && !pcie_aspm_enabled(pdev))
+		amdgpu_aspm = 0;
+
 	if (amdgpu_virtual_display ||
 	    amdgpu_device_asic_has_dc_support(flags & AMD_ASIC_MASK))
 		supports_atomic = true;


