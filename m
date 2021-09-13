Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1907F408EE2
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242066AbhIMNhR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:37:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:34930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243300AbhIMNfN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:35:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D8A861252;
        Mon, 13 Sep 2021 13:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539640;
        bh=7KiC/1SwSPjzV2bmnZ/FsGG5+kHJ/z4AvoT9m+N1XvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T8IYg/X06+LZIUimVp83eCm1W4oNPlmOVlZ6rC6IrXnsdXT4oot+aD0PW3Ib8vqkO
         OwWE8jO6mm5Y+xuNt4RIVp4HTyTK9NyrWkmyZbyRhCc0rFz7TlGjwyOQy2NjVz/F0P
         5hvP0Lm2TM3b/uH6WmhbMbbEvQ7S8+mSMdqB3eiw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Steven Price <steven.price@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 069/236] drm/panfrost: Fix missing clk_disable_unprepare() on error in panfrost_clk_init()
Date:   Mon, 13 Sep 2021 15:12:54 +0200
Message-Id: <20210913131102.704479245@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit f42498705965bd4b026953c1892c686d8b1138e4 ]

Fix the missing clk_disable_unprepare() before return
from panfrost_clk_init() in the error handling case.

Fixes: b681af0bc1cc ("drm: panfrost: add optional bus_clock")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210608143856.4154766-1-weiyongjun1@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panfrost/panfrost_device.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_device.c b/drivers/gpu/drm/panfrost/panfrost_device.c
index bf7c34cfb84c..c256929e859b 100644
--- a/drivers/gpu/drm/panfrost/panfrost_device.c
+++ b/drivers/gpu/drm/panfrost/panfrost_device.c
@@ -60,7 +60,8 @@ static int panfrost_clk_init(struct panfrost_device *pfdev)
 	if (IS_ERR(pfdev->bus_clock)) {
 		dev_err(pfdev->dev, "get bus_clock failed %ld\n",
 			PTR_ERR(pfdev->bus_clock));
-		return PTR_ERR(pfdev->bus_clock);
+		err = PTR_ERR(pfdev->bus_clock);
+		goto disable_clock;
 	}
 
 	if (pfdev->bus_clock) {
-- 
2.30.2



