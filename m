Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C628368D757
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 13:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbjBGM6z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 07:58:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231942AbjBGM6x (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 07:58:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AC2E7D9B
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 04:58:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15C36613DC
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 12:58:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 088AAC4339B;
        Tue,  7 Feb 2023 12:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675774729;
        bh=QaVhD6hGuu+MB3IpunfKLfI/p3BYivX3B9MKoA+9tEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2p8XfGMW1D47LVawVxMlCnWfnd4p8ej6cVVRB/yhBRU1uZ/942Q2ih4dGUkZiE/8K
         tZ4p6IXvDD75pTsAkHrTvOvVOaigaMVWQPh27CPff33AyUnMm17mLTkJcBSmoHBPq9
         5Bz1Zomcmg7P1NE0QHZMYD6qC2HsN3pIRuCMdJp8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Artemii Karasev <karasev@ispras.ru>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 015/208] ALSA: hda/via: Avoid potential array out-of-bound in add_secret_dac_path()
Date:   Tue,  7 Feb 2023 13:54:29 +0100
Message-Id: <20230207125635.028069131@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Artemii Karasev <karasev@ispras.ru>

[ Upstream commit b9cee506da2b7920b5ea02ccd8e78a907d0ee7aa ]

snd_hda_get_connections() can return a negative error code.
It may lead to accessing 'conn' array at a negative index.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Artemii Karasev <karasev@ispras.ru>
Fixes: 30b4503378c9 ("ALSA: hda - Expose secret DAC-AA connection of some VIA codecs")
Link: https://lore.kernel.org/r/20230119082259.3634-1-karasev@ispras.ru
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_via.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/pci/hda/patch_via.c b/sound/pci/hda/patch_via.c
index aea7fae2ca4b..2994f85bc1b9 100644
--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -819,6 +819,9 @@ static int add_secret_dac_path(struct hda_codec *codec)
 		return 0;
 	nums = snd_hda_get_connections(codec, spec->gen.mixer_nid, conn,
 				       ARRAY_SIZE(conn) - 1);
+	if (nums < 0)
+		return nums;
+
 	for (i = 0; i < nums; i++) {
 		if (get_wcaps_type(get_wcaps(codec, conn[i])) == AC_WID_AUD_OUT)
 			return 0;
-- 
2.39.0



