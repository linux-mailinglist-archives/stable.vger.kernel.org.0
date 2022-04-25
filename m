Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC7E750D665
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 02:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238517AbiDYAxB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Apr 2022 20:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237688AbiDYAxB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Apr 2022 20:53:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93BE16595;
        Sun, 24 Apr 2022 17:49:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF073B8108E;
        Mon, 25 Apr 2022 00:49:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3504CC385A7;
        Mon, 25 Apr 2022 00:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650847795;
        bh=F1o86+c3i27P7lXaQREiQ3xGCoQJ5F/6dbeDXC2Hv+8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NNNl2oY39OmGQht4oPedgUc5AAbsNs5dCdeNish0v9zUwAm4Y9lbMjwf8EcfuAWup
         qcFw9YUWOwk6wbfJWvEo9T8S3AARfyUw0ONzssRewEuitHeBNB4tqp7lBcOoq+mcdW
         2A+BIncUk9HPmEyRctmQmw/afV/4FDqj47jTsuc3RmbpmHBbP+VpeTsaBV0zrMYXGa
         WRswl1PJY/bA5HC1DFZa+pnRsYqCp1NuSgeh0IHN0BGhXN7dhxCHwQMR24HPCckAmS
         i5f8Cjb/uHMB2kdNPcB/mQAUYAK8tadxIH//xkb5mqksoYP2avFOrAHMUfAuN/hCsF
         oKXRoocw/A6gQ==
Date:   Sun, 24 Apr 2022 20:49:53 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Klaus Jensen <its@irrelevant.dk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>, axboe@fb.com,
        linux-nvme@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 5.10 18/18] nvme-pci: disable namespace
 identifiers for Qemu controllers
Message-ID: <YmXwMUdka3m01hUV@sashalap>
References: <20220419181353.485719-1-sashal@kernel.org>
 <20220419181353.485719-18-sashal@kernel.org>
 <YmBWdMfQ/WIACcTg@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YmBWdMfQ/WIACcTg@bombadil.infradead.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 20, 2022 at 11:52:36AM -0700, Luis Chamberlain wrote:
>On Tue, Apr 19, 2022 at 02:13:52PM -0400, Sasha Levin wrote:
>> From: Christoph Hellwig <hch@lst.de>
>>
>> [ Upstream commit 66dd346b84d79fde20832ed691a54f4881eac20d ]
>>
>> Qemu unconditionally reports a UUID, which depending on the qemu version
>> is either all-null (which is incorrect but harmless) or contains a single
>> bit set for all controllers.  In addition it can also optionally report
>> a eui64 which needs to be manually set.  Disable namespace identifiers
>> for Qemu controlles entirely even if in some cases they could be set
>> correctly through manual intervention.
>>
>> Reported-by: Luis Chamberlain <mcgrof@kernel.org>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>> Reviewed-by: Keith Busch <kbusch@kernel.org>
>> Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>Huh? The NVME_QUIRK_BOGUS_NID is a new define and the code which uses
>this quirk is also new, and so I'm curious *how and why* the auto-sel
>stuff for stable can decide to merge this and this should not even
>compile? I see this was backported to v5.15  and v5.17 as well.

Because we take quirks for -stable?

It does compile apparently... At least with the configs we test.

>I didn't get Cc'd on perhaps some other patches, but this immediately
>caught my attention as not applicable, unless of course the patch
>"nvme: add a quirk to disable namespace identifiers" was also sent
>as part of this series to stable kernels. And if that was done, well
>holy crap, really?

Yes, it was.

I'm not sure why we shouldn't be picking it up?

-- 
Thanks,
Sasha
