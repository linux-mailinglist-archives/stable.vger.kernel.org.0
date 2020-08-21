Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87C0624E20E
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 22:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbgHUUT5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 16:19:57 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:11029 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726337AbgHUUT4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Aug 2020 16:19:56 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f402c5e0001>; Fri, 21 Aug 2020 13:19:42 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Fri, 21 Aug 2020 13:19:56 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Fri, 21 Aug 2020 13:19:56 -0700
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 21 Aug
 2020 20:19:56 +0000
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (104.47.44.52) by
 HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 21 Aug 2020 20:19:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GGggqA2hmtCXMV/vOkj+1nSxyL+zD+DCc8I0PezlVI8w1bTOH73qy8ILrBbazThOZ/liei0NR9Y9nYl7pNv6DacunE1c+d7FWTeDfh4mPFuv7OLRsLyo5dLwG70gRhNXhjzdPcdSO7Byf/ryPhxIDWEeOXL/35zupy3l+HfBf/9/z9wq42tnWhOn7VWhM1j8OVQIVQxT2YyEb3ucI9LbyuX6QUu54SxmdSKsSqNLWfbd0Z2eGGatm73dSH/PLhX3snJEKNIZTM59Ak4cz522JeFQIPjcNTpjO2Md7yGnXbCdDNhyf3UkocwUPpWnSBAaYHZJ1kZL+SRCFWcM1FW7Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PDTvngi607u4jMaGSb/D5EsvVwURy7nN+90pRQcjbKc=;
 b=enYrjJ+ueTHhlan/VC5dM7nLU9ZWRgOz5XFFHU3JGsDFzLo6gwQa8mYryKrnzgXNGKFxHqx4wPxQoS8dImNPGdx2Y0x7xidxReDvewN/RDEteJmLBzo8iJbj8KLTI6bpmni6jHhZ8a//CqGx67TYHJQNgfhyyIEA+DGuFZJXMetbAk9gcSujHHFrt23xxuiAqZt0SQug377v4gsztXFOJRM1k/F+OzJB1NOGd0ePdmBSN3oY/C1MGBOrYqd0qGT9YxsTUyIet4cso5XaYy93SV/PNhQ354hVXP19XCiU+YRgP9qLfCDTN9p1m3oFirH2FNLL3CXtkBu8B0Vyoq0/+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1657.namprd12.prod.outlook.com (2603:10b6:4:d::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3305.26; Fri, 21 Aug 2020 20:19:54 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::2d79:7f96:6406:6c76]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::2d79:7f96:6406:6c76%3]) with mapi id 15.20.3305.025; Fri, 21 Aug 2020
 20:19:54 +0000
Date:   Fri, 21 Aug 2020 17:19:52 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Sasha Levin <sashal@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Gal Pressman <galpress@amazon.com>,
        Shadi Ammouri <sammouri@amazon.com>,
        Yossi Leybovich <sleybo@amazon.com>,
        <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 5.8 55/62] RDMA/efa: Add EFA 0xefa1 PCI ID
Message-ID: <20200821201952.GB2811871@nvidia.com>
References: <20200821161423.347071-1-sashal@kernel.org>
 <20200821161423.347071-55-sashal@kernel.org>
 <20200821194036.GB2811093@nvidia.com> <20200821195322.GC8670@sasha-vm>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200821195322.GC8670@sasha-vm>
X-ClientProxiedBy: BL0PR05CA0024.namprd05.prod.outlook.com
 (2603:10b6:208:91::34) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by BL0PR05CA0024.namprd05.prod.outlook.com (2603:10b6:208:91::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.10 via Frontend Transport; Fri, 21 Aug 2020 20:19:54 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1k9DVw-00BnxB-Pe; Fri, 21 Aug 2020 17:19:52 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: beb6e07b-4978-4924-bb7b-08d8460f90fa
X-MS-TrafficTypeDiagnostic: DM5PR12MB1657:
X-Microsoft-Antispam-PRVS: <DM5PR12MB1657057F9867B8F3E324C97DC25B0@DM5PR12MB1657.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZA+fePsi0RGrmNhxyy4OWyAcC7LeEkTO8MCWCH7FMtJg58rDco34U2wTLM9YNIPq2OB0MxN633/+o4DZ1t3Jv4c3OT03dHZZzmtjF5eyUXrNZHfAM6isTxuzzKXlpxhuK5ITgSXEP4oQTMS1K14I9UdhRKaSdwfjM48esEilgeOStkOrFcCuyX9W1lBOZZzDRucpWCl/p2nSmjOg/rP0eURtCZ3Xo6TMF+ZMeQscxs7216k03K2ENgPeycoUOg3xROwaha7KJBzXKM689WbIJCcJpqC095k+h5VQLsObMunFyUJLmNviOYZgxfr5LZ8xsSAU03sy+kTos2+Cpqai97I3QLzXlP3Bx5vu7TyeodFdEn5JKuZ+AObOUzb+odkLc75+Efs3QyfZ0PaoAX2g7g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(366004)(39860400002)(396003)(1076003)(9786002)(8936002)(54906003)(9746002)(966005)(33656002)(478600001)(36756003)(86362001)(83380400001)(8676002)(4326008)(426003)(2906002)(5660300002)(6916009)(186003)(66946007)(66556008)(316002)(26005)(2616005)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: vzj78kME+euiOmaT/FJuI9KVmoqDbpoG1uK/L0hAsPgbTioP7v+ttoKr8OkyjU7wboUAJHuhW7q3Bb38W3Hb1+y++iZ4+heX5lpUtZpKylCLHBR8wVAVN3InmOo0/nAnu06VDqdxgTVuGB543OVRcTr4pVwTlVYQrpmFTJqh/UC5mKx2SyYrgyx6BEniUbV+hC5fW43+MlV3sNmVUmFDGJHaJvyd8L0+eeNglTvpKcetuohcUllRYwDxOtBwnQd+TRcHFS+xOwvAy0i1SaFc0x3naMMJjJMnDgMzikPr3fe9/DJWHWlG0H0ylFFcXIEv37q/5wmlfsVG7Q/WTbgHrxAfgnRaOZfoIAImj78zLVMY4EEjTrPMnuTugIot2Zy+Im8797j3tQLtz5g5NyXv7hqxoeJGDGssME7bVNwXNJn3KmBwv3u5Jo0WdIB9nzdlrHSIMbQd1XJy0FOLkqiBgVsTxmiJ2x+Rxd0LX1UdcHw6KYmRvN8oYNCrwZs5IXhvn032RJsN0UOQqRTePCFCL0jtgNqz5hKowaRFjaAxNH1ZvJWjS8uiKt00SYTAOEZ2i2YGK9UCIkObqtn6Ch7kn//T7OLiMISsQsGpHmU36NrDaw4UzTu2CyCMbg9leiOUhGlOdViwkw/g16fnk4i+7g==
X-MS-Exchange-CrossTenant-Network-Message-Id: beb6e07b-4978-4924-bb7b-08d8460f90fa
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2020 20:19:54.5678
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zXK6pZaDtn6BjW6Hxjcke4NUz8gbHk06yuvqxCVB/ckO7Dn19vtem4UlFhSYjHjd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1657
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598041182; bh=PDTvngi607u4jMaGSb/D5EsvVwURy7nN+90pRQcjbKc=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:Authentication-Results:Date:From:To:CC:
         Subject:Message-ID:References:Content-Type:Content-Disposition:
         In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Originating-IP:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-Microsoft-Antispam-PRVS:
         X-MS-Oob-TLC-OOBClassifiers:X-MS-Exchange-SenderADCheck:
         X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
         X-Forefront-Antispam-Report:X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=r7VlCJUaMrkR+oypu2Kxyqe6G7e41dY0bHNyFSOH+ZUI6Qc4nLJEurSdvavytuq8Z
         CcGEklXxCZJvhO0/HDE06ejl47oUH1yMpeHFDu2WMDBzvwD1Qj4Ir6VINShYXHgqaq
         VIV4FwL9C3P+cVBO7HUaBK95kTE491UI/rpGqtAjBbpJT2KJmzupN4WEU9Iqsh4KLY
         AVZtpuZwrtSAszeiGYdDEolMf2MlZxhp2gZIAZOzlqDTtw+d9Va2W6ZJfOkOUG2uHl
         Nw+Xf0scH3s7ikph3KGWOucZ0AKkx62Ag4JwA6P3Iq1qm3hPhAjFBBqKqYeTdZclYB
         EzTfCS3+5JOlg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 21, 2020 at 03:53:22PM -0400, Sasha Levin wrote:
> On Fri, Aug 21, 2020 at 04:40:36PM -0300, Jason Gunthorpe wrote:
> > On Fri, Aug 21, 2020 at 12:14:16PM -0400, Sasha Levin wrote:
> > > From: Gal Pressman <galpress@amazon.com>
> > > 
> > > [ Upstream commit d4f9cb5c5b224dca3ff752c1bb854250bf114944 ]
> > > 
> > > Add support for 0xefa1 devices.
> > > 
> > > Link: https://lore.kernel.org/r/20200722140312.3651-5-galpress@amazon.com
> > > Reviewed-by: Shadi Ammouri <sammouri@amazon.com>
> > > Reviewed-by: Yossi Leybovich <sleybo@amazon.com>
> > > Signed-off-by: Gal Pressman <galpress@amazon.com>
> > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > >  drivers/infiniband/hw/efa/efa_main.c | 6 ++++--
> > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > Wait, what? Why is this being autosel'd?
> 
> Stable trees try to pick up device enablement patches (such as patches
> that add PCI IDs). I suppose that AUTOSEL get pretty eager to grab
> those.

Is it so common that old drivers will work with new HW with just a
PCI_ID update?

I would have guessed that is the minority situation

Jason
