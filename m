Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6662C3CDA0B
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242062AbhGSOcm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:32:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:47690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243529AbhGSObU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:31:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B335661205;
        Mon, 19 Jul 2021 15:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707520;
        bh=U3XyAJ4TRtQBnQOuHtoGHvzGvSgBkJEg6w1xIsCvSHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YskK85akB3eGNBCyU1YQXMU4GCQCInmxrfYmlzfiywesMwPbKoanLtDAcZ7zT9GVb
         H25ApQjCGnJ2yhd0B82OagVCBducv1K8djuUdprktwEDoDtodHNpbbYWxSmoPBWa+z
         twG/EvIfVmkGEdvaGqyaCb+UiTDJiJXraC55z5zk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 197/245] ALSA: ppc: fix error return code in snd_pmac_probe()
Date:   Mon, 19 Jul 2021 16:52:19 +0200
Message-Id: <20210719144946.770843317@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 33c6be9fb388..7c70ba5e2540 100644
--- a/sound/ppc/powermac.c
+++ b/sound/ppc/powermac.c
@@ -90,7 +90,11 @@ static int snd_pmac_probe(struct platform_device *devptr)
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



