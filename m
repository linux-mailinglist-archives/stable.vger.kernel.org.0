Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3D743301BF
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 14:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231643AbhCGN6z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 08:58:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:44058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231823AbhCGN6b (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Mar 2021 08:58:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A2C465115;
        Sun,  7 Mar 2021 13:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615125511;
        bh=KQ00QTj0XVJIrkn8U7per0PslvEMuVvSyY5Tm39jvBs=;
        h=From:To:Cc:Subject:Date:From;
        b=ClGgYKmoLzUBmN+4lC7RwiywUu6lZ//zTL5gaFlxrSF+fh1cVOCajWX8xKS986QRd
         7FVrwSzuxMSpsIyzHtkqV98TkbY4Pjow+xpOfUfnNJIhfddusNS0t634C8XRDYNjfP
         7qVqRuvFPwTER9oBXOC+3eQ4BYMvRJJv9E6Yx5EhaK6wPaX5EQ4T/GdAMejsB5Wr+s
         k1u3jM+XRUTKo5gUjMEk1knMhpXBSzEAyfYcYvMq7iVpahfkPwIyrdtjNAwNO1z+Wp
         sTsM4YnDUvaBuSL+RFFFrljKkUnkCl/smVS9mEMf9g21DPlaFCQ2KIlS+rsqzbJdmv
         tpixwAg9v6k5Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Osipenko <digetx@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4] pstore/ram: Rate-limit "uncorrectable error in header" message
Date:   Sun,  7 Mar 2021 08:58:29 -0500
Message-Id: <20210307135829.968091-1-sashal@kernel.org>
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
index 679d75a864d0..40bdf7d85a05 100644
--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -236,7 +236,7 @@ static int persistent_ram_init_ecc(struct persistent_ram_zone *prz,
 		pr_info("error in header, %d\n", numerr);
 		prz->corrected_bytes += numerr;
 	} else if (numerr < 0) {
-		pr_info("uncorrectable error in header\n");
+		pr_info_ratelimited("uncorrectable error in header\n");
 		prz->bad_blocks++;
 	}
 
-- 
2.30.1

