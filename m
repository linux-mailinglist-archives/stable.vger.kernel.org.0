Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A47EE49A342
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386412AbiAXX5P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:57:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1846013AbiAXXOO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:14:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A881C0610C8;
        Mon, 24 Jan 2022 13:21:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16DD9B81218;
        Mon, 24 Jan 2022 21:21:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DF1CC340E4;
        Mon, 24 Jan 2022 21:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059268;
        bh=k/Lz/Zo8RSedFrd/Cb57u0V3RMctMpavMVRb8b8/edc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jZ8pB21F/Uuw6HDKwNLWJGuQ8i6zYvDiNnJ/qKDojFx2PxSDZL9tIyffLo3ZgiEx6
         wzTQWK7kDVWEBv6bgNeYpgBkd7sBUI7l7J6vaAH810AmAPYWB4a48wYhj4I4E6nLK0
         +BXtxhkQRciO+IAipUT724W47VQ2DqaKe4JfWnVQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wan Jiabing <wanjiabing@vivo.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0560/1039] ARM: shmobile: rcar-gen2: Add missing of_node_put()
Date:   Mon, 24 Jan 2022 19:39:09 +0100
Message-Id: <20220124184144.137999152@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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



