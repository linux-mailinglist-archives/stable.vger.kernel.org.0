Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 695605FFFA9
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 15:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbiJPNa1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 09:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiJPNaZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 09:30:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F4C231DE9;
        Sun, 16 Oct 2022 06:30:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4209360B76;
        Sun, 16 Oct 2022 13:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 713DBC433D6;
        Sun, 16 Oct 2022 13:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665927016;
        bh=KTzBJ41O2/NP1Xvp37TwTR0e2oXjg8Mhj0R85XRcxf0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LxvXkWcim8owV9e8FtwxLjBqyryolV2zepprknggKvzuqEciYeCJy4uUXR5iTRSw5
         bNE7B4zUurstMJ/44/zHnCmI+PvBSTlmd4+JHC6smhcHJ4pIDlCfcd6qW+CNBqTkkZ
         tHcvmUJjm/4E4XI/xe71CJyVO9Sj0mQms+vLpoKefTVZJA77WIi19GU/LTYYZlyQe0
         Y/B6BMMn5hU3J1KCf/ugC3LGLpb85sR+gwBqZ8FkxztyL+doy7W7dLhYe++tPuzvjf
         3RBcE8AKBNVD/mjglesBSb/y63NDq0+R7dhKDtFobir/yg8vKdzYjPvBQpCmoAppCR
         xgRNdHfeD+waw==
Date:   Sun, 16 Oct 2022 09:30:15 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     John Garry <john.garry@huawei.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Yicong Yang <yangyicong@hisilicon.com>,
        Will Deacon <will@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>, joro@8bytes.org,
        robin.murphy@arm.com, baolu.lu@linux.intel.com, jgg@ziepe.ca,
        tglx@linutronix.de, shameerali.kolothum.thodi@huawei.com,
        christophe.jaillet@wanadoo.fr,
        linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev
Subject: Re: [PATCH AUTOSEL 5.15 10/47] iommu/arm-smmu-v3: Make default
 domain type of HiSilicon PTT device to identity
Message-ID: <Y0wHZxMV2pRVjvyN@sashalap>
References: <20221013002124.1894077-1-sashal@kernel.org>
 <20221013002124.1894077-10-sashal@kernel.org>
 <4ffc662d-5c73-5047-81d5-ad78ca3a7d7e@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <4ffc662d-5c73-5047-81d5-ad78ca3a7d7e@huawei.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 13, 2022 at 08:07:46AM +0100, John Garry wrote:
>On 13/10/2022 01:20, Sasha Levin wrote:
>>From: Yicong Yang<yangyicong@hisilicon.com>
>>
>>[ Upstream commit 24b6c7798a0122012ca848ea0d25e973334266b0 ]
>>
>>The DMA operations of HiSilicon PTT device can only work properly with
>>identical mappings. So add a quirk for the device to force the domain
>>as passthrough.
>>
>>Acked-by: Will Deacon<will@kernel.org>
>>Signed-off-by: Yicong Yang<yangyicong@hisilicon.com>
>>Reviewed-by: John Garry<john.garry@huawei.com>
>>Link:https://lore.kernel.org/r/20220816114414.4092-2-yangyicong@huawei.com
>>Signed-off-by: Mathieu Poirier<mathieu.poirier@linaro.org>
>>Signed-off-by: Sasha Levin<sashal@kernel.org>
>>---
>>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 21 +++++++++++++++++++++
>>  1 file changed, 21 insertions(+)
>
>I don't think that this commit should be backported to any stable 
>tree. It's only required for a new driver.

I'll drop it, thanks!
-- 
Thanks,
Sasha
