Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9D621FB9C
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731116AbgGNS5n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:57:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:55974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731105AbgGNS5l (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:57:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93C1A207F5;
        Tue, 14 Jul 2020 18:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594753061;
        bh=JYfOiBOUm4P3pjmchGUH5VzRPMLgcMzZNY+DU8Pm3rA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wSn2fB4ALrq6EQ2SXzKytjzNH5XxPDHkyQUxensCk5jj1ulKIY3UVivSupgR2cdP4
         roSXI3wd53lGVk/IEJTNW4nHe82sAj4OuG7z48eAKmeAwiH1unnc7weCuQB+eJxkDe
         HSLPrDSGoMkUmS/iGtxmCXajZQGoRdLoVZ66RPwg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 105/166] mlxsw: spectrum_router: Remove inappropriate usage of WARN_ON()
Date:   Tue, 14 Jul 2020 20:44:30 +0200
Message-Id: <20200714184120.871876432@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

[ Upstream commit d9d5420273997664a1c09151ca86ac993f2f89c1 ]

We should not trigger a warning when a memory allocation fails. Remove
the WARN_ON().

The warning is constantly triggered by syzkaller when it is injecting
faults:

[ 2230.758664] FAULT_INJECTION: forcing a failure.
[ 2230.758664] name failslab, interval 1, probability 0, space 0, times 0
[ 2230.762329] CPU: 3 PID: 1407 Comm: syz-executor.0 Not tainted 5.8.0-rc2+ #28
...
[ 2230.898175] WARNING: CPU: 3 PID: 1407 at drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c:6265 mlxsw_sp_router_fib_event+0xfad/0x13e0
[ 2230.898179] Kernel panic - not syncing: panic_on_warn set ...
[ 2230.898183] CPU: 3 PID: 1407 Comm: syz-executor.0 Not tainted 5.8.0-rc2+ #28
[ 2230.898190] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014

Fixes: 3057224e014c ("mlxsw: spectrum_router: Implement FIB offload in deferred work")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index d5bca1be3ef53..84b3d78a9dd84 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -6256,7 +6256,7 @@ static int mlxsw_sp_router_fib_event(struct notifier_block *nb,
 	}
 
 	fib_work = kzalloc(sizeof(*fib_work), GFP_ATOMIC);
-	if (WARN_ON(!fib_work))
+	if (!fib_work)
 		return NOTIFY_BAD;
 
 	fib_work->mlxsw_sp = router->mlxsw_sp;
-- 
2.25.1



