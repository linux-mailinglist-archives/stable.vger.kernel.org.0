Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7A991C16D9
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731279AbgEANxv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:53:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:34206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730791AbgEANfv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:35:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B84FD24954;
        Fri,  1 May 2020 13:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340151;
        bh=Mcz1s08FCgfrrpakRyvfiHZc58gglHOpp4TXO1Or6+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=trNTNP0xxTIToT/czb4S9mSm5MaS0zRABdxl26TV262Mh1tcHPmq3bgVAD8q0n9Dw
         AkFaCEaPC0zVUVUolLa42h+HAa++Cs1PRwKbifOVikoRfIcg6UJiwtOdd1Tq3JUsLn
         Pe3lgg6Lc8thlSuZ5zT9/Gbw/9xYKSe6tTwR1LLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Clement Leger <cleger@kalray.eu>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Doug Anderson <dianders@chromium.org>
Subject: [PATCH 4.19 01/46] remoteproc: Fix wrong rvring index computation
Date:   Fri,  1 May 2020 15:22:26 +0200
Message-Id: <20200501131459.150148012@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131457.023036302@linuxfoundation.org>
References: <20200501131457.023036302@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Clement Leger <cleger@kalray.eu>

commit 00a0eec59ddbb1ce966b19097d8a8d2f777e726a upstream.

Index of rvring is computed using pointer arithmetic. However, since
rvring->rvdev->vring is the base of the vring array, computation
of rvring idx should be reversed. It previously lead to writing at negative
indices in the resource table.

Signed-off-by: Clement Leger <cleger@kalray.eu>
Link: https://lore.kernel.org/r/20191004073736.8327-1-cleger@kalray.eu
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Doug Anderson <dianders@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/remoteproc/remoteproc_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -289,7 +289,7 @@ void rproc_free_vring(struct rproc_vring
 {
 	int size = PAGE_ALIGN(vring_size(rvring->len, rvring->align));
 	struct rproc *rproc = rvring->rvdev->rproc;
-	int idx = rvring->rvdev->vring - rvring;
+	int idx = rvring - rvring->rvdev->vring;
 	struct fw_rsc_vdev *rsc;
 
 	dma_free_coherent(rproc->dev.parent, size, rvring->va, rvring->dma);


