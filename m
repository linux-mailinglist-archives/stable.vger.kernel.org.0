Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FAD2299F14
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438783AbgJ0AGl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:06:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:53632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437747AbgJ0AEs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 20:04:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 116EB217A0;
        Tue, 27 Oct 2020 00:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603757087;
        bh=Sog6csUjUgR2LJbLo3MJ6MPOEPBwnjRRvV+d/iW42WU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E6rFOm5QPk1MXt3hbKjDJJ5wFR4Z5CuVbm4oTLb+O3eOUJ415wBads1zPDsGO2K7q
         jVlGsv2dJ/B3q4PC/NsqruggdNMaSwQMNPSq8/WtQQ4m2LrDGt2J/w6OTrYpHZ4BZN
         HQPyeP0TKNEVg6e1R1wyJ0AWlwE/H85nQoqSegZ0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Douglas Anderson <dianders@chromium.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.19 26/60] kgdb: Make "kgdbcon" work properly with "kgdb_earlycon"
Date:   Mon, 26 Oct 2020 20:03:41 -0400
Message-Id: <20201027000415.1026364-26-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201027000415.1026364-1-sashal@kernel.org>
References: <20201027000415.1026364-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit b18b099e04f450cdc77bec72acefcde7042bd1f3 ]

On my system the kernel processes the "kgdb_earlycon" parameter before
the "kgdbcon" parameter.  When we setup "kgdb_earlycon" we'll end up
in kgdb_register_callbacks() and "kgdb_use_con" won't have been set
yet so we'll never get around to starting "kgdbcon".  Let's remedy
this by detecting that the IO module was already registered when
setting "kgdb_use_con" and registering the console then.

As part of this, to avoid pre-declaring things, move the handling of
the "kgdbcon" further down in the file.

Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20200630151422.1.I4aa062751ff5e281f5116655c976dff545c09a46@changeid
Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/debug/debug_core.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index fbb1bfdd2fa53..8c76141c99c8c 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -95,14 +95,6 @@ int dbg_switch_cpu;
 /* Use kdb or gdbserver mode */
 int dbg_kdb_mode = 1;
 
-static int __init opt_kgdb_con(char *str)
-{
-	kgdb_use_con = 1;
-	return 0;
-}
-
-early_param("kgdbcon", opt_kgdb_con);
-
 module_param(kgdb_use_con, int, 0644);
 module_param(kgdbreboot, int, 0644);
 
@@ -820,6 +812,20 @@ static struct console kgdbcons = {
 	.index		= -1,
 };
 
+static int __init opt_kgdb_con(char *str)
+{
+	kgdb_use_con = 1;
+
+	if (kgdb_io_module_registered && !kgdb_con_registered) {
+		register_console(&kgdbcons);
+		kgdb_con_registered = 1;
+	}
+
+	return 0;
+}
+
+early_param("kgdbcon", opt_kgdb_con);
+
 #ifdef CONFIG_MAGIC_SYSRQ
 static void sysrq_handle_dbg(int key)
 {
-- 
2.25.1

