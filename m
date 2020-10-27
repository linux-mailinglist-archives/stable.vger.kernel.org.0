Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6753429B844
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1799951AbgJ0PeS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:34:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:52328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799948AbgJ0PeS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:34:18 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 112FF2225E;
        Tue, 27 Oct 2020 15:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812857;
        bh=bT4zdji2nWw1CSWlYhosL2pkLfy29MGk2M4rnXIvYOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jTnARZ0NKZl/87aGZB2yf/cARYSe9AwDA/9dz7DngwEgRiVtB2z2qLNZnY0P5Az44
         Q+UJezJot28Z9UYSxYdPaWtKsRkm7yad3q7jf81OhHntJv+NBy367R70TmlcUGymrS
         KbY8QnIQvAhC+noXEvlkLeCaIw+Cz/do49mU3aYc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 355/757] mfd: syscon: Dont free allocated name for regmap_config
Date:   Tue, 27 Oct 2020 14:50:05 +0100
Message-Id: <20201027135507.222445643@linuxfoundation.org>
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

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 529a1101212a785c5df92c314b0e718287150c3b ]

The name allocated for the regmap_config structure is freed
pretty early, right after the registration of the MMIO region.

Unfortunately, that doesn't follow the life cycle that debugfs
expects, as it can access the name field long after the free
has occurred.

Move the free on the error path, and keep it forever otherwise.

Fixes: e15d7f2b81d2 ("mfd: syscon: Use a unique name with regmap_config")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/syscon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
index df5cebb372a59..ca465794ea9c8 100644
--- a/drivers/mfd/syscon.c
+++ b/drivers/mfd/syscon.c
@@ -108,7 +108,6 @@ static struct syscon *of_syscon_register(struct device_node *np, bool check_clk)
 	syscon_config.max_register = resource_size(&res) - reg_io_width;
 
 	regmap = regmap_init_mmio(NULL, base, &syscon_config);
-	kfree(syscon_config.name);
 	if (IS_ERR(regmap)) {
 		pr_err("regmap init failed\n");
 		ret = PTR_ERR(regmap);
@@ -145,6 +144,7 @@ static struct syscon *of_syscon_register(struct device_node *np, bool check_clk)
 	regmap_exit(regmap);
 err_regmap:
 	iounmap(base);
+	kfree(syscon_config.name);
 err_map:
 	kfree(syscon);
 	return ERR_PTR(ret);
-- 
2.25.1



