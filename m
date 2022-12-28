Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B38C657AE9
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbiL1PQP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:16:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233052AbiL1PQN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:16:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C20D729C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:16:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 603DD61365
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:16:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7165FC433EF;
        Wed, 28 Dec 2022 15:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240571;
        bh=bStODH//uoNgIQzokissAlAGcDFttmQ5PfzEbyo0UUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aNETw6J/d1yq1tOMG4hA/F+UGqV3JvXPMoGDmI6Swkx5Z4UUqI4BWBJlwJl1W4zZo
         etKj1c4SetrCFI+Zzlxdh9D7wTnzDDtc3kNr3/lN/NtIuZ4Sxpw4+v14IxyBA5G1gB
         bl0cC3pBuwDnjhIiOrK9JN5CeXHnw787V20b6mKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ladislav Michl <ladis@linux-mips.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0176/1073] MIPS: OCTEON: warn only once if deprecated link status is being used
Date:   Wed, 28 Dec 2022 15:29:24 +0100
Message-Id: <20221228144332.791632964@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ladislav Michl <ladis@linux-mips.org>

[ Upstream commit 4c587a982603d7e7e751b4925809a1512099a690 ]

Avoid flooding kernel log with warnings.

Fixes: 2c0756d306c2 ("MIPS: OCTEON: warn if deprecated link status is being used")
Signed-off-by: Ladislav Michl <ladis@linux-mips.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/cavium-octeon/executive/cvmx-helper-board.c | 2 +-
 arch/mips/cavium-octeon/executive/cvmx-helper.c       | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/cavium-octeon/executive/cvmx-helper-board.c b/arch/mips/cavium-octeon/executive/cvmx-helper-board.c
index d09d0769f549..0fd9ac76eb74 100644
--- a/arch/mips/cavium-octeon/executive/cvmx-helper-board.c
+++ b/arch/mips/cavium-octeon/executive/cvmx-helper-board.c
@@ -211,7 +211,7 @@ union cvmx_helper_link_info __cvmx_helper_board_link_get(int ipd_port)
 {
 	union cvmx_helper_link_info result;
 
-	WARN(!octeon_is_simulation(),
+	WARN_ONCE(!octeon_is_simulation(),
 	     "Using deprecated link status - please update your DT");
 
 	/* Unless we fix it later, all links are defaulted to down */
diff --git a/arch/mips/cavium-octeon/executive/cvmx-helper.c b/arch/mips/cavium-octeon/executive/cvmx-helper.c
index 6f49fd9be1f3..9abfc4bf9bd8 100644
--- a/arch/mips/cavium-octeon/executive/cvmx-helper.c
+++ b/arch/mips/cavium-octeon/executive/cvmx-helper.c
@@ -1096,7 +1096,7 @@ union cvmx_helper_link_info cvmx_helper_link_get(int ipd_port)
 		if (index == 0)
 			result = __cvmx_helper_rgmii_link_get(ipd_port);
 		else {
-			WARN(1, "Using deprecated link status - please update your DT");
+			WARN_ONCE(1, "Using deprecated link status - please update your DT");
 			result.s.full_duplex = 1;
 			result.s.link_up = 1;
 			result.s.speed = 1000;
-- 
2.35.1



