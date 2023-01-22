Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 518F167700B
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231450AbjAVP1y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:27:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231468AbjAVP1x (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:27:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED5E11176
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:27:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D91860C44
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:27:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B193FC433EF;
        Sun, 22 Jan 2023 15:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674401272;
        bh=ekXyULMs7HgD/y3cYUydBC9BMq9XqU6J4rCDj4MQJf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1i/hsJZ9ln1uwTmOabYNtwhMXm9es4dST1Qoo+a6Tg7czBmYcq8/P1n/EBKLnlj59
         k4LuIHVVLhL00sLmrD1nPU7jtds6q9dtZhMSSz/5eqICjAyUH/KGSxRsBVHwJMWFhh
         uYgDHefDCCDvt7Oo6IByoqeSt5LtRf4hQV+dPGb0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tim Huang <tim.huang@amd.com>,
        Yifan Zhang <yifan1.zhang@amd.com>,
        Aaron Liu <aaron.liu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        "Limonciello, Mario" <Mario.Limonciello@amd.com>
Subject: [PATCH 6.1 176/193] drm/amdgpu: enable PSP IP v13.0.11 support
Date:   Sun, 22 Jan 2023 16:05:05 +0100
Message-Id: <20230122150254.471856139@linuxfoundation.org>
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

From: Tim Huang <tim.huang@amd.com>

commit 2c83e3fd928b9cb1e35340e58d4b1bd2eea23ed6 upstream.

Enable PSP FW loading for PSP IP v13.0.11

Signed-off-by: Tim Huang <tim.huang@amd.com>
Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
Reviewed-by: Aaron Liu <aaron.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: "Limonciello, Mario" <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c |    1 +
 drivers/gpu/drm/amd/amdgpu/psp_v13_0.c  |    3 +++
 2 files changed, 4 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -139,6 +139,7 @@ static int psp_early_init(void *handle)
 	case IP_VERSION(13, 0, 5):
 	case IP_VERSION(13, 0, 8):
 	case IP_VERSION(13, 0, 10):
+	case IP_VERSION(13, 0, 11):
 		psp_v13_0_set_psp_funcs(psp);
 		psp->autoload_supported = true;
 		break;
--- a/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c
@@ -46,6 +46,8 @@ MODULE_FIRMWARE("amdgpu/psp_13_0_7_sos.b
 MODULE_FIRMWARE("amdgpu/psp_13_0_7_ta.bin");
 MODULE_FIRMWARE("amdgpu/psp_13_0_10_sos.bin");
 MODULE_FIRMWARE("amdgpu/psp_13_0_10_ta.bin");
+MODULE_FIRMWARE("amdgpu/psp_13_0_11_toc.bin");
+MODULE_FIRMWARE("amdgpu/psp_13_0_11_ta.bin");
 
 /* For large FW files the time to complete can be very long */
 #define USBC_PD_POLLING_LIMIT_S 240
@@ -102,6 +104,7 @@ static int psp_v13_0_init_microcode(stru
 	case IP_VERSION(13, 0, 3):
 	case IP_VERSION(13, 0, 5):
 	case IP_VERSION(13, 0, 8):
+	case IP_VERSION(13, 0, 11):
 		err = psp_init_toc_microcode(psp, chip_name);
 		if (err)
 			return err;


