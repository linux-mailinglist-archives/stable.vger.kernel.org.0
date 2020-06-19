Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C53E7201123
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393741AbgFSPaj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:30:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:34556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391297AbgFSPai (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:30:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A29B20757;
        Fri, 19 Jun 2020 15:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580637;
        bh=qb7f3W7ksEM5G51wSix1O2GVlf8dyfkMJi+JkWqJbPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S61UN0VsmHDeSd+QiKl6aaGRimfvBInIaFsPFrBeFqqcdz3ryUlN+oauI/f6kxm0j
         6Rn6PGL2kLJT4jk6C2yjFaEEp5zJfCOPMz73MpTsSgGGqlG+itPrY1C+c5GeUwWUn+
         HRLb71RmS8714trJkH8ibS133aICGJp8h1HzdEtk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bernard Zhao <bernard@vivo.com>,
        Lukasz Luba <lukasz.luba@arm.com>,
        Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 5.7 326/376] memory: samsung: exynos5422-dmc: Fix tFAW timings alignment
Date:   Fri, 19 Jun 2020 16:34:04 +0200
Message-Id: <20200619141725.764504538@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bernard Zhao <bernard@vivo.com>

commit 4bff7214d263b5235263136cb53147a759b3f3ab upstream.

Aligning of tFAW timing with standard was using wrong argument as
minimum acceptable value.  This could lead to wrong timing if provided
timings and clock period do not match the standard.

Fixes: 6e7674c3c6df ("memory: Add DMC driver for Exynos5422")
Cc: <stable@vger.kernel.org>
Signed-off-by: Bernard Zhao <bernard@vivo.com>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/memory/samsung/exynos5422-dmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/memory/samsung/exynos5422-dmc.c
+++ b/drivers/memory/samsung/exynos5422-dmc.c
@@ -1091,7 +1091,7 @@ static int create_timings_aligned(struct
 	/* power related timings */
 	val = dmc->timings->tFAW / clk_period_ps;
 	val += dmc->timings->tFAW % clk_period_ps ? 1 : 0;
-	val = max(val, dmc->min_tck->tXP);
+	val = max(val, dmc->min_tck->tFAW);
 	reg = &timing_power[0];
 	*reg_timing_power |= TIMING_VAL2REG(reg, val);
 


