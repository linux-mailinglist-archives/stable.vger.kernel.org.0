Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6DA315EC09
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389564AbgBNRYP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:24:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:33318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391202AbgBNQJH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:09:07 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D58D2467E;
        Fri, 14 Feb 2020 16:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696547;
        bh=AJXW1CMLWcubyoLjPolCPobZXlVMMU/nqykdf1BmEWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bnbgTKrWcmw6kSWgw0lEeRHPZ8SyRD7DD8+bKN6BTO1d1XpGGodjRAY/o7o5TAoV4
         C1QEHUDmJxAW9rn+KcUNTi+9zmlPqWbZ1FFb+esy2jrn5uPntUZ5RENcRe7QKqPlrD
         vQHggx3TbzX+T6j+t7P5rJhN4cmoOBSIEe1VD1C8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Yongjun <weiyongjun1@huawei.com>, Borislav Petkov <bp@suse.de>,
        Sasha Levin <sashal@kernel.org>, linux-edac@vger.kernel.org,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 340/459] EDAC/sifive: Fix return value check in ecc_register()
Date:   Fri, 14 Feb 2020 10:59:50 -0500
Message-Id: <20200214160149.11681-340-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 413cdb4a591db..bb9ceeaf29bf9 100644
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

