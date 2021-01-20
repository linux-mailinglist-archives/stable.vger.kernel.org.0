Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE4D82FC59C
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 01:21:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730795AbhATAT4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 19:19:56 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:8150 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730751AbhATATz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jan 2021 19:19:55 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600777010000>; Tue, 19 Jan 2021 16:19:13 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 20 Jan
 2021 00:19:13 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 20 Jan 2021 00:19:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aUj+A8CH0MQbKkpzHrcQCabXdi1R/Q0dSO/BxRcgZLnyd8NnyP9a1Xf/OFIeugWs0PVskGoKD3oQuczB14uqOfjarGV7G8fNuoEIZKoKh2KsqgKN/8mZgNCNVcq05yksKC46/tmMUBtdq1J+O9aj0dtTxSOtzn8Q1RBzmIblZMFvVt6YROIREjbcsbk9sdcU1mJ3yv7939sbLEyVNYXl0V8Ylvb3NtD2mP1+Yhj/mF2wCwhUyVNzFwdMqTFCHWY8200A/QGSNSL4LVhH5Dwj9d/iB9FOYIiwLDTb/31IEUYLofkZHfI2wLfMVE/EXAnRE0XFf3hX7TF4oWDz3nF6RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dlRkVZYo8Ynw6NsomlhJbr2S8e5uoygNaUWKiuIvSes=;
 b=oEu8mWyi1ebpQu/aKRnMMqaO0N5IQEAooxQr70A9+3H7iAhPGupKzg5m6j0/a0kxrAJ+8V0XvKJbTEGAEmhJHmroRJbWNMRgQzUZDndlaHtbnP2JSczs9+2vKw0PkPiVf7fPcbJQ8lFOsWf6fgaT3+WQ1UgrpvL3VUzA3PaH5p5H9QCda/6wHr8AmKR6NRV6XgVvuEHkEwwq0WnLnC4wP8KcZ1ZMi3bKX+QHerW2bTt7KsTMHiRD+Xfp2pR0LC3ZsxdGNJrre4RFuv1k9FWa6YXQwDmtFWTw3vWNGmhSjNAFL+vGqQJ21/8Arz3aUDhFaJ7O/TPwGsp9b9grnPBfhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3514.namprd12.prod.outlook.com (2603:10b6:5:183::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.12; Wed, 20 Jan
 2021 00:19:12 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727%7]) with mapi id 15.20.3784.011; Wed, 20 Jan 2021
 00:19:12 +0000
Date:   Tue, 19 Jan 2021 20:19:10 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Bryan Tan <bryantan@vmware.com>
CC:     <linux-rdma@vger.kernel.org>, <pv-drivers@vmware.com>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH v1 for-rc] RDMA/vmw_pvrdma: Fix network_hdr_type reported
 in WC
Message-ID: <20210120001910.GA952659@nvidia.com>
References: <1611026189-17943-1-git-send-email-bryantan@vmware.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1611026189-17943-1-git-send-email-bryantan@vmware.com>
X-ClientProxiedBy: MN2PR11CA0025.namprd11.prod.outlook.com
 (2603:10b6:208:23b::30) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR11CA0025.namprd11.prod.outlook.com (2603:10b6:208:23b::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Wed, 20 Jan 2021 00:19:11 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l21DK-003zqF-C3; Tue, 19 Jan 2021 20:19:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611101953; bh=dlRkVZYo8Ynw6NsomlhJbr2S8e5uoygNaUWKiuIvSes=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=sIw9PFsuhsNymnAjsIqpKAqvdjI8m6dUapD2nPHkE7vaTo98XvwmsTciWGxoOGoJo
         ohZdieLslgUnQZGANhYSZSYA8fGijBIAhCRL/RHt2DKI1Hs1yO2s53pBPH+T0h9Ge8
         ITSAxtkPCJmoOV+GawvO8toWi/SDcd9hYN1N3AbW6f9ZKXS4ty2bT1JIP/qti8k7SS
         ISkcgCvSRAn+76VjqlzK7X0Vbz03/4vWiWWJaIP4oVYZJBKLvXj+dnwtq2V2L29IcS
         vZrUdbMEP62FWek7ip/TVy5w+StaHI8hnzVYplMBP2BB62ADZ99YTfXmvnN8D9PAO9
         DV48JE6AvnfMw==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 18, 2021 at 07:16:29PM -0800, Bryan Tan wrote:
> The PVRDMA device defines network_hdr_type according to an old
> definition of the rdma_network_type enum that has since changed,
> resulting in the wrong rdma_network_type being reported. Fix this by
> explicitly defining the enum used by the PVRDMA device and adding a
> function to convert the pvrdma_network_type to rdma_network_type enum.
> 
> Cc: stable@vger.kernel.org # 5.10+
> Fixes: 1c15b4f2a42f ("RDMA/core: Modify enum ib_gid_type and enum rdma_network_type")
> Reviewed-by: Adit Ranadive <aditr@vmware.com>
> Signed-off-by: Bryan Tan <bryantan@vmware.com>
> ---
> 
> Changelog:
>  - v0->v1: Moved new enum to uapi header and added Cc as per Jason.
> ---
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma.h    | 14 ++++++++++++++
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c |  2 +-
>  include/uapi/rdma/vmw_pvrdma-abi.h           |  7 +++++++
>  3 files changed, 22 insertions(+), 1 deletion(-)

Applied to for-next, thanks

Jason
