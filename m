Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74FE5463764
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242920AbhK3Ox1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:53:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242738AbhK3Owg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:52:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2633C0613F2;
        Tue, 30 Nov 2021 06:48:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D07AB81A20;
        Tue, 30 Nov 2021 14:48:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF05C53FC1;
        Tue, 30 Nov 2021 14:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283703;
        bh=mpEyYu4PWzomuBycfIkHmVbV0lljm3jVg/CS7Xg/Ym4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JqJLt1oELdheJwSYVA06rHH0tZW6plGe3wdIvf3Iiw9mTZCuczzcPLiSaJH0uj/eV
         KQvevh74T7Sgz52RfnsICKeSj5JAULEcgKHiDOe6FSWUSJlgypi/zpsNw8A/zSjVh+
         YXiw631gce4nyqLmRntz8CtWxuf+aeC2oQMpTfpVl4WaUS7D/Qq/qiNJmTitY6U6NF
         86rQay9mlf754jFZ6kOQdn8vRlZjiaOArqsBEAeewaFLyZ1sJg99B6domwul8+iTl6
         jg/ia/EyqeOjWPZ3MBJDC0h0A93ExIosuVN+OB4XS0L3d1Xmkt5KPY1j3YALLN72J6
         0BH1vSMoGe56Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Helge Deller <deller@gmx.de>, kernel test robot <lkp@intel.com>,
        Sasha Levin <sashal@kernel.org>, akpm@linux-foundation.org,
        masahiroy@kernel.org, ndesaulniers@google.com,
        peterz@infradead.org, nathan@kernel.org,
        penguin-kernel@I-love.SAKURA.ne.jp, tpiepho@gmail.com,
        paulmck@kernel.org, glittao@gmail.com, tglx@linutronix.de,
        dlatypov@google.com
Subject: [PATCH AUTOSEL 5.15 26/68] parisc: Increase FRAME_WARN to 2048 bytes on parisc
Date:   Tue, 30 Nov 2021 09:46:22 -0500
Message-Id: <20211130144707.944580-26-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130144707.944580-1-sashal@kernel.org>
References: <20211130144707.944580-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

[ Upstream commit 8d192bec534bd5b778135769a12e5f04580771f7 ]

PA-RISC uses a much bigger frame size for functions than other
architectures. So increase it to 2048 for 32- and 64-bit kernels.
This fixes e.g. a warning in lib/xxhash.c.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/Kconfig.debug | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 2a9b6dcdac4ff..f54ffa79643d3 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -346,8 +346,9 @@ config FRAME_WARN
 	int "Warn for stack frames larger than"
 	range 0 8192
 	default 2048 if GCC_PLUGIN_LATENT_ENTROPY
-	default 1536 if (!64BIT && (PARISC || XTENSA))
-	default 1024 if (!64BIT && !PARISC)
+	default 2048 if PARISC
+	default 1536 if (!64BIT && XTENSA)
+	default 1024 if !64BIT
 	default 2048 if 64BIT
 	help
 	  Tell gcc to warn at build time for stack frames larger than this.
-- 
2.33.0

