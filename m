Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A414E499449
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:42:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388985AbiAXUkU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:40:20 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39362 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386132AbiAXUfM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:35:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79ADEB8121C;
        Mon, 24 Jan 2022 20:35:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B697C340E5;
        Mon, 24 Jan 2022 20:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056510;
        bh=k/Lz/Zo8RSedFrd/Cb57u0V3RMctMpavMVRb8b8/edc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=djwRMKdEp1wd99y7GeWqYI4YcYe5rY0QY9xPo2CLYfvoSV9pgKBVYQ1uZqtb72M/T
         FXt1FShWLkFPCQPAaly9rxvjTh+tENbOM4BTDRlLUBscYh7NfOj6EknCCLJkyUT+HU
         5TlWSxQFS3aL4BjcHgoXAPL7gQgJYpkYETlRHrUo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wan Jiabing <wanjiabing@vivo.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 476/846] ARM: shmobile: rcar-gen2: Add missing of_node_put()
Date:   Mon, 24 Jan 2022 19:39:53 +0100
Message-Id: <20220124184117.438723526@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



