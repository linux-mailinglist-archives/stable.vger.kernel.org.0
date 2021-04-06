Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D889355D18
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 22:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347216AbhDFUob (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 16:44:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347193AbhDFUob (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 16:44:31 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96478C06174A
        for <stable@vger.kernel.org>; Tue,  6 Apr 2021 13:44:23 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id u7so3403395plf.18
        for <stable@vger.kernel.org>; Tue, 06 Apr 2021 13:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=qG8YVz2W+v2ZVyYyewM7RpQOeINM3BQCkVYCGOPl7Sk=;
        b=pStLCgS2WzZPN8vWwwK1qMk+tPG+TnMhu+xsrKC0E6MNYHyWAgVMuz7hRi5lT5wzYy
         GxtOWnXyLD5O7HbHTIv7BbCMK2pXXt/wgrW3GV4ubeP7kWO1uXVsLyiXrAp4cwlcRiLG
         ygsEJ6H2ctdSPwMS1Sjq4JpOai2TnEp9ORqaKwKOvj3Ca/8YD+r1e9N3zM56ybfMpfjz
         JgyqqgBOcif01P6EP2DagxNHPZvQd9K5Y7G+XD1gT7SJ4SVwa3Zcb2cJ2E/Ty0A/QV1c
         lMVLpdjmAhdCZUuCkCgwyq71qBiPEQvxO3HtiAIOE3dOqTipoRpUeyY07Xyr0Oy5laSn
         1vcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=qG8YVz2W+v2ZVyYyewM7RpQOeINM3BQCkVYCGOPl7Sk=;
        b=hNOd4Arj2YQPPrmKv0SLXMuxGj7jeTsDVxn70ymELtEzy7h+VGnpvRUzpup6JDm+/x
         +U8fBodqF4z9c1Gbn56CKRK/jTg75LyHxbk3SdVMUaCh8scgYPr3MGX0eiakvfGTTkhO
         cU8OeZYCaiJz2CKaR+e0R5pfl1is8kGuaAiLW0890CaZZFuZndbaYex1whbLUyDBwj6f
         zUM5GRVnF7y/WfdNBswkR8KrPcIuCK+Bk6fCO41QuRGBwk0hFqDln/nsVNSPGRhDfGAE
         J/8RB60UQXiQp895ziAMTEdJipdgTXqHprCPsmeSyD8oxGYeq6jA+S5sIeAT75/i4Kdc
         KzrQ==
X-Gm-Message-State: AOAM531IuW8tIVPx41wRbrGxNDW2ZDI/6MZEjUMp8U4KlFCvcPT6iRtO
        hpSIA/CNa7sN/iHK7Z0HhC+H7bxp8D5UXk/gVx0vXFbJ+DFdn6h4xNuuw3x45t58ggDB8C79OpA
        NVC55nU734bOONq3yYnCS22mX/IKGuFy3Lj7yaagmnq1OCCOM44GZUFl6SlY=
X-Google-Smtp-Source: ABdhPJyL18MF0NjdQTkFrNEcJHpsdvChUJAwGT4jGXzKVuGQV433tESI8a/MYMtxeEfY13F5cu2Zf98PJw==
X-Received: from jxgao-snp.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1373])
 (user=jxgao job=sendgmr) by 2002:a62:800c:0:b029:203:6990:78e2 with SMTP id
 j12-20020a62800c0000b0290203699078e2mr29334086pfd.3.1617741863064; Tue, 06
 Apr 2021 13:44:23 -0700 (PDT)
Date:   Tue,  6 Apr 2021 20:43:25 +0000
In-Reply-To: <20210406204326.1932888-1-jxgao@google.com>
Message-Id: <20210406204326.1932888-7-jxgao@google.com>
Mime-Version: 1.0
References: <20210406204326.1932888-1-jxgao@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH V2 v5.4 6/8] swiotlb: don't modify orig_addr in  swiotlb_tbl_sync_single
From:   Jianxiong Gao <jxgao@google.com>
To:     stable@vger.kernel.org
Cc:     Jianxiong Gao <jxgao@google.com>, Christoph Hellwig <hch@lst.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

'commit 16fc3cef33a0 ("swiotlb: don't modify orig_addr in swiotlb_tbl_sync_single")'

swiotlb_tbl_map_single currently nevers sets a tlb_addr that is not
aligned to the tlb bucket size.  But we're going to add such a case
soon, for which this adjustment would be bogus.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jianxiong Gao <jxgao@google.com>
Tested-by: Jianxiong Gao <jxgao@google.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 kernel/dma/swiotlb.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 46286c0d38e2..388c5e2a684e 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -639,7 +639,6 @@ void swiotlb_tbl_sync_single(struct device *hwdev, phys_addr_t tlb_addr,
 
 	if (orig_addr == INVALID_PHYS_ADDR)
 		return;
-	orig_addr += (unsigned long)tlb_addr & ((1 << IO_TLB_SHIFT) - 1);
 
 	switch (target) {
 	case SYNC_FOR_CPU:
-- 
2.27.0

