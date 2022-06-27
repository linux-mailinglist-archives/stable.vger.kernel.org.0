Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D83AF55D776
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235369AbiF0L3w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235419AbiF0L3N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:29:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B0B8109;
        Mon, 27 Jun 2022 04:28:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D06F61494;
        Mon, 27 Jun 2022 11:28:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39F97C3411D;
        Mon, 27 Jun 2022 11:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329290;
        bh=NqWKPAx54vazXc3qKoDsW40jReYuUC9TIV8zapkZdIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mjtouuWwTbNllOMFg/k8oV6IGa1i4Vmy7jdM81p27HdTlg5Zcka/O6By316TrSMdv
         ElWneVZpW56k6/awhPyTbWwLR2moVAlOP02l/pc2n3fDs1P70flMyjLsHq1tZ2vzVG
         vXxdITunATjDZkxDd1xmcS7zqESTkiUzXA2CdtCs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 03/60] ALSA: hda/via: Fix missing beep setup
Date:   Mon, 27 Jun 2022 13:21:14 +0200
Message-Id: <20220627111927.748906353@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111927.641837068@linuxfoundation.org>
References: <20220627111927.641837068@linuxfoundation.org>
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

commit c7807b27d510e5aa53c8a120cfc02c33c24ebb5f upstream.

Like the previous fix for Conexant codec, the beep_nid has to be set
up before calling snd_hda_gen_parse_auto_config(); otherwise it'd miss
the path setup.

Fix the call order for addressing the missing beep setup.

Fixes: 0e8f9862493a ("ALSA: hda/via - Simplify control management")
Cc: <stable@vger.kernel.org>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216152
Link: https://lore.kernel.org/r/20220620104008.1994-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_via.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -520,11 +520,11 @@ static int via_parse_auto_config(struct
 	if (err < 0)
 		return err;
 
-	err = snd_hda_gen_parse_auto_config(codec, &spec->gen.autocfg);
+	err = auto_parse_beep(codec);
 	if (err < 0)
 		return err;
 
-	err = auto_parse_beep(codec);
+	err = snd_hda_gen_parse_auto_config(codec, &spec->gen.autocfg);
 	if (err < 0)
 		return err;
 


