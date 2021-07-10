Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4ED3C303F
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234675AbhGJCeF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:34:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:51680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233105AbhGJCce (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:32:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD9276143E;
        Sat, 10 Jul 2021 02:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884079;
        bh=aNgvai2dHUFLmKna88+VloTUFYnAA2YEoAtKk5xaEIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i0Dqnz/kQ3fmjYrpX4SiVF0d4yYS4M/e5yYYyyI5pkGHLmXSkZekgG1czlZVvf3rV
         r4MCe78oWiJ+swihJ3EgXI9yb2+7plLypcg4wWZZWk9XFc6H1DlmASaRVn/HcLF2OJ
         KauzWNVG2GTmY0zW9ka3IglHCZbDcqgAJZ9CsPNQlhtYTjGFDPxxr5VWptweW+tC7h
         ikFaNowB8z4NzGFWc3pC5O0hZgANh2hxSbyUfR7aXsaQoBP4S4RmQX2XgSdyO0vs5d
         Ci4xpRi0zGeLAGgpvp/ppMTGt1R1sBye33/tHaWhApPbY+6BlrGLa58Fs9ircUPjMo
         zHQM0ZMo+usBw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.4 39/63] ALSA: ppc: fix error return code in snd_pmac_probe()
Date:   Fri,  9 Jul 2021 22:26:45 -0400
Message-Id: <20210710022709.3170675-39-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022709.3170675-1-sashal@kernel.org>
References: <20210710022709.3170675-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 80b9c1be567c3c6bbe0d4b290af578e630485b5d ]

If snd_pmac_tumbler_init() or snd_pmac_tumbler_post_init() fails,
snd_pmac_probe() need return error code.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20210616021121.1991502-1-yangyingliang@huawei.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/ppc/powermac.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/ppc/powermac.c b/sound/ppc/powermac.c
index 96ef55082bf9..b135d114ce89 100644
--- a/sound/ppc/powermac.c
+++ b/sound/ppc/powermac.c
@@ -77,7 +77,11 @@ static int snd_pmac_probe(struct platform_device *devptr)
 		sprintf(card->shortname, "PowerMac %s", name_ext);
 		sprintf(card->longname, "%s (Dev %d) Sub-frame %d",
 			card->shortname, chip->device_id, chip->subframe);
-		if ( snd_pmac_tumbler_init(chip) < 0 || snd_pmac_tumbler_post_init() < 0)
+		err = snd_pmac_tumbler_init(chip);
+		if (err < 0)
+			goto __error;
+		err = snd_pmac_tumbler_post_init();
+		if (err < 0)
 			goto __error;
 		break;
 	case PMAC_AWACS:
-- 
2.30.2

