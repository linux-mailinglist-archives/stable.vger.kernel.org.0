Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEE7829BDCE
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1812959AbgJ0QrB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:47:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:33118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752709AbgJ0Plf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:41:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CE80222E9;
        Tue, 27 Oct 2020 15:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813294;
        bh=REmmnSsJwWZx/kVUtojQvQwHNvJzF7LjL9JjzVKz8co=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YnCoGy9KxS+XyajEgXhfG4xcrZfqPeSrnAgIGg3KadZNENc3wGI7zi0pfojC8D1rK
         qrWZqH0R1URj/cvamvRvAtCC72+DkJqSwwcbss+cRVbsD3xgRuCcGdzDNnWdb94qnK
         YRiBZkp/4o9xKaFhFBkAwQ+XWi7Z1u5sVuZ7o2/o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 476/757] mtd: rawnand: ams-delta: Fix non-OF build warning
Date:   Tue, 27 Oct 2020 14:52:06 +0100
Message-Id: <20201027135512.834123749@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Janusz Krzysztofik <jmkrzyszt@gmail.com>

[ Upstream commit 6d11178762f7c8338a028b428198383b8978b280 ]

Commit 7c2f66a960fc ("mtd: rawnand: ams-delta: Add module device
tables") introduced an OF module device table but wrapped a reference
to it with of_match_ptr() which resolves to NULL in non-OF configs.
That resulted in a clang compiler warning on unused variable in non-OF
builds.  Fix it.

drivers/mtd/nand/raw/ams-delta.c:373:34: warning: unused variable 'gpio_nand_of_id_table' [-Wunused-const-variable]
   static const struct of_device_id gpio_nand_of_id_table[] = {
                                    ^
   1 warning generated.

Fixes: 7c2f66a960fc ("mtd: rawnand: ams-delta: Add module device tables")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Janusz Krzysztofik <jmkrzyszt@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20200919080403.17520-1-jmkrzyszt@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/ams-delta.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mtd/nand/raw/ams-delta.c b/drivers/mtd/nand/raw/ams-delta.c
index fdba155416d25..0bf4cfc251472 100644
--- a/drivers/mtd/nand/raw/ams-delta.c
+++ b/drivers/mtd/nand/raw/ams-delta.c
@@ -400,12 +400,14 @@ static int gpio_nand_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_OF
 static const struct of_device_id gpio_nand_of_id_table[] = {
 	{
 		/* sentinel */
 	},
 };
 MODULE_DEVICE_TABLE(of, gpio_nand_of_id_table);
+#endif
 
 static const struct platform_device_id gpio_nand_plat_id_table[] = {
 	{
-- 
2.25.1



