Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 934284917A2
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344022AbiARCmg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:42:36 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50448 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244693AbiARCdR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:33:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1E6D61251;
        Tue, 18 Jan 2022 02:33:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC02C36AEB;
        Tue, 18 Jan 2022 02:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473196;
        bh=Fhv3mi1Mm8uNIIYwqjQOhdSly4zsT0G1KS4gJQ8MreU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vo+ZnX33RbOO/TC2GPPU0bgyj8sJErxMVlgX/U5k3pRuL02NUZNuKc4cC5z7oINqM
         BC+reprJzj6G/oxzjIxVwseEuvoPftWWeXh4lNM7U04zfnJVFZgfbpHzXf31iRm/Gy
         Ayza1WM5x0wG7H20kFB/mvIwHolnKzeX+2muIdR4S0WOIKPle6sXGYWjW/AHbbeGt2
         a6FQC4fzpcJjGyx80JlYjoCDqhPnw91+BdLnRKo1ZIBKAmiku5GizCRT0f5lZ4KALB
         lzDvAKIuE6WPKuVtsWz7WOZjvS3HquJ9XqnUbs8lw+NHQvzwZofG8w1KNubiIOjvMR
         2EbW0SwidDK3Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Sasha Levin <sashal@kernel.org>, mchehab@kernel.org,
        gregkh@linuxfoundation.org, ndesaulniers@google.com, drv@mailo.com,
        abaci-bugfix@linux.alibaba.com, robert.foss@linaro.org,
        dingxiang@cmss.chinamobile.com, colin.i.king@googlemail.com,
        linux-media@vger.kernel.org, linux-staging@lists.linux.dev,
        llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 5.15 021/188] media: atomisp: handle errors at sh_css_create_isp_params()
Date:   Mon, 17 Jan 2022 21:29:05 -0500
Message-Id: <20220118023152.1948105-21-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
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

