Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D777A3C4D33
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245363AbhGLHMM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:12:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:45294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244398AbhGLHKt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:10:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A70F60FF4;
        Mon, 12 Jul 2021 07:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073679;
        bh=VBwULnpEr7iI+Jlxs91pwYaxs55yCj0kjAc+tOmLKcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uLvumhcaAuUeClDik8THt4FkkSGC0eBLUR5CkGKvHOmAGODmC8WkxVjVP/jm/0ogY
         +IJVMRQr61bew6Sg9sbR4eq4gvP+lwE7CcEY/HX7Srsnm7WXHfD0G8XfDlthksAlTE
         tQ+dgLawyvGhzi8EdOzU13DKfEbYm0EpqBPfD/wU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 323/700] PM / devfreq: Add missing error code in devfreq_add_device()
Date:   Mon, 12 Jul 2021 08:06:46 +0200
Message-Id: <20210712061010.741353737@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 18b380ed61f892ed06838d1f1a5124d966292ed3 ]

Set err code in the error path before jumping to the end of the function.

Fixes: 4dc3bab8687f ("PM / devfreq: Add support delayed timer for polling mode")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/devfreq/devfreq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index 59ba59bea0f5..db1bc8cf9276 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -822,6 +822,7 @@ struct devfreq *devfreq_add_device(struct device *dev,
 	if (devfreq->profile->timer < 0
 		|| devfreq->profile->timer >= DEVFREQ_TIMER_NUM) {
 		mutex_unlock(&devfreq->lock);
+		err = -EINVAL;
 		goto err_dev;
 	}
 
-- 
2.30.2



