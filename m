Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94058328B6B
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238587AbhCASd7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:33:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:41720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239873AbhCAS0W (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:26:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51E5465324;
        Mon,  1 Mar 2021 17:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620682;
        bh=AMAovv1m707oJ1y9ptFW2suwX9WU19RRVpElkic2UbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ynDc5Vv6J6W6G7Dr/s2atbfqYX561HK6ZnHoPBm3Qc/3tsgvKOdGhdsqlExaO6BrS
         NCqqPDemEPcxlMwR1j7rJCLz7M8gUw0iAzmweH9iJsgLht94UKQynvyh/gK1QCH3RC
         wUo40Zs1Iqa/l6xudZs5M0jF284z0yGuJrwW55Q0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 242/775] mtd: parser: imagetag: fix error codes in bcm963xx_parse_imagetag_partitions()
Date:   Mon,  1 Mar 2021 17:06:50 +0100
Message-Id: <20210301161213.593420279@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 12ba8f8ce29fdd277f3100052eddc1afd2f5ea3f ]

If the kstrtouint() calls fail, then this should return a negative
error code but it currently returns success.

Fixes: dd84cb022b31 ("mtd: bcm63xxpart: move imagetag parsing to its own parser")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/YBKFtNaFHGYBj+u4@mwanda
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/parsers/parser_imagetag.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mtd/parsers/parser_imagetag.c b/drivers/mtd/parsers/parser_imagetag.c
index d69607b482272..fab0949aabba1 100644
--- a/drivers/mtd/parsers/parser_imagetag.c
+++ b/drivers/mtd/parsers/parser_imagetag.c
@@ -83,6 +83,7 @@ static int bcm963xx_parse_imagetag_partitions(struct mtd_info *master,
 			pr_err("invalid rootfs address: %*ph\n",
 				(int)sizeof(buf->flash_image_start),
 				buf->flash_image_start);
+			ret = -EINVAL;
 			goto out;
 		}
 
@@ -92,6 +93,7 @@ static int bcm963xx_parse_imagetag_partitions(struct mtd_info *master,
 			pr_err("invalid kernel address: %*ph\n",
 				(int)sizeof(buf->kernel_address),
 				buf->kernel_address);
+			ret = -EINVAL;
 			goto out;
 		}
 
@@ -100,6 +102,7 @@ static int bcm963xx_parse_imagetag_partitions(struct mtd_info *master,
 			pr_err("invalid kernel length: %*ph\n",
 				(int)sizeof(buf->kernel_length),
 				buf->kernel_length);
+			ret = -EINVAL;
 			goto out;
 		}
 
@@ -108,6 +111,7 @@ static int bcm963xx_parse_imagetag_partitions(struct mtd_info *master,
 			pr_err("invalid total length: %*ph\n",
 				(int)sizeof(buf->total_length),
 				buf->total_length);
+			ret = -EINVAL;
 			goto out;
 		}
 
-- 
2.27.0



