Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD7534BE60E
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346682AbiBUJDg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:03:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347139AbiBUJAx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:00:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF13E275F0;
        Mon, 21 Feb 2022 00:55:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 704A7B80EB5;
        Mon, 21 Feb 2022 08:55:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C906C340F1;
        Mon, 21 Feb 2022 08:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645433724;
        bh=jq0IZZMNLqbynoTr7qWYEP7/cjlKhs6FfrgJYs/FnmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Befte3VuEloqeDmDtlKa8BWLwnTJBCib8Qs7jKMOdYOQT7oxrmr/ynJwfQrmiOJnM
         1f2PezvC+w4FzJx9M0HOvGFW+iUuqEn5XpRrzGehfZnoUpxKeg2R+ebkhQ+BtGLIAQ
         DEJjhTlOYXyY4m5XRAZgcDy/qbElDOIKLF4UFBA8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John David Anglin <dave.anglin@bell.net>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 4.19 05/58] parisc: Fix sglist access in ccio-dma.c
Date:   Mon, 21 Feb 2022 09:48:58 +0100
Message-Id: <20220221084912.062549850@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084911.895146879@linuxfoundation.org>
References: <20220221084911.895146879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
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


