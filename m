Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C255F676FFF
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231452AbjAVP1Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:27:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231448AbjAVP1Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:27:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C16B23100
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:27:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1483FB80B20
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:27:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63B50C433EF;
        Sun, 22 Jan 2023 15:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674401240;
        bh=bQnoNS0XjH1O/2AQytDihP+jVtkDXpNk+sC5q6JxebY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cJX8/McQuhHJr8WizZge13UM0py0DcMxJ/6xXrJN8greT53prH6nWJvNUf56FRcsA
         7HXKPJ8rgv+nMfKO+uiQSeVyX2/rPolvZmtgfQjgGuV2XpVkNx1ryFD7mlcbyRfGHL
         lBny5fsGvwluXDxCaaTVAHmr/W2B5xV7naOPiC84=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lang Yu <Lang.Yu@amd.com>,
        Aaron Liu <aaron.liu@amd.com>,
        Yifan Zhang <yifan1.zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 135/193] drm/amdgpu: allow multipipe policy on ASICs with one MEC
Date:   Sun, 22 Jan 2023 16:04:24 +0100
Message-Id: <20230122150252.519689870@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
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

From: Lang Yu <Lang.Yu@amd.com>

commit dc88063b87775971be564d79dc1b05f7b8b5c135 upstream.

Always enable multipipe policy on ASICs with GC VERSION > 9.0.0
instead of MEC number > 1.

This will allow multipipe policy on ASICs with one MEC,
e.g., gfx11 APUs.

Signed-off-by: Lang Yu <Lang.Yu@amd.com>
Reviewed-by: Aaron Liu <aaron.liu@amd.com>
Reviewed-by: Yifan Zhang <yifan1.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
@@ -156,6 +156,9 @@ static bool amdgpu_gfx_is_compute_multip
 		return amdgpu_compute_multipipe == 1;
 	}
 
+	if (adev->ip_versions[GC_HWIP][0] > IP_VERSION(9, 0, 0))
+		return true;
+
 	/* FIXME: spreading the queues across pipes causes perf regressions
 	 * on POLARIS11 compute workloads */
 	if (adev->asic_type == CHIP_POLARIS11)


