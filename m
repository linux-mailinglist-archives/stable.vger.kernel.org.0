Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B87F9FA507
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:21:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728884AbfKMBy3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:54:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:45352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728880AbfKMBy2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:54:28 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82D472245A;
        Wed, 13 Nov 2019 01:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610068;
        bh=iORbwAUQT32YOs7L6orzyi2v9UCPskwpAZJBMgtZrms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a0GAc63VHUX7/FwWQ8RrytyNstqOvI6j7VhRaSw2PFSu5kkj6ZZUIVOsz2OO5G05H
         NGrNVkCnI6ysDoe/hnNomFQwdbS8q9496TkWeHuYyyn8dwbaCCprFT2kkYW4TpJKVf
         sfj2AMgAsT3nCMtke+hWo/0ZqNve3kTLKOpiS7pI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Vadim Pasternak <vadimp@mellanox.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 4.19 147/209] platform/x86: mlx-platform: Properly use mlxplat_mlxcpld_msn201x_items
Date:   Tue, 12 Nov 2019 20:49:23 -0500
Message-Id: <20191113015025.9685-147-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit 8289c4b6f2e53750de78bd38cecb6bce4d7a988c ]

Clang warns that mlxplat_mlxcpld_msn201x_items is not going to be
emitted in the final assembly because it's only used in ARRAY_SIZE right
now, which is a compile time evaluation since the array's size is known.

drivers/platform/x86/mlx-platform.c:555:32: warning: variable
'mlxplat_mlxcpld_msn201x_items' is not needed and will not be emitted
[-Wunneeded-internal-declaration]
static struct mlxreg_core_item mlxplat_mlxcpld_msn201x_items[] = {
                               ^
1 warning generated.

It appears this was a copy and paste mistake from when this item was
first added. Use the definition in mlxplat_mlxcpld_msn201x_data so that
Clang no longer warns.

Link: https://github.com/ClangBuiltLinux/linux/issues/141
Fixes: a49a41482f61 ("platform/x86: mlx-platform: Add support for new msn201x system type")
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Acked-by: Vadim Pasternak <vadimp@mellanox.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/mlx-platform.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/mlx-platform.c b/drivers/platform/x86/mlx-platform.c
index 742a0c2179256..d17db140cb1fc 100644
--- a/drivers/platform/x86/mlx-platform.c
+++ b/drivers/platform/x86/mlx-platform.c
@@ -575,7 +575,7 @@ static struct mlxreg_core_item mlxplat_mlxcpld_msn201x_items[] = {
 
 static
 struct mlxreg_core_hotplug_platform_data mlxplat_mlxcpld_msn201x_data = {
-	.items = mlxplat_mlxcpld_msn21xx_items,
+	.items = mlxplat_mlxcpld_msn201x_items,
 	.counter = ARRAY_SIZE(mlxplat_mlxcpld_msn201x_items),
 	.cell = MLXPLAT_CPLD_LPC_REG_AGGR_OFFSET,
 	.mask = MLXPLAT_CPLD_AGGR_MASK_DEF,
-- 
2.20.1

