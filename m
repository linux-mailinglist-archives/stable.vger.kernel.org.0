Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB892018EA
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 19:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405801AbgFSQy2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:54:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:53098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733262AbgFSOgf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:36:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDBEF208B8;
        Fri, 19 Jun 2020 14:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592577395;
        bh=JJUIQdIHA6BFYeUGulLEzaEadv0OHvtwXvehKyhyyOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JsZIDFwTfpi+MwUP9Kg/rSynOGo9qH4urCdyIGLtAKJW8fpR1ymH69xEU7E6KQLEd
         LTm7JSUol6UbqbxUXPEzF57+8uM47HrBEbFQ95Eeca/e1DHrMoAunbIN02SDqazOqc
         ybVJ9/BxInPrcbHzNkdd1NWKJpJ3+hyceBQf5VX8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Agner <stefan@agner.ch>,
        Mark Brown <broonie@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 4.4 005/101] pwm: fsl-ftm: Use flat regmap cache
Date:   Fri, 19 Jun 2020 16:31:54 +0200
Message-Id: <20200619141614.294537901@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141614.001544111@linuxfoundation.org>
References: <20200619141614.001544111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pwm/pwm-fsl-ftm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pwm/pwm-fsl-ftm.c
+++ b/drivers/pwm/pwm-fsl-ftm.c
@@ -392,7 +392,7 @@ static const struct regmap_config fsl_pw
 
 	.max_register = FTM_PWMLOAD,
 	.volatile_reg = fsl_pwm_volatile_reg,
-	.cache_type = REGCACHE_RBTREE,
+	.cache_type = REGCACHE_FLAT,
 };
 
 static int fsl_pwm_probe(struct platform_device *pdev)


