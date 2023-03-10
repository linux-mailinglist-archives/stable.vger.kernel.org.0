Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1A86B43DC
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232156AbjCJOTR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:19:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232057AbjCJOSs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:18:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5195B1ABE6
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:17:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C35B2B822CC
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:17:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED902C433D2;
        Fri, 10 Mar 2023 14:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457839;
        bh=cH20vsidyE9GU0I90u2Zyy/9JjiCnxfD8mgCSl3AK4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PwzHZmdV9+dVMmlcwB4wYQhAjiTdChLLjzhzJquuj0lwvCFfl52RUi5j13e5PnFox
         9iY83xpnJFu+rTZ0Xg7r5Vh2SqG+y464MyQNWq0Chvgne2oPnzfRDZXOgkWe83bJ5S
         3HIh6RvH4QEV2s76lVC9xvLw43IDYgtyIN9GxvJ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Alexey V. Vissarionov" <gremlin@altlinux.org>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 075/252] ALSA: hda/ca0132: minor fix for allocation size
Date:   Fri, 10 Mar 2023 14:37:25 +0100
Message-Id: <20230310133721.099473852@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
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

From: Alexey V. Vissarionov <gremlin@altlinux.org>

[ Upstream commit 3ee0fe7fa39b14d1cea455b7041f2df933bd97d2 ]

Although the "dma_chan" pointer occupies more or equal space compared
to "*dma_chan", the allocation size should use the size of variable
itself.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 01ef7dbffb41 ("ALSA: hda - Update CA0132 codec to load DSP firmware binary")
Signed-off-by: Alexey V. Vissarionov <gremlin@altlinux.org>
Link: https://lore.kernel.org/r/20230117111522.GA15213@altlinux.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_ca0132.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_ca0132.c b/sound/pci/hda/patch_ca0132.c
index 23f00ba993cb7..ca8a37388d565 100644
--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -1917,7 +1917,7 @@ static int dspio_set_uint_param_no_source(struct hda_codec *codec, int mod_id,
 static int dspio_alloc_dma_chan(struct hda_codec *codec, unsigned int *dma_chan)
 {
 	int status = 0;
-	unsigned int size = sizeof(dma_chan);
+	unsigned int size = sizeof(*dma_chan);
 
 	codec_dbg(codec, "     dspio_alloc_dma_chan() -- begin\n");
 	status = dspio_scp(codec, MASTERCONTROL, 0x20,
-- 
2.39.2



