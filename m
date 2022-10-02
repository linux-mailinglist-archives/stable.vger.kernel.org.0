Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08BF55F2691
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 00:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbiJBWyp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Oct 2022 18:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbiJBWxo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Oct 2022 18:53:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F90B186F1;
        Sun,  2 Oct 2022 15:51:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D1F060EF1;
        Sun,  2 Oct 2022 22:51:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C0BAC433C1;
        Sun,  2 Oct 2022 22:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664751085;
        bh=fePKjXwvZe4cssNgNOsnoApiIf49pkGwedEnC0k3pl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u4QqXy0P6hSOnCM7uWr3nw+MhYJ6Qom1iVuGiH91dRCcrwxK9DHp6SG1KntNUjw0L
         MrTvG9n2xBV3gQBOiTEEw3LrQwkqxXcxg1yu+kZWpSg+KBPfzDj8uuyMDScA9vMleP
         zOJSJ8WJxTfhmIJvcV20YlavN9QH7rzWyQDiKs9FojzpR6bgN7KXo++LE+knSFBnHi
         KAFcE5jB3kUOtAnBSoEeW6W+VHmmTZsBuwT7KnsdJ5GLWfn7cAwBhG7D31ZgOEA/dP
         iHa394xKrayCRPVR7O8TF1J+wVC/Tzt4dTVN+2AH5VHpUrdSYigaTPbX/w4mS3cNwM
         7E3FNv2+0g7ew==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jaroslav Kysela <perex@perex.cz>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        tiwai@suse.com, mkumard@nvidia.com,
        pierre-louis.bossart@linux.intel.com,
        ville.syrjala@linux.intel.com, kai.heng.feng@canonical.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.15 12/20] ALSA: hda/hdmi: Fix the converter reuse for the silent stream
Date:   Sun,  2 Oct 2022 18:50:51 -0400
Message-Id: <20221002225100.239217-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221002225100.239217-1-sashal@kernel.org>
References: <20221002225100.239217-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaroslav Kysela <perex@perex.cz>

[ Upstream commit 5f80d6bd2b01de4cafac3302f58456bf860322fc ]

When the user space pcm stream uses the silent stream converter,
it is no longer allocated for the silent stream. Clear the appropriate
flag in the hdmi_pcm_open() function. The silent stream setup may
be applied in hdmi_pcm_close() (and the error path - open fcn) again.

If the flag is not cleared, the reuse conditions for the silent
stream converter in hdmi_choose_cvt() may improperly share
this converter.

Cc: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Link: https://lore.kernel.org/r/20220913070216.3233974-1-perex@perex.cz
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_hdmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 24da843f39a1..b3bcc6df5985 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1259,6 +1259,7 @@ static int hdmi_pcm_open(struct hda_pcm_stream *hinfo,
 	set_bit(pcm_idx, &spec->pcm_in_use);
 	per_pin = get_pin(spec, pin_idx);
 	per_pin->cvt_nid = per_cvt->cvt_nid;
+	per_pin->silent_stream = false;
 	hinfo->nid = per_cvt->cvt_nid;
 
 	/* flip stripe flag for the assigned stream if supported */
-- 
2.35.1

