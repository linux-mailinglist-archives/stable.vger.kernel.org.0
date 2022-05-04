Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F003519AD9
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 10:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243156AbiEDI4M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 04:56:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346896AbiEDIxx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 04:53:53 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD17025EBB;
        Wed,  4 May 2022 01:49:38 -0700 (PDT)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 5A61167B; Wed,  4 May 2022 10:49:37 +0200 (CEST)
Date:   Wed, 4 May 2022 10:49:36 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>
Cc:     agross@kernel.org, bjorn.andersson@linaro.org, will@kernel.org,
        sricharan@codeaurora.org, linux-arm-msm@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] iommu: fix an incorrect NULL check on list iterator
Message-ID: <YnI+IPP0VIftWwPA@8bytes.org>
References: <20220501132823.12714-1-xiam0nd.tong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220501132823.12714-1-xiam0nd.tong@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 01, 2022 at 09:28:23PM +0800, Xiaomeng Tong wrote:
> The bug is here:
> 	if (!iommu || iommu->dev->of_node != spec->np) {
> 
> The list iterator value 'iommu' will *always* be set and non-NULL by
> list_for_each_entry(), so it is incorrect to assume that the iterator
> value will be NULL if the list is empty or no element is found (in fact,
> it will point to a invalid structure object containing HEAD).
> 
> To fix the bug, use a new value 'iter' as the list iterator, while use
> the old value 'iommu' as a dedicated variable to point to the found one,
> and remove the unneeded check for 'iommu->dev->of_node != spec->np'
> outside the loop.
> 
> Cc: stable@vger.kernel.org
> Fixes: f78ebca8ff3d6 ("iommu/msm: Add support for generic master bindings")
> Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
> ---
> changes since v1:
>  - add a new iter variable (suggested by Joerg Roedel)

This is now applied. I had to manually apply it because the patch was
malformed at line 36 and git-am complained.

Regards,

	Joerg
