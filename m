Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42A254C7C14
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 22:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbiB1Vdu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 16:33:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbiB1Vdu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 16:33:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C03F34D9D9;
        Mon, 28 Feb 2022 13:33:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D017B8123F;
        Mon, 28 Feb 2022 21:33:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28829C340F1;
        Mon, 28 Feb 2022 21:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646083988;
        bh=jTglwX0Y1klyRtQh80VCQNNTZid9lUYfXtgdkgv+LUY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Oy9dc7j3It/sFHWlQpGAIbf8fLmvavreGmNTqbD379LhklDMy5PsTAVBn3JrTGakO
         8+CDnpCO3llwz9Rfe56qdl/kN0/Gqm3ZHrFQMSFYJd0pJnO85H1dmS/przxyWZwY8K
         nH/AQx94B6eR1FpnQ778/SioiqFSloGusfDNZa2w=
Date:   Mon, 28 Feb 2022 22:33:04 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        "Koenig, Christian" <Christian.Koenig@amd.com>,
        "Yu, Qiang" <Qiang.Yu@amd.com>
Subject: Re: [PATCH 5.16 022/164] drm/amdgpu: check vm ready by
 amdgpu_vm->evicting flag
Message-ID: <Yh0/kHWw1fMhR83L@kroah.com>
References: <20220228172359.567256961@linuxfoundation.org>
 <20220228172402.072667800@linuxfoundation.org>
 <BN9PR12MB5146C35D7EE1B6AD23E2503BF7019@BN9PR12MB5146.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BN9PR12MB5146C35D7EE1B6AD23E2503BF7019@BN9PR12MB5146.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 28, 2022 at 06:24:53PM +0000, Deucher, Alexander wrote:
> [Public]
> 
> > -----Original Message-----
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Sent: Monday, February 28, 2022 12:23 PM
> > To: linux-kernel@vger.kernel.org
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>;
> > stable@vger.kernel.org; Paul Menzel <pmenzel@molgen.mpg.de>; Koenig,
> > Christian <Christian.Koenig@amd.com>; Yu, Qiang <Qiang.Yu@amd.com>;
> > Deucher, Alexander <Alexander.Deucher@amd.com>
> > Subject: [PATCH 5.16 022/164] drm/amdgpu: check vm ready by
> > amdgpu_vm->evicting flag
> > 
> > From: Qiang Yu <qiang.yu@amd.com>
> > 
> > commit c1a66c3bc425ff93774fb2f6eefa67b83170dd7e upstream.
> > 
> > Workstation application ANSA/META v21.1.4 get this error dmesg when
> > running CI test suite provided by ANSA/META:
> > [drm:amdgpu_gem_va_ioctl [amdgpu]] *ERROR* Couldn't update BO_VA (-
> > 16)
> > 
> > This is caused by:
> > 1. create a 256MB buffer in invisible VRAM 2. CPU map the buffer and access
> > it causes vm_fault and try to move
> >    it to visible VRAM
> > 3. force visible VRAM space and traverse all VRAM bos to check if
> >    evicting this bo is valuable
> > 4. when checking a VM bo (in invisible VRAM), amdgpu_vm_evictable()
> >    will set amdgpu_vm->evicting, but latter due to not in visible
> >    VRAM, won't really evict it so not add it to amdgpu_vm->evicted 5. before
> > next CS to clear the amdgpu_vm->evicting, user VM ops
> >    ioctl will pass amdgpu_vm_ready() (check amdgpu_vm->evicted)
> >    but fail in amdgpu_vm_bo_update_mapping() (check
> >    amdgpu_vm->evicting) and get this error log
> > 
> > This error won't affect functionality as next CS will finish the waiting VM ops.
> > But we'd better clear the error log by checking the amdgpu_vm->evicting flag
> > in amdgpu_vm_ready() to stop calling
> > amdgpu_vm_bo_update_mapping() later.
> > 
> > Another reason is amdgpu_vm->evicted list holds all BOs (both user buffer
> > and page table), but only page table BOs' eviction prevent VM ops.
> > amdgpu_vm->evicting flag is set only for page table BOs, so we should use
> > evicting flag instead of evicted list in amdgpu_vm_ready().
> > 
> > The side effect of this change is: previously blocked VM op (user buffer in
> > "evicted" list but no page table in it) gets done immediately.
> > 
> > v2: update commit comments.
> > 
> > Acked-by: Paul Menzel <pmenzel@molgen.mpg.de>
> > Reviewed-by: Christian König <christian.koenig@amd.com>
> > Signed-off-by: Qiang Yu <qiang.yu@amd.com>
> > Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> A regression was reported against this patch in 5.17.  Please drop for now.

Dropped from 5.10.y, 5.15.y, and 5.16.y.  Please feel free to send it to
stable@vger.kernel.org when it is now working correctly.

thanks,

greg k-h
