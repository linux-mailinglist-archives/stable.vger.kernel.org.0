Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 972FD11B58E
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731553AbfLKPSG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:18:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:45846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730371AbfLKPSF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:18:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 171BF2073D;
        Wed, 11 Dec 2019 15:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077484;
        bh=fhvtmL8GZu/pKDtGa9VK13wtQwS8/qg2FXgDYF7RPcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OCftq9/T8TD7LRDB+HOFSIIAkgaIYHjbk4O8uCiFmnWd7C6APVXsqxG6OWgEQWrlZ
         RsOHAOgDRKLwgX9jzbfF751yAV1kLX8QbrB1k5NeSpFN0PmGkR6+wAmi7Gq/YvZQ6O
         VJow1gvZmRuCw2JVn+EFKnRL/qOFqL/l7tzVarEA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 056/243] bus: ti-sysc: Fix getting optional clocks in clock_roles
Date:   Wed, 11 Dec 2019 16:03:38 +0100
Message-Id: <20191211150342.887027890@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 7b4f8ac2f1acdff3c0cce23d8c3b86434a6e768a ]

We can have holes in clock_roles with interface clock missing for
example. Currently getting an optional clock will fail if there are
only a functional clock and an optional clock.

Fixes: 09dfe5810762 ("bus: ti-sysc: Add handling for clkctrl opt clocks")
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/ti-sysc.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index 5b31131d0cba2..b6f63e7620214 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -217,8 +217,13 @@ static int sysc_get_clocks(struct sysc *ddata)
 	if (!ddata->clocks)
 		return -ENOMEM;
 
-	for (i = 0; i < ddata->nr_clocks; i++) {
-		error = sysc_get_one_clock(ddata, ddata->clock_roles[i]);
+	for (i = 0; i < SYSC_MAX_CLOCKS; i++) {
+		const char *name = ddata->clock_roles[i];
+
+		if (!name)
+			continue;
+
+		error = sysc_get_one_clock(ddata, name);
 		if (error && error != -ENOENT)
 			return error;
 	}
-- 
2.20.1



