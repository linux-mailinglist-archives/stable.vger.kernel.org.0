Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22D3B29B3B0
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2900720AbgJ0OyY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:54:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:50718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1773110AbgJ0OvT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:51:19 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A686206E5;
        Tue, 27 Oct 2020 14:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810278;
        bh=vivV3xKPzAQjtPZH6nSfZfJGcVRD2ycs4JVZSA+belE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AovgoX+mRypPewulBjs1LFr6eJecFM2i608fGsOmt+ldkt3Hf1r1eq2mVo3q4D5U7
         ReWZvjinutnkwX0rZRY+uEEwUQ+UZffuMPgz4sXmwNyRomL+EYjpK/+S4hTrQUG2H0
         EuB2JJ2VAqVGlvyP8hnbkOd4fLquw32ReUGjod8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Borislav Petkov <bp@suse.de>, Tero Kristo <t-kristo@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 084/633] EDAC/ti: Fix handling of platform_get_irq() error
Date:   Tue, 27 Oct 2020 14:47:07 +0100
Message-Id: <20201027135526.627309664@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
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
index 8be3e89a510e4..d7419a90a2f5b 100644
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



