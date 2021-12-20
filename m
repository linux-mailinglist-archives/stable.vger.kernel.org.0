Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B66647AD24
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:51:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235445AbhLTOuj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:50:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236895AbhLTOrc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:47:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19EBFC06179C;
        Mon, 20 Dec 2021 06:44:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD6F561141;
        Mon, 20 Dec 2021 14:44:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D9E1C36AE8;
        Mon, 20 Dec 2021 14:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011457;
        bh=Xmm2tj+fVy9fNRrVL5KGyrgGJ6AJWAx9oEGIQvBm7ZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=md8ODJ2NqLlO7jnUBy5hV8lIQ1AXdQHybP9v0GmFjxNac3eR7z/VsnsEK43u2m9gW
         y+JOw+sRNqUWsZUkA1gBlawnMzd8Tzx46ytAqLYIsYZZ6Yd3XgtBFXV/TSPwiFp/KR
         ukrnf91LGUYeAuVJ6KFyFAgaVuQdgN3cC+loO8mc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pedro Batista <pedbap.g@gmail.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Cristian Marussi <cristian.marussi@arm.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.4 04/71] firmware: arm_scpi: Fix string overflow in SCPI genpd driver
Date:   Mon, 20 Dec 2021 15:33:53 +0100
Message-Id: <20211220143025.827140494@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143025.683747691@linuxfoundation.org>
References: <20211220143025.683747691@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudeep Holla <sudeep.holla@arm.com>

commit 865ed67ab955428b9aa771d8b4f1e4fb7fd08945 upstream.

Without the bound checks for scpi_pd->name, it could result in the buffer
overflow when copying the SCPI device name from the corresponding device
tree node as the name string is set at maximum size of 30.

Let us fix it by using devm_kasprintf so that the string buffer is
allocated dynamically.

Fixes: 8bec4337ad40 ("firmware: scpi: add device power domain support using genpd")
Reported-by: Pedro Batista <pedbap.g@gmail.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Cc: stable@vger.kernel.org
Cc: Cristian Marussi <cristian.marussi@arm.com>
Link: https://lore.kernel.org/r/20211209120456.696879-1-sudeep.holla@arm.com'
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/scpi_pm_domain.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/firmware/scpi_pm_domain.c
+++ b/drivers/firmware/scpi_pm_domain.c
@@ -16,7 +16,6 @@ struct scpi_pm_domain {
 	struct generic_pm_domain genpd;
 	struct scpi_ops *ops;
 	u32 domain;
-	char name[30];
 };
 
 /*
@@ -110,8 +109,13 @@ static int scpi_pm_domain_probe(struct p
 
 		scpi_pd->domain = i;
 		scpi_pd->ops = scpi_ops;
-		sprintf(scpi_pd->name, "%pOFn.%d", np, i);
-		scpi_pd->genpd.name = scpi_pd->name;
+		scpi_pd->genpd.name = devm_kasprintf(dev, GFP_KERNEL,
+						     "%pOFn.%d", np, i);
+		if (!scpi_pd->genpd.name) {
+			dev_err(dev, "Failed to allocate genpd name:%pOFn.%d\n",
+				np, i);
+			continue;
+		}
 		scpi_pd->genpd.power_off = scpi_pd_power_off;
 		scpi_pd->genpd.power_on = scpi_pd_power_on;
 


