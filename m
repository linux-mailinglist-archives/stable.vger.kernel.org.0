Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E46D61597B
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:12:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbiKBDMh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbiKBDMY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:12:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 824BB248C3
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:11:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E7CB617BA
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:11:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7C8C433D6;
        Wed,  2 Nov 2022 03:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667358707;
        bh=9YE8xNRwQ1S/L6+fnhltSfnHxtdI6bfsQfhQFrF1GS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gdVNiqRREAZ4RoGoCnjJivf8l3+51NR3D7h2mvtlEmOOsDESdHhOATMFFzGgRy42f
         tj5U7tKUDzkKHXmzIVntz+4fzXSI5ZmjuIBpWzSbktvpbbNo8qH/mc3gMmKZ11SSqQ
         bBFU26Z+2hJ5dDintxta2Zp8sHbSW1YtF+BIJGMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 04/91] ALSA: au88x0: use explicitly signed char
Date:   Wed,  2 Nov 2022 03:32:47 +0100
Message-Id: <20221102022055.163682020@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022055.039689234@linuxfoundation.org>
References: <20221102022055.039689234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit ee03c0f200eb0d9f22dd8732d9fb7956d91019c2 upstream.

With char becoming unsigned by default, and with `char` alone being
ambiguous and based on architecture, signed chars need to be marked
explicitly as such. This fixes warnings like:

sound/pci/au88x0/au88x0_core.c:2029 vortex_adb_checkinout() warn: signedness bug returning '(-22)'
sound/pci/au88x0/au88x0_core.c:2046 vortex_adb_checkinout() warn: signedness bug returning '(-12)'
sound/pci/au88x0/au88x0_core.c:2125 vortex_adb_allocroute() warn: 'vortex_adb_checkinout(vortex, (0), en, 0)' is unsigned
sound/pci/au88x0/au88x0_core.c:2170 vortex_adb_allocroute() warn: 'vortex_adb_checkinout(vortex, stream->resources, en, 4)' is unsigned

As well, since one function returns errnos, return an `int` rather than
a `signed char`.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20221024162929.536004-1-Jason@zx2c4.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/au88x0/au88x0.h      |    6 +++---
 sound/pci/au88x0/au88x0_core.c |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/sound/pci/au88x0/au88x0.h
+++ b/sound/pci/au88x0/au88x0.h
@@ -141,7 +141,7 @@ struct snd_vortex {
 #ifndef CHIP_AU8810
 	stream_t dma_wt[NR_WT];
 	wt_voice_t wt_voice[NR_WT];	/* WT register cache. */
-	char mixwt[(NR_WT / NR_WTPB) * 6];	/* WT mixin objects */
+	s8 mixwt[(NR_WT / NR_WTPB) * 6];	/* WT mixin objects */
 #endif
 
 	/* Global resources */
@@ -235,8 +235,8 @@ static int vortex_alsafmt_aspfmt(snd_pcm
 static void vortex_connect_default(vortex_t * vortex, int en);
 static int vortex_adb_allocroute(vortex_t * vortex, int dma, int nr_ch,
 				 int dir, int type, int subdev);
-static char vortex_adb_checkinout(vortex_t * vortex, int resmap[], int out,
-				  int restype);
+static int vortex_adb_checkinout(vortex_t * vortex, int resmap[], int out,
+				 int restype);
 #ifndef CHIP_AU8810
 static int vortex_wt_allocroute(vortex_t * vortex, int dma, int nr_ch);
 static void vortex_wt_connect(vortex_t * vortex, int en);
--- a/sound/pci/au88x0/au88x0_core.c
+++ b/sound/pci/au88x0/au88x0_core.c
@@ -1998,7 +1998,7 @@ static const int resnum[VORTEX_RESOURCE_
  out: Mean checkout if != 0. Else mean Checkin resource.
  restype: Indicates type of resource to be checked in or out.
 */
-static char
+static int
 vortex_adb_checkinout(vortex_t * vortex, int resmap[], int out, int restype)
 {
 	int i, qty = resnum[restype], resinuse = 0;


