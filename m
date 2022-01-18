Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA0DF491E16
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351220AbiARDqq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:46:46 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48216 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347237AbiARClB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:41:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57D7AB811CC;
        Tue, 18 Jan 2022 02:40:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B427BC36AE3;
        Tue, 18 Jan 2022 02:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473658;
        bh=1b6YLDjsUCQzFUYs8Px5c2cq/w57NeG2Q6+eG+HGcOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ubem+bjQl2Ugmvv7y22ehJLM/9P72vmfBOC8zcQmJIscbTQMG6fsg7KWwm6fbOiJe
         Rznj+tCHQS8SzhZAgLb3uwCZZCXP72o1w2G3v3kvlmhs7dmhHXgWRpKXo911MslDUH
         uSwh2F8JNxPXFJAI+8UR8okmBmgkvCkC5w/iHj6Y2RggWvgBSzaCyPs2T28Fh0RgwZ
         TA/o0eK8QwzngaEoDOBYWGSjBMxLWEvISDDiuWIw/x7aMjQmZBH2uoJRpfgesKO+ok
         ACvkdWd8QH6XRidKEISnkmUrJ3sjNclsH8eCrik3mORjhAEUl+PRGUTFy4ZOeBX0AD
         mPD74rHwjMjhg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Sasha Levin <sashal@kernel.org>, mchehab@kernel.org,
        gregkh@linuxfoundation.org, ndesaulniers@google.com, drv@mailo.com,
        abaci-bugfix@linux.alibaba.com, colin.i.king@googlemail.com,
        dingxiang@cmss.chinamobile.com, linux-media@vger.kernel.org,
        linux-staging@lists.linux.dev, llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 5.10 014/116] media: atomisp: handle errors at sh_css_create_isp_params()
Date:   Mon, 17 Jan 2022 21:38:25 -0500
Message-Id: <20220118024007.1950576-14-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024007.1950576-1-sashal@kernel.org>
References: <20220118024007.1950576-1-sashal@kernel.org>
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

