Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87337328AB4
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239649AbhCASVt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:21:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:34282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239503AbhCASRA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:17:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E48D652F6;
        Mon,  1 Mar 2021 17:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620458;
        bh=mZcnrgi8B582SnCq4bcrTHUNa4DYBXcoGAQB5miVU3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gomx/cbvIGky1xL7wOm+TSSRJOZ6xAA0mhZi0rwcJ8dMZv4T0BmBmfdFlo7ICSdhM
         WaauYnsjbGu/tpz8c+1wvIs9PYqt0xQiLj0CBi73Gc6uviqbvpli1NNgpNNwgHEv6k
         b231BXBXNkVlkzaD97A1OMHke9K0RPoYa98JRKTU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joel Stanley <joel@jms.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 160/775] soc: aspeed: socinfo: Add new systems
Date:   Mon,  1 Mar 2021 17:05:28 +0100
Message-Id: <20210301161209.549142793@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joel Stanley <joel@jms.id.au>

[ Upstream commit d0e72be77e7995923fac73f27cf7a75d3d1a4dec ]

Aspeed's u-boot sdk has been updated with the SoC IDs for the AST2605
variant, as well as A2 and A3 variants of the 2600 family.

>From u-boot's arch/arm/mach-aspeed/ast2600/scu_info.c:

    SOC_ID("AST2600-A0", 0x0500030305000303),
    SOC_ID("AST2600-A1", 0x0501030305010303),
    SOC_ID("AST2620-A1", 0x0501020305010203),
    SOC_ID("AST2600-A2", 0x0502030305010303),
    SOC_ID("AST2620-A2", 0x0502020305010203),
    SOC_ID("AST2605-A2", 0x0502010305010103),
    SOC_ID("AST2600-A3", 0x0503030305030303),
    SOC_ID("AST2620-A3", 0x0503020305030203),
    SOC_ID("AST2605-A3", 0x0503010305030103),

Fixes: e0218dca5787 ("soc: aspeed: Add soc info driver")
Link: https://lore.kernel.org/r/20210210114651.334324-1-joel@jms.id.au
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/aspeed/aspeed-socinfo.c | 33 ++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/drivers/soc/aspeed/aspeed-socinfo.c b/drivers/soc/aspeed/aspeed-socinfo.c
index 773930e0cb100..e3215f826d17a 100644
--- a/drivers/soc/aspeed/aspeed-socinfo.c
+++ b/drivers/soc/aspeed/aspeed-socinfo.c
@@ -25,6 +25,7 @@ static struct {
 	/* AST2600 */
 	{ "AST2600", 0x05000303 },
 	{ "AST2620", 0x05010203 },
+	{ "AST2605", 0x05030103 },
 };
 
 static const char *siliconid_to_name(u32 siliconid)
@@ -43,14 +44,30 @@ static const char *siliconid_to_name(u32 siliconid)
 static const char *siliconid_to_rev(u32 siliconid)
 {
 	unsigned int rev = (siliconid >> 16) & 0xff;
-
-	switch (rev) {
-	case 0:
-		return "A0";
-	case 1:
-		return "A1";
-	case 3:
-		return "A2";
+	unsigned int gen = (siliconid >> 24) & 0xff;
+
+	if (gen < 0x5) {
+		/* AST2500 and below */
+		switch (rev) {
+		case 0:
+			return "A0";
+		case 1:
+			return "A1";
+		case 3:
+			return "A2";
+		}
+	} else {
+		/* AST2600 */
+		switch (rev) {
+		case 0:
+			return "A0";
+		case 1:
+			return "A1";
+		case 2:
+			return "A2";
+		case 3:
+			return "A3";
+		}
 	}
 
 	return "??";
-- 
2.27.0



