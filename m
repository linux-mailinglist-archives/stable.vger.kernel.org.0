Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6574F3301BE
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 14:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbhCGN6y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 08:58:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:44006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231740AbhCGN6Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Mar 2021 08:58:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54BE165115;
        Sun,  7 Mar 2021 13:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615125504;
        bh=CrlDiH4TzEmX/ofJ9a+XOHmR7iE0uCOfrMwVymurr6s=;
        h=From:To:Cc:Subject:Date:From;
        b=myw60cwM6VzK+SNK7Z2WBXkagNi9v/iuHfRUMsuzr5sogDvX6SPTz/FxGDmYbnqg5
         VXzpfQ/Az4Ri6pTOOOOBQP/JAm1sVivfsX4KHG/qslWDDzQamTuP2hQSK/PzO4bcmb
         vh98Bh48yKM2pIbWVL+nh7ZzaPc7YMCVRja5w3NLCgjw8nrDiI7bv1RjTmkK8N9gll
         apvvMSsKQgQTNuIHwxCzmFUsbuG3y3p39pb8h0FG/bJ42clgqKsQNSFXfxg1Rl7aMS
         XoKtHD72GZ0K5RStuTaGkSoWnORE/69qUCpfbuF14+Qa/wQrcUel+hZuG+FQFpn842
         eot2/4u+IzZpw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Osipenko <digetx@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 1/2] pstore/ram: Rate-limit "uncorrectable error in header" message
Date:   Sun,  7 Mar 2021 08:58:22 -0500
Message-Id: <20210307135823.967879-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
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
index 11e558efd61e..a953d5f04ea0 100644
--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -237,7 +237,7 @@ static int persistent_ram_init_ecc(struct persistent_ram_zone *prz,
 		pr_info("error in header, %d\n", numerr);
 		prz->corrected_bytes += numerr;
 	} else if (numerr < 0) {
-		pr_info("uncorrectable error in header\n");
+		pr_info_ratelimited("uncorrectable error in header\n");
 		prz->bad_blocks++;
 	}
 
-- 
2.30.1

