Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F06E3CE3EC
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344298AbhGSPlM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:41:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:59806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347973AbhGSPfV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FA1D61494;
        Mon, 19 Jul 2021 16:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711190;
        bh=uG/bOACiXnipF7frzN43OzvSqgdcFLXtJExWq0kHYQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=spRAbhF7ZVs6Efgg08wP5KEiSVCMO6JlaBLyP3ezcUxH52dmmf2FmrTl5NJ1QnNPT
         EN0YMmw/Q2Gtdrduh6MbgiE/pGtgjzSQHJZyoMqbv/mt50NyWGdGhChHhcybyOsRI3
         h4Fq807INn3f9LkmoWdxquJJRmmYXFP42kHSavro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 261/351] ALSA: isa: Fix error return code in snd_cmi8330_probe()
Date:   Mon, 19 Jul 2021 16:53:27 +0200
Message-Id: <20210719144953.582776699@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit 31028cbed26a8afa25533a10425ffa2ab794c76c ]

When 'SB_HW_16' check fails, the error code -ENODEV instead of 0 should be
returned, which is the same as that returned when 'WSS_HW_CMI8330' check
fails.

Fixes: 43bcd973d6d0 ("[ALSA] Add snd_card_set_generic_dev() call to ISA drivers")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Link: https://lore.kernel.org/r/20210707074051.2663-1-thunder.leizhen@huawei.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/isa/cmi8330.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/isa/cmi8330.c b/sound/isa/cmi8330.c
index bc112df10fc5..d1ac9fc99491 100644
--- a/sound/isa/cmi8330.c
+++ b/sound/isa/cmi8330.c
@@ -547,7 +547,7 @@ static int snd_cmi8330_probe(struct snd_card *card, int dev)
 	}
 	if (acard->sb->hardware != SB_HW_16) {
 		snd_printk(KERN_ERR PFX "SB16 not found during probe\n");
-		return err;
+		return -ENODEV;
 	}
 
 	snd_wss_out(acard->wss, CS4231_MISC_INFO, 0x40); /* switch on MODE2 */
-- 
2.30.2



