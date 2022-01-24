Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8F1499558
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392595AbiAXUvf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:51:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390883AbiAXUqc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:46:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE04CC06127E;
        Mon, 24 Jan 2022 11:56:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A921FB81218;
        Mon, 24 Jan 2022 19:56:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D515BC340E5;
        Mon, 24 Jan 2022 19:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054201;
        bh=1b6YLDjsUCQzFUYs8Px5c2cq/w57NeG2Q6+eG+HGcOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UjkkszSa8i0F10lcts/2MC45EXJB/WDlhOY/r//qLwOhyxT0NQ1gwt1seoEg8XEbe
         S2ZuiRZEJNDZJBAmUmkz6WhuNCFqP/kgnutGzyzKjtt50kbnQGdwnHe3kFMCtLeD+t
         iEJK/iVe0VPVLKm4E48ztidc8Ah9ZLsEk8wvcDeo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 311/563] media: atomisp: handle errors at sh_css_create_isp_params()
Date:   Mon, 24 Jan 2022 19:41:16 +0100
Message-Id: <20220124184035.186222073@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 24fc497bd4915..8d6514c45eeb6 100644
--- a/drivers/staging/media/atomisp/pci/sh_css_params.c
+++ b/drivers/staging/media/atomisp/pci/sh_css_params.c
@@ -2437,7 +2437,7 @@ sh_css_create_isp_params(struct ia_css_stream *stream,
 	unsigned int i;
 	struct sh_css_ddr_address_map *ddr_ptrs;
 	struct sh_css_ddr_address_map_size *ddr_ptrs_size;
-	int err = 0;
+	int err;
 	size_t params_size;
 	struct ia_css_isp_parameters *params =
 	kvmalloc(sizeof(struct ia_css_isp_parameters), GFP_KERNEL);
@@ -2482,7 +2482,11 @@ sh_css_create_isp_params(struct ia_css_stream *stream,
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



