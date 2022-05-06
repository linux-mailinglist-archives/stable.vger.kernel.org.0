Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F321451DB24
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 16:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442337AbiEFO4J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 May 2022 10:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442312AbiEFO4I (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 May 2022 10:56:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 139666972C
        for <stable@vger.kernel.org>; Fri,  6 May 2022 07:52:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3A8BB83664
        for <stable@vger.kernel.org>; Fri,  6 May 2022 14:52:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D84FDC385A9;
        Fri,  6 May 2022 14:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651848742;
        bh=Y5OJkmX4Dd/00D5HJSHYgMobdVRsD6CVk0in6an+2a8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iEYiNf43BBANELzqyiAH4BYkPvpvn5Fs8KGb7ijrtAKC6f1OzkQw4x+0C8/EUveMT
         WotHObj+Lxe7y+I+H9rHCJ2ehW4Ezua6hhBfUAd1b60FsLRRl8c5ea3ASYX9fvQ+td
         ahB4qyzB6A42p5VQK2SNh46fY5DsHgFDlfuUVvhE=
Date:   Fri, 6 May 2022 16:52:18 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Kun(llfl)" <llfl@linux.alibaba.com>
Cc:     Jiangbo Wu <jiangbo.wu@intel.com>, Xu Yu <xuyu@linux.alibaba.com>,
        Sanjay Kumar <sanjay.k.kumar@intel.com>,
        stable@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>
Subject: Re: [PATCH 05/19] iommu/vt-d: Global devTLB flush when present
 context entry changed
Message-ID: <YnU2Is7w6u6TZK9V@kroah.com>
References: <20220506120057.77320-1-llfl@linux.alibaba.com>
 <20220506120057.77320-5-llfl@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506120057.77320-5-llfl@linux.alibaba.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 06, 2022 at 08:00:43PM +0800, Kun(llfl) wrote:
> From: Sanjay Kumar <sanjay.k.kumar@intel.com>
> 
> ANBZ: #1105

What is this?

> commit 37764b952e1b39053defc7ebe5dcd8c4e3e78de9 upstream.
> 
> This fixes a bug in context cache clear operation. The code was not
> following the correct invalidation flow. A global device TLB invalidation
> should be added after the IOTLB invalidation. At the same time, it
> uses the domain ID from the context entry. But in scalable mode, the
> domain ID is in PASID table entry, not context entry.
> 
> Fixes: 7373a8cc38197 ("iommu/vt-d: Setup context and enable RID2PASID support")
> Cc: stable@vger.kernel.org # v5.0+

Is this a 5.10 backport for us to pick up?  What about 5.4?

thanks,

greg k-h
