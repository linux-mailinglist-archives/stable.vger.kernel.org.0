Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B78041787D
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 18:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245078AbhIXQ3V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 12:29:21 -0400
Received: from mga18.intel.com ([134.134.136.126]:50903 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244892AbhIXQ3V (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 12:29:21 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10116"; a="211186172"
X-IronPort-AV: E=Sophos;i="5.85,320,1624345200"; 
   d="scan'208";a="211186172"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2021 09:27:48 -0700
X-IronPort-AV: E=Sophos;i="5.85,320,1624345200"; 
   d="scan'208";a="519387659"
Received: from wchriste-mobl1.amr.corp.intel.com ([10.251.2.203])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2021 09:27:48 -0700
Message-ID: <46d6d30201e11422f57bd79691133dc0491bd4c5.camel@linux.intel.com>
Subject: Re: [PATCH v2 1/2] thermal: int340x: do not set a wrong tcc offset
 on resume
From:   Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
To:     Antoine Tenart <atenart@kernel.org>, rui.zhang@intel.com,
        daniel.lezcano@linaro.org, amitk@kernel.org
Cc:     linux-pm@vger.kernel.org, stable@vger.kernel.org
Date:   Fri, 24 Sep 2021 09:27:47 -0700
In-Reply-To: <20210909085613.5577-2-atenart@kernel.org>
References: <20210909085613.5577-1-atenart@kernel.org>
         <20210909085613.5577-2-atenart@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Daniel,

This patch is important. Can we send for 5.15 rc release?

I see the previous version of this patch is applied to linux-next.
But this series is better as it splits into two patches. The first one
can be easily backported and will fix the problem. The second one is an
improvement.

Thanks,
Srinivas

On Thu, 2021-09-09 at 10:56 +0200, Antoine Tenart wrote:
> After upgrading to Linux 5.13.3 I noticed my laptop would shutdown
> due
> to overheat (when it should not). It turned out this was due to
> commit
> fe6a6de6692e ("thermal/drivers/int340x/processor_thermal: Fix tcc
> setting").
> 
> What happens is this drivers uses a global variable to keep track of
> the
> tcc offset (tcc_offset_save) and uses it on resume. The issue is this
> variable is initialized to 0, but is only set in
> tcc_offset_degree_celsius_store, i.e. when the tcc offset is
> explicitly
> set by userspace. If that does not happen, the resume path will set
> the
> offset to 0 (in my case the h/w default being 3, the offset would
> become
> too low after a suspend/resume cycle).
> 
> The issue did not arise before commit fe6a6de6692e, as the function
> setting the offset would return if the offset was 0. This is no
> longer
> the case (rightfully).
> 
> Fix this by not applying the offset if it wasn't saved before,
> reverting
> back to the old logic. A better approach will come later, but this
> will
> be easier to apply to stable kernels.
> 
> The logic to restore the offset after a resume was there long before
> commit fe6a6de6692e, but as a value of 0 was considered invalid I'm
> referencing the commit that made the issue possible in the Fixes tag
> instead.
> 
> Fixes: fe6a6de6692e ("thermal/drivers/int340x/processor_thermal: Fix
> tcc setting")
> Cc: stable@vger.kernel.org
> Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
> Signed-off-by: Antoine Tenart <atenart@kernel.org>
> ---
>  .../thermal/intel/int340x_thermal/processor_thermal_device.c | 5
> +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git
> a/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
> b/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
> index 0f0038af2ad4..fb64acfd5e07 100644
> ---
> a/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
> +++
> b/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
> @@ -107,7 +107,7 @@ static int tcc_offset_update(unsigned int tcc)
>         return 0;
>  }
>  
> -static unsigned int tcc_offset_save;
> +static int tcc_offset_save = -1;
>  
>  static ssize_t tcc_offset_degree_celsius_store(struct device *dev,
>                                 struct device_attribute *attr, const
> char *buf,
> @@ -352,7 +352,8 @@ int proc_thermal_resume(struct device *dev)
>         proc_dev = dev_get_drvdata(dev);
>         proc_thermal_read_ppcc(proc_dev);
>  
> -       tcc_offset_update(tcc_offset_save);
> +       if (tcc_offset_save >= 0)
> +               tcc_offset_update(tcc_offset_save);
>  
>         return 0;
>  }


