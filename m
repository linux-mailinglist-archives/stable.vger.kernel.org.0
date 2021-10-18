Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1EDB431B92
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232556AbhJRNdv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:33:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:42496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231929AbhJRNcG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:32:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD57061371;
        Mon, 18 Oct 2021 13:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563742;
        bh=CUwO4p1OoWHyzUG9wwNwu9Do9Enkrl8bJ3sUCcxMLHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nTY4bMMQLJHGB7alB9j9IUIOpeg5u4N5ERRCpDQRNkCciSmJgax/Ta90TLtLnaEGo
         eGEwOid02Ik9e75EYhSRgsI7Xx8bMwq4JUZt87hD66pZwAEKQOune7rQ2p7p62SXrC
         azH55EhgeoUf78quEtpXN0ikzg69QvVKZ6KCatjY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Rob Clark <robdclark@chromium.org>
Subject: [PATCH 4.19 46/50] drm/msm/dsi: fix off by one in dsi_bus_clk_enable error handling
Date:   Mon, 18 Oct 2021 15:24:53 +0200
Message-Id: <20211018132328.045930924@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132326.529486647@linuxfoundation.org>
References: <20211018132326.529486647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit c8f01ffc83923a91e8087aaa077de13354a7aa59 upstream.

This disables a lock which wasn't enabled and it does not disable
the first lock in the array.

Fixes: 6e0eb52eba9e ("drm/msm/dsi: Parse bus clocks from a list")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20211001123409.GG2283@kili
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/dsi/dsi_host.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -468,7 +468,7 @@ static int dsi_bus_clk_enable(struct msm
 
 	return 0;
 err:
-	for (; i > 0; i--)
+	while (--i >= 0)
 		clk_disable_unprepare(msm_host->bus_clks[i]);
 
 	return ret;


