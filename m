Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0D4147DA9
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 11:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388926AbgAXKCi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 05:02:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:38138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733301AbgAXKCi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 05:02:38 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53A572075D;
        Fri, 24 Jan 2020 10:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579860157;
        bh=03vxJpeyQt75CgTZoG1Wr9wuuaiFdoOiPQReOgQVZT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ewelbu33uXWAhuwn39/Hfl7D56e8HyOSlrmfCAHyitPgqfLWpk2r76OOs90bUCVPk
         d5cZoliOoxV8MV+T7lQ57DZsDGolLH6lFweJYEMv4Yo7guJaQ8CeNHGQATGq6O1TOR
         V4xlhqdzen2C/Os4k7KXHYpWf+Y8bUp+oOcyckN0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Johannes Berg <johannes@sipsolutions.net>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 263/343] ALSA: aoa: onyx: always initialize register read value
Date:   Fri, 24 Jan 2020 10:31:21 +0100
Message-Id: <20200124092954.615720135@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>

[ Upstream commit f474808acb3c4b30552d9c59b181244e0300d218 ]

A lot of places in the driver use onyx_read_register() without
checking the return value, and it's been working OK for ~10 years
or so, so probably never fails ... Rather than trying to check the
return value everywhere, which would be relatively intrusive, at
least make sure we don't use an uninitialized value.

Fixes: f3d9478b2ce4 ("[ALSA] snd-aoa: add snd-aoa")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/aoa/codecs/onyx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/aoa/codecs/onyx.c b/sound/aoa/codecs/onyx.c
index d2d96ca082b71..6224fd3bbf7cc 100644
--- a/sound/aoa/codecs/onyx.c
+++ b/sound/aoa/codecs/onyx.c
@@ -74,8 +74,10 @@ static int onyx_read_register(struct onyx *onyx, u8 reg, u8 *value)
 		return 0;
 	}
 	v = i2c_smbus_read_byte_data(onyx->i2c, reg);
-	if (v < 0)
+	if (v < 0) {
+		*value = 0;
 		return -1;
+	}
 	*value = (u8)v;
 	onyx->cache[ONYX_REG_CONTROL-FIRSTREGISTER] = *value;
 	return 0;
-- 
2.20.1



