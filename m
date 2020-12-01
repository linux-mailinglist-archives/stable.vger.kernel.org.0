Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD1E2C9BF3
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390122AbgLAJNh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:13:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:52048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390117AbgLAJNf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:13:35 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9593220770;
        Tue,  1 Dec 2020 09:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813975;
        bh=MAH/RI1ZQWvsdDIr3yKXYvcY4b5ZJdlNwms8MtsJxYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rl48mX5oz4NZMv8XI+BHr/b3qloZPwXdf391Kq3xPUjeOh5J15zq5FkFeGiweVRzF
         OmX0vQSO79zzAF+xTJTIK+IarIlT9+cjJQ5Ciz9b8/dyUHX974N5q4ydgm3ZCCOPCT
         6UteZPh7azQH1fFv3bBX4NvDiXI724k5hXrp3My8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anup Patel <anup.patel@wdc.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 124/152] RISC-V: Add missing jump label initialization
Date:   Tue,  1 Dec 2020 09:53:59 +0100
Message-Id: <20201201084728.060494648@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anup Patel <anup.patel@wdc.com>

[ Upstream commit 6134b110f97178d6919441a82dc91a7f3664b4e0 ]

The jump_label_init() should be called from setup_arch() very
early for proper functioning of jump label support.

Fixes: ebc00dde8a97 ("riscv: Add jump-label implementation")
Signed-off-by: Anup Patel <anup.patel@wdc.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/setup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/kernel/setup.c b/arch/riscv/kernel/setup.c
index 2c6dd329312bd..3de5234b6de5b 100644
--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -69,6 +69,7 @@ void __init setup_arch(char **cmdline_p)
 
 	*cmdline_p = boot_command_line;
 
+	jump_label_init();
 	parse_early_param();
 
 	setup_bootmem();
-- 
2.27.0



