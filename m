Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E10C59F3CE
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 08:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235241AbiHXG4L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 02:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235240AbiHXG4I (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 02:56:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E6285AA1;
        Tue, 23 Aug 2022 23:56:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ABD7FB82371;
        Wed, 24 Aug 2022 06:56:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02A68C433D6;
        Wed, 24 Aug 2022 06:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661324165;
        bh=1jtX6ORxPIkayI4jhfqIZ8SoaBPm8JNXwJB+iwVWy7E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TYMW9PgshZgadVjDrUNF/ugumlll+uux2YBXEIh2cIdnM7+jadZraebMQwHPcJuHK
         Atvjs8bLhf6RQVxZkWuLPLni6KsUwiw5Kd9l5dFgaW0BYcVeYBP68TyIuGE4gGM2uy
         tTnycXxhA9OUlptt4Yr7BH2F4gGNuw/du04aQ100=
Date:   Wed, 24 Aug 2022 08:56:02 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Dongli Zhang <dongli.zhang@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Robin Murphy <robin.murphy@arm.com>,
        Yu Zhao <yuzhao@google.com>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        iommu@lists.linux.dev
Subject: Re: [PATCH 5.19 319/365] swiotlb: panic if nslabs is too small
Message-ID: <YwXLgq94hSd1TTak@kroah.com>
References: <20220823080118.128342613@linuxfoundation.org>
 <20220823080131.532813281@linuxfoundation.org>
 <c49d3b2b-9f5a-4257-9085-f7ac107cff40@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c49d3b2b-9f5a-4257-9085-f7ac107cff40@oracle.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 23, 2022 at 10:25:27AM -0700, Dongli Zhang wrote:
> Adding Robin, Yu and swiotlb list.
> 
> Hi Greg,
> 
> There is an on-going discussion whether to revert this patch, because it breaks
> a corner case in MIPS when many kernel CONFIGs are not enabled (related to PCI
> and device). As a result, MIPS pre-allocates only PAGE_SIZE buffer as swiotlb.
> 
> https://lore.kernel.org/all/20220820012031.1285979-1-yuzhao@google.com/
> 
> However, the core idea of the patch is to panic on purpose if the swiotlb is
> configured with <1MB memory, in order to sync with the remap failure handler in
> swiotlb_init_remap().

Ok, I've dropped it from the 5.19 queue now.  If you want it added to a
future kernel release, just resend it.

thanks,

greg k-h
