Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B02382C4C35
	for <lists+stable@lfdr.de>; Thu, 26 Nov 2020 01:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727062AbgKZAdZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 19:33:25 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:7000 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726874AbgKZAdZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Nov 2020 19:33:25 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fbef7d40000>; Wed, 25 Nov 2020 16:33:24 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 26 Nov
 2020 00:33:20 +0000
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.174)
 by HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 26 Nov 2020 00:33:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DFsmiznFxLVsfRGqOaSsa+Q4stuLp2wNBiT6xdtnfTRNjVCRT8keiG4GVfDmwgclgBWbsibt/uq1Un4z1C5Md+1a6xCn2FnrDDg15MAVWKrXSxwNGUrMo/l5zE82vSyAv01/kujMvH6Wu1HLxHRsPJkRBqbzUlomA7frshnVtwO6ntl0of/pztInv2W7ugGhOAC3ZhjZUDPuMUtI1M/EByyrwgQT+PhwHjUjioIF9NEE0fTihWY/Y6XqWsHWMytlV0Dn7bz5qE6ua+SmIep+gXnVubOn6MPqRzGwj0+vMmSjYRM19MbNB9wMi+ytd5YuEQBRjjahliEW2sHdrFPQyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J/h95MKHoUwa8Xl2HFvjw3XeUB9yIwlyBbiYUzfSXFc=;
 b=GJGvIPNeja8cG8Tp/NNwR1jQ24f+Cg0EnTnq/8r1fAZpqrPRtK0awiZVjlOwst/6eauPfe0g9OKpgy1LzjFfKFCwRoYdCMOWC0RjUbwtdkhbye9EdLsX4xMSUOb7vF2eCFBF0HD4C2P9LvJNq5VSzOL8P1VRY3yxuaCKA0VTt3kb7VVS7nWmZkBzKyWX30nUc2OVePpwG1UbHqdMPkQlzgQkjAoVahaCBgbvalxNp335YyEaGYywkJEpkVMi9PTN8BK33Z3uAiObshQuqRIqkJztFonj0zc5XFJTkpclPowFZbPscm0XDGVwpinJZLgSW5hWFZpY5IhyoKEK5Y79rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB3827.namprd12.prod.outlook.com (2603:10b6:a03:1ab::16)
 by BY5PR12MB4052.namprd12.prod.outlook.com (2603:10b6:a03:209::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22; Thu, 26 Nov
 2020 00:33:18 +0000
Received: from BY5PR12MB3827.namprd12.prod.outlook.com
 ([fe80::7503:d9f2:9040:b0d7]) by BY5PR12MB3827.namprd12.prod.outlook.com
 ([fe80::7503:d9f2:9040:b0d7%7]) with mapi id 15.20.3589.030; Thu, 26 Nov 2020
 00:33:18 +0000
Date:   Wed, 25 Nov 2020 20:33:16 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
CC:     <dledford@redhat.com>, <linux-rdma@vger.kernel.org>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        <stable@vger.kernel.org>, <linux-mm@kvack.org>,
        Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH for-rc v5] IB/hfi1: Ensure correct mm is used at all times
Message-ID: <20201126003316.GQ4800@nvidia.com>
References: <20201125210112.104301.51331.stgit@awfm-01.aw.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201125210112.104301.51331.stgit@awfm-01.aw.intel.com>
X-ClientProxiedBy: MN2PR13CA0010.namprd13.prod.outlook.com
 (2603:10b6:208:160::23) To BY5PR12MB3827.namprd12.prod.outlook.com
 (2603:10b6:a03:1ab::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR13CA0010.namprd13.prod.outlook.com (2603:10b6:208:160::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.6 via Frontend Transport; Thu, 26 Nov 2020 00:33:18 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1ki5Do-001Sok-RR; Wed, 25 Nov 2020 20:33:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606350804; bh=J/h95MKHoUwa8Xl2HFvjw3XeUB9yIwlyBbiYUzfSXFc=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=gzwRoaVw7qIBW5290+k8DolVYflyj3syDkJYyFd6R8CAYa1dey63ef3pIeJyxBb8R
         iUVWhCxcGphdde5skQ3LtRti4vhgF73pvlUxo9IKwM3AUTbOdOC2dx3e+ggpw/fEh/
         4gzsow8gJPoqmcHF6xO47OmRaDr7qWVCLbYmuWccbp2YI9rS7qKJiIAXAI5Fs8ylKS
         mGberNZdpQwYoJv5ohzjQbq45S1rIVX2FRpJQwzjT77azFi5K91Q90T4+Aor3GZmv/
         weifHJUkuOMcpXsSRmA5wSFoRv/Ehzba+qWc6iQgWLtRbtz9z6tdk9pMaFmTSGegB0
         VAC5/eWKnyvFg==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 25, 2020 at 04:01:12PM -0500, Dennis Dalessandro wrote:
> Two earlier bug fixes have created a security problem in the hfi1
> driver. One fix aimed to solve an issue where current->mm was not valid
> when closing the hfi1 cdev. It attempted to do this by saving a cached
> value of the current->mm pointer at file open time. This is a problem if
> another process with access to the FD calls in via write() or ioctl() to
> pin pages via the hfi driver. The other fix tried to solve a use after
> free by taking a reference on the mm.
> 
> To fix this correctly we use the existing cached value of the mm in the
> mmu notifier. Now we can check in the insert, evict, etc. routines that
> current->mm matched what the notifier was registered for. If not, then
> don't allow access. The register of the mmu notifier will save the mm
> pointer.
> 
> Note the check in the unregister is not needed in the event that
> current->mm is empty. This means the tear down is happening due to a
> SigKill or OOM Killer, something along those lines. If current->mm has a
> value then it must be checked and only the task that did the register
> can do the unregister.

I deleted this paragraph, it doesn't apply any more

> Since in do_exit() the exit_mm() is called before exit_files(), which
> would call our close routine a reference is needed on the mm. We rely on
> the mmgrab done by the registration of the notifier, whereas before it
> was explicit. The mmu notifier deregistration happens when the user
> context is torn down, the creation of which triggered the registration.
> 
> Also of note is we do not do any explicit work to protect the interval
> tree notifier. It doesn't seem that this is going to be needed since we
> aren't actually doing anything with current->mm. The interval tree
> notifier stuff still has a FIXME noted from a previous commit that will
> be addressed in a follow on patch.
> 
> Fixes: e0cf75deab81 ("IB/hfi1: Fix mm_struct use after free")
> Fixes: 3faa3d9a308e ("IB/hfi1: Make use of mm consistent")
> Cc: <stable@vger.kernel.org>
> Suggested-by: Jann Horn <jannh@google.com>
> Reported-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Reviewed-by: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>

Applied to for-rc

Thanks,
Jason
