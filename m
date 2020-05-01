Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 772101C1327
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728947AbgEAN1f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:27:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:49924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729486AbgEAN1e (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:27:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FE0420757;
        Fri,  1 May 2020 13:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588339652;
        bh=9z4LahtgSkFQavSR0Kpqso99n4FDvhhsFpPIpUuuUlY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GyCimMYF5dGfvlGAUSPvlLmgp6nwHDrDLY/cSK/zXkdMBFjLXv/mjxHBe4qli9Gs5
         Tzov2ZKpggBb3FCYdvjS6aUEV732kbO5fyg2AISnyXYA1CioVElH/kijnWYrLCIb2h
         UV3W4UsvJl2zAK2MLRB17P1e7jEMCM/dAwTBxN4A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Clement Leger <cleger@kalray.eu>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Doug Anderson <dianders@chromium.org>
Subject: [PATCH 4.4 54/70] remoteproc: Fix wrong rvring index computation
Date:   Fri,  1 May 2020 15:21:42 +0200
Message-Id: <20200501131529.831555248@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131513.302599262@linuxfoundation.org>
References: <20200501131513.302599262@linuxfoundation.org>
User-Agent: quilt/0.66
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
@@ -288,7 +288,7 @@ void rproc_free_vring(struct rproc_vring
 {
 	int size = PAGE_ALIGN(vring_size(rvring->len, rvring->align));
 	struct rproc *rproc = rvring->rvdev->rproc;
-	int idx = rvring->rvdev->vring - rvring;
+	int idx = rvring - rvring->rvdev->vring;
 	struct fw_rsc_vdev *rsc;
 
 	dma_free_coherent(rproc->dev.parent, size, rvring->va, rvring->dma);


