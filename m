Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27C10561C87
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 16:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235999AbiF3N7x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 09:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236123AbiF3N5n (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 09:57:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B44553D02;
        Thu, 30 Jun 2022 06:51:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F09DB82AD8;
        Thu, 30 Jun 2022 13:50:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D368DC34115;
        Thu, 30 Jun 2022 13:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656597053;
        bh=NbbeKQEkCqGH7eRSg2mh0Rg8B4WuQz46K8KLqlu+Qdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sjCZVfdku1dYc0E/Zd6KS1tNvHs0gSv9VDanG0wq6+XzT/Ha0shtMXCAY4UUMomiG
         t+xXs2Db1O8+3IytBln/O+L+W6JWBqeSsjr4vssfrWFpvBgpPMFvxGLsFq8uXrJzh+
         Z5A1/ROBfoARh9yKYwyfM9LdV7yXadf1vymdOJ94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 03/49] ALSA: hda/via: Fix missing beep setup
Date:   Thu, 30 Jun 2022 15:46:16 +0200
Message-Id: <20220630133234.010703384@linuxfoundation.org>
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
@@ -533,11 +533,11 @@ static int via_parse_auto_config(struct
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
 


