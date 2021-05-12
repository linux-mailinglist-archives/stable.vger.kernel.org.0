Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10AFC37CC24
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239260AbhELQjN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:39:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:48666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241839AbhELQa4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:30:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BC0A61C27;
        Wed, 12 May 2021 15:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835060;
        bh=YBgL38BbDoQ3OoqPikTjVjilfPDlvVgFSeTcvn87+fA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Doq+Ku799nAOTzG7Voa5xh3qXL1k7Rl04tW2w0qhkvEUnSyKcEPRU93LIDj8URIwR
         MpgMdnejmxdLG1BZFpl4dQ8RAh+zgXu/FLvpzsKO2LF+BxA7h5e+oPIGgtC+DFhyly
         89ZYME8KPV/G2NL5OSKpiUJUV6sFMYI67L+I7JuE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 185/677] mtd: parsers: qcom: Fix error condition
Date:   Wed, 12 May 2021 16:43:51 +0200
Message-Id: <20210512144843.392484632@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit c95310e1b33eae9767af9698aa976d5301f37203 ]

qcom_smem_get() does not return NULL, and even if it did, the NULL
condition is usually not an error but a success condition and should
not trigger an error trace.

Let's replace IS_ERR_OR_NULL() by IS_ERR().

This fixes the following smatch warning:
drivers/mtd/parsers/qcomsmempart.c:109 parse_qcomsmem_part() warn: passing zero to 'PTR_ERR'

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 803eb124e1a6 ("mtd: parsers: Add Qcom SMEM parser")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20210303084634.12796-1-miquel.raynal@bootlin.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/parsers/qcomsmempart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/parsers/qcomsmempart.c b/drivers/mtd/parsers/qcomsmempart.c
index 808cb33d71f8..1c8a44d0d6e4 100644
--- a/drivers/mtd/parsers/qcomsmempart.c
+++ b/drivers/mtd/parsers/qcomsmempart.c
@@ -104,7 +104,7 @@ static int parse_qcomsmem_part(struct mtd_info *mtd,
 	 * complete partition table
 	 */
 	ptable = qcom_smem_get(SMEM_APPS, SMEM_AARM_PARTITION_TABLE, &len);
-	if (IS_ERR_OR_NULL(ptable)) {
+	if (IS_ERR(ptable)) {
 		pr_err("Error reading partition table\n");
 		return PTR_ERR(ptable);
 	}
-- 
2.30.2



