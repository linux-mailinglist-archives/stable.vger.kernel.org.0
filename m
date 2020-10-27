Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3174A29B050
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2901022AbgJ0OSH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:18:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:41396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2901017AbgJ0OSH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:18:07 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3EB6E206F7;
        Tue, 27 Oct 2020 14:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808286;
        bh=gu14B/3XyOqUww19uJ6tUihj6C0vESM6NGFqZSz5VoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ioWVMA4HzzyHX0GrvgdbEQaUT5sNeVFwmdGonar7bmAdJV6CS1bvkDZk3Il8dHTZF
         s0WGQLB+6CXjqHYB6cbbMY19Yk5UAT8yvQuSA5zG7X71N3tUsXeJ/9Nwd1qPyP3M7E
         9Pn1juhVMjj/nQ7wkztsAPjFF/1L5Ksv+BUamtJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Borislav Petkov <bp@suse.de>, Tero Kristo <t-kristo@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 034/264] EDAC/ti: Fix handling of platform_get_irq() error
Date:   Tue, 27 Oct 2020 14:51:32 +0100
Message-Id: <20201027135432.261879287@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 66077adb70a2a9e92540155b2ace33ec98299c90 ]

platform_get_irq() returns a negative error number on error. In such a
case, comparison to 0 would pass the check therefore check the return
value properly, whether it is negative.

 [ bp: Massage commit message. ]

Fixes: 86a18ee21e5e ("EDAC, ti: Add support for TI keystone and DRA7xx EDAC")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Tero Kristo <t-kristo@ti.com>
Link: https://lkml.kernel.org/r/20200827070743.26628-2-krzk@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/ti_edac.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/edac/ti_edac.c b/drivers/edac/ti_edac.c
index 6ac26d1b929f0..3247689467435 100644
--- a/drivers/edac/ti_edac.c
+++ b/drivers/edac/ti_edac.c
@@ -278,7 +278,8 @@ static int ti_edac_probe(struct platform_device *pdev)
 
 	/* add EMIF ECC error handler */
 	error_irq = platform_get_irq(pdev, 0);
-	if (!error_irq) {
+	if (error_irq < 0) {
+		ret = error_irq;
 		edac_printk(KERN_ERR, EDAC_MOD_NAME,
 			    "EMIF irq number not defined.\n");
 		goto err;
-- 
2.25.1



