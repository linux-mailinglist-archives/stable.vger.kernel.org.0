Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A050613E110
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729499AbgAPQre (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:47:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:57412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729946AbgAPQrc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:47:32 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61D992081E;
        Thu, 16 Jan 2020 16:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193252;
        bh=ZOIvOYprd3XLNljzNUYFfxxYX6r1QQgmbxqckAwtrVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MF5Xg0RLdTloyF9uVj7czZkT0F29oVmyfR+B5J3RuHxKxU50CBF/5tN1gz5ic2zLI
         Ga8xSdjnueDGC1/88aRYAbQPUBq+P5hMpy/e0R5H6fuvFjglvbFGFgCZD6TvO2+Z4M
         gvGdAafsrwl13E3H+ccHWw8l+McrkNi9V4nh6MHA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        Corey Minyard <cminyard@mvista.com>,
        Sasha Levin <sashal@kernel.org>,
        openipmi-developer@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.4 055/205] ipmi: Fix memory leak in __ipmi_bmc_register
Date:   Thu, 16 Jan 2020 11:40:30 -0500
Message-Id: <20200116164300.6705-55-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit 4aa7afb0ee20a97fbf0c5bab3df028d5fb85fdab ]

In the impelementation of __ipmi_bmc_register() the allocated memory for
bmc should be released in case ida_simple_get() fails.

Fixes: 68e7e50f195f ("ipmi: Don't use BMC product/dev ids in the BMC name")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Message-Id: <20191021200649.1511-1-navid.emamdoost@gmail.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ipmi_msghandler.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index 3c8a559506e8..0b6e7f8d9729 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -3039,8 +3039,11 @@ static int __ipmi_bmc_register(struct ipmi_smi *intf,
 		bmc->pdev.name = "ipmi_bmc";
 
 		rv = ida_simple_get(&ipmi_bmc_ida, 0, 0, GFP_KERNEL);
-		if (rv < 0)
+		if (rv < 0) {
+			kfree(bmc);
 			goto out;
+		}
+
 		bmc->pdev.dev.driver = &ipmidriver.driver;
 		bmc->pdev.id = rv;
 		bmc->pdev.dev.release = release_bmc_device;
-- 
2.20.1

