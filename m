Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25B874BDE20
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346301AbiBUI4a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 03:56:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346329AbiBUIzo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 03:55:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9065C1AD9A;
        Mon, 21 Feb 2022 00:53:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D988B61140;
        Mon, 21 Feb 2022 08:53:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD422C340EB;
        Mon, 21 Feb 2022 08:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645433624;
        bh=jq0IZZMNLqbynoTr7qWYEP7/cjlKhs6FfrgJYs/FnmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p8XccNOFHGEhcp8b332PRbhDMT649eBW+Cry7k4STyUks7EftoGd7zy6wnPeooSeL
         t8dw0KQB1vu4FdOkjtOItM8TcpUTM6KWWqddwkbI3FUGjgDTy1zodnMu+FVr+7z9Sy
         ZumISMs1kyM1PV0gaT+MivbUT+QFTBx+zR/mTp2M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John David Anglin <dave.anglin@bell.net>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 4.14 05/45] parisc: Fix sglist access in ccio-dma.c
Date:   Mon, 21 Feb 2022 09:48:56 +0100
Message-Id: <20220221084910.637678831@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084910.454824160@linuxfoundation.org>
References: <20220221084910.454824160@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John David Anglin <dave.anglin@bell.net>

commit d7da660cab47183cded65e11b64497d0f56c6edf upstream.

This patch implements the same bug fix to ccio-dma.c as to sba_iommu.c.
It ensures that only the allocated entries of the sglist are accessed.

Signed-off-by: John David Anglin <dave.anglin@bell.net>
Cc: stable@vger.kernel.org
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/parisc/ccio-dma.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/parisc/ccio-dma.c
+++ b/drivers/parisc/ccio-dma.c
@@ -1010,7 +1010,7 @@ ccio_unmap_sg(struct device *dev, struct
 	ioc->usg_calls++;
 #endif
 
-	while(sg_dma_len(sglist) && nents--) {
+	while (nents && sg_dma_len(sglist)) {
 
 #ifdef CCIO_COLLECT_STATS
 		ioc->usg_pages += sg_dma_len(sglist) >> PAGE_SHIFT;
@@ -1018,6 +1018,7 @@ ccio_unmap_sg(struct device *dev, struct
 		ccio_unmap_page(dev, sg_dma_address(sglist),
 				  sg_dma_len(sglist), direction, 0);
 		++sglist;
+		nents--;
 	}
 
 	DBG_RUN_SG("%s() DONE (nents %d)\n", __func__, nents);


