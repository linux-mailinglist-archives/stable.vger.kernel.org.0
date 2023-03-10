Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFCC16B40E4
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbjCJNrb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:47:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbjCJNr1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:47:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 868E528E54
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:47:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 464BFB822B9
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:47:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E81C4339B;
        Fri, 10 Mar 2023 13:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456032;
        bh=Om8PxE6ZB+ne0XDEq6sArrC+EiRImwTx6kG/KFseuFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TUgaZIWgBtXT51VTO1/yvvLKy9hkQgWikZJQJs0Amj1XJBsNFZ6QZx64ZEmdvUH9e
         tNPRXh+RRX8FVKGYE+7zcyhMRv1Ogk2+b7gHOBjoUnITZTk6DWad6cVHLdki+kOa+p
         rui5Jd13Gu7qI7VokQrTFkWg6gfgnefGiPmaFrFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Alexey V. Vissarionov" <gremlin@altlinux.org>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 057/193] ALSA: hda/ca0132: minor fix for allocation size
Date:   Fri, 10 Mar 2023 14:37:19 +0100
Message-Id: <20230310133712.922927556@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
References: <20230310133710.926811681@linuxfoundation.org>
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
index 369f812d70722..280643f72c6e2 100644
--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -1523,7 +1523,7 @@ static int dspio_set_uint_param(struct hda_codec *codec, int mod_id,
 static int dspio_alloc_dma_chan(struct hda_codec *codec, unsigned int *dma_chan)
 {
 	int status = 0;
-	unsigned int size = sizeof(dma_chan);
+	unsigned int size = sizeof(*dma_chan);
 
 	codec_dbg(codec, "     dspio_alloc_dma_chan() -- begin\n");
 	status = dspio_scp(codec, MASTERCONTROL, MASTERCONTROL_ALLOC_DMA_CHAN,
-- 
2.39.2



