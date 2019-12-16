Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 022CD121938
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727749AbfLPRxa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:53:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:47526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727241AbfLPRx3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:53:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50473206D3;
        Mon, 16 Dec 2019 17:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576518808;
        bh=mcG230k4lamzWpW3NpAe1KHV2HqJzW67mkEHLprDO9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BnBcZxcncbTrL0OOxPJf6Uv89dcYHev6XMmGRf3fGkU6X64l96lzFiBK9g1WF+e52
         Pmwn8kQcMOVZ6rty6iyfkXOSJc3eEjjwS5XOZtFHCPwQmvtctMawHfcPCb7xM4D5Vp
         XXpjpCdvpvlI6mrY/TcTuGTEJw2VbF1wY3zZSwvw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nguyen Viet Dung <dung.nguyen.aj@renesas.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Hiroyuki Yokoyama <hiroyuki.yokoyama.vx@renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 076/267] ASoC: rsnd: tidyup registering method for rsnd_kctrl_new()
Date:   Mon, 16 Dec 2019 18:46:42 +0100
Message-Id: <20191216174856.947138993@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit 9c698e8481a15237a5b1db5f8391dd66d59e42a4 ]

Current rsnd dvc.c is using flags to avoid duplicating register for
MIXer case. OTOH, commit e894efef9ac7 ("ASoC: core: add support to card
rebind") allows to rebind sound card without rebinding all drivers.

Because of above patch and dvc.c flags, it can't re-register kctrl if
only sound card was rebinded, because dvc is keeping old flags.
(Of course it will be no problem if rsnd driver also be rebinded,
but it is not purpose of above patch).

This patch checks current card registered kctrl when registering.
In MIXer case, it can avoid duplicate register if card already has same
kctrl. In rebind case, it can re-register kctrl because card registered
kctl had been removed when unbinding.

This patch is updated version of commit b918f1bc7f1ce ("ASoC: rsnd: DVC
kctrl sets once")

Reported-by: Nguyen Viet Dung <dung.nguyen.aj@renesas.com>
Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Tested-by: Nguyen Viet Dung <dung.nguyen.aj@renesas.com>
Cc: Hiroyuki Yokoyama <hiroyuki.yokoyama.vx@renesas.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sh/rcar/core.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/sound/soc/sh/rcar/core.c b/sound/soc/sh/rcar/core.c
index ab0bbef7eb48a..bb06dd72ca9a7 100644
--- a/sound/soc/sh/rcar/core.c
+++ b/sound/soc/sh/rcar/core.c
@@ -1278,6 +1278,18 @@ int rsnd_kctrl_new(struct rsnd_mod *mod,
 	};
 	int ret;
 
+	/*
+	 * 1) Avoid duplicate register (ex. MIXer case)
+	 * 2) re-register if card was rebinded
+	 */
+	list_for_each_entry(kctrl, &card->controls, list) {
+		struct rsnd_kctrl_cfg *c = kctrl->private_data;
+
+		if (strcmp(kctrl->id.name, name) == 0 &&
+		    c->mod == mod)
+			return 0;
+	}
+
 	if (size > RSND_MAX_CHANNELS)
 		return -EINVAL;
 
-- 
2.20.1



