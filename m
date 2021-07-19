Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E96343CE189
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349291AbhGSP00 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:26:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:40604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348084AbhGSPYe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:24:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A201B613F5;
        Mon, 19 Jul 2021 16:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710454;
        bh=xSBtEGB60n4H9EAEjCxhlr3ccB8h/4mssLV8fVgEEwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Znr9dj3BsZaZkVQcrn1X9kSgUWWt5B9Br21esMvKrx2/BlenPJSheuueIiGYQrUwq
         amcDNytyr0KQKTRZ1LvCZxq7U7Z/DHNIC/djmmNGxk2Anz6v7rbAYEJ7KCQ10e2HAf
         UE19iKMmzkEV/XIj70WFrhPQ5mOSiLXUCpWm9TJA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 179/243] ALSA: isa: Fix error return code in snd_cmi8330_probe()
Date:   Mon, 19 Jul 2021 16:53:28 +0200
Message-Id: <20210719144946.685052702@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
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
index 4669eb0cc8ce..5434cc90db1d 100644
--- a/sound/isa/cmi8330.c
+++ b/sound/isa/cmi8330.c
@@ -548,7 +548,7 @@ static int snd_cmi8330_probe(struct snd_card *card, int dev)
 	}
 	if (acard->sb->hardware != SB_HW_16) {
 		snd_printk(KERN_ERR PFX "SB16 not found during probe\n");
-		return err;
+		return -ENODEV;
 	}
 
 	snd_wss_out(acard->wss, CS4231_MISC_INFO, 0x40); /* switch on MODE2 */
-- 
2.30.2



