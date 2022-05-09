Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB10452022F
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 18:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238981AbiEIQYd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 12:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238951AbiEIQYc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 12:24:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF53A1FCD7
        for <stable@vger.kernel.org>; Mon,  9 May 2022 09:20:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DDEC61326
        for <stable@vger.kernel.org>; Mon,  9 May 2022 16:20:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A0D4C385AE;
        Mon,  9 May 2022 16:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652113236;
        bh=LllHEgeoLTDOhwjbyHwW62k63J60brWNA8omZ65KYPw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NGrLarIgffZmyEkx7ZqPpEltf6OICGEr/amlNnfhr/r+YMlNMwbS01qrxK5zx4p7R
         qPbQwZnmSFsgpmWgf0VN1UvPpadiJmbK1Ai8O3KxuNoZh7wEiOcGQAkZEICLyX2Ycd
         8gsSvSiBBgvbs/xksA5PJiIvs1Nt+J26caz3/lwI=
Date:   Mon, 9 May 2022 18:20:26 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     stable@vger.kernel.org, Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 5.10 1/1] drm/amdgpu: Ensure the AMDGPU file descriptor
 is legitimate
Message-ID: <Ynk/SsWQKh/dmgQ3@kroah.com>
References: <20220412152057.1170235-1-lee.jones@linaro.org>
 <Ylf5zmP88Lw0md47@kroah.com>
 <Ynkp3+eBhhilI8vK@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Ynkp3+eBhhilI8vK@google.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 09, 2022 at 03:49:03PM +0100, Lee Jones wrote:
> On Thu, 14 Apr 2022, Greg KH wrote:
> 
> > On Tue, Apr 12, 2022 at 04:20:57PM +0100, Lee Jones wrote:
> > > [ Upstream commit b40a6ab2cf9213923bf8e821ce7fa7f6a0a26990 ]
> > > 
> > > This is a partial cherry-pick of the above upstream commit.
> > > 
> > > It ensures the file descriptor passed in by userspace is a valid one.
> > > 
> > > Cc: Felix Kuehling <Felix.Kuehling@amd.com>
> > > Cc: Alex Deucher <alexander.deucher@amd.com>
> > > Cc: "Christian König" <christian.koenig@amd.com>
> > > Cc: David Airlie <airlied@linux.ie>
> > > Cc: Daniel Vetter <daniel@ffwll.ch>
> > > Cc: amd-gfx@lists.freedesktop.org
> > > Cc: dri-devel@lists.freedesktop.org
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > ---
> > >  drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c | 10 +++++++---
> > >  1 file changed, 7 insertions(+), 3 deletions(-)
> > 
> > Now queued up, thanks.
> 
> Could you also back-port this into v5.4 please?
> 
> FYI, in the v5.10.y tree, it's now called:
> 
>   f0c31f192f38c drm/amdkfd: Use drm_priv to pass VM from KFD to amdgpu
> 

Now queued up, thanks.

greg k-h
