Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B105F3C532F
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350644AbhGLHyA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:54:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:35416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346469AbhGLHsk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:48:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 043CC6195A;
        Mon, 12 Jul 2021 07:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075768;
        bh=qTNBvR7k5wCiJjIz7H7WoJUxLxMfhe0AXKF36Vxkxmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=128pbFBQFfPYphxH+PrR5frLvWm6yUxkJuXLfPGPebT33/KxxHqHLR7iav7UQ7863
         LAHGc0rzW1T/m6jdGZ06fUQIrWOxR1shItoJE1mdl+5I4MeZ7c0JdFcvKv/8sFmSm2
         oUadFL6YoeSqXDxrqb0FDUYfdBbw1W57o3nXBWCA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 356/800] PM / devfreq: Add missing error code in devfreq_add_device()
Date:   Mon, 12 Jul 2021 08:06:19 +0200
Message-Id: <20210712061004.961641795@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
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
index fe08c46642f7..28f3e0ba6cdd 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -823,6 +823,7 @@ struct devfreq *devfreq_add_device(struct device *dev,
 	if (devfreq->profile->timer < 0
 		|| devfreq->profile->timer >= DEVFREQ_TIMER_NUM) {
 		mutex_unlock(&devfreq->lock);
+		err = -EINVAL;
 		goto err_dev;
 	}
 
-- 
2.30.2



