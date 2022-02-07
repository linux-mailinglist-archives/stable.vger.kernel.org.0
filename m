Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34E3B4ABCD0
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:50:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387133AbiBGLj0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:39:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386025AbiBGLdU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:33:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75BD5C043181;
        Mon,  7 Feb 2022 03:33:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E6AD60C8E;
        Mon,  7 Feb 2022 11:33:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAD58C004E1;
        Mon,  7 Feb 2022 11:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233599;
        bh=8eH1MdEVdu2hKNRuGIzmCqaimYky5xcS1WJ3g2iEc98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nYBjP/lpsYMSpxS2KGxgpjebAfpxTLD9ORgOuV013wD4J8V1fPzwukRYrJbXRsIbf
         J2t7UxSXcvhcDQj6YHRhSGJyhBibqJWtAARj3QtAUwFpGtfiBGhm+pZ34wqhJLwCHz
         nhLb3pWzNtxwGHYa7ajQ3ZOkIp2ey8Z1BpiTjxMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.16 055/126] ALSA: hda: Fix signedness of sscanf() arguments
Date:   Mon,  7 Feb 2022 12:06:26 +0100
Message-Id: <20220207103806.014919306@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103804.053675072@linuxfoundation.org>
References: <20220207103804.053675072@linuxfoundation.org>
User-Agent: quilt/0.66
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

commit 0444f82766f0b5b9c8302ad802dafa5dd0e722d0 upstream.

The %x format of sscanf() takes an unsigned int pointer, while we pass
a signed int pointer.  Practically it's OK, but this may result in a
compile warning.  Let's fix it.

Fixes: a235d5b8e550 ("ALSA: hda: Allow model option to specify PCI SSID alias")
Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/r/20220127135717.31751-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/hda_auto_parser.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/hda_auto_parser.c
+++ b/sound/pci/hda/hda_auto_parser.c
@@ -985,7 +985,7 @@ void snd_hda_pick_fixup(struct hda_codec
 	int id = HDA_FIXUP_ID_NOT_SET;
 	const char *name = NULL;
 	const char *type = NULL;
-	int vendor, device;
+	unsigned int vendor, device;
 
 	if (codec->fixup_id != HDA_FIXUP_ID_NOT_SET)
 		return;


