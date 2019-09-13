Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2486DB1E4E
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388355AbfIMNIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:08:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:33376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388354AbfIMNIx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:08:53 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BC54206BB;
        Fri, 13 Sep 2019 13:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380133;
        bh=5N/0yJj/nhkLQbwGS5Lg+IMvkme1kib95I/XYZhO2vY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=blHtXbkxBJAdNC5+1lZPO55qMdXl2mJugkfpelCMRv1vlpl47/rG/eaFxHnI86k+f
         YoQvG1sTEWfvSFVi6rHjLi7m29BppeNIYtV9VSa8tzsnPIoizMF1w74WYOGjgjrEei
         T4j1aP6DnAtU4zV3uk5YHMrIXwm8BkX5IZvRvlEg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 6/9] clk: s2mps11: Add used attribute to s2mps11_dt_match
Date:   Fri, 13 Sep 2019 14:06:56 +0100
Message-Id: <20190913130429.728754074@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130424.160808669@linuxfoundation.org>
References: <20190913130424.160808669@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 785864893f9a6..14af5c916c9ca 100644
--- a/drivers/clk/clk-s2mps11.c
+++ b/drivers/clk/clk-s2mps11.c
@@ -307,7 +307,7 @@ MODULE_DEVICE_TABLE(platform, s2mps11_clk_id);
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



