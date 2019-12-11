Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E61C511B4DA
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732601AbfLKPW0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:22:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:53142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732598AbfLKPWZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:22:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA5332073D;
        Wed, 11 Dec 2019 15:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077745;
        bh=RH6l+hQax7qbFY0dTEQKlj4I4P1gsXMGK+Cq4J28fQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e1jWcMHmB0BpDBTXCRMu8v1CNGD3eMsEG8FL5ES5AW5n5HnxQcRUqxIbvNRRehyWF
         AoNYWy+unQzNjUliLpcHiyhxeoM9hVUNQGrGyTi6FglwGtjcq/Lye3hT0dcExbdYom
         TxKga0Mjjke9O2c6O/+rUDQoFUyLN8PO7qCAmwEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikko Perttunen <mperttunen@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 117/243] gpu: host1x: Fix syncpoint ID field size on Tegra186
Date:   Wed, 11 Dec 2019 16:04:39 +0100
Message-Id: <20191211150347.029702666@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit 2fc777ba8422e4a38cae61537ad6a26435a86fb8 ]

The number of syncpoints on Tegra186 is 576 and therefore no longer fits
into 8 bits. Increase the size of the syncpoint ID field to 10 in order
to accomodate all syncpoints.

Reviewed-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/host1x/hw/hw_host1x06_uclass.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/host1x/hw/hw_host1x06_uclass.h b/drivers/gpu/host1x/hw/hw_host1x06_uclass.h
index 4457486c72b05..e599e15bf999a 100644
--- a/drivers/gpu/host1x/hw/hw_host1x06_uclass.h
+++ b/drivers/gpu/host1x/hw/hw_host1x06_uclass.h
@@ -59,7 +59,7 @@ static inline u32 host1x_uclass_incr_syncpt_r(void)
 	host1x_uclass_incr_syncpt_r()
 static inline u32 host1x_uclass_incr_syncpt_cond_f(u32 v)
 {
-	return (v & 0xff) << 8;
+	return (v & 0xff) << 10;
 }
 #define HOST1X_UCLASS_INCR_SYNCPT_COND_F(v) \
 	host1x_uclass_incr_syncpt_cond_f(v)
-- 
2.20.1



