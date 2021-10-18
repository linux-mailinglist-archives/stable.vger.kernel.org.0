Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5F2C431E9B
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 16:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233332AbhJRODA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 10:03:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:39032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234730AbhJROAz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 10:00:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1582461A62;
        Mon, 18 Oct 2021 13:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564549;
        bh=4JVTp6e2N7XK2TQ81UKMPTnYvwTJbjLERjbcct7OG0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mg4MUuZXf3FsUFGm64AsxnU9+mMIWT5iLNocwCznecHrfQCGRPl0UnIKbGY4NIn+P
         1RzsOVR8rbrpMvVYWuN6U8F/9+yEjmuP/FAWEtTsWmXusqw5xsKQOC4C2HhePP4wDI
         HY26SXtkS+Xij+DUnJQQ3xBg4ReD2yRwlorMB/rg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Rob Clark <robdclark@chromium.org>
Subject: [PATCH 5.14 131/151] drm/msm/a4xx: fix error handling in a4xx_gpu_init()
Date:   Mon, 18 Oct 2021 15:25:10 +0200
Message-Id: <20211018132344.922670224@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 980d74e7d03ccf2eaa11d133416946bd880c7c08 upstream.

This code returns 1 on error instead of a negative error.  It leads to
an Oops in the caller.  A second problem is that the check for
"if (ret != -ENODATA)" cannot be true because "ret" is set to 1.

Fixes: 5785dd7a8ef0 ("drm/msm: Fix duplicate gpu node in icc summary")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20211001125759.GJ2283@kili
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/adreno/a4xx_gpu.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/msm/adreno/a4xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a4xx_gpu.c
@@ -699,13 +699,14 @@ struct msm_gpu *a4xx_gpu_init(struct drm
 	}
 
 	icc_path = devm_of_icc_get(&pdev->dev, "gfx-mem");
-	ret = IS_ERR(icc_path);
-	if (ret)
+	if (IS_ERR(icc_path)) {
+		ret = PTR_ERR(icc_path);
 		goto fail;
+	}
 
 	ocmem_icc_path = devm_of_icc_get(&pdev->dev, "ocmem");
-	ret = IS_ERR(ocmem_icc_path);
-	if (ret) {
+	if (IS_ERR(ocmem_icc_path)) {
+		ret = PTR_ERR(ocmem_icc_path);
 		/* allow -ENODATA, ocmem icc is optional */
 		if (ret != -ENODATA)
 			goto fail;


