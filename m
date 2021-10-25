Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12B4A439F94
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234855AbhJYTWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:22:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:38138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234550AbhJYTVC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:21:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D900610CF;
        Mon, 25 Oct 2021 19:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635189519;
        bh=mHL1+/sGFYkWBjJdyj/s4p2sjcui4IVOvEEToKqYAoA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xDjj/hNqkZraxTv1hu5jgfLLU+5kMHkKNjDa5xS88CpRrGZrauJ4KEcaI+AqGo4RY
         ZYZ5gGegKhXiuz8HYGJQf1/oeqlkrWb+n+EBwEeZDZiN4T33YlfTKd/quU8OqV1vqR
         +an86IIKp03X6WN5AnjAR8OcnUKr0pJMAHap4uPQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Rob Clark <robdclark@chromium.org>
Subject: [PATCH 4.9 24/50] drm/msm/dsi: fix off by one in dsi_bus_clk_enable error handling
Date:   Mon, 25 Oct 2021 21:14:11 +0200
Message-Id: <20211025190937.555999473@linuxfoundation.org>
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
@@ -439,7 +439,7 @@ static int dsi_bus_clk_enable(struct msm
 
 	return 0;
 err:
-	for (; i > 0; i--)
+	while (--i >= 0)
 		clk_disable_unprepare(msm_host->bus_clks[i]);
 
 	return ret;


