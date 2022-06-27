Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6032855E26A
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236163AbiF0LiQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236412AbiF0LhX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:37:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74A72B11;
        Mon, 27 Jun 2022 04:32:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 303C6B80E6F;
        Mon, 27 Jun 2022 11:32:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CB96C3411D;
        Mon, 27 Jun 2022 11:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329549;
        bh=O+K58Y8XS0NwtGq2lbcrHbcvtEFN2KTPEyGnAd9qpdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wh7YdLENBZZ/BSS+chb2aezmuXMi9avO1VKt/ArYPAtffEMZon5pFp0k/uZhagqgZ
         TN81/qWD3jZFVaaenhixofqsKKBDfSuTJt+CxkIIliBfv4E+N7DTm8P5/s393RDVva
         7Jrb1JR2Ybw1LyVcs/fGvHc/Lm/qDtckgMEmWctY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 004/135] ALSA: hda/conexant: Fix missing beep setup
Date:   Mon, 27 Jun 2022 13:20:11 +0200
Message-Id: <20220627111938.285623141@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111938.151743692@linuxfoundation.org>
References: <20220627111938.151743692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 5faa0bc69102f3a4c605581564c367be5eb94dfa upstream.

Currently the Conexant codec driver sets up the beep NID after calling
snd_hda_gen_parse_auto_config().  It turned out that this results in
the insufficient setup for the beep control, as the generic parser
handles the fake path in snd_hda_gen_parse_auto_config() only if the
beep_nid is set up beforehand.

For dealing with the beep widget properly, call cx_auto_parse_beep()
before snd_hda_gen_parse_auto_config() call.

Fixes: 51e19ca5f755 ("ALSA: hda/conexant - Clean up beep code")
Cc: <stable@vger.kernel.org>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216152
Link: https://lore.kernel.org/r/20220620104008.1994-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_conexant.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -1079,11 +1079,11 @@ static int patch_conexant_auto(struct hd
 	if (err < 0)
 		goto error;
 
-	err = snd_hda_gen_parse_auto_config(codec, &spec->gen.autocfg);
+	err = cx_auto_parse_beep(codec);
 	if (err < 0)
 		goto error;
 
-	err = cx_auto_parse_beep(codec);
+	err = snd_hda_gen_parse_auto_config(codec, &spec->gen.autocfg);
 	if (err < 0)
 		goto error;
 


