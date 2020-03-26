Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0AE194566
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 18:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbgCZRZo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 13:25:44 -0400
Received: from mail-qv1-f66.google.com ([209.85.219.66]:45196 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbgCZRZo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Mar 2020 13:25:44 -0400
Received: by mail-qv1-f66.google.com with SMTP id g4so3411435qvo.12
        for <stable@vger.kernel.org>; Thu, 26 Mar 2020 10:25:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=r1jUyMkQJrDu5V/f8nEvdhsmZBYjYcPFwpTXfYffy00=;
        b=jFxOw/leIb9Hr5GcHroTulCd9u3sNDwplxRa9Su4n+tX+gSVT+rJkU7PZ/WCFtCv1W
         L4BikAnrLMx3eVZRu2hvy6o5Gi3OQ6si/+pa7ti91Lf6aEA+DiVkaZyffWMq/U2odfUA
         /SgWhpUgcR5NTGmv/WdSqYnVnCmMAxdAqI2+iAeXc3roSrLiqPAjOxdE9XriqSUmJJQD
         UrUpAiTyVDqyF0iNyPqFJ7stHa3eTZu2naO8foWhL686rmdnRy6dV9GHqWLs6gkH6dfp
         J+DHyHQjdWuyUg6ERFX2G49NDqJVtC9E20wXTfMyr3+FTVwLNPMmbUyUffrlLjPlGW1m
         d79g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=r1jUyMkQJrDu5V/f8nEvdhsmZBYjYcPFwpTXfYffy00=;
        b=YCIO06Zu7UpQCtVl0fy9XSgkVHzAUvADpCB5JqLHSwTteGKcHtGkqHtjM06MUjwhz3
         RkfhXbTw1t4yc4/CaAhzhi5b3OEQj6ejixdpsal4Dsea4sJ51dEqewhwjrU5PkqDCmd7
         xqTd1qFuPv9VHDEY3LP+x29iCk6qELW8sXULrVrecpyxvzy/gYfcGQXzQagPrwO0I5kp
         SLUsbmesrHaZGlWp6tYhoqjZfx8Vwt8s9Ph81HVckiLcEaUzPaXlAJyWSA/0OPgmILBz
         W4iS5su4R/XJJ94gNdoxRildaa9N7i3tZx6vbCB2clroBNIN7YjGbFVh0y9eEVHnKzdh
         rcFA==
X-Gm-Message-State: ANhLgQ3CWlcmIjIL2oeTHM38z1ut3qCJ1x5S7wjVnOc/UE8U9fIeO/dO
        IyWb2A+FPQ3R6LN3lZvi9k6kBw==
X-Google-Smtp-Source: ADFU+vvujrhVchWtlZ8ZC/TiAmNO/A57lif5w48e0hthqfmrBJr/Kyc3EQFCjp6O6gvsol02ELRU8g==
X-Received: by 2002:a05:6214:1e5:: with SMTP id c5mr2663861qvu.233.1585243543241;
        Thu, 26 Mar 2020 10:25:43 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id d2sm1804938qkl.98.2020.03.26.10.25.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 26 Mar 2020 10:25:42 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jHWGD-0005jU-PR; Thu, 26 Mar 2020 14:25:41 -0300
Date:   Thu, 26 Mar 2020 14:25:41 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc:     dledford@redhat.com, linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        stable@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>
Subject: Re: [PATCH for-rc 1/2] IB/hfi1: Fix memory leaks in sysfs
 registration and unregistration
Message-ID: <20200326172541.GM20941@ziepe.ca>
References: <20200326163619.21129.13002.stgit@awfm-01.aw.intel.com>
 <20200326163807.21129.27371.stgit@awfm-01.aw.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326163807.21129.27371.stgit@awfm-01.aw.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 26, 2020 at 12:38:07PM -0400, Dennis Dalessandro wrote:
> From: Kaike Wan <kaike.wan@intel.com>
> 
> When the hfi1 driver is unloaded, kmemleak will report the following
> issue:
> 
> unreferenced object 0xffff8888461a4c08 (size 8):
> comm "kworker/0:0", pid 5, jiffies 4298601264 (age 2047.134s)
> hex dump (first 8 bytes):
> 73 64 6d 61 30 00 ff ff sdma0...
> backtrace:
> [<00000000311a6ef5>] kvasprintf+0x62/0xd0
> [<00000000ade94d9f>] kobject_set_name_vargs+0x1c/0x90
> [<0000000060657dbb>] kobject_init_and_add+0x5d/0xb0
> [<00000000346fe72b>] 0xffffffffa0c5ecba
> [<000000006cfc5819>] 0xffffffffa0c866b9
> [<0000000031c65580>] 0xffffffffa0c38e87
> [<00000000e9739b3f>] local_pci_probe+0x41/0x80
> [<000000006c69911d>] work_for_cpu_fn+0x16/0x20
> [<00000000601267b5>] process_one_work+0x171/0x380
> [<0000000049a0eefa>] worker_thread+0x1d1/0x3f0
> [<00000000909cf2b9>] kthread+0xf8/0x130
> [<0000000058f5f874>] ret_from_fork+0x35/0x40
> 
> This patch fixes the issue by:
> - Releasing dd->per_sdma[i].kobject in hfi1_unregister_sysfs().
>   - This will fix the memory leak.
> - Calling kobject_put() to unwind operations only for those entries in
>    dd->per_sdma[] whose operations have succeeded (including the current
>    one that has just failed) in hfi1_verbs_register_sysfs().
> 
> Fixes: 0cb2aa690c7e ("IB/hfi1: Add sysfs interface for affinity setup")
> Cc: <stable@vger.kernel.org>
> Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
> Signed-off-by: Kaike Wan <kaike.wan@intel.com>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
> ---
>  drivers/infiniband/hw/hfi1/sysfs.c |   13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)

I'm not certain, but this seems unwise.

After hfi1_verbs_unregiser_sysfs() returns there should be no sysfs left
under the ibdev as we are going to delete the ibdev sysfs next.

kobject_del() triggers synchronous delete of the sysfs, while
kobject_put() potentially defers it to the future.

Will ib unregister fail if the kobject_del() has not happened yet? I
am unsure.

Jason
