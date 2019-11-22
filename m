Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5660106D65
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730190AbfKVK7r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:59:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:51200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730195AbfKVK7q (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:59:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A62DD20706;
        Fri, 22 Nov 2019 10:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420386;
        bh=/fUyGVnz4vUZV7QqWfrT9JvA8+OesvTPpl/KA51g0nE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=unI8auj+e1zH/k7WQheQreYXv0L5kBu/9NeivOPMrZorR+yspddVqrhag+IfZAMiE
         +efrtlVu0gD3ICM0dZ+BFLVPslXUQ1rd7009a5Lgm0bqGjBVqMFEk31kFcnrGW8qOy
         ixhuJafSbfoffkxN9cCJ73p8Wht3248iRfDGAu5Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Arun Kumar Neelakantam <aneela@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 090/220] rpmsg: glink: smem: Support rx peak for size less than 4 bytes
Date:   Fri, 22 Nov 2019 11:27:35 +0100
Message-Id: <20191122100919.110458321@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arun Kumar Neelakantam <aneela@codeaurora.org>

[ Upstream commit 928002a5e9dab2ddc1a0fe3e00739e89be30dc6b ]

The current rx peak function fails to read the data if size is
less than 4bytes.

Use memcpy_fromio to support data reads of size less than 4 bytes.

Cc: stable@vger.kernel.org
Fixes: f0beb4ba9b18 ("rpmsg: glink: Remove chunk size word align warning")
Signed-off-by: Arun Kumar Neelakantam <aneela@codeaurora.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rpmsg/qcom_glink_smem.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/rpmsg/qcom_glink_smem.c b/drivers/rpmsg/qcom_glink_smem.c
index 2b5cf27909540..7b6544348a3e0 100644
--- a/drivers/rpmsg/qcom_glink_smem.c
+++ b/drivers/rpmsg/qcom_glink_smem.c
@@ -89,15 +89,11 @@ static void glink_smem_rx_peak(struct qcom_glink_pipe *np,
 		tail -= pipe->native.length;
 
 	len = min_t(size_t, count, pipe->native.length - tail);
-	if (len) {
-		__ioread32_copy(data, pipe->fifo + tail,
-				len / sizeof(u32));
-	}
+	if (len)
+		memcpy_fromio(data, pipe->fifo + tail, len);
 
-	if (len != count) {
-		__ioread32_copy(data + len, pipe->fifo,
-				(count - len) / sizeof(u32));
-	}
+	if (len != count)
+		memcpy_fromio(data + len, pipe->fifo, (count - len));
 }
 
 static void glink_smem_rx_advance(struct qcom_glink_pipe *np,
-- 
2.20.1



