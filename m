Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9DB89C08
	for <lists+stable@lfdr.de>; Mon, 12 Aug 2019 12:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728114AbfHLKzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Aug 2019 06:55:23 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50554 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727980AbfHLKzX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Aug 2019 06:55:23 -0400
Received: by mail-wm1-f67.google.com with SMTP id v15so11724260wml.0
        for <stable@vger.kernel.org>; Mon, 12 Aug 2019 03:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=android.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nj+3s2yrWseVcLh3wJxjh5wTreHAkZAnG1J6avSid7E=;
        b=XgvPjH/MwveIgl8aFYjN+Tttzua/lbqCtjlfe6yz+ELv8B4/KvQK6LfwVTSkVLDyW0
         NZz78c0d8/FlvJPMTc+9oA77npKJrLUzY4s/XfLdum7uydS32UWT8/kGatjfyHP3wgvW
         2WqwAWkzu4HwUPcnH4YdyFOQQZEOnhl6Gf7oUJG8K/7CwQLVlJwLPw9BB0gpzrW504HA
         +7DRL9sd7B/2cXjVWnQ+P5flClhXZSRvE42vsx/iDDxs0PuE2BTk8+tUG8JgKcXX0L3G
         TiUqbdYyDQu3sca6YNOtC914X7eStNpJcPv27tCvpEes63VeBLSbrcgnX/vBjafQu+Yi
         Hrsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nj+3s2yrWseVcLh3wJxjh5wTreHAkZAnG1J6avSid7E=;
        b=DC/zQbg9BV98VoEzA/E9l7sXmjdQdiI1ot3XMCAbz7Qft9n5NyqavTS9v6NSyclJLu
         XKtOtSnLIHzaW5Kaeti7rYzwz+tFdVJ2SxfmMItbvrncv15N0IGNYlfiRFxUz9+EXmCY
         8OGCpqBE635kFR1kgw6SDWwboNKNWTDzeNpkBWvvL58hpDN8CxYUXcTECjPez/ZeFC6D
         +moeaOMgDmgnTZFEkkJQtV98n05YnP++2ea5zLTGLsOB/LsxxOe4YtHNyYKvQWJR2zxE
         Ku1tYV9ssuL8c79RgqZ9u4l+4EF8n6ZAAr52tk5Kg4xwAKSLHFw2PhaF7Cpj103ih2vR
         irBg==
X-Gm-Message-State: APjAAAW854FJc68V54+YBHK8kH334mBKiXEAX/FrDOobtOdmj+gk/5D2
        U7Xd1hEDECCYsV07bGwV5CpohA==
X-Google-Smtp-Source: APXvYqwMNLd879rWEsOClegptD2DrDBCGSZK5Crb2bIkJDlKgEfyXjeFtl+KB0crwiYwgc9wBzKong==
X-Received: by 2002:a1c:f70c:: with SMTP id v12mr27108992wmh.42.1565607321113;
        Mon, 12 Aug 2019 03:55:21 -0700 (PDT)
Received: from balsini.lon.corp.google.com ([2a00:79e0:d:210:e751:37a0:1e95:e65d])
        by smtp.gmail.com with ESMTPSA id 20sm8375472wmk.34.2019.08.12.03.55.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 03:55:20 -0700 (PDT)
From:   Alessio Balsini <balsini@android.com>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com, Jason Gunthorpe <jgg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Alessio Balsini <balsini@android.com>
Subject: [PATCH 4.9.y 4.14.y] IB/mlx5: Fix leaking stack memory to userspace
Date:   Mon, 12 Aug 2019 11:55:03 +0100
Message-Id: <20190812105503.153253-1-balsini@android.com>
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
In-Reply-To: <20190812105136.151840-1-balsini@android.com>
References: <20190812105136.151840-1-balsini@android.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

commit 0625b4ba1a5d4703c7fb01c497bd6c156908af00 upstream.

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
index a7bc89f5dae7..89357d9e489d 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1515,7 +1515,7 @@ static int create_qp_common(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	struct mlx5_ib_resources *devr = &dev->devr;
 	int inlen = MLX5_ST_SZ_BYTES(create_qp_in);
 	struct mlx5_core_dev *mdev = dev->mdev;
-	struct mlx5_ib_create_qp_resp resp;
+	struct mlx5_ib_create_qp_resp resp = {};
 	struct mlx5_ib_cq *send_cq;
 	struct mlx5_ib_cq *recv_cq;
 	unsigned long flags;
-- 
2.23.0.rc1.153.gdeed80330f-goog

