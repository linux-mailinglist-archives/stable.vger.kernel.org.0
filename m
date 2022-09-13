Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8826D5B6F7F
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232837AbiIMOLb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:11:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232754AbiIMOKR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:10:17 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D85A265E;
        Tue, 13 Sep 2022 07:09:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DBD83CE1271;
        Tue, 13 Sep 2022 14:09:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E50B6C433B5;
        Tue, 13 Sep 2022 14:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078167;
        bh=mvwsHrLNf7H9ACenmnm4IYVA2zqJfnuZXGMlcGru+I0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UrwFtcPQUNM404Z53HTAnoZ5lSfJlQkyv0wLn7wTEin5x+J5TAILKi3ryvTjIGu9O
         gQHq9DdIOPw5nSSb9BvgSs1hnVZLY3mJYHR35VFiFU1PhxKr9ThIlEAiNp5WDj5nHJ
         UShOm45d5lg3y6YC0nJb1HTGVgCKE699/amuprFo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.19 037/192] ALSA: hda: Once again fix regression of page allocations with IOMMU
Date:   Tue, 13 Sep 2022 16:02:23 +0200
Message-Id: <20220913140411.766265237@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Takashi Iwai <tiwai@suse.de>

commit 37137ec26c2c03039d8064c00f6eae176841ee0d upstream.

The last fix for trying to recover the regression on AMD platforms,
unfortunately, leaded to yet another regression: it turned out that
IOMMUs don't like the usage of raw page allocations.

This is yet another attempt for addressing the log saga; at this time,
we re-use the existing buffer allocation mechanism with SG-pages
although we require only single pages.  The SG buffer allocation
itself was confirmed to work for stream buffers, so it's relatively
easy to adapt for other places.

The only problem is: although the HD-audio code is accessing the
address directly via dmab->address field, SG-pages don't set up it.
For the ease of adaption, we now set up the dmab->addr field from the
address of the first page as default, so that it can run with the
HD-audio driver code as-is without the excessive call of
snd_sgbuf_get_addr() multiple times; that's the only change in the
memalloc helper side.  The rest is nothing but a flip of the dma_type
field in the HD-audio side.

Fixes: a8d302a0b770 ("ALSA: memalloc: Revive x86-specific WC page allocations again")
Reported-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Tested-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/CABXGCsO+kB2t5QyHY-rUe76npr1m0-5JOtt8g8SiHUo34ur7Ww@mail.gmail.com
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216112
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216363
Link: https://lore.kernel.org/r/20220906090319.23358-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/memalloc.c     |    9 +++++++--
 sound/pci/hda/hda_intel.c |    2 +-
 2 files changed, 8 insertions(+), 3 deletions(-)

--- a/sound/core/memalloc.c
+++ b/sound/core/memalloc.c
@@ -535,10 +535,13 @@ static void *snd_dma_noncontig_alloc(str
 	dmab->dev.need_sync = dma_need_sync(dmab->dev.dev,
 					    sg_dma_address(sgt->sgl));
 	p = dma_vmap_noncontiguous(dmab->dev.dev, size, sgt);
-	if (p)
+	if (p) {
 		dmab->private_data = sgt;
-	else
+		/* store the first page address for convenience */
+		dmab->addr = snd_sgbuf_get_addr(dmab, 0);
+	} else {
 		dma_free_noncontiguous(dmab->dev.dev, size, sgt, dmab->dev.dir);
+	}
 	return p;
 }
 
@@ -772,6 +775,8 @@ static void *snd_dma_sg_fallback_alloc(s
 	if (!p)
 		goto error;
 	dmab->private_data = sgbuf;
+	/* store the first page address for convenience */
+	dmab->addr = snd_sgbuf_get_addr(dmab, 0);
 	return p;
 
  error:
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -1817,7 +1817,7 @@ static int azx_create(struct snd_card *c
 
 	/* use the non-cached pages in non-snoop mode */
 	if (!azx_snoop(chip))
-		azx_bus(chip)->dma_type = SNDRV_DMA_TYPE_DEV_WC;
+		azx_bus(chip)->dma_type = SNDRV_DMA_TYPE_DEV_WC_SG;
 
 	if (chip->driver_type == AZX_DRIVER_NVIDIA) {
 		dev_dbg(chip->card->dev, "Enable delay in RIRB handling\n");


