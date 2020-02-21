Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB1E2167768
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:42:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730133AbgBUHzv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:55:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:54934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728318AbgBUHzu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:55:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4A95206ED;
        Fri, 21 Feb 2020 07:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271750;
        bh=Xidm1KLHeikUqJj0mf8sqeP5+U4+kFE95p+55aYHmkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tUyp6qEKKwbuKMBvsUtG7ovuphVVGUFiY5eB7RuoYl2t7RvAVmtk3WqsFeYq1I7/Y
         rEOSzUDdLhBmCThOFlbesCogkmRuS0RZ/t6CcYnZv0qFeR+SN4bfqibDpHxdlZKJyS
         Cp0McUsAh9ijY11hvSLlLM3beVHKAxvx4DK3fDIw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Yongjun <weiyongjun1@huawei.com>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 285/399] EDAC/sifive: Fix return value check in ecc_register()
Date:   Fri, 21 Feb 2020 08:40:10 +0100
Message-Id: <20200221072429.600413723@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 6cd18453b68942913fd3b1913b707646e544c2ac ]

In case of error, the function edac_device_alloc_ctl_info() returns a
NULL pointer, not ERR_PTR(). Replace the IS_ERR() test in the return
value check with a NULL test.

Fixes: 91abaeaaff35 ("EDAC/sifive: Add EDAC platform driver for SiFive SoCs")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20200115150303.112627-1-weiyongjun1@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/sifive_edac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/sifive_edac.c b/drivers/edac/sifive_edac.c
index c0cc72a3b2be9..3a3dcb14ed99d 100644
--- a/drivers/edac/sifive_edac.c
+++ b/drivers/edac/sifive_edac.c
@@ -54,8 +54,8 @@ static int ecc_register(struct platform_device *pdev)
 	p->dci = edac_device_alloc_ctl_info(0, "sifive_ecc", 1, "sifive_ecc",
 					    1, 1, NULL, 0,
 					    edac_device_alloc_index());
-	if (IS_ERR(p->dci))
-		return PTR_ERR(p->dci);
+	if (!p->dci)
+		return -ENOMEM;
 
 	p->dci->dev = &pdev->dev;
 	p->dci->mod_name = "Sifive ECC Manager";
-- 
2.20.1



