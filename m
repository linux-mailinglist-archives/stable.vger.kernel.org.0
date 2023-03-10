Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7FA6B4A7C
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:23:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232784AbjCJPXr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:23:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233387AbjCJPXW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:23:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D2765CC31
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:13:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C917061A01
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:52:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2EE8C433D2;
        Fri, 10 Mar 2023 14:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459934;
        bh=7c8m30BdcwP+54vQ6GLhcEOURqUqIiQ89ay8ji102NE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vWKi63gYrIUm7k6S2RqGRzpAe6C3lcFIAqaCAVBUvUj1SDkYK/BPLvh3ls8yRcGiD
         Uy256XxZhGnuAwUQC+GHpCvqTcH2mOW8hoxFU13aaAFicVh3U90rkVexevmNRZouAV
         BJwW//0Ev9jJpG9q8eGOVos+cthHvv2iYelnIgk8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Alexey V. Vissarionov" <gremlin@altlinux.org>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 168/529] ALSA: hda/ca0132: minor fix for allocation size
Date:   Fri, 10 Mar 2023 14:35:11 +0100
Message-Id: <20230310133812.733193280@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
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
index 82f14c3f642bd..24c2638cde376 100644
--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -2331,7 +2331,7 @@ static int dspio_set_uint_param_no_source(struct hda_codec *codec, int mod_id,
 static int dspio_alloc_dma_chan(struct hda_codec *codec, unsigned int *dma_chan)
 {
 	int status = 0;
-	unsigned int size = sizeof(dma_chan);
+	unsigned int size = sizeof(*dma_chan);
 
 	codec_dbg(codec, "     dspio_alloc_dma_chan() -- begin\n");
 	status = dspio_scp(codec, MASTERCONTROL, 0x20,
-- 
2.39.2



