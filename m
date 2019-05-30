Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92DAA2F533
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728864AbfE3EpE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:45:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:52788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728746AbfE3DL4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:11:56 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 365D3244F6;
        Thu, 30 May 2019 03:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185916;
        bh=SXHFiI9uoBadf8i39ZALRGAweCgd7bRUCy53s1u3XBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s6mXyDuohO0kNoOMm9HDX9XhFt7VHDE0r0CuDJ6P7nQEtzRLJgZVbNFz42l/Me/Wr
         Ms0KG8DsYmRk4vGeBVc0HuoU2o2Q/7XxkA+qTOpNIPqgdoXeyzhwbFsrnH4EtvuzO/
         G/S5+E0IEGA7qIuEavrRZCxk4RMyGSp5S6fHUit0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 299/405] misc: fastrpc: make sure memory read and writes are visible
Date:   Wed, 29 May 2019 20:04:57 -0700
Message-Id: <20190530030555.959311227@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 415a0729bd1225f0ffbc0ba82888dd65772554f7 ]

dma_alloc_coherent buffers could have writes queued in store buffers so
commit them before sending buffer to DSP using correct dma barriers.
Same with vice-versa.

Fixes: c68cfb718c8f ("misc: fastrpc: Add support for context Invoke method")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/fastrpc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/misc/fastrpc.c b/drivers/misc/fastrpc.c
index 9996c83ba5cb9..a10937652ca73 100644
--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -790,6 +790,9 @@ static int fastrpc_internal_invoke(struct fastrpc_user *fl,  u32 kernel,
 		if (err)
 			goto bail;
 	}
+
+	/* make sure that all CPU memory writes are seen by DSP */
+	dma_wmb();
 	/* Send invoke buffer to remote dsp */
 	err = fastrpc_invoke_send(fl->sctx, ctx, kernel, handle);
 	if (err)
@@ -806,6 +809,8 @@ static int fastrpc_internal_invoke(struct fastrpc_user *fl,  u32 kernel,
 		goto bail;
 
 	if (ctx->nscalars) {
+		/* make sure that all memory writes by DSP are seen by CPU */
+		dma_rmb();
 		/* populate all the output buffers with results */
 		err = fastrpc_put_args(ctx, kernel);
 		if (err)
-- 
2.20.1



