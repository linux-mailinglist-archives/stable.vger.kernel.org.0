Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59F3E111FE5
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727516AbfLCWkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:40:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:51530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728018AbfLCWkE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:40:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A44920684;
        Tue,  3 Dec 2019 22:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412803;
        bh=4vCA25Z0+dH53pBdgMERWlhPydL8bkVbLm7wZP9xvZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AH8D/dqw4otv2Sov6NSSUairGFKpdtah2YZfXBGbhzyvCxk5antIxbT8PqrbcosG3
         8qTJF3V2a2dc2SQIn1CDBI83KVr+h1fX803NdZMlvWFMTonUoJkj5VmuAcgR57kB4c
         NSGo9dZ2t7D2XViQm6F1XL8Z5uQ+mdUSedpSUPgg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Dooks <ben.dooks@codethink.co.uk>,
        Lucas Stach <l.stach@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 022/135] soc: imx: gpc: fix initialiser format
Date:   Tue,  3 Dec 2019 23:34:22 +0100
Message-Id: <20191203213010.120207107@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Dooks <ben.dooks@codethink.co.uk>

[ Upstream commit 96ed1044fa98ea9e164fc1e679cad61575bf4f32 ]

Make the initialiers in imx_gpc_domains C99 format to fix the
following sparse warnings:

drivers/soc/imx/gpc.c:252:30: warning: obsolete array initializer, use C99 syntax
drivers/soc/imx/gpc.c:258:29: warning: obsolete array initializer, use C99 syntax
drivers/soc/imx/gpc.c:269:34: warning: obsolete array initializer, use C99 syntax
drivers/soc/imx/gpc.c:278:30: warning: obsolete array initializer, use C99 syntax

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
Reviewed-by: Lucas Stach <l.stach@pengutronix.de>
Fixes: b0682d485f12 ("soc: imx: gpc: use GPC_PGC_DOMAIN_* indexes")
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/imx/gpc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/soc/imx/gpc.c b/drivers/soc/imx/gpc.c
index d9231bd3c691a..98b9d9a902ae3 100644
--- a/drivers/soc/imx/gpc.c
+++ b/drivers/soc/imx/gpc.c
@@ -249,13 +249,13 @@ static struct genpd_power_state imx6_pm_domain_pu_state = {
 };
 
 static struct imx_pm_domain imx_gpc_domains[] = {
-	[GPC_PGC_DOMAIN_ARM] {
+	[GPC_PGC_DOMAIN_ARM] = {
 		.base = {
 			.name = "ARM",
 			.flags = GENPD_FLAG_ALWAYS_ON,
 		},
 	},
-	[GPC_PGC_DOMAIN_PU] {
+	[GPC_PGC_DOMAIN_PU] = {
 		.base = {
 			.name = "PU",
 			.power_off = imx6_pm_domain_power_off,
@@ -266,7 +266,7 @@ static struct imx_pm_domain imx_gpc_domains[] = {
 		.reg_offs = 0x260,
 		.cntr_pdn_bit = 0,
 	},
-	[GPC_PGC_DOMAIN_DISPLAY] {
+	[GPC_PGC_DOMAIN_DISPLAY] = {
 		.base = {
 			.name = "DISPLAY",
 			.power_off = imx6_pm_domain_power_off,
@@ -275,7 +275,7 @@ static struct imx_pm_domain imx_gpc_domains[] = {
 		.reg_offs = 0x240,
 		.cntr_pdn_bit = 4,
 	},
-	[GPC_PGC_DOMAIN_PCI] {
+	[GPC_PGC_DOMAIN_PCI] = {
 		.base = {
 			.name = "PCI",
 			.power_off = imx6_pm_domain_power_off,
-- 
2.20.1



