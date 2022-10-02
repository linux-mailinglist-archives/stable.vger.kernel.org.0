Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D42CE5F2639
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 00:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbiJBWvV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Oct 2022 18:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbiJBWun (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Oct 2022 18:50:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA6916592;
        Sun,  2 Oct 2022 15:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 930DC60EBA;
        Sun,  2 Oct 2022 22:50:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8ACCC433C1;
        Sun,  2 Oct 2022 22:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664751006;
        bh=oRaeNM+kB4XeFHB9RkLIcAmmI+eFA6AzdtTYAyQE01c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F9CoZiYVoFagvS4pxe+nNcfHXHPgENUDZ77i+mCcg7x34qd14yBgzMU6Mvz9qMOyI
         lMBqoPEhZKJP6gVpWCUDRh2WXNSXkDXW/YfoyZpzHIqsvKoHv/hTqL+lTzx26sTiXz
         IAOcpKVukJAXpMN5YsZ7PWc/fD7mVg6F4Il3f9SsBfzg2HGEivbkoBrVam7nzh62x2
         RMrxo5lkvV4JDdYbhGYjKkwkVjBY1zoSuCc2HelGbK22v3UY3btJlZkLoKl093R7Nv
         Gnh8NOUKst6Lq+uHYDgeCSoeUQ+2xmOTQYNS05sI1ZJ0B5Vi+1gQOlI1EEb3oUfGpS
         x8SLs+xaiHgfw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jaroslav Kysela <perex@perex.cz>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        tiwai@suse.com, mkumard@nvidia.com,
        pierre-louis.bossart@linux.intel.com,
        ville.syrjala@linux.intel.com, kai.heng.feng@canonical.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.19 15/29] ALSA: hda/hdmi: Fix the converter reuse for the silent stream
Date:   Sun,  2 Oct 2022 18:49:08 -0400
Message-Id: <20221002224922.238837-15-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221002224922.238837-1-sashal@kernel.org>
References: <20221002224922.238837-1-sashal@kernel.org>
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
index 6c209cd26c0c..22766810635b 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1267,6 +1267,7 @@ static int hdmi_pcm_open(struct hda_pcm_stream *hinfo,
 	set_bit(pcm_idx, &spec->pcm_in_use);
 	per_pin = get_pin(spec, pin_idx);
 	per_pin->cvt_nid = per_cvt->cvt_nid;
+	per_pin->silent_stream = false;
 	hinfo->nid = per_cvt->cvt_nid;
 
 	/* flip stripe flag for the assigned stream if supported */
-- 
2.35.1

