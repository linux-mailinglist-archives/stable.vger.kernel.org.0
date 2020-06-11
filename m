Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F22CD1F6655
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 13:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbgFKLNH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 07:13:07 -0400
Received: from foss.arm.com ([217.140.110.172]:50692 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726817AbgFKLNG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jun 2020 07:13:06 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EBE7C31B;
        Thu, 11 Jun 2020 04:13:05 -0700 (PDT)
Received: from [192.168.1.84] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AC1933F66F;
        Thu, 11 Jun 2020 04:13:04 -0700 (PDT)
Subject: Re: [linux-stable-rc:linux-5.4.y 2150/5369]
 drivers/gpu/drm/panfrost/panfrost_job.c:279:31: warning: variable 'bo' set
 but not used
To:     kbuild test robot <lkp@intel.com>,
        Boris Brezillon <bbrezillon@kernel.org>
Cc:     kbuild-all@lists.01.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh@kernel.org>, stable@vger.kernel.org
References: <202005281519.WXxHWhBJ%lkp@intel.com>
From:   Steven Price <steven.price@arm.com>
Message-ID: <e9750a6f-742e-e148-e1d6-0f4d405f06c9@arm.com>
Date:   Thu, 11 Jun 2020 12:13:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <202005281519.WXxHWhBJ%lkp@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 28/05/2020 08:17, kbuild test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> head:   e0d81ce760044efd3f26004aa32821c34968512a
> commit: 3e041c27b9909704a54bc673f9110391e740f583 [2150/5369] drm/panfrost: Add the panfrost_gem_mapping concept
> config: sparc-allyesconfig (attached as .config)
> compiler: sparc64-linux-gcc (GCC) 9.3.0
> reproduce (this is a W=1 build):
>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          git checkout 3e041c27b9909704a54bc673f9110391e740f583
>          # save the attached .config to linux build tree
>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=sparc
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kbuild test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>, old ones prefixed by <<):
> 
> drivers/gpu/drm/panfrost/panfrost_job.c: In function 'panfrost_job_cleanup':
>>> drivers/gpu/drm/panfrost/panfrost_job.c:279:31: warning: variable 'bo' set but not used [-Wunused-but-set-variable]
> 279 |   struct panfrost_gem_object *bo;
> |                               ^~

FYI: This was fixed upstream in fe154a242233 ("drm/panfrost: Remove set 
but not used variable 'bo'")

Steve

> vim +/bo +279 drivers/gpu/drm/panfrost/panfrost_job.c
> 
>     252	
>     253	static void panfrost_job_cleanup(struct kref *ref)
>     254	{
>     255		struct panfrost_job *job = container_of(ref, struct panfrost_job,
>     256							refcount);
>     257		unsigned int i;
>     258	
>     259		if (job->in_fences) {
>     260			for (i = 0; i < job->in_fence_count; i++)
>     261				dma_fence_put(job->in_fences[i]);
>     262			kvfree(job->in_fences);
>     263		}
>     264		if (job->implicit_fences) {
>     265			for (i = 0; i < job->bo_count; i++)
>     266				dma_fence_put(job->implicit_fences[i]);
>     267			kvfree(job->implicit_fences);
>     268		}
>     269		dma_fence_put(job->done_fence);
>     270		dma_fence_put(job->render_done_fence);
>     271	
>     272		if (job->mappings) {
>     273			for (i = 0; i < job->bo_count; i++)
>     274				panfrost_gem_mapping_put(job->mappings[i]);
>     275			kvfree(job->mappings);
>     276		}
>     277	
>     278		if (job->bos) {
>   > 279			struct panfrost_gem_object *bo;
>     280	
>     281			for (i = 0; i < job->bo_count; i++) {
>     282				bo = to_panfrost_bo(job->bos[i]);
>     283				drm_gem_object_put_unlocked(job->bos[i]);
>     284			}
>     285	
>     286			kvfree(job->bos);
>     287		}
>     288	
>     289		kfree(job);
>     290	}
>     291	
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
> 

