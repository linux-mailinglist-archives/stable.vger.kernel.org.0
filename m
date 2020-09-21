Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9FF27303C
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 19:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728161AbgIURDn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 13:03:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:36792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728476AbgIUQgt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:36:49 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 004CE206B7;
        Mon, 21 Sep 2020 16:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706209;
        bh=3st5nF5UcQ80yr/lcX3pOnZPlbiq4npcK9jsNL3vzmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vJsIbk/J+7BwxZGL0zEG1mhECRWPPSPfq7hhuIA31i2rTCXUs9Mz3CjbFXcjjhH2w
         ga9WHQmt2ooK5jrviGcR+pEnGj0tptqKPlLgIcsuJEz/lzxZ81FQ7I4cGNJWELpPlF
         ekpTnfC37qAzjo9AnJ3PDCCaV5ZXXuejP6ULdtSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hanjun Guo <guohanjun@huawei.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 10/94] dmaengine: acpi: Put the CSRT table after using it
Date:   Mon, 21 Sep 2020 18:26:57 +0200
Message-Id: <20200921162036.019702560@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162035.541285330@linuxfoundation.org>
References: <20200921162035.541285330@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
index 4a748c3435d7d..8d99c84361cbb 100644
--- a/drivers/dma/acpi-dma.c
+++ b/drivers/dma/acpi-dma.c
@@ -131,11 +131,13 @@ static void acpi_dma_parse_csrt(struct acpi_device *adev, struct acpi_dma *adma)
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



