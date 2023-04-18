Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 614AA6E6474
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232124AbjDRMt0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232102AbjDRMtW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:49:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A3D214F6C
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:49:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9A38633F5
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:49:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B76ECC433EF;
        Tue, 18 Apr 2023 12:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822151;
        bh=c1pR8cWxhFF/daZjSAkj5rolbIrm46/edDw3/QyGyRk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XEvfKt7LbOJNDPMelioNpXCgpdNkNfiCDUAGZ27admRIGRMEo1SeWi5tq+veONYqJ
         iV/xarjwiOCGo+vJBgwieNaD3z51EQLy/AD1MUcDm778nd7W23DB1SChtLlyDiUpfJ
         4/tYuChlvPIWjDNUjW925/k4VLNczRD+8zuPsXy8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.2 012/139] ALSA: hda/hdmi: disable KAE for Intel DG2
Date:   Tue, 18 Apr 2023 14:21:17 +0200
Message-Id: <20230418120314.162279926@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

commit 6ab6f98fcdc9d4fbe245aa67de03542deea65322 upstream.

Use of keep-alive (KAE) has resulted in loss of audio on some A750/770
cards as the transition from keep-alive to stream playback is not
working as expected. As there is limited benefit of the new KAE mode
on discrete cards, revert back to older silent-stream implementation
on these systems.

Cc: stable@vger.kernel.org
Fixes: 15175a4f2bbb ("ALSA: hda/hdmi: add keep-alive support for ADL-P and DG2")
Link: https://gitlab.freedesktop.org/drm/intel/-/issues/8307
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20230413191153.3692049-1-kai.vehmanen@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_hdmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -4604,7 +4604,7 @@ HDA_CODEC_ENTRY(0x80862814, "DG1 HDMI",
 HDA_CODEC_ENTRY(0x80862815, "Alderlake HDMI",	patch_i915_tgl_hdmi),
 HDA_CODEC_ENTRY(0x80862816, "Rocketlake HDMI",	patch_i915_tgl_hdmi),
 HDA_CODEC_ENTRY(0x80862818, "Raptorlake HDMI",	patch_i915_tgl_hdmi),
-HDA_CODEC_ENTRY(0x80862819, "DG2 HDMI",	patch_i915_adlp_hdmi),
+HDA_CODEC_ENTRY(0x80862819, "DG2 HDMI",	patch_i915_tgl_hdmi),
 HDA_CODEC_ENTRY(0x8086281a, "Jasperlake HDMI",	patch_i915_icl_hdmi),
 HDA_CODEC_ENTRY(0x8086281b, "Elkhartlake HDMI",	patch_i915_icl_hdmi),
 HDA_CODEC_ENTRY(0x8086281c, "Alderlake-P HDMI", patch_i915_adlp_hdmi),


