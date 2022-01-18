Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 486A5491455
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244814AbiARCVv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:21:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244697AbiARCVL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:21:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C2B3C061771;
        Mon, 17 Jan 2022 18:21:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5EE0B81232;
        Tue, 18 Jan 2022 02:21:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B62DBC36AEF;
        Tue, 18 Jan 2022 02:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472467;
        bh=k/Lz/Zo8RSedFrd/Cb57u0V3RMctMpavMVRb8b8/edc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ugDW+h0m0Lec8Amh9nn6MTrmpF0p8BrDsvHsEmI2kZUCllS1UFyOxfcVeE29peAia
         EQETf6VnKqI0kLj36d09RQ7VYcIInUstKJoBb7SV6I8XUJCezHqoYOafI5saRepHxX
         Ti6kaxnBk3vD3Z6E1JnIyEKOjSilgWI5058T5reqOiGC4GeASfWip5ZlVhkElQW+Jy
         V3MYrup3G3satFQmqH58ElHA8qu751oCLgzvTYcyYQINAFzClEeGz1GHQHYYulmWt0
         6KfWMzBvkLsvx7LmlRL/xvvdNFGOx8uZKeiN+eB9EAxbCQkJXc+0fhrXmo8FRcJkqE
         FnQUrmCPknW4w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wan Jiabing <wanjiabing@vivo.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>, magnus.damm@gmail.com,
        linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 023/217] ARM: shmobile: rcar-gen2: Add missing of_node_put()
Date:   Mon, 17 Jan 2022 21:16:26 -0500
Message-Id: <20220118021940.1942199-23-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wan Jiabing <wanjiabing@vivo.com>

[ Upstream commit 85744f2d938c5f3cfc44cb6533c157469634da93 ]

Fix following coccicheck warning:
./arch/arm/mach-shmobile/regulator-quirk-rcar-gen2.c:156:1-33: Function
for_each_matching_node_and_match should have of_node_put() before break
and goto.

Early exits from for_each_matching_node_and_match() should decrement the
node reference counter.

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
Link: https://lore.kernel.org/r/20211018014503.7598-1-wanjiabing@vivo.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-shmobile/regulator-quirk-rcar-gen2.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-shmobile/regulator-quirk-rcar-gen2.c b/arch/arm/mach-shmobile/regulator-quirk-rcar-gen2.c
index ee949255ced3f..09ef73b99dd86 100644
--- a/arch/arm/mach-shmobile/regulator-quirk-rcar-gen2.c
+++ b/arch/arm/mach-shmobile/regulator-quirk-rcar-gen2.c
@@ -154,8 +154,10 @@ static int __init rcar_gen2_regulator_quirk(void)
 		return -ENODEV;
 
 	for_each_matching_node_and_match(np, rcar_gen2_quirk_match, &id) {
-		if (!of_device_is_available(np))
+		if (!of_device_is_available(np)) {
+			of_node_put(np);
 			break;
+		}
 
 		ret = of_property_read_u32(np, "reg", &addr);
 		if (ret)	/* Skip invalid entry and continue */
@@ -164,6 +166,7 @@ static int __init rcar_gen2_regulator_quirk(void)
 		quirk = kzalloc(sizeof(*quirk), GFP_KERNEL);
 		if (!quirk) {
 			ret = -ENOMEM;
+			of_node_put(np);
 			goto err_mem;
 		}
 
-- 
2.34.1

