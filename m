Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AECB2450D56
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239171AbhKORys (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:54:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:35784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238901AbhKORwo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:52:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B55463282;
        Mon, 15 Nov 2021 17:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997543;
        bh=q/oacaZYzNMACT7bW784z0AZu89lv5Bt7+rOVyb+E+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1K+mf9pdTq/j5d8XAoQP0fNjEx4Fpt7pAzIP6UvxV+HPEwpWprC6R/9G9F8YIl32r
         vyp4SBqsGVLUOMIw8K9ad2QDl47ex3F4xCF6ez521yYYX1n2FKdq5P1eVOBR81t7ME
         oi/WCLv0ZBHLrlASlkjDGWzb1gq1GKnE3d5vEUbU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tao Zhang <quic_taozha@quicinc.com>,
        Leo Yan <leo.yan@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 5.10 154/575] coresight: cti: Correct the parameter for pm_runtime_put
Date:   Mon, 15 Nov 2021 17:57:59 +0100
Message-Id: <20211115165349.023029006@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tao Zhang <quic_taozha@quicinc.com>

commit 692c9a499b286ea478f41b23a91fe3873b9e1326 upstream.

The input parameter of the function pm_runtime_put should be the
same in the function cti_enable_hw and cti_disable_hw. The correct
parameter to use here should be dev->parent.

Signed-off-by: Tao Zhang <quic_taozha@quicinc.com>
Reviewed-by: Leo Yan <leo.yan@linaro.org>
Fixes: 835d722ba10a ("coresight: cti: Initial CoreSight CTI Driver")
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1629365377-5937-1-git-send-email-quic_taozha@quicinc.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/coresight/coresight-cti-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwtracing/coresight/coresight-cti-core.c
+++ b/drivers/hwtracing/coresight/coresight-cti-core.c
@@ -174,7 +174,7 @@ static int cti_disable_hw(struct cti_drv
 	coresight_disclaim_device_unlocked(drvdata->base);
 	CS_LOCK(drvdata->base);
 	spin_unlock(&drvdata->spinlock);
-	pm_runtime_put(dev);
+	pm_runtime_put(dev->parent);
 	return 0;
 
 	/* not disabled this call */


