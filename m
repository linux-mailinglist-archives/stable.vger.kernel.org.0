Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 582673301C1
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 14:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbhCGN6z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 08:58:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:44034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231526AbhCGN62 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Mar 2021 08:58:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01B2065111;
        Sun,  7 Mar 2021 13:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615125508;
        bh=CrlDiH4TzEmX/ofJ9a+XOHmR7iE0uCOfrMwVymurr6s=;
        h=From:To:Cc:Subject:Date:From;
        b=G8Xm3ty2n8eys9nv16kbIjbnplLav9eEexf8SrKbLTkc/TL6/NweP80cyqYbDZry3
         L3DmnuY8RmccWGCBGs1EvbKcV3EkLduL2+XdRnTAefJGViLWVCpxk5qSU995h57JXU
         hss+l66aMqA0KGWMsNWfhFo8pSVDYzgq+JXVFoZnA2max6UttQ0CF+jXOB9t6Wm00/
         jY18pFpsMktKX376VXvx3Dp6YjAByCRCrS4V4r/kkg5Xcu18Q5U+3ne2HRrKjrktxH
         SuPQf3m0CO+rX8B3+vXug/BH9sb4gSYe1DZNrcTpUyzFXIcxsHCgu+rLPrg8R9umXA
         74EdY2PBNYV/g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Osipenko <digetx@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9] pstore/ram: Rate-limit "uncorrectable error in header" message
Date:   Sun,  7 Mar 2021 08:58:26 -0500
Message-Id: <20210307135826.968018-1-sashal@kernel.org>
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

