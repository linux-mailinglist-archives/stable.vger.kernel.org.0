Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87EC953CE3B
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244418AbiFCRkQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344641AbiFCRkO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:40:14 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 394D152E73;
        Fri,  3 Jun 2022 10:40:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8E572CE247C;
        Fri,  3 Jun 2022 17:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75348C385A9;
        Fri,  3 Jun 2022 17:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278008;
        bh=komNFgnS0FqLDSYmW+a2ifBD02kTTJqYIBqeGiPTkEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w07WZQ3HHKLuSE9CBwcHzujbBeIHirwic+tJjie1Yn4QjYAMKq+XLL91GQVv3bwJB
         x9PC1Pc3hEHeJWLC6078OM53pBVE0gLTjSdLqQaC8YuufrceDXsLCgJwkQOf8HF/Qk
         EVm1uiuKQ+mxbsj9NBxFL86+O99OMdgq/0Y0LKEM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haimin Zhang <tcs.kernel@gmail.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Dragos-Marian Panait <dragos.panait@windriver.com>
Subject: [PATCH 4.9 05/12] block-map: add __GFP_ZERO flag for alloc_page in function bio_copy_kern
Date:   Fri,  3 Jun 2022 19:39:31 +0200
Message-Id: <20220603173812.684682590@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173812.524184588@linuxfoundation.org>
References: <20220603173812.524184588@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haimin Zhang <tcs.kernel@gmail.com>

commit cc8f7fe1f5eab010191aa4570f27641876fa1267 upstream.

Add __GFP_ZERO flag for alloc_page in function bio_copy_kern to initialize
the buffer of a bio.

Signed-off-by: Haimin Zhang <tcs.kernel@gmail.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20220216084038.15635-1-tcs.kernel@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[DP: Backported to 4.19: Manually added __GFP_ZERO flag]
Signed-off-by: Dragos-Marian Panait <dragos.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/bio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/block/bio.c
+++ b/block/bio.c
@@ -1538,7 +1538,7 @@ struct bio *bio_copy_kern(struct request
 		if (bytes > len)
 			bytes = len;
 
-		page = alloc_page(q->bounce_gfp | gfp_mask);
+		page = alloc_page(q->bounce_gfp | __GFP_ZERO | gfp_mask);
 		if (!page)
 			goto cleanup;
 


