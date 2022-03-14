Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6EB14D83C5
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233278AbiCNMVm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241067AbiCNMR3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:17:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F090E4925E;
        Mon, 14 Mar 2022 05:12:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CD9161387;
        Mon, 14 Mar 2022 12:12:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E291C340F6;
        Mon, 14 Mar 2022 12:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259940;
        bh=VOh4WZWDHbvl0DVM0VCouT/2UyXl+kHCC7NlZIFYlBw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wMQpgGnJWp8345qD7boJaxDiNLiEG+DReKyzRBLp/UHAo28OMBWnieGbliXV1uQwJ
         MzLEPh5ooT6Unos4Ifw1ImloD3J8ew4jvSO2PG6vkUD7mbr+uGWosa5upaHQMNT1a4
         6KgVaM/YiZRLBCR00Dt6LSDRTrvNeEMwZW2sGRtM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 014/121] vduse: Fix returning wrong type in vduse_domain_alloc_iova()
Date:   Mon, 14 Mar 2022 12:53:17 +0100
Message-Id: <20220314112744.524268764@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112744.120491875@linuxfoundation.org>
References: <20220314112744.120491875@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xie Yongji <xieyongji@bytedance.com>

[ Upstream commit b9d102dafec6af1c07b610faf0a6d4e8aee14ae0 ]

This fixes the following smatch warnings:

drivers/vdpa/vdpa_user/iova_domain.c:305 vduse_domain_alloc_iova() warn: should 'iova_pfn << shift' be a 64 bit type?

Fixes: 8c773d53fb7b ("vduse: Implement an MMU-based software IOTLB")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Link: https://lore.kernel.org/r/20220121083940.102-1-xieyongji@bytedance.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/vdpa_user/iova_domain.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vdpa/vdpa_user/iova_domain.c b/drivers/vdpa/vdpa_user/iova_domain.c
index 1daae2608860..0678c2514197 100644
--- a/drivers/vdpa/vdpa_user/iova_domain.c
+++ b/drivers/vdpa/vdpa_user/iova_domain.c
@@ -302,7 +302,7 @@ vduse_domain_alloc_iova(struct iova_domain *iovad,
 		iova_len = roundup_pow_of_two(iova_len);
 	iova_pfn = alloc_iova_fast(iovad, iova_len, limit >> shift, true);
 
-	return iova_pfn << shift;
+	return (dma_addr_t)iova_pfn << shift;
 }
 
 static void vduse_domain_free_iova(struct iova_domain *iovad,
-- 
2.34.1



