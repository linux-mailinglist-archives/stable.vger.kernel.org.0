Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06A9CA1709
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 12:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728395AbfH2KvA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 06:51:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:58586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728372AbfH2KvA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 06:51:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6ABDC23403;
        Thu, 29 Aug 2019 10:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567075859;
        bh=6ZTbBvYvBxAA5ThjBoEmBwgFxQiPy3QjeGMo/nvlzno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U5dlvMFX57iJDb5EFah8dt/RlwZM4LJ7gZIk29NAa25m6BsEYeuA+zUUzkaMyqMi5
         dLbnEZcWi4RV9sAcxO7ftTLVeoESHePXCpZQmC48xLIzOKJ4bJtyl3vxIIrz3+nKxB
         EwXjqzIQP+vWc/mwvsxRfu7kDyBJlbr8H5IarYAo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-samsung-soc@vger.kernel.org, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 13/14] clk: s2mps11: Add used attribute to s2mps11_dt_match
Date:   Thu, 29 Aug 2019 06:50:42 -0400
Message-Id: <20190829105043.2508-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829105043.2508-1-sashal@kernel.org>
References: <20190829105043.2508-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit 9c940bbe2bb47e03ca5e937d30b6a50bf9c0e671 ]

Clang warns after commit 8985167ecf57 ("clk: s2mps11: Fix matching when
built as module and DT node contains compatible"):

drivers/clk/clk-s2mps11.c:242:34: warning: variable 's2mps11_dt_match'
is not needed and will not be emitted [-Wunneeded-internal-declaration]
static const struct of_device_id s2mps11_dt_match[] = {
                                 ^
1 warning generated.

This warning happens when a variable is used in some construct that
doesn't require a reference to that variable to be emitted in the symbol
table; in this case, it's MODULE_DEVICE_TABLE, which only needs to hold
the data of the variable, not the variable itself.

$ nm -S drivers/clk/clk-s2mps11.o | rg s2mps11_dt_match
00000078 000003d4 R __mod_of__s2mps11_dt_match_device_table

Normally, with device ID table variables, it means that the variable
just needs to be tied to the device declaration at the bottom of the
file, like s2mps11_clk_id:

$ nm -S drivers/clk/clk-s2mps11.o | rg s2mps11_clk_id
00000000 00000078 R __mod_platform__s2mps11_clk_id_device_table
00000000 00000078 r s2mps11_clk_id

However, because the comment above this deliberately doesn't want this
variable added to .of_match_table, we need to mark s2mps11_dt_match as
__used to silence this warning. This makes it clear to Clang that the
variable is used for something, even if a reference to it isn't being
emitted.

Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Fixes: 8985167ecf57 ("clk: s2mps11: Fix matching when built as module and DT node contains compatible")
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-s2mps11.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk-s2mps11.c b/drivers/clk/clk-s2mps11.c
index 14071a57c9262..f5d74e8db4327 100644
--- a/drivers/clk/clk-s2mps11.c
+++ b/drivers/clk/clk-s2mps11.c
@@ -255,7 +255,7 @@ MODULE_DEVICE_TABLE(platform, s2mps11_clk_id);
  * This requires of_device_id table.  In the same time this will not change the
  * actual *device* matching so do not add .of_match_table.
  */
-static const struct of_device_id s2mps11_dt_match[] = {
+static const struct of_device_id s2mps11_dt_match[] __used = {
 	{
 		.compatible = "samsung,s2mps11-clk",
 		.data = (void *)S2MPS11X,
-- 
2.20.1

