Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0F4329021
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242666AbhCAUDI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:03:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:58658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242067AbhCATw3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:52:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2954E650EF;
        Mon,  1 Mar 2021 17:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621174;
        bh=eCg/lIjEM+W/uBZZrji2wyLg8gsCtmA7cM7v0jv6DWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YJSV+DIPagf8QK8VS6u2Gharf5Y2w+i8uZGS0Pwo6BhSyY08KZVAu1yfv8aM5CJt6
         ACDWEE1bhTh47OzsnL2rWxBvXxaucgIIABp+3q+Fzgq7FIxxjja/bndz/EF9EFjZqj
         x9ahhnBF9s08ycufoifrVOzUwDBFZlxAhaVNe8Nc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 420/775] mfd: altera-sysmgr: Fix physical address storing more
Date:   Mon,  1 Mar 2021 17:09:48 +0100
Message-Id: <20210301161222.335127993@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit b0b5b16b78cea1b2b990a69ab8e07a42ccf7a2ed ]

A recent fix improved the way the resource gets passed to
the low-level accessors, but left one warning that appears
in configurations with a resource_size_t that is wider than
a pointer:

In file included from drivers/mfd/altera-sysmgr.c:19:
drivers/mfd/altera-sysmgr.c: In function 'sysmgr_probe':
drivers/mfd/altera-sysmgr.c:148:40: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
  148 |   regmap = devm_regmap_init(dev, NULL, (void *)res->start,
      |                                        ^
include/linux/regmap.h:646:6: note: in definition of macro '__regmap_lockdep_wrapper'
  646 |   fn(__VA_ARGS__, &_key,     \
      |      ^~~~~~~~~~~
drivers/mfd/altera-sysmgr.c:148:12: note: in expansion of macro 'devm_regmap_init'
  148 |   regmap = devm_regmap_init(dev, NULL, (void *)res->start,
      |            ^~~~~~~~~~~~~~~~

I had tried a different approach that would store the address
in the private data as a phys_addr_t, but the easiest solution
now seems to be to add a double cast to shut up the warning.

As the address is passed to an inline assembly, it is guaranteed
to not be wider than a register anyway.

Fixes: d9ca7801b6e5 ("mfd: altera-sysmgr: Fix physical address storing hacks")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/altera-sysmgr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/altera-sysmgr.c b/drivers/mfd/altera-sysmgr.c
index 193a96c8b1eab..20cb294c75122 100644
--- a/drivers/mfd/altera-sysmgr.c
+++ b/drivers/mfd/altera-sysmgr.c
@@ -145,7 +145,8 @@ static int sysmgr_probe(struct platform_device *pdev)
 		sysmgr_config.reg_write = s10_protected_reg_write;
 
 		/* Need physical address for SMCC call */
-		regmap = devm_regmap_init(dev, NULL, (void *)res->start,
+		regmap = devm_regmap_init(dev, NULL,
+					  (void *)(uintptr_t)res->start,
 					  &sysmgr_config);
 	} else {
 		base = devm_ioremap(dev, res->start, resource_size(res));
-- 
2.27.0



