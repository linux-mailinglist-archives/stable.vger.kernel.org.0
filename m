Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 155EF89BF3
	for <lists+stable@lfdr.de>; Mon, 12 Aug 2019 12:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728113AbfHLKwC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Aug 2019 06:52:02 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51387 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727997AbfHLKwB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Aug 2019 06:52:01 -0400
Received: by mail-wm1-f67.google.com with SMTP id 207so11724260wma.1
        for <stable@vger.kernel.org>; Mon, 12 Aug 2019 03:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=android.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O++uRsHIpORfNijsJuAZCfYZu5AagOJx1j5KC3QdVcw=;
        b=WCSxhklfkSzS5/+kkOkukSkT1h+mFwRUtmjfny6WJSaaYvw0v6fTvhSsW6r6hAzwVC
         5BgJtJT3vVGXk9r5T4lsxbDqI2LCyF2h6Fu7shSOjvhpwREZycWrzvbQS+m3Ml/ewaTz
         +0UDCMfv3zAJNsMTO2IA3M7RXV/wp2tgbMPZ4xNSiysltMtC1gg4hLbu0Tm2+PFmyquF
         e2DYyadblv3GIEFppUCdnxKa9mEhj+z70SgrdT81PHqMvSYRkCQ389pY9f1hAd9MIdki
         WIC2EqA0miWwN9r+myF/979nOF72hXNpzSmRVx/FtLLWpUhlSHfBWHZkCd7eXV2jeID5
         DnOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O++uRsHIpORfNijsJuAZCfYZu5AagOJx1j5KC3QdVcw=;
        b=UThjdmfvns8rUhnSbwlUHePXfRQnjT32ol3jArB5mnxlqnUPy3+bieFUctC+nUX/wp
         Y+6/wJ/sD8C68fx3+KPeIEGv/cM7zJB1Xt5G2L2xntEeu4EsT5B9scKIu2M8zVuwyJ2S
         auLla/KdcOnZZAmU3hYfvvEpExH6suJujt1DnbDDfBkLTtoy3kyWZLHRLx4TLe9TMREL
         C9W7L1umPX2S/KS+UGemAdzJVhIarqnqIao9P9S3qnYb30rk3p4Ca1t9iZY4QmvzU19g
         mVs/l8L1XOIU7nx317V9e8sjdBTrbp9N7PQ8WhFUmp1zVwkHGxnhTuxj+9HxNyOkoEr7
         bOkw==
X-Gm-Message-State: APjAAAWXOu2G5XA4WRW+mo4cgA5FAjwWGraufUO/gj/Day14FAZUCavS
        D6pVwD9zr+1DRk6sddKVKrQMBA==
X-Google-Smtp-Source: APXvYqxdhoDzzqMbFWiHpr3b23pn8q93eGI6N4yLdQ3P0IvYGe4x45TxERM+VierDtKsKWPruWT1ZQ==
X-Received: by 2002:a05:600c:224c:: with SMTP id a12mr13043785wmm.12.1565607119705;
        Mon, 12 Aug 2019 03:51:59 -0700 (PDT)
Received: from balsini.lon.corp.google.com ([2a00:79e0:d:210:e751:37a0:1e95:e65d])
        by smtp.gmail.com with ESMTPSA id 74sm5169675wma.15.2019.08.12.03.51.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 03:51:59 -0700 (PDT)
From:   Alessio Balsini <balsini@android.com>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com, Jason Gunthorpe <jgg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Alessio Balsini <balsini@android.com>
Subject: [PATCH 4.4.y] IB/mlx5: Fix leaking stack memory to userspace
Date:   Mon, 12 Aug 2019 11:51:36 +0100
Message-Id: <20190812105136.151840-1-balsini@android.com>
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
In-Reply-To: <20190812104843.150191-1-balsini@android.com>
References: <20190812104843.150191-1-balsini@android.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

mlx5_ib_create_qp_resp was never initialized and only the first 4 bytes
were written.

Fixes: 41d902cb7c32 ("RDMA/mlx5: Fix definition of mlx5_ib_create_qp_resp")
Cc: <stable@vger.kernel.org>
Acked-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Alessio Balsini <balsini@android.com>
---
 drivers/infiniband/hw/mlx5/qp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 43d277a931c2..c035abfe8c55 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -865,7 +865,7 @@ static int create_qp_common(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 {
 	struct mlx5_ib_resources *devr = &dev->devr;
 	struct mlx5_core_dev *mdev = dev->mdev;
-	struct mlx5_ib_create_qp_resp resp;
+	struct mlx5_ib_create_qp_resp resp = {};
 	struct mlx5_create_qp_mbox_in *in;
 	struct mlx5_ib_create_qp ucmd;
 	int inlen = sizeof(*in);
-- 
2.23.0.rc1.153.gdeed80330f-goog

