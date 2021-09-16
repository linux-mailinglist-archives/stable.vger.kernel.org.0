Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 335C240E62A
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346637AbhIPRSf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:18:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:39918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343574AbhIPRQG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:16:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7035D61452;
        Thu, 16 Sep 2021 16:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810412;
        bh=4XLyxolhrMLjNIFlyN8qlI7yuJw7mrGBG65yOjX38Uo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XO7ykQ+iYBGci6p/+KYGs1WWX/+m4q1PQwuXQO6sXOWFLwESis3tVZx1jG0kvXrZg
         MdSDvAup47P3FfMC0NYeSGiK+DjMKp7vOqom5qloAcgMzdcRywfitx+xHrse+1VjvG
         T/gbtqECQs/wQiW7iHDdpeSJ2fAjvhqJbPrBy7cI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 099/432] cpuidle: pseries: Mark pseries_idle_proble() as __init
Date:   Thu, 16 Sep 2021 17:57:28 +0200
Message-Id: <20210916155814.133008143@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit d04691d373e75c83424b85c0e68e4a3f9370c10d ]

After commit 7cbd631d4dec ("cpuidle: pseries: Fixup CEDE0 latency only
for POWER10 onwards"), pseries_idle_probe() is no longer inlined when
compiling with clang, which causes a modpost warning:

WARNING: modpost: vmlinux.o(.text+0xc86a54): Section mismatch in
reference from the function pseries_idle_probe() to the function
.init.text:fixup_cede0_latency()
The function pseries_idle_probe() references
the function __init fixup_cede0_latency().
This is often because pseries_idle_probe lacks a __init
annotation or the annotation of fixup_cede0_latency is wrong.

pseries_idle_probe() is a non-init function, which calls
fixup_cede0_latency(), which is an init function, explaining the
mismatch. pseries_idle_probe() is only called from
pseries_processor_idle_init(), which is an init function, so mark
pseries_idle_probe() as __init so there is no more warning.

Fixes: 054e44ba99ae ("cpuidle: pseries: Add function to parse extended CEDE records")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210803211547.1093820-1-nathan@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpuidle/cpuidle-pseries.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpuidle/cpuidle-pseries.c b/drivers/cpuidle/cpuidle-pseries.c
index e592280d8acf..ff164dec8422 100644
--- a/drivers/cpuidle/cpuidle-pseries.c
+++ b/drivers/cpuidle/cpuidle-pseries.c
@@ -402,7 +402,7 @@ static void __init fixup_cede0_latency(void)
  * pseries_idle_probe()
  * Choose state table for shared versus dedicated partition
  */
-static int pseries_idle_probe(void)
+static int __init pseries_idle_probe(void)
 {
 
 	if (cpuidle_disable != IDLE_NO_OVERRIDE)
-- 
2.30.2



