Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E032C26B472
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbgIOXYk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:24:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:48810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726402AbgIOOiA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:38:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9A062244C;
        Tue, 15 Sep 2020 14:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600180057;
        bh=nEKjW6rYP6qA3oTip1YczSNAMKPIAvulBqSmtTcH6zg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rq2WJ1ULWWEmdmQRq/CQ/2UX4dPERjcH/AO6QmWZr+IIKUjk/FQCTsR7czumUi6+C
         6cfLE28zBGfUwwO0GT7lnI7LTkN7bVAxGTQtJXBSfNRrq2r8Uo5grVP3TgihIIO3tb
         pIoVwLg4gWb6WEDAGKHg83kijxpij5jKrZrRKQdI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hanjun Guo <guohanjun@huawei.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 062/177] dmaengine: acpi: Put the CSRT table after using it
Date:   Tue, 15 Sep 2020 16:12:13 +0200
Message-Id: <20200915140656.604298441@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hanjun Guo <guohanjun@huawei.com>

[ Upstream commit 7eb48dd094de5fe0e216b550e73aa85257903973 ]

The acpi_get_table() should be coupled with acpi_put_table() if
the mapped table is not used at runtime to release the table
mapping, put the CSRT table buf after using it.

Signed-off-by: Hanjun Guo <guohanjun@huawei.com>
Link: https://lore.kernel.org/r/1595411661-15936-1-git-send-email-guohanjun@huawei.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/acpi-dma.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/acpi-dma.c b/drivers/dma/acpi-dma.c
index 8a05db3343d39..dcbcb712de6e8 100644
--- a/drivers/dma/acpi-dma.c
+++ b/drivers/dma/acpi-dma.c
@@ -135,11 +135,13 @@ static void acpi_dma_parse_csrt(struct acpi_device *adev, struct acpi_dma *adma)
 		if (ret < 0) {
 			dev_warn(&adev->dev,
 				 "error in parsing resource group\n");
-			return;
+			break;
 		}
 
 		grp = (struct acpi_csrt_group *)((void *)grp + grp->length);
 	}
+
+	acpi_put_table((struct acpi_table_header *)csrt);
 }
 
 /**
-- 
2.25.1



