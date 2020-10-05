Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E538E283DC6
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 19:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727705AbgJERyA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 13:54:00 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:1176 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727033AbgJERyA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Oct 2020 13:54:00 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f7b5d4d0009>; Mon, 05 Oct 2020 10:52:13 -0700
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 5 Oct
 2020 17:47:50 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 5 Oct 2020 17:47:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oJpFXszOys/TVw/UMAcM7yoS0Q7CFw5+v/49bPw2z3X/8ltx54AI2SM0FEJPRatBpGCV1tYqyzDv6yZ3XcT2mVMCBcov9mrTPg1jnFm8j5H2A0gV7pDHL1nLEggOOhPHOQJp5dmzzByQfaM7JQIQ5rRRL3ElFBYWg2bo2Cqgc4EvemrQLM0cFriBZxVePZ/ZgZDcOoJpEWze2gIBSAF2/hTfczIjnE9LQHUCqZA5gTcOua3XZpCtttuTHRbYYZvhjD2P8mcs3i97P050u9WPf49HBeoQjwTmv7dPcz0TqJUVYvcwa5e7S+qo/IkriEQ1vI24GaCb95bPTIDVOE4Q1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=86Ck8VzDFVaztcONv7uTtduf2bY6DLkDLQqCb1Hyprw=;
 b=U/oRdpsJX+BHF97GsyUlcB1WUyWgYszEv1xwKhubRdgpOIopj7jX9MOivcJJNjinfA9iM7KvZQrAKjgzmbHyeA72vqKsREbOx1/2N+68Q8ERtlXluSOkl5l0W0o8ms9QR0cISw4X4D2xLxYtrhV6UwmV29/XnOtYnNi5lKrIB8HYhPkRDeXwNu1+Zzb2UzGYEqQKgyP1CXo+b+x1gUokzCpXv3DTI9xM9cy5fPvsOAXMjP2C0xBu29L08c2MDvQ4ejiegYsRNR+YmsG28eO0oINrXnVxwHTTaKVhpFYP3hOxSe9yBdcmbfPT7lwMNYse+E4yGsSTZ4YEtmgLWTjUEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4498.namprd12.prod.outlook.com (2603:10b6:5:2a2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32; Mon, 5 Oct
 2020 17:47:49 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3433.044; Mon, 5 Oct 2020
 17:47:49 +0000
Date:   Mon, 5 Oct 2020 14:47:47 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     andrew Morton <akpm@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, <linux-mm@kvack.org>
CC:     Hans Verkuil <hans.verkuil@cisco.com>, Jan Kara <jack@suse.cz>,
        "Mauro Carvalho Chehab" <mchehab@osg.samsung.com>,
        Mel Gorman <mgorman@suse.de>, <stable@vger.kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        John Hubbard <jhubbard@nvidia.com>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/2] mm/frame-vec: use FOLL_LONGTERM
Message-ID: <20201005174747.GA15803@nvidia.com>
References: <0-v1-447bb60c11dd+174-frame_vec_fix_jgg@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0-v1-447bb60c11dd+174-frame_vec_fix_jgg@nvidia.com>
X-ClientProxiedBy: MN2PR15CA0040.namprd15.prod.outlook.com
 (2603:10b6:208:237::9) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR15CA0040.namprd15.prod.outlook.com (2603:10b6:208:237::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.36 via Frontend Transport; Mon, 5 Oct 2020 17:47:49 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kPUaR-000488-U4; Mon, 05 Oct 2020 14:47:47 -0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1601920333; bh=86Ck8VzDFVaztcONv7uTtduf2bY6DLkDLQqCb1Hyprw=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=UnqcthBkLbyZZZDBXc+rhPItfScmGERDo6RTNKFTTXTDcZFMYFEzvyVt6d5ZNIcW1
         I5CR6SPwFfMK/8l0OzB5Qjh8KFvSB9FdFHvSockc1m2L1KRFWhLxcRTGjC57SHRe3e
         8RW1oRR1TnXDPVSAbnSPVN3wCLAwXscsP7RtfVrpC1Ky8D+DY5Ymlb9//3YuQobD5w
         QbsWC9vtdf48hJlNi4kWeAHHqI4qbfshPihDzy5H6uG+NcNRiNjsuur7yPA+8lry6j
         O8XNDIIUhrMyfNCmh2c1kUegTBlKXP0L3whOFKgFL/IFiAeffWw9TjvqUnNGq0sdvv
         PysZjVa5HRnHg==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 05, 2020 at 02:38:54PM -0300, Jason Gunthorpe wrote:
> When get_vaddr_frames() does its hacky follow_pfn() loop it should never
> be allowed to extract a struct page from a normal VMA. This could allow a
> serious use-after-free problem on any kernel memory.
> 
> Restrict this to only work on VMA's with one of VM_IO | VM_PFNMAP
> set. This limits the use-after-free problem to only IO memory, which while
> still serious, is an improvement.
> 
> Cc: stable@vger.kernel.org
> Fixes: 8025e5ddf9c1 ("[media] mm: Provide new get_vaddr_frames() helper")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  mm/frame_vector.c | 4 ++++
>  1 file changed, 4 insertions(+)

woops, this subject got badly corrupted when I was editing the CC
list, it was supposed to be:

[PATCH] mm/gpu: frame_vector: require all VMAs to be VM_PFNMAP

Andrew please let me know if you need a resend

Sorry,
Jason
