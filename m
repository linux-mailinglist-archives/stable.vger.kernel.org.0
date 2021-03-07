Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68EEE330197
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 14:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231675AbhCGN6S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 08:58:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:43720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231539AbhCGN6E (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Mar 2021 08:58:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1050D65109;
        Sun,  7 Mar 2021 13:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615125484;
        bh=QPPKuQ4M8BA5N8oW7F3URkcN3zGFKJp2wkxgK1B99g0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CL7em0DtdqcOpS2DvXNHlleIR/58guMo2ABH5kSwP5vQlddkv5Gz+JodDnsmFDUGS
         h2uAzj/yj1v53fSGU8EGyVN8dqStGLED2ccZI9K78dAratEGkHLmteNbeWbkPw1EJa
         wkrDLsyD84ro8ulYm/qaB4MX7eP6IsFjpzKcfNMlouMqyMAVTxYRm/hmYWnq6dmTqy
         yMYr8drHPmiBwoGbko5PTLtXCN79mTvgKHhueyYodXjO7BddVO7HaFAyO4IyQqml0r
         MqlnzbZd6DAJg9k6VkEc7zwMwX2GAeDgDWwRwXffWmfC+uUXa+N+bUHb55duuhNALh
         OMzV80+PS9lvA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Osipenko <digetx@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 2/8] pstore/ram: Rate-limit "uncorrectable error in header" message
Date:   Sun,  7 Mar 2021 08:57:55 -0500
Message-Id: <20210307135801.967583-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210307135801.967583-1-sashal@kernel.org>
References: <20210307135801.967583-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit 7db688e99c0f770ae73e0f1f3fb67f9b64266445 ]

There is a quite huge "uncorrectable error in header" flood in KMSG
on a clean system boot since there is no pstore buffer saved in RAM.
Let's silence the redundant noisy messages by rate-limiting the printk
message. Now there are maximum 10 messages printed repeatedly instead
of 35+.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20210302095850.30894-1-digetx@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pstore/ram_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
index aa8e0b65ff1a..fff363bfd484 100644
--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -246,7 +246,7 @@ static int persistent_ram_init_ecc(struct persistent_ram_zone *prz,
 		pr_info("error in header, %d\n", numerr);
 		prz->corrected_bytes += numerr;
 	} else if (numerr < 0) {
-		pr_info("uncorrectable error in header\n");
+		pr_info_ratelimited("uncorrectable error in header\n");
 		prz->bad_blocks++;
 	}
 
-- 
2.30.1

