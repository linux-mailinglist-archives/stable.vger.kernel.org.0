Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB4A260482A
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232070AbiJSNtl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:49:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233645AbiJSNsm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:48:42 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D4B21C8D5D;
        Wed, 19 Oct 2022 06:32:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5BBD6CE20F0;
        Wed, 19 Oct 2022 13:32:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0EA2C433D7;
        Wed, 19 Oct 2022 13:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666186343;
        bh=wgaCgIIQv6GL6KJIOFePc+gBrTKmB+z9ZIHuM3k0ifI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gnOGPipMSWDY3/Gk4UFGA+GUjpCTWJ/wH3w6Nl8iTKLPjDVt3LS5JAi07fYcmKU+f
         DHJto78dkbY66u2AUdGwY7al5P+g+YORjXOArsNAAAXIs5d8qZ7w/HthI7m+kWwNKJ
         Kjlcm4o3YKS3vCvahN3koioZqTeahxHJRo0xECgBHGivwXJXSbjl90EWWqWsGPLWY/
         0sUpGvSml0a6UPyufDNyed9/90YMTsMqSdFGelX1azZJPSTelGFwTfmSpFpt+kpWwL
         QrQ1pJiikXCH9Cw2ma6xqe3jSdZ2sqjz10GyUiiRfZUb3RBwsRB2mjtpoJWfqC7+0w
         9UDB/9rw8trEw==
Date:   Wed, 19 Oct 2022 19:02:19 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Fenghua Yu <fenghua.yu@intel.com>
Cc:     Arjan Van De Ven <arjan.van.de.ven@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        dmaengine@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] dmaengine: idxd: Do not enable user type Work Queue
 without Shared Virtual Addressing
Message-ID: <Y0/8Y0xUuUoi3KvL@matsya>
References: <20221014222541.3912195-1-fenghua.yu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221014222541.3912195-1-fenghua.yu@intel.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 14-10-22, 15:25, Fenghua Yu wrote:
> When the idxd_user_drv driver is bound to a Work Queue (WQ) device
> without IOMMU or with IOMMU Passthrough without Shared Virtual
> Addressing (SVA), the application gains direct access to physical
> memory via the device by programming physical address to a submitted
> descriptor. This allows direct userspace read and write access to
> arbitrary physical memory. This is inconsistent with the security
> goals of a good kernel API.
> 
> Unlike vfio_pci driver, the IDXD char device driver does not provide any
> ways to pin user pages and translate the address from user VA to IOVA or
> PA without IOMMU SVA. Therefore the application has no way to instruct the
> device to perform DMA function. This makes the char device not usable for
> normal application usage.
> 
> Since user type WQ without SVA cannot be used for normal application usage
> and presents the security issue, bind idxd_user_drv driver and enable user
> type WQ only when SVA is enabled (i.e. user PASID is enabled).

Applied, thanks

-- 
~Vinod
