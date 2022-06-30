Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F011D561C29
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 15:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235788AbiF3N5C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 09:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235896AbiF3N4b (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 09:56:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 001138736E;
        Thu, 30 Jun 2022 06:50:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89C2462009;
        Thu, 30 Jun 2022 13:50:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91F16C34115;
        Thu, 30 Jun 2022 13:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656597056;
        bh=2sFKLwZBKaUx5/6j1UGYHDXTcu1SDlI/GP1hp4ivWUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iFcbvuOJ0K0cmE/TGIzCA/tlMhbVFgNKjRJoQvKe/e8v14bVQIe4YTXsCYn9GCNUJ
         6gzSzr8CrBwiQfmbHqCJOEhveSYQqYFTuPmCjXyl8V2vugw8miA6XtCGZK2nPne/BK
         D9oPZDDbxnOlZgagfbLpgkQmF3WqXtG8tXegepkE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 04/49] ALSA: hda/conexant: Fix missing beep setup
Date:   Thu, 30 Jun 2022 15:46:17 +0200
Message-Id: <20220630133234.039219005@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133233.910803744@linuxfoundation.org>
References: <20220630133233.910803744@linuxfoundation.org>
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
@@ -1061,11 +1061,11 @@ static int patch_conexant_auto(struct hd
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
 


