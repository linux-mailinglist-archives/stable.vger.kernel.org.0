Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07E1B498EFF
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357372AbiAXTtx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:49:53 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33092 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356057AbiAXTpK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:45:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06209B8119D;
        Mon, 24 Jan 2022 19:45:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 220C7C340E5;
        Mon, 24 Jan 2022 19:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053506;
        bh=6oShnav0XEb7H1YaxcQhmuRS9xKP6Df8LCApCyXbdIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CQteU0QqMJmwKWpoRRi7RnAOnOP2cesYnQxxe8q0yC1kF7EJrd4Livh0bsT+8HQIU
         i3MtfR5e/OCPqpTMtr6VfPLhwym9kACS89AAIDgiHnyLfJUNy7ZQtAucCGmfVFG3wS
         MMjitEMpBAzyfw0D1vn92rtU4gLaMDLjH6bamuHk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tsuchiya Yuto <kitakar@gmail.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 070/563] media: atomisp: fix ifdefs in sh_css.c
Date:   Mon, 24 Jan 2022 19:37:15 +0100
Message-Id: <20220124184026.832725144@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tsuchiya Yuto <kitakar@gmail.com>

[ Upstream commit 5a1b2725558f8a3b4cbf0504f53cffae8e163034 ]

 ## `if (pipe->stream->config.mode == IA_CSS_INPUT_MODE_TPG) {` case

The intel-aero atomisp has `#if defined(IS_ISP_2400_SYSTEM)` [1]. It is
to be defined in the following two places [2]:

  - css/hive_isp_css_common/system_global.h
  - css/css_2401_csi2p_system/system_global.h

and the former file is to be included on ISP2400 devices, too. So, it
is to be defined for both ISP2400 and ISP2401 devices.

Because the upstreamed atomisp driver now supports only ISP2400 and
ISP2401, just remove the ISP version test again. This matches the other
upstream commits like 3c0538fbad9f ("media: atomisp: get rid of most
checks for ISP2401 version").

While here, moved the comment for define GP_ISEL_TPG_MODE to the
appropriate place.

[1] https://github.com/intel-aero/linux-kernel/blob/a1b673258feb915268377275130c5c5df0eafc82/drivers/media/pci/atomisp/css/sh_css.c#L552-L558
[2] https://github.com/intel-aero/linux-kernel/search?q=IS_ISP_2400_SYSTEM

  ## `isys_stream_descr->polling_mode` case

This does not exist on the intel-aero atomisp. This is because it is
based on css version irci_stable_candrpv_0415_20150521_0458.

On the other hand, the upstreamed atomisp is based on the following css
version depending on the ISP version using ifdefs:

  - ISP2400: irci_stable_candrpv_0415_20150521_0458
  - ISP2401: irci_master_20150911_0724

The `isys_stream_descr->polling_mode` usage was added on updating css
version to irci_master_20150701_0213 [3].

So, it is not a ISP version specific thing, but css version specific
thing. Because the upstreamed atomisp driver uses irci_master_20150911_0724
for ISP2401, re-add the ISP version check for now.

I say "for now" because ISP2401 should eventually use the same css
version with ISP2400 (i.e., irci_stable_candrpv_0415_20150521_0458)

[3] https://raw.githubusercontent.com/intel/ProductionKernelQuilts/cht-m1stable-2016_ww31/uefi/cht-m1stable/patches/cam-0439-atomisp2-css2401-and-2401_legacy-irci_master_2015070.patch
    ("atomisp2: css2401 and 2401_legacy-irci_master_20150701_0213")
    Link to Intel's Android kernel patch.

 ## `coord = &me->config.internal_frame_origin_bqs_on_sctbl;` case

it was added on commit 4f744a573db3 ("media: atomisp: make
sh_css_sp_init_pipeline() ISP version independent") for ISP2401. Because
the upstreamed atomisp for the ISP2401 part is based on
irci_master_20150911_0724, hence the difference.

Because the upstreamed atomisp driver uses irci_master_20150911_0724
for ISP2401, revert the test back to `if (IS_ISP2401)`.

Fixes: 27333dadef57 ("media: atomisp: adjust some code at sh_css that could be broken")
Signed-off-by: Tsuchiya Yuto <kitakar@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/atomisp/pci/sh_css.c | 27 +++++++++-------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/sh_css.c b/drivers/staging/media/atomisp/pci/sh_css.c
index ddee04c8248d0..54a18921fbd15 100644
--- a/drivers/staging/media/atomisp/pci/sh_css.c
+++ b/drivers/staging/media/atomisp/pci/sh_css.c
@@ -527,6 +527,7 @@ ia_css_stream_input_format_bits_per_pixel(struct ia_css_stream *stream)
 	return bpp;
 }
 
+/* TODO: move define to proper file in tools */
 #define GP_ISEL_TPG_MODE 0x90058
 
 #if !defined(ISP2401)
@@ -579,12 +580,8 @@ sh_css_config_input_network(struct ia_css_stream *stream) {
 		vblank_cycles = vblank_lines * (width + hblank_cycles);
 		sh_css_sp_configure_sync_gen(width, height, hblank_cycles,
 					     vblank_cycles);
-		if (!IS_ISP2401) {
-			if (pipe->stream->config.mode == IA_CSS_INPUT_MODE_TPG) {
-				/* TODO: move define to proper file in tools */
-				ia_css_device_store_uint32(GP_ISEL_TPG_MODE, 0);
-			}
-		}
+		if (pipe->stream->config.mode == IA_CSS_INPUT_MODE_TPG)
+			ia_css_device_store_uint32(GP_ISEL_TPG_MODE, 0);
 	}
 	ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE_PRIVATE,
 			    "sh_css_config_input_network() leave:\n");
@@ -1019,16 +1016,14 @@ static bool sh_css_translate_stream_cfg_to_isys_stream_descr(
 	 * ia_css_isys_stream_capture_indication() instead of
 	 * ia_css_pipeline_sp_wait_for_isys_stream_N() as isp processing of
 	 * capture takes longer than getting an ISYS frame
-	 *
-	 * Only 2401 relevant ??
 	 */
-#if 0 // FIXME: NOT USED on Yocto Aero
-	isys_stream_descr->polling_mode
-	    = early_polling ? INPUT_SYSTEM_POLL_ON_CAPTURE_REQUEST
-	      : INPUT_SYSTEM_POLL_ON_WAIT_FOR_FRAME;
-	ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE_PRIVATE,
-			    "sh_css_translate_stream_cfg_to_isys_stream_descr() leave:\n");
-#endif
+	if (IS_ISP2401) {
+		isys_stream_descr->polling_mode
+		    = early_polling ? INPUT_SYSTEM_POLL_ON_CAPTURE_REQUEST
+		      : INPUT_SYSTEM_POLL_ON_WAIT_FOR_FRAME;
+		ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE_PRIVATE,
+				    "sh_css_translate_stream_cfg_to_isys_stream_descr() leave:\n");
+	}
 
 	return rc;
 }
@@ -1451,7 +1446,7 @@ static void start_pipe(
 
 	assert(me); /* all callers are in this file and call with non null argument */
 
-	if (!IS_ISP2401) {
+	if (IS_ISP2401) {
 		coord = &me->config.internal_frame_origin_bqs_on_sctbl;
 		params = me->stream->isp_params_configs;
 	}
-- 
2.34.1



