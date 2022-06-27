Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 083C855D873
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234790AbiF0LYn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234780AbiF0LYi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:24:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12DB5658B;
        Mon, 27 Jun 2022 04:24:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A071D61458;
        Mon, 27 Jun 2022 11:24:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB10C3411D;
        Mon, 27 Jun 2022 11:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329077;
        bh=vEOyzikwHr8yUIyT1NrM8XxN7gOHcBAHFwZsTCrnaNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=edZSr5JYUekTSbL5mqLAD0ZW6n9XktTLFVaG0rMAzpBbdSYAWUZR18FGUy0lMxf18
         TUuUjEHOhZk0xCSxW9bTUpWZiMPeboDkf+0MbDSohF9rglg3Naag+CEaETwaeUg57I
         roRLgRVDrxB1aT6R2py3d96znlw0wf9uN54Ssivk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 005/102] ALSA: hda/conexant: Fix missing beep setup
Date:   Mon, 27 Jun 2022 13:20:16 +0200
Message-Id: <20220627111933.621750485@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111933.455024953@linuxfoundation.org>
References: <20220627111933.455024953@linuxfoundation.org>
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
@@ -1072,11 +1072,11 @@ static int patch_conexant_auto(struct hd
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
 


