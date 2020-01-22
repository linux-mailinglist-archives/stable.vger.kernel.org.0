Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7662145078
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388022AbgAVJoT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:44:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:37368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387848AbgAVJoS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:44:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9AAA2468B;
        Wed, 22 Jan 2020 09:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579686258;
        bh=dEwi0JC7TzjYmMHSKOvdlRofP9l7kVazWtTHC4k6uxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XJWwX1X4JKXp4SaBbx9EjjM4nZyhlGk3Kgwsgk8zM3o0HB9KJglxZ0vvIhOAqrNv4
         NK/70AfnIZ0fV32aesQx7WiraJYly2HNeHnQZkLiSTcgotsU13GQgN+/uTEDH9i/Bs
         XMyGymvgC901t/d5bueychdgJFrZ5Wx0mNmyAH6k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Baolin Wang <baolin.wang@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 4.19 101/103] clk: sprd: Use IS_ERR() to validate the return value of syscon_regmap_lookup_by_phandle()
Date:   Wed, 22 Jan 2020 10:29:57 +0100
Message-Id: <20200122092816.824516282@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092803.587683021@linuxfoundation.org>
References: <20200122092803.587683021@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baolin Wang <baolin.wang@linaro.org>

commit 9629dbdabd1983ef53f125336e1d62d77b1620f9 upstream.

The syscon_regmap_lookup_by_phandle() will never return NULL, thus use
IS_ERR() to validate the return value instead of IS_ERR_OR_NULL().

Fixes: d41f59fd92f2 ("clk: sprd: Add common infrastructure")
Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
Link: https://lkml.kernel.org/r/1995139bee5248ff3e9d46dc715968f212cfc4cc.1570520268.git.baolin.wang@linaro.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/sprd/common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/sprd/common.c
+++ b/drivers/clk/sprd/common.c
@@ -45,7 +45,7 @@ int sprd_clk_regmap_init(struct platform
 
 	if (of_find_property(node, "sprd,syscon", NULL)) {
 		regmap = syscon_regmap_lookup_by_phandle(node, "sprd,syscon");
-		if (IS_ERR_OR_NULL(regmap)) {
+		if (IS_ERR(regmap)) {
 			pr_err("%s: failed to get syscon regmap\n", __func__);
 			return PTR_ERR(regmap);
 		}


