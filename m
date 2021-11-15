Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7695C452785
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344073AbhKPC0H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:26:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:48806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237406AbhKORVC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:21:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79E696326F;
        Mon, 15 Nov 2021 17:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996528;
        bh=PtzGnVFi+P8cgAOzSLEudaOBZxkg2CXSyrbIpExCZgs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mQXw5XQspzd903vVhcWMbecqz5w2S69NWX5UyBOhDkfZ/09PzM8JHLHop4NnbTHW3
         x/sZWG7dCdiHwhMsyYjnycE6PL8QPMGMRs9wJffiqhiY3F3hOeEY6EZvm0aOe+SNFL
         t3aQyM8I8rmV84I8cUJVotX0GaOI/mn8Iet972ck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 140/355] brcmfmac: Add DMI nvram filename quirk for Cyberbook T116 tablet
Date:   Mon, 15 Nov 2021 18:01:04 +0100
Message-Id: <20211115165318.323922689@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 49c3eb3036e6359c5c20fe76c611a2c0e0d4710e ]

The Cyberbook T116 tablet contains quite generic names in the sys_vendor
and product_name DMI strings, without this patch brcmfmac will try to load:
"brcmfmac43455-sdio.Default string-Default string.txt" as nvram file which
is way too generic.

The nvram file shipped on the factory Android image contains the exact
same settings as those used on the AcePC T8 mini PC, so point the new
DMI nvram filename quirk to the acepc-t8 nvram file.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210928160633.96928-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c
index 6d5188b78f2de..0af452dca7664 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c
@@ -75,6 +75,16 @@ static const struct dmi_system_id dmi_platform_data[] = {
 		},
 		.driver_data = (void *)&acepc_t8_data,
 	},
+	{
+		/* Cyberbook T116 rugged tablet */
+		.matches = {
+			DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "Default string"),
+			DMI_EXACT_MATCH(DMI_BOARD_NAME, "Cherry Trail CR"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "20170531"),
+		},
+		/* The factory image nvram file is identical to the ACEPC T8 one */
+		.driver_data = (void *)&acepc_t8_data,
+	},
 	{
 		/* Match for the GPDwin which unfortunately uses somewhat
 		 * generic dmi strings, which is why we test for 4 strings.
-- 
2.33.0



