Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3483430CCBA
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 21:07:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240384AbhBBUGD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 15:06:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:36460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232488AbhBBNnC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:43:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D388164F6A;
        Tue,  2 Feb 2021 13:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273208;
        bh=IjypJaJSk/7+1ZmBJKbXqbYWEL9BTf9vBQ/k0PVZX2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HnNaaEUWOa1moROaDCAny0ctz65BhLwYdDKmT6OBeCeSlqXQR9jwefI6r7CGuGdwH
         QUt/wx959owtDLdnxxezE8RiYDJ3OvOOxJHCxoJRtS/DTP5yJlasGNriNpL7XB9knj
         4/5Zlxh9VadO12dnoBP6UX/9deFgrn4XKNA1G5VQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Jaroslav Kysela <perex@perex.cz>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 021/142] ASoC: AMD Renoir - refine DMI entries for some Lenovo products
Date:   Tue,  2 Feb 2021 14:36:24 +0100
Message-Id: <20210202132958.584950791@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaroslav Kysela <perex@perex.cz>

commit 40caffd66ca9ad1baa2d5541232675160bc6c772 upstream.

Apparently, the DMI board name LNVNB161216 is also used also
for products with the digital microphones connected to the AMD's
audio bridge. Refine the DMI table - use product name identifiers
extracted from https://bugzilla.redhat.com/show_bug.cgi?id=1892115 .

The report for Lenovo Yoga Slim 7 14ARE05 (82A2) is in buglink.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=211299
Cc: <stable@kernel.org>
Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Cc: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20210120144211.817937-1-perex@perex.cz
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/amd/renoir/rn-pci-acp3x.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/sound/soc/amd/renoir/rn-pci-acp3x.c
+++ b/sound/soc/amd/renoir/rn-pci-acp3x.c
@@ -165,10 +165,24 @@ static int rn_acp_deinit(void __iomem *a
 
 static const struct dmi_system_id rn_acp_quirk_table[] = {
 	{
-		/* Lenovo IdeaPad Flex 5 14ARE05, IdeaPad 5 15ARE05 */
+		/* Lenovo IdeaPad S340-14API */
 		.matches = {
 			DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
-			DMI_EXACT_MATCH(DMI_BOARD_NAME, "LNVNB161216"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "81NB"),
+		}
+	},
+	{
+		/* Lenovo IdeaPad Flex 5 14ARE05 */
+		.matches = {
+			DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "81X2"),
+		}
+	},
+	{
+		/* Lenovo IdeaPad 5 15ARE05 */
+		.matches = {
+			DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "81YQ"),
 		}
 	},
 	{


