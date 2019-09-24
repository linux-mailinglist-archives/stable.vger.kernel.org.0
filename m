Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9475DBCE24
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 18:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410252AbfIXQtJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 12:49:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:41310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410240AbfIXQtI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:49:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24769217D9;
        Tue, 24 Sep 2019 16:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343748;
        bh=9EMZoMlOTp277FGr1ArlagX6CsLtls8Fgtekm+PH48w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nu3vvE6JL3r2onHKea7bb5ioswXFCHfWpe6Dn8RsjU8DRaCJx0tOLrhsdgph3lT3L
         4XfNERemyRh+2o8PueNtiWTdn6Q+erAQ0c60IU1J3mTE5CsMgX4heljGwunKLK+APC
         9MxgQmL6zpvoTh77dXyUN3Nw+XyeA5LESONw6S5s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Huckleberry <nhuck@google.com>,
        clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Scott Wood <oss@buserror.net>, Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 13/50] clk: qoriq: Fix -Wunused-const-variable
Date:   Tue, 24 Sep 2019 12:48:10 -0400
Message-Id: <20190924164847.27780-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924164847.27780-1-sashal@kernel.org>
References: <20190924164847.27780-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Huckleberry <nhuck@google.com>

[ Upstream commit a95fb581b144b5e73da382eaedb2e32027610597 ]

drivers/clk/clk-qoriq.c:138:38: warning: unused variable
'p5020_cmux_grp1' [-Wunused-const-variable] static const struct
clockgen_muxinfo p5020_cmux_grp1

drivers/clk/clk-qoriq.c:146:38: warning: unused variable
'p5020_cmux_grp2' [-Wunused-const-variable] static const struct
clockgen_muxinfo p5020_cmux_grp2

In the definition of the p5020 chip, the p2041 chip's info was used
instead.  The p5020 and p2041 chips have different info. This is most
likely a typo.

Link: https://github.com/ClangBuiltLinux/linux/issues/525
Cc: clang-built-linux@googlegroups.com
Signed-off-by: Nathan Huckleberry <nhuck@google.com>
Link: https://lkml.kernel.org/r/20190627220642.78575-1-nhuck@google.com
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Acked-by: Scott Wood <oss@buserror.net>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-qoriq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk-qoriq.c b/drivers/clk/clk-qoriq.c
index 3a1812f65e5d8..8abc5c8cb8b8c 100644
--- a/drivers/clk/clk-qoriq.c
+++ b/drivers/clk/clk-qoriq.c
@@ -610,7 +610,7 @@ static const struct clockgen_chipinfo chipinfo[] = {
 		.guts_compat = "fsl,qoriq-device-config-1.0",
 		.init_periph = p5020_init_periph,
 		.cmux_groups = {
-			&p2041_cmux_grp1, &p2041_cmux_grp2
+			&p5020_cmux_grp1, &p5020_cmux_grp2
 		},
 		.cmux_to_group = {
 			0, 1, -1
-- 
2.20.1

