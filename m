Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26DF9205D71
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389086AbgFWUN1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:13:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:55528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389083AbgFWUN1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:13:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A7A920707;
        Tue, 23 Jun 2020 20:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943206;
        bh=K/4JzaY+ILlY4OM95wmDtD1aA5+zt7bNidlRQvr0BaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SYT5w9cNlIzZ+qOSr0g+A/NTWXYRR3VeXDgYcNCCOavr/E/RZBooAmmw/Z6MwAsa2
         5py28qICi7gK7alEaa9LiO8pV/mH4CxUY7j1e+FednpR2vJHYrnSXOE3NdwkSEv+Wc
         uPAKk2SWnGHH1WH3r9+jVu52Edqc8a7yXa3r7lPU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amelie Delaunay <amelie.delaunay@st.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 271/477] mfd: stmfx: Disable IRQ in suspend to avoid spurious interrupt
Date:   Tue, 23 Jun 2020 21:54:28 +0200
Message-Id: <20200623195420.372000784@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amelie Delaunay <amelie.delaunay@st.com>

[ Upstream commit 97eda5dcc2cde5dcc778bef7a9344db3b6bf8ef5 ]

When STMFX supply is stopped, spurious interrupt can occur. To avoid that,
disable the interrupt in suspend before disabling the regulator and
re-enable it at the end of resume.

Fixes: 06252ade9156 ("mfd: Add ST Multi-Function eXpander (STMFX) core driver")
Signed-off-by: Amelie Delaunay <amelie.delaunay@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/stmfx.c       | 6 ++++++
 include/linux/mfd/stmfx.h | 1 +
 2 files changed, 7 insertions(+)

diff --git a/drivers/mfd/stmfx.c b/drivers/mfd/stmfx.c
index 1977fe95f876c..711979afd90a0 100644
--- a/drivers/mfd/stmfx.c
+++ b/drivers/mfd/stmfx.c
@@ -296,6 +296,8 @@ static int stmfx_irq_init(struct i2c_client *client)
 	if (ret)
 		goto irq_exit;
 
+	stmfx->irq = client->irq;
+
 	return 0;
 
 irq_exit:
@@ -486,6 +488,8 @@ static int stmfx_suspend(struct device *dev)
 	if (ret)
 		return ret;
 
+	disable_irq(stmfx->irq);
+
 	if (stmfx->vdd)
 		return regulator_disable(stmfx->vdd);
 
@@ -529,6 +533,8 @@ static int stmfx_resume(struct device *dev)
 	if (ret)
 		return ret;
 
+	enable_irq(stmfx->irq);
+
 	return 0;
 }
 #endif
diff --git a/include/linux/mfd/stmfx.h b/include/linux/mfd/stmfx.h
index 3c67983678ec7..744dce63946e0 100644
--- a/include/linux/mfd/stmfx.h
+++ b/include/linux/mfd/stmfx.h
@@ -109,6 +109,7 @@ struct stmfx {
 	struct device *dev;
 	struct regmap *map;
 	struct regulator *vdd;
+	int irq;
 	struct irq_domain *irq_domain;
 	struct mutex lock; /* IRQ bus lock */
 	u8 irq_src;
-- 
2.25.1



