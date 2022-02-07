Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF0454ABC72
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:48:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbiBGLhh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:37:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359797AbiBGL2q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:28:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B186C02C451;
        Mon,  7 Feb 2022 03:27:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F34C0B81158;
        Mon,  7 Feb 2022 11:26:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 363CFC004E1;
        Mon,  7 Feb 2022 11:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233199;
        bh=wgI2JfwnGs9YATRBKGTUEYM00WplHCkNomidae7ocq0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0f5GyFz8ib+wdXvFIXOKyyBEOyLmUovADcSXUPARbrOlxheWnIj3ylNf3aO0QkTeY
         lC5nyeevmeEda4WpjmZMyW+ChmbjlsfKgBqQW8v7QRHottzOI7yDQSVcSsQTDWhVnT
         037/OvvJEq11w6g3SYpB+UgJRzMnsG2yaurghuD0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 047/110] ALSA: hda: Skip codec shutdown in case the codec is not registered
Date:   Mon,  7 Feb 2022 12:06:20 +0100
Message-Id: <20220207103803.876984550@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103802.280120990@linuxfoundation.org>
References: <20220207103802.280120990@linuxfoundation.org>
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
 


