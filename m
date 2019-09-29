Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC56DC17AC
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 19:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730468AbfI2Rew (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 13:34:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:46946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730463AbfI2Rew (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 13:34:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BCA221906;
        Sun, 29 Sep 2019 17:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569778491;
        bh=083q+yZ0ZAmFQlK1Ja7FPWGtT4oivjOlDpFQKWeB3Uw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xRlL51JnvpQ5RbOV+XDAuP3+28I1kZ99pl4Z4RDZBLcfMylvj7W7nRpDNTJKg3b3q
         9mecIzQCEHUMIIN/fzVGiID68fyMKXYwXZKRXY7RJ3eF9c8UkpC3DiE6RP/Enmc5Pc
         RG/1whwZjIy2WQ2AAfWSSQeJqqFjajtElgy3A/Ls=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Paul Burton <paul.burton@mips.com>, linux-mips@linux-mips.org,
        joe@perches.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        linux-mips@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 13/33] firmware: bcm47xx_nvram: Correct size_t printf format
Date:   Sun, 29 Sep 2019 13:34:01 -0400
Message-Id: <20190929173424.9361-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190929173424.9361-1-sashal@kernel.org>
References: <20190929173424.9361-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit feb4eb060c3aecc3c5076bebe699cd09f1133c41 ]

When building on a 64-bit host, we will get warnings like those:

drivers/firmware/broadcom/bcm47xx_nvram.c:103:3: note: in expansion of macro 'pr_err'
   pr_err("nvram on flash (%i bytes) is bigger than the reserved space in memory, will just copy the first %i bytes\n",
   ^~~~~~
drivers/firmware/broadcom/bcm47xx_nvram.c:103:28: note: format string is defined here
   pr_err("nvram on flash (%i bytes) is bigger than the reserved space in memory, will just copy the first %i bytes\n",
                           ~^
                           %li

Use %zu instead for that purpose.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Signed-off-by: Paul Burton <paul.burton@mips.com>
Cc: linux-mips@linux-mips.org
Cc: joe@perches.com
Cc: Rafał Miłecki <zajec5@gmail.com>
Cc: linux-mips@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/broadcom/bcm47xx_nvram.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/broadcom/bcm47xx_nvram.c b/drivers/firmware/broadcom/bcm47xx_nvram.c
index d25f080fcb0d8..8698c5dd29d9c 100644
--- a/drivers/firmware/broadcom/bcm47xx_nvram.c
+++ b/drivers/firmware/broadcom/bcm47xx_nvram.c
@@ -100,7 +100,7 @@ static int nvram_find_and_copy(void __iomem *iobase, u32 lim)
 		nvram_len = size;
 	}
 	if (nvram_len >= NVRAM_SPACE) {
-		pr_err("nvram on flash (%i bytes) is bigger than the reserved space in memory, will just copy the first %i bytes\n",
+		pr_err("nvram on flash (%zu bytes) is bigger than the reserved space in memory, will just copy the first %i bytes\n",
 		       nvram_len, NVRAM_SPACE - 1);
 		nvram_len = NVRAM_SPACE - 1;
 	}
@@ -152,7 +152,7 @@ static int nvram_init(void)
 	    header.len > sizeof(header)) {
 		nvram_len = header.len;
 		if (nvram_len >= NVRAM_SPACE) {
-			pr_err("nvram on flash (%i bytes) is bigger than the reserved space in memory, will just copy the first %i bytes\n",
+			pr_err("nvram on flash (%zu bytes) is bigger than the reserved space in memory, will just copy the first %i bytes\n",
 				header.len, NVRAM_SPACE);
 			nvram_len = NVRAM_SPACE - 1;
 		}
-- 
2.20.1

