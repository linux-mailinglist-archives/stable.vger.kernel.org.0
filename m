Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD5F40520D
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355066AbhIIMkq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:40:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:46130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352888AbhIIMhe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:37:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CD9D61BB2;
        Thu,  9 Sep 2021 11:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188466;
        bh=C56UGu/jYrwM6Jfi/51pH9IQNP0Jn9eLUHEN3yNrW1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DAHm045IACqZgJoq+pL1Ne8WE7xtth2EAO9khmOtkczGUYIF7w66fFWviHAYyJSYk
         +mkrGi096ES4ObahAeZljURSCsgmsDmshWiFC0Puee6eWApQait3xLoEvYAYZbddkj
         uL1oazxihm/OX/MwMhNAvreUCqUJ6nPYW3F/cnuVf9sk6Hp5ac49goP2JEIRuugt5H
         ISny4r8TrfaTk0OmLz0tN6aVwPZ7iHKCUCrUJ58XYdkoUczzdhjuM9rDyuYTkOmi2z
         R9XB34xfDYQP5LmF2+3W6RL0MNNLvKKN0gIebbtinHvdcq1BL1OVisSx2oFpNhZaZD
         GajmV/Z7wP7lQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>, Rob Herring <robh@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 145/176] of: Don't allow __of_attached_node_sysfs() without CONFIG_SYSFS
Date:   Thu,  9 Sep 2021 07:50:47 -0400
Message-Id: <20210909115118.146181-145-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115118.146181-1-sashal@kernel.org>
References: <20210909115118.146181-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 6211e9cb2f8faf7faae0b6caf844bfe9527cc607 ]

Trying to boot without SYSFS, but with OF_DYNAMIC quickly
results in a crash:

[    0.088460] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000070
[...]
[    0.103927] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 5.14.0-rc3 #4179
[    0.105810] Hardware name: linux,dummy-virt (DT)
[    0.107147] pstate: 80000005 (Nzcv daif -PAN -UAO -TCO BTYPE=--)
[    0.108876] pc : kernfs_find_and_get_ns+0x3c/0x7c
[    0.110244] lr : kernfs_find_and_get_ns+0x3c/0x7c
[...]
[    0.134087] Call trace:
[    0.134800]  kernfs_find_and_get_ns+0x3c/0x7c
[    0.136054]  safe_name+0x4c/0xd0
[    0.136994]  __of_attach_node_sysfs+0xf8/0x124
[    0.138287]  of_core_init+0x90/0xfc
[    0.139296]  driver_init+0x30/0x4c
[    0.140283]  kernel_init_freeable+0x160/0x1b8
[    0.141543]  kernel_init+0x30/0x140
[    0.142561]  ret_from_fork+0x10/0x18

While not having sysfs isn't a very common option these days,
it is still expected that such configuration would work.

Paper over it by bailing out from __of_attach_node_sysfs() if
CONFIG_SYSFS isn't enabled.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210820144722.169226-1-maz@kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/kobj.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/of/kobj.c b/drivers/of/kobj.c
index a32e60b024b8..6675b5e56960 100644
--- a/drivers/of/kobj.c
+++ b/drivers/of/kobj.c
@@ -119,7 +119,7 @@ int __of_attach_node_sysfs(struct device_node *np)
 	struct property *pp;
 	int rc;
 
-	if (!of_kset)
+	if (!IS_ENABLED(CONFIG_SYSFS) || !of_kset)
 		return 0;
 
 	np->kobj.kset = of_kset;
-- 
2.30.2

