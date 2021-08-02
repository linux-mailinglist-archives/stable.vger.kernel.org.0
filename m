Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 315F73DD267
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 10:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232838AbhHBI6b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 04:58:31 -0400
Received: from mail-wr1-f42.google.com ([209.85.221.42]:39899 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232711AbhHBI6a (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Aug 2021 04:58:30 -0400
Received: by mail-wr1-f42.google.com with SMTP id b11so15225179wrx.6;
        Mon, 02 Aug 2021 01:58:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3w/K1BHHPdxnw4BgvCO49QjL9Du7QDixwLU5epoJCOs=;
        b=Wy6jb4B7sAb7Eg3ccboUFpNZ1vrE9l1oxNAzHRpv2I3xWimcrRyFOPNurFYv6xY2PE
         BhqI3wcqnXKHpU0cxVCSlPhqpm8vp5pPp5ADn+bdz2pYvv42l2SEq1M9/Yvx1c0M+sqg
         yKwupgsWKXwnr1KH4xf2cxty7UDSK40Ng18mtJ7/9s06Cm66g1RANUfGQ0USRp6JYrmL
         F1PVRWHSEAtQdNFDfPf1tiYAE0B9X5DHGbT5ViFmQYQkmnejWJTXQrXJ72hRyghWQVo4
         +pPXh/vUTld7WnHjoYLp38oeOxDN48YVfrP+V/xrcnxALv80VJbCE1jhWWp1QtU3BI/Q
         x5MA==
X-Gm-Message-State: AOAM532KvBeT3FxGJHYnduFWUWI9KptueDwNjX/SBqQulAG9/Kf6xWvm
        GSkL2OidxDljA3z8IvHRucw=
X-Google-Smtp-Source: ABdhPJx0/tMXH15yaWP4fTnBDctEXhuDmohjGavsyW1cAWu4hdthkDNgpjt8Fdob5jAXYMN8mboFgA==
X-Received: by 2002:adf:d194:: with SMTP id v20mr16017994wrc.126.1627894698889;
        Mon, 02 Aug 2021 01:58:18 -0700 (PDT)
Received: from localhost ([149.172.45.165])
        by smtp.gmail.com with ESMTPSA id l4sm3773280wrw.32.2021.08.02.01.58.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 01:58:18 -0700 (PDT)
Date:   Mon, 2 Aug 2021 01:58:17 -0700
From:   Moritz Fischer <mdf@kernel.org>
To:     kajoljain <kjain@linux.ibm.com>
Cc:     will@kernel.org, hao.wu@intel.com, mark.rutland@arm.com,
        trix@redhat.com, yilun.xu@intel.com, mdf@kernel.org,
        linux-fpga@vger.kernel.org, maddy@linux.ibm.com,
        atrajeev@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, rnsastry@linux.ibm.com,
        linux-perf-users@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] fpga: dfl: fme: Fix cpu hotplug issue in performance
 reporting
Message-ID: <YQezqZcOrePV/FnW@archbook>
References: <20210713074216.208391-1-kjain@linux.ibm.com>
 <61495dc0-f496-992c-1d2a-9229a04e6e44@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61495dc0-f496-992c-1d2a-9229a04e6e44@linux.ibm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 02, 2021 at 01:15:00PM +0530, kajoljain wrote:
> 
> 
> On 7/13/21 1:12 PM, Kajol Jain wrote:
> > The performance reporting driver added cpu hotplug
> > feature but it didn't add pmu migration call in cpu
> > offline function.
> > This can create an issue incase the current designated
> > cpu being used to collect fme pmu data got offline,
> > as based on current code we are not migrating fme pmu to
> > new target cpu. Because of that perf will still try to
> > fetch data from that offline cpu and hence we will not
> > get counter data.
> > 
> > Patch fixed this issue by adding pmu_migrate_context call
> > in fme_perf_offline_cpu function.
> > 
> > Fixes: 724142f8c42a ("fpga: dfl: fme: add performance reporting support")
> > Tested-by: Xu Yilun <yilun.xu@intel.com>
> > Acked-by: Wu Hao <hao.wu@intel.com>
> > Signed-off-by: Kajol Jain <kjain@linux.ibm.com>
> > Cc: stable@vger.kernel.org
> > ---
> 
> Any update on this patch? Please let me know if any changes required.
> 
> Thanks,
> Kajol Jain

It's in my 'fixes' branch.

- Moritz
