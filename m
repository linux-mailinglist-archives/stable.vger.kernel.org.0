Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 927AE26B6DD
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 02:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbgIPAMv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 20:12:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:41426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726944AbgIOO0a (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:26:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02B2E22464;
        Tue, 15 Sep 2020 14:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179580;
        bh=nEKjW6rYP6qA3oTip1YczSNAMKPIAvulBqSmtTcH6zg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FWSnlTFWK4tGYUKTLjU0Esknqp3rlRRNuPoLJ4nJVxv4ZhT8WK/M1UtHOI+/6Iqvx
         2G+UOR/9JQwEDOau8Z5p4GWFLE6C1ioX7RM4dKbD4sFaU4GZmG4F0577TXechO/2cv
         b+Z5qUxbk4IGNMfKNnSyFOb9U8mVbfwBMxWXn+4k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hanjun Guo <guohanjun@huawei.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 037/132] dmaengine: acpi: Put the CSRT table after using it
Date:   Tue, 15 Sep 2020 16:12:19 +0200
Message-Id: <20200915140645.978906292@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140644.037604909@linuxfoundation.org>
References: <20200915140644.037604909@linuxfoundation.org>
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



