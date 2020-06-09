Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB8C11F3E52
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 16:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728601AbgFIOfd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 10:35:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:36740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726395AbgFIOfc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 10:35:32 -0400
Received: from kozik-lap.mshome.net (unknown [194.230.155.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BA1D20737;
        Tue,  9 Jun 2020 14:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591713331;
        bh=yTSfLVVa/4q+G+xdsELkHjOQHjS5m+v+/oO7DnmXjtA=;
        h=From:To:Cc:Subject:Date:From;
        b=zsfYWaBDkGkeoxhKp+mefjDW+8CjhVFjt2Eer1p60QQL5qumj3yqgRIJZmz1d+qQG
         fzGWEB7WuHNskWGeHp7au4unqLwjGvcWy18GhNoaX4fPEfBmgW87JRwWIUyLXHMWKc
         TlqrlTtSSnQUmaslRbWeHAUVoB2ovIi0RPYMHwZw=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     stable@vger.kernel.org
Cc:     Stefan Agner <stefan@agner.ch>, Mark Brown <broonie@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH STABLE v4.4+] pwm: fsl-ftm: Use flat regmap cache
Date:   Tue,  9 Jun 2020 16:35:17 +0200
Message-Id: <20200609143517.31243-1-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Agner <stefan@agner.ch>

commit ad06fdeeef1cbadf86ebbe510e8079abada8b44e upstream.

Use flat regmap cache to avoid lockdep warning at probe:

[    0.697285] WARNING: CPU: 0 PID: 1 at kernel/locking/lockdep.c:2755 lockdep_trace_alloc+0x15c/0x160()
[    0.697449] DEBUG_LOCKS_WARN_ON(irqs_disabled_flags(flags))

The RB-tree regmap cache needs to allocate new space on first writes.
However, allocations in an atomic context (e.g. when a spinlock is held)
are not allowed. The function regmap_write calls map->lock, which
acquires a spinlock in the fast_io case. Since the pwm-fsl-ftm driver
uses MMIO, the regmap bus of type regmap_mmio is being used which has
fast_io set to true.

The MMIO space of the pwm-fsl-ftm driver is reasonable condense, hence
using the much faster flat regmap cache is anyway the better choice.

Signed-off-by: Stefan Agner <stefan@agner.ch>
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

---

Fixes lockdep warning. Apply to v4.4 and newer.
---
 drivers/pwm/pwm-fsl-ftm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pwm/pwm-fsl-ftm.c b/drivers/pwm/pwm-fsl-ftm.c
index 7225ac6b3df5..fad968eb75f6 100644
--- a/drivers/pwm/pwm-fsl-ftm.c
+++ b/drivers/pwm/pwm-fsl-ftm.c
@@ -392,7 +392,7 @@ static const struct regmap_config fsl_pwm_regmap_config = {
 
 	.max_register = FTM_PWMLOAD,
 	.volatile_reg = fsl_pwm_volatile_reg,
-	.cache_type = REGCACHE_RBTREE,
+	.cache_type = REGCACHE_FLAT,
 };
 
 static int fsl_pwm_probe(struct platform_device *pdev)
-- 
2.17.1

