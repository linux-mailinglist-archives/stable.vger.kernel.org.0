Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 626434914CF
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245522AbiARCYZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:24:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244743AbiARCV0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:21:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CADBC061778;
        Mon, 17 Jan 2022 18:21:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2454B81244;
        Tue, 18 Jan 2022 02:21:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 125FBC36AE3;
        Tue, 18 Jan 2022 02:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472483;
        bh=Fhv3mi1Mm8uNIIYwqjQOhdSly4zsT0G1KS4gJQ8MreU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bhi0MQl6T7QsaBu/6e/sw1uhSYYZbGx5h064E+1KuxC3aRHuW5KKiNDm1nUm5h8dB
         JWExtmN0oPXBrQlK9TmWeSnZK7w0D98VwFVjSe3xjkxpoeI0o/1Np/O/VFrf9oqNRO
         9EzcSfNAVz+p4GXvtlt1ptLzfSayrDIwex+mbuqfbw5InH09BWi+r4+lLGUvvIe9+k
         E9aC21juFq1/S1b2jYIq+IIEe0w0hLt11YwKU3//VD9i1hmcsz/2HYntvyIrZShEIl
         pC6X6sZxHlLrI/FNFQZM5kNOle7FKLdiMeoRi5b4Ui0zNYPrktnyS9ZM4/U83W7aI/
         WqCD47Lk/18Dw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Sasha Levin <sashal@kernel.org>, mchehab@kernel.org,
        gregkh@linuxfoundation.org, ndesaulniers@google.com, drv@mailo.com,
        robert.foss@linaro.org, colin.i.king@googlemail.com,
        dingxiang@cmss.chinamobile.com, abaci-bugfix@linux.alibaba.com,
        linux-media@vger.kernel.org, linux-staging@lists.linux.dev,
        llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 5.16 027/217] media: atomisp: handle errors at sh_css_create_isp_params()
Date:   Mon, 17 Jan 2022 21:16:30 -0500
Message-Id: <20220118021940.1942199-27-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit 58043dbf6d1ae9deab4f5aa1e039c70112017682 ]

The succ var tracks memory allocation erros on this function.

Fix it, in order to stop this W=1 Werror in clang:

drivers/staging/media/atomisp/pci/sh_css_params.c:2430:7: error: variable 'succ' set but not used [-Werror,-Wunused-but-set-variable]
        bool succ = true;
             ^

Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/atomisp/pci/sh_css_params.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/sh_css_params.c b/drivers/staging/media/atomisp/pci/sh_css_params.c
index dbd3bfe3d343c..ccc0078795648 100644
--- a/drivers/staging/media/atomisp/pci/sh_css_params.c
+++ b/drivers/staging/media/atomisp/pci/sh_css_params.c
@@ -2431,7 +2431,7 @@ sh_css_create_isp_params(struct ia_css_stream *stream,
 	unsigned int i;
 	struct sh_css_ddr_address_map *ddr_ptrs;
 	struct sh_css_ddr_address_map_size *ddr_ptrs_size;
-	int err = 0;
+	int err;
 	size_t params_size;
 	struct ia_css_isp_parameters *params =
 	kvmalloc(sizeof(struct ia_css_isp_parameters), GFP_KERNEL);
@@ -2473,7 +2473,11 @@ sh_css_create_isp_params(struct ia_css_stream *stream,
 	succ &= (ddr_ptrs->macc_tbl != mmgr_NULL);
 
 	*isp_params_out = params;
-	return err;
+
+	if (!succ)
+		return -ENOMEM;
+
+	return 0;
 }
 
 static bool
-- 
2.34.1

