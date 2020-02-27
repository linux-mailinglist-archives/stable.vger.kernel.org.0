Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7406B171912
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 14:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729648AbgB0Nlp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:41:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:36466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729644AbgB0Nlp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:41:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C2C220578;
        Thu, 27 Feb 2020 13:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582810904;
        bh=Su6IFIGirrLOUgdlL/sRKT0JfpP+Dg+DC1+yPwb5HTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OeG5BizY2thSYFzDZcUwsZtUAnX7WROJBKXgqQQ4XO5TizDN8fu4OWURPgKYTWfWf
         Lo+X2wA1ehlgMZ/rIrgdYn21TPbPl9X1NqXEpvwowtxp6EZpQwBwQKiso/JiwDz3iJ
         Xg5JWuMjio4IVCfjCZzc2GdarexPQDzBgJuG0JXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phong Tran <tranmanphong@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 042/113] iwlegacy: Fix -Wcast-function-type
Date:   Thu, 27 Feb 2020 14:35:58 +0100
Message-Id: <20200227132218.459470270@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132211.791484803@linuxfoundation.org>
References: <20200227132211.791484803@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phong Tran <tranmanphong@gmail.com>

[ Upstream commit da5e57e8a6a3e69dac2937ba63fa86355628fbb2 ]

correct usage prototype of callback in tasklet_init().
Report by https://github.com/KSPP/linux/issues/20

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/iwlegacy/3945-mac.c | 5 +++--
 drivers/net/wireless/iwlegacy/4965-mac.c | 5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index af1b3e6839fa6..775f5e7791d48 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -1399,8 +1399,9 @@ il3945_dump_nic_error_log(struct il_priv *il)
 }
 
 static void
-il3945_irq_tasklet(struct il_priv *il)
+il3945_irq_tasklet(unsigned long data)
 {
+	struct il_priv *il = (struct il_priv *)data;
 	u32 inta, handled = 0;
 	u32 inta_fh;
 	unsigned long flags;
@@ -3432,7 +3433,7 @@ il3945_setup_deferred_work(struct il_priv *il)
 	setup_timer(&il->watchdog, il_bg_watchdog, (unsigned long)il);
 
 	tasklet_init(&il->irq_tasklet,
-		     (void (*)(unsigned long))il3945_irq_tasklet,
+		     il3945_irq_tasklet,
 		     (unsigned long)il);
 }
 
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 04b0349a6ad9f..b1925bdb11718 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -4361,8 +4361,9 @@ il4965_synchronize_irq(struct il_priv *il)
 }
 
 static void
-il4965_irq_tasklet(struct il_priv *il)
+il4965_irq_tasklet(unsigned long data)
 {
+	struct il_priv *il = (struct il_priv *)data;
 	u32 inta, handled = 0;
 	u32 inta_fh;
 	unsigned long flags;
@@ -6257,7 +6258,7 @@ il4965_setup_deferred_work(struct il_priv *il)
 	setup_timer(&il->watchdog, il_bg_watchdog, (unsigned long)il);
 
 	tasklet_init(&il->irq_tasklet,
-		     (void (*)(unsigned long))il4965_irq_tasklet,
+		     il4965_irq_tasklet,
 		     (unsigned long)il);
 }
 
-- 
2.20.1



