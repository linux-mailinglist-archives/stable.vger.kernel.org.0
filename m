Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74594439F92
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234800AbhJYTWI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:22:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:39276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234802AbhJYTU5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:20:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0CB1610A5;
        Mon, 25 Oct 2021 19:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635189514;
        bh=DkzIO5A03SRxsi4IHh9zWKcpfsQxM/uye2P9HevFwXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YeGMoRQjHJ/NMYwDlqCGyxdvS2jAPBaVmxWUNj/ml7DYWtxCsZH3Z8zAiJSUg/u4K
         0w/pj83BPjYnKh+ch1zwmK42ZkyA2nZzgjKJjC3vAO9pQ4sRV5Ht5r5t3wNsBcuspR
         0QiKE6X82E6S10/BPWJAKTX+s3PYx2HPHZqVcXgo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Rob Clark <robdclark@chromium.org>
Subject: [PATCH 4.9 23/50] drm/msm: Fix null pointer dereference on pointer edp
Date:   Mon, 25 Oct 2021 21:14:10 +0200
Message-Id: <20211025190937.385507956@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190932.542632625@linuxfoundation.org>
References: <20211025190932.542632625@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

commit 2133c4fc8e1348dcb752f267a143fe2254613b34 upstream.

The initialization of pointer dev dereferences pointer edp before
edp is null checked, so there is a potential null pointer deference
issue. Fix this by only dereferencing edp after edp has been null
checked.

Addresses-Coverity: ("Dereference before null check")
Fixes: ab5b0107ccf3 ("drm/msm: Initial add eDP support in msm drm driver (v5)")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20210929121857.213922-1-colin.king@canonical.com
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/edp/edp_ctrl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/msm/edp/edp_ctrl.c
+++ b/drivers/gpu/drm/msm/edp/edp_ctrl.c
@@ -1090,7 +1090,7 @@ void msm_edp_ctrl_power(struct edp_ctrl
 int msm_edp_ctrl_init(struct msm_edp *edp)
 {
 	struct edp_ctrl *ctrl = NULL;
-	struct device *dev = &edp->pdev->dev;
+	struct device *dev;
 	int ret;
 
 	if (!edp) {
@@ -1098,6 +1098,7 @@ int msm_edp_ctrl_init(struct msm_edp *ed
 		return -EINVAL;
 	}
 
+	dev = &edp->pdev->dev;
 	ctrl = devm_kzalloc(dev, sizeof(*ctrl), GFP_KERNEL);
 	if (!ctrl)
 		return -ENOMEM;


