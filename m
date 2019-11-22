Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E88F106E83
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731411AbfKVLDQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:03:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:57232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731408AbfKVLDL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:03:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FE182075E;
        Fri, 22 Nov 2019 11:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420591;
        bh=iORbwAUQT32YOs7L6orzyi2v9UCPskwpAZJBMgtZrms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T1ZMlQAmLJ4WhGDxENgt6zqmwgHJPvU8OC1iW2WIBvSEsarjX9tBsa1Gi0VgKWfR+
         PLS8tTTp1OYloslvoB1VmjNLMDtd2RYMFJIP3TPJx/s6naKWgh1WFyzEhJZZkNSaE8
         pJv9l92XxsXJz8deRK3ioG92avT4kOlFdm0VOLrk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Vadim Pasternak <vadimp@mellanox.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 158/220] platform/x86: mlx-platform: Properly use mlxplat_mlxcpld_msn201x_items
Date:   Fri, 22 Nov 2019 11:28:43 +0100
Message-Id: <20191122100924.075147228@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



