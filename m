Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1522F3C4F43
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239762AbhGLHXt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:23:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:60556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241658AbhGLHWe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:22:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55B2F6113B;
        Mon, 12 Jul 2021 07:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074386;
        bh=r+33zhwkhlNb4+e7xWkw9fVjzpf9JQnRil8eNp7a1/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gSjrED8MOgnweyLE7R9YoptHW+NWhmpULRWddez0g0H5W3Dw8r2A+PiQ8djYEVIAK
         ra4fRoxUEf75el8lT087LLSRmgUqVdJohehjEFJUQruj/pyev3pSx8wTWzhQ7EvsVF
         SRTUh9ZGzy9t/I00U1lxB5Pa6vtluS6yNilVImvI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ansuel Smith <ansuelsmth@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 562/700] mtd: parsers: qcom: Fix leaking of partition name
Date:   Mon, 12 Jul 2021 08:10:45 +0200
Message-Id: <20210712061035.998714043@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ansuel Smith <ansuelsmth@gmail.com>

[ Upstream commit 10f3b4d79958d6f9f71588c6fa862159c83fa80f ]

Add cleanup function as the name variable for the partition name was
allocaed but never freed after the use as the add mtd function
duplicate the name and free the pparts struct as the partition name is
assumed to be static.
The leak was found using kmemleak.

Fixes: 803eb124e1a6 ("mtd: parsers: Add Qcom SMEM parser")
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20210525230931.30013-1-ansuelsmth@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/parsers/qcomsmempart.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/mtd/parsers/qcomsmempart.c b/drivers/mtd/parsers/qcomsmempart.c
index d9083308f6ba..06a818cd2433 100644
--- a/drivers/mtd/parsers/qcomsmempart.c
+++ b/drivers/mtd/parsers/qcomsmempart.c
@@ -159,6 +159,15 @@ out_free_parts:
 	return ret;
 }
 
+static void parse_qcomsmem_cleanup(const struct mtd_partition *pparts,
+				   int nr_parts)
+{
+	int i;
+
+	for (i = 0; i < nr_parts; i++)
+		kfree(pparts[i].name);
+}
+
 static const struct of_device_id qcomsmem_of_match_table[] = {
 	{ .compatible = "qcom,smem-part" },
 	{},
@@ -167,6 +176,7 @@ MODULE_DEVICE_TABLE(of, qcomsmem_of_match_table);
 
 static struct mtd_part_parser mtd_parser_qcomsmem = {
 	.parse_fn = parse_qcomsmem_part,
+	.cleanup = parse_qcomsmem_cleanup,
 	.name = "qcomsmem",
 	.of_match_table = qcomsmem_of_match_table,
 };
-- 
2.30.2



