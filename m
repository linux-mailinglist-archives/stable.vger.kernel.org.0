Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3C6369CC3F
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232001AbjBTNih (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:38:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbjBTNig (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:38:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FCDD1A941
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:38:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3189CB80D48
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:38:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2C07C4339B;
        Mon, 20 Feb 2023 13:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900312;
        bh=TuylgALl1Y1F7ON6Fsxa/NarENfJF5eVHjsPPGivcEM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PitO3AGc55bwyvTCbKc+/wiwu0jRrmfkOAsGxUhzRRqVkkaw6iZqUiySLdRpI3cMp
         7OP29TkRDSLL1lsV06PJ9izGb9CVjCyS9qbi11P7bXZvaLlvNYoz2zWoo+lj+a4w/Y
         2qX6AHJuV+Vpu2L0CKNn4EgOrbOK+iTMMdnZYPfo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Artemii Karasev <karasev@ispras.ru>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 03/53] ALSA: hda/via: Avoid potential array out-of-bound in add_secret_dac_path()
Date:   Mon, 20 Feb 2023 14:35:29 +0100
Message-Id: <20230220133548.289741597@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133548.158615609@linuxfoundation.org>
References: <20230220133548.158615609@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index 9dd104c308e1..5ab6d9b3e6d0 100644
--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -870,6 +870,9 @@ static int add_secret_dac_path(struct hda_codec *codec)
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



