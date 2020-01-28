Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 480F514BA26
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731091AbgA1OUc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:20:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:45276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731064AbgA1OUY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:20:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37D1E24696;
        Tue, 28 Jan 2020 14:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221223;
        bh=6VVs+YcJkjkc4AbeBlabJHGpjVqAyqZrDuIdDFpuW7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fKoY9uCl5g5LZTu0O7S1fQC092ymXWGwdpyl4i1w/n22k6tz2//6grsDF1KyUkRww
         lRyWUZj508YUjlH79f0Oaq5JtbI+MBm/A2r6+r96tPVSDxhSyVSZBvqGemjThNvHcA
         bAz5s8TYL/TQcljD4OsFnV5TEcLXBXW0rNSnvp+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Li Yang <leoyang.li@nxp.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 111/271] soc/fsl/qe: Fix an error code in qe_pin_request()
Date:   Tue, 28 Jan 2020 15:04:20 +0100
Message-Id: <20200128135900.834467580@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 5674a92ca4b7e5a6a19231edd10298d30324cd27 ]

We forgot to set "err" on this error path.

Fixes: 1a2d397a6eb5 ("gpio/powerpc: Eliminate duplication of of_get_named_gpio_flags()")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Li Yang <leoyang.li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/fsl/qe/gpio.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/fsl/qe/gpio.c b/drivers/soc/fsl/qe/gpio.c
index 0aaf429f31d57..b5a7107a9c0a9 100644
--- a/drivers/soc/fsl/qe/gpio.c
+++ b/drivers/soc/fsl/qe/gpio.c
@@ -152,8 +152,10 @@ struct qe_pin *qe_pin_request(struct device_node *np, int index)
 	if (err < 0)
 		goto err0;
 	gc = gpio_to_chip(err);
-	if (WARN_ON(!gc))
+	if (WARN_ON(!gc)) {
+		err = -ENODEV;
 		goto err0;
+	}
 
 	if (!of_device_is_compatible(gc->of_node, "fsl,mpc8323-qe-pario-bank")) {
 		pr_debug("%s: tried to get a non-qe pin\n", __func__);
-- 
2.20.1



