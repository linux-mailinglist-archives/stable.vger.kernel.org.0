Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D439B37C80C
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238146AbhELQEY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:04:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:38450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235247AbhELP7W (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:59:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C902661979;
        Wed, 12 May 2021 15:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833528;
        bh=FlV0apPUCGhhOmavjoa/Fx7dfZy8Fp8RRC8TfT9sIh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mUPkDf/T51asJ/PP4LaF/gixprSaPZHPX/cpuzzttXAMQNPV9Y5zVwG6Gw0j6IH+o
         zEHMkpziTy9QOG4CN5dM+w7G782LqGz/QxNTopqYl1fqtjUvcG+csUZx3jClVwmMzl
         r455t6L9qZZ18jpgOTnRHI019YaamWLhfIF9LHmI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 141/601] bus: ti-sysc: Fix initializing module_pa for modules without sysc register
Date:   Wed, 12 May 2021 16:43:38 +0200
Message-Id: <20210512144832.469272873@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 7bad5af826aba00487fed9a3300d3f43f0cba11b ]

We have interconnect target modules with no known registers using only
clocks and resets, but we still want to detect them based on the module
IO range. So let's call sysc_parse_and_check_child_range() earlier so we
have module_pa properly initialized.

Fixes: 2928135c93f8 ("bus: ti-sysc: Support modules without control registers")
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/ti-sysc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index 9e535336689f..68145e326eb9 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -901,9 +901,6 @@ static int sysc_map_and_check_registers(struct sysc *ddata)
 	struct device_node *np = ddata->dev->of_node;
 	int error;
 
-	if (!of_get_property(np, "reg", NULL))
-		return 0;
-
 	error = sysc_parse_and_check_child_range(ddata);
 	if (error)
 		return error;
@@ -914,6 +911,9 @@ static int sysc_map_and_check_registers(struct sysc *ddata)
 
 	sysc_check_children(ddata);
 
+	if (!of_get_property(np, "reg", NULL))
+		return 0;
+
 	error = sysc_parse_registers(ddata);
 	if (error)
 		return error;
-- 
2.30.2



