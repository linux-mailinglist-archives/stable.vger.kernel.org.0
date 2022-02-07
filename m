Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05ECD4ABD27
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377747AbiBGLjr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:39:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386206AbiBGLd5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:33:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 133FEC043181;
        Mon,  7 Feb 2022 03:33:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3C1BB8102E;
        Mon,  7 Feb 2022 11:33:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9334C004E1;
        Mon,  7 Feb 2022 11:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233634;
        bh=wgI2JfwnGs9YATRBKGTUEYM00WplHCkNomidae7ocq0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E5hJrcYu2fgD30Z5xz5W3arU6JP9ykG3Zt4ozcxDXkAgl688Ufa1Mce1Vhi+K8J8S
         XBUdt69pqAsuki+d4es/NBP7AM+XvedSWvp4p4W9VawdiRQvljzqk2LKyiDCiRfZUk
         FEiRktLy6wEXGDtAVTsYjTzm2h8/HnmRuvpuX2Ek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.16 056/126] ALSA: hda: Skip codec shutdown in case the codec is not registered
Date:   Mon,  7 Feb 2022 12:06:27 +0100
Message-Id: <20220207103806.052435714@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103804.053675072@linuxfoundation.org>
References: <20220207103804.053675072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit 1c7f0e349aa5f8f80b1cac3d4917405332e14cdf upstream.

If the codec->registered is not set then it means that pm_runtime is
not yet enabled and the codec->pcm_list_head has not been initialized.

The access to the not initialized pcm_list_head will lead a kernel crash
during shutdown.

Reported-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Tested-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Fixes: b98444ed597d ("ALSA: hda: Suspend codec at shutdown")
Link: https://lore.kernel.org/r/20220201112144.29411-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/hda_codec.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -3000,6 +3000,10 @@ void snd_hda_codec_shutdown(struct hda_c
 {
 	struct hda_pcm *cpcm;
 
+	/* Skip the shutdown if codec is not registered */
+	if (!codec->registered)
+		return;
+
 	list_for_each_entry(cpcm, &codec->pcm_list_head, list)
 		snd_pcm_suspend_all(cpcm->pcm);
 


