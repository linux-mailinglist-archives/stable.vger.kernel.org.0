Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEE7C3CAB29
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244373AbhGOTR6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:17:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:50894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243838AbhGOTP6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:15:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16DE061370;
        Thu, 15 Jul 2021 19:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376332;
        bh=oeHtHu3SOTnq8xDXXFlMf7eT9quDwllg4ho5H1FEKSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=olqwvRaregawMTHlxlcWVNpwm7n+mFE4P4caGJG8V2p6usMEJOWag79+SVkECh+00
         wO2UwYQIjkHg7oDLPn1r24Izf6SSY2Po2cGfsDvuMC+alzinRZHXURtF37LUkM4kSH
         ASV6qxw1kD0YzF9GsxCiCLPrSmwWTcIsYZMBGql4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Meng Li <Meng.Li@windriver.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 5.13 226/266] mfd: syscon: Free the allocated name field of struct regmap_config
Date:   Thu, 15 Jul 2021 20:39:41 +0200
Message-Id: <20210715182648.972371678@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Limeng <Meng.Li@windriver.com>

commit 56a1188159cb2b87fbcb5a7a7afb38a4dd9db0c1 upstream.

The commit 529a1101212a("mfd: syscon: Don't free allocated name
for regmap_config") doesn't free the allocated name field of struct
regmap_config, but introduce a memory leak. There is another
commit 94cc89eb8fa5("regmap: debugfs: Fix handling of name string
for debugfs init delays") fixing this debugfs init issue from root
cause. With this fixing, the name field in struct regmap_debugfs_node
is removed. When initialize debugfs for syscon driver, the name
field of struct regmap_config is not used anymore. So, the allocated
name field of struct regmap_config is need to be freed directly after
regmap initialization to avoid memory leak.

Cc: stable@vger.kernel.org
Fixes: 529a1101212a("mfd: syscon: Don't free allocated name for regmap_config")
Signed-off-by: Meng Li <Meng.Li@windriver.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/syscon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mfd/syscon.c
+++ b/drivers/mfd/syscon.c
@@ -108,6 +108,7 @@ static struct syscon *of_syscon_register
 	syscon_config.max_register = resource_size(&res) - reg_io_width;
 
 	regmap = regmap_init_mmio(NULL, base, &syscon_config);
+	kfree(syscon_config.name);
 	if (IS_ERR(regmap)) {
 		pr_err("regmap init failed\n");
 		ret = PTR_ERR(regmap);
@@ -144,7 +145,6 @@ err_clk:
 	regmap_exit(regmap);
 err_regmap:
 	iounmap(base);
-	kfree(syscon_config.name);
 err_map:
 	kfree(syscon);
 	return ERR_PTR(ret);


