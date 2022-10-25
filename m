Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03F9860CECD
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 16:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232719AbiJYOVJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 10:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232968AbiJYOVH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 10:21:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD486746A;
        Tue, 25 Oct 2022 07:21:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4155AB81D14;
        Tue, 25 Oct 2022 14:21:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF32C433C1;
        Tue, 25 Oct 2022 14:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666707660;
        bh=npqwxasURQRjt6ABDS11DHTpEYlQm3/w7oHiAuuaNNQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zqyiqDiIFYYZ5JichYUevRVtzSCBeTiGoqVbpYFwVp8SpXUMu99ghXGdK4GO1AlJa
         zmv71rQfOke0AtlwfLOa54yMMdbLsfgsBfy88vrTBwkuuMsDuKKHdoqBpT1DJirl1P
         MrqkNvVWfWHhtgdI+IhMrzl6owd8GeD/QBGsMj3k=
Date:   Tue, 25 Oct 2022 16:20:57 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>
Subject: Re: [PATCH 5.10 384/390] Revert "drm/amdgpu: move nbio
 sdma_doorbell_range() into sdma code for vega"
Message-ID: <Y1fwyYcHsMPhUE2o@kroah.com>
References: <20221024113022.510008560@linuxfoundation.org>
 <20221024113039.334437223@linuxfoundation.org>
 <Y1emKRzhii9qK+cN@eldamar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1emKRzhii9qK+cN@eldamar.lan>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 25, 2022 at 11:02:33AM +0200, Salvatore Bonaccorso wrote:
> Hi Greg,
> 
> On Mon, Oct 24, 2022 at 01:33:01PM +0200, Greg Kroah-Hartman wrote:
> > From: Shuah Khan <skhan@linuxfoundation.org>
> > 
> > This reverts commit 9f55f36f749a7608eeef57d7d72991a9bd557341 which is
> > commit e3163bc8ffdfdb405e10530b140135b2ee487f89 upstream.
> > 
> > This commit causes repeated WARN_ONs from
> > 
> > drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amd
> > gpu_dm.c:7391 amdgpu_dm_atomic_commit_tail+0x23b9/0x2430 [amdgpu]
> > 
> > dmesg fills up with the following messages and drm initialization takes
> > a very long time.
> > 
> > Cc: <stable@vger.kernel.org>    # 5.10
> > Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c |    5 -----
> >  drivers/gpu/drm/amd/amdgpu/soc15.c     |   25 +++++++++++++++++++++++++
> >  2 files changed, 25 insertions(+), 5 deletions(-)
> > 
> > --- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
> > +++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
> > @@ -1475,11 +1475,6 @@ static int sdma_v4_0_start(struct amdgpu
> >  		WREG32_SDMA(i, mmSDMA0_CNTL, temp);
> >  
> >  		if (!amdgpu_sriov_vf(adev)) {
> > -			ring = &adev->sdma.instance[i].ring;
> > -			adev->nbio.funcs->sdma_doorbell_range(adev, i,
> > -				ring->use_doorbell, ring->doorbell_index,
> > -				adev->doorbell_index.sdma_doorbell_range);
> > -
> >  			/* unhalt engine */
> >  			temp = RREG32_SDMA(i, mmSDMA0_F32_CNTL);
> >  			temp = REG_SET_FIELD(temp, SDMA0_F32_CNTL, HALT, 0);
> > --- a/drivers/gpu/drm/amd/amdgpu/soc15.c
> > +++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
> > @@ -1332,6 +1332,25 @@ static int soc15_common_sw_fini(void *ha
> >  	return 0;
> >  }
> >  
> > +static void soc15_doorbell_range_init(struct amdgpu_device *adev)
> > +{
> > +	int i;
> > +	struct amdgpu_ring *ring;
> > +
> > +	/* sdma/ih doorbell range are programed by hypervisor */
> > +	if (!amdgpu_sriov_vf(adev)) {
> > +		for (i = 0; i < adev->sdma.num_instances; i++) {
> > +			ring = &adev->sdma.instance[i].ring;
> > +			adev->nbio.funcs->sdma_doorbell_range(adev, i,
> > +				ring->use_doorbell, ring->doorbell_index,
> > +				adev->doorbell_index.sdma_doorbell_range);
> > +		}
> > +
> > +		adev->nbio.funcs->ih_doorbell_range(adev, adev->irq.ih.use_doorbell,
> > +						adev->irq.ih.doorbell_index);
> > +	}
> > +}
> > +
> >  static int soc15_common_hw_init(void *handle)
> >  {
> >  	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
> > @@ -1351,6 +1370,12 @@ static int soc15_common_hw_init(void *ha
> >  
> >  	/* enable the doorbell aperture */
> >  	soc15_enable_doorbell_aperture(adev, true);
> > +	/* HW doorbell routing policy: doorbell writing not
> > +	 * in SDMA/IH/MM/ACV range will be routed to CP. So
> > +	 * we need to init SDMA/IH/MM/ACV doorbell range prior
> > +	 * to CP ip block init and ring test.
> > +	 */
> > +	soc15_doorbell_range_init(adev);
> >  
> >  	return 0;
> >  }
> 
> Can you please as well revert 7b0db849ea030a70b8fb9c9afec67c81f955482e
> on top?
> 
> See https://lore.kernel.org/stable/BL1PR12MB5144F3CC640A18DF0C36E414F72E9@BL1PR12MB5144.namprd12.prod.outlook.com/
> 
> Both of these reverts need to be applied to fix regressions which were
> reported in https://gitlab.freedesktop.org/drm/amd/-/issues/2216 and
> downstream in Debian (https://bugs.debian.org/1022025).
> 
> If it is now not anymore possible for 5.10.150 can you pick the revert
> for 5.10.151?

Now queued up.

greg k-h
