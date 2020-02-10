Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8D8157565
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729305AbgBJMkm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:40:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:40998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728177AbgBJMkl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:40:41 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F21A424681;
        Mon, 10 Feb 2020 12:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338441;
        bh=NgxN8rk0oEyiDL59DR9toPD4TH1Hq4BjSOhDPYlVWUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XFFU2n03AK0XvJEz9wYsm1JOe6nF2TDYMti+zkZZiVNR602DD/qxnpx3Y+pIFclqu
         0yE4V0evOvgJahpYpnYVBQhV3vblaos40MwWB9Dwg7xaCniT5tmKHDm1vVTshX4TQr
         PaCIHGj9XpBdfjnw3WXcyfojhpXS1luXt2kRmdto=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.5 178/367] crypto: hisilicon - Fix issue with wrong number of sg elements after dma map
Date:   Mon, 10 Feb 2020 04:31:31 -0800
Message-Id: <20200210122441.223289189@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

commit 8debacd60c69beab80736d4af4feca47c2e2bd9e upstream.

We fill the hardware scatter gather list assuming it will need the same
number of elements at the original scatterlist. If an IOMMU is involved,
then it may well need fewer. The return value of dma_map_sg tells us how
many.

Probably never caused visible problems as the hardware won't get to
the elements that are incorrect before it finds enough space.

Fixes: dfed0098ab91 (crypto: hisilicon - add hardware SGL support)
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/hisilicon/sgl.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/crypto/hisilicon/sgl.c
+++ b/drivers/crypto/hisilicon/sgl.c
@@ -202,18 +202,21 @@ hisi_acc_sg_buf_map_to_hw_sgl(struct dev
 	dma_addr_t curr_sgl_dma = 0;
 	struct acc_hw_sge *curr_hw_sge;
 	struct scatterlist *sg;
-	int i, ret, sg_n;
+	int i, sg_n, sg_n_mapped;
 
 	if (!dev || !sgl || !pool || !hw_sgl_dma)
 		return ERR_PTR(-EINVAL);
 
 	sg_n = sg_nents(sgl);
-	if (sg_n > pool->sge_nr)
+
+	sg_n_mapped = dma_map_sg(dev, sgl, sg_n, DMA_BIDIRECTIONAL);
+	if (!sg_n_mapped)
 		return ERR_PTR(-EINVAL);
 
-	ret = dma_map_sg(dev, sgl, sg_n, DMA_BIDIRECTIONAL);
-	if (!ret)
+	if (sg_n_mapped > pool->sge_nr) {
+		dma_unmap_sg(dev, sgl, sg_n, DMA_BIDIRECTIONAL);
 		return ERR_PTR(-EINVAL);
+	}
 
 	curr_hw_sgl = acc_get_sgl(pool, index, &curr_sgl_dma);
 	if (IS_ERR(curr_hw_sgl)) {
@@ -224,7 +227,7 @@ hisi_acc_sg_buf_map_to_hw_sgl(struct dev
 	curr_hw_sgl->entry_length_in_sgl = cpu_to_le16(pool->sge_nr);
 	curr_hw_sge = curr_hw_sgl->sge_entries;
 
-	for_each_sg(sgl, sg, sg_n, i) {
+	for_each_sg(sgl, sg, sg_n_mapped, i) {
 		sg_map_to_hw_sg(sg, curr_hw_sge);
 		inc_hw_sgl_sge(curr_hw_sgl);
 		curr_hw_sge++;


