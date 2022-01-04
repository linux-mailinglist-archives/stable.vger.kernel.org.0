Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51A50484362
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 15:30:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234200AbiADOaw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 09:30:52 -0500
Received: from mail-mw2nam10on2043.outbound.protection.outlook.com ([40.107.94.43]:61102
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230170AbiADOav (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jan 2022 09:30:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OK7sIyfH9FntDHJGADt3YGRob3y6nmkb5BL+XZSEakMmQ1ePzLEeBREwGSYN+uiuij7nmopL0qCa3h33kv4ZBLqn12zVWpVI/OJFQY19MZZH3cq9dm8znq981Q4q+ggsTl/YSb/73BrxcW6SovLDlfGvno8gtl6SqCwlSGYkH4FWi3Z2kkZ+njQZLCl0HwSDksoG+KQJmOj4+GTRXvwRoavyk93k7n3RF3hmEqpDviL8G6ECxD3i6lMV2qrqzM4Wb8tceEjP3+Rjn2VauSUELQ6F5pZ0ZKmGW1ZUkOTcEkpytRz3X4qu2sUEl2FOVPzAtSxr241tYWrfAP3sSEkKTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=80mGIjZlSIdP4k+hfQJ5gEnb7iYm3X7RKYu7O8CvMhY=;
 b=U4XKo9h5VcDFeGXA7lbugOgdQpqKNSvKJkY9n2h1MNAx46rT/hHQJ9mxBJzj3yQQ7uDwNkxNxIEIua4gyJmDyuAQ4SDZSFu0sD/XTMrfUcT5EY/cXn5towkNjSmbVYYWcsCfV7MIv5QrYId3n5YX6wAB1Cpo1M0u50iTJw70Rq9RlnXnPfJy2i9oSj/rbxGxSTv3Z+O3pcBbBsgedGTOkjKUdht1yRgc5sk1w8obtODGz6qLO59GRgujDuPc63f8afNok2za0xr/ZJ8wwMrBPGgINy3kPdObA4gJS2FaRLAYnhMu2izQeMg8zZkYp4GZxxwzdNFesvTXwKY8are74A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=80mGIjZlSIdP4k+hfQJ5gEnb7iYm3X7RKYu7O8CvMhY=;
 b=JasGt1xUeg0FqeMhRv0QAh68E8Bi9hWAPybI567+B33kUE6RmO7d19O26eiJemz06GoLsBKV5kt0UbsI5963wcb10Tp8SaU1ywIV9UlWLazUUeJr51BveYgzwF+4nTgGjB7YATh+Utd5pfZshHjQqsOXx3al/uKswBv878D7Pj1t2AUNrsrnvZkDP0Lhpff93rpygBmEl6E+NAZM37auWQXZWRXSHhZwvEoa1Gt1jopa1ZihHR53G36R1adI5Dtaf0O2g7h7DFT6mADMqfWt+7hSX/vzJqYQnMDdEiQ3siJtQshnkCL2iTH9Aywv3hL1htEUt197XgCf9FUKVI53IA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB5520.namprd12.prod.outlook.com (2603:10b6:5:208::9) by
 DM4PR12MB5390.namprd12.prod.outlook.com (2603:10b6:5:39a::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4844.14; Tue, 4 Jan 2022 14:30:50 +0000
Received: from DM6PR12MB5520.namprd12.prod.outlook.com
 ([fe80::218e:ede8:15a4:f00d]) by DM6PR12MB5520.namprd12.prod.outlook.com
 ([fe80::218e:ede8:15a4:f00d%4]) with mapi id 15.20.4844.016; Tue, 4 Jan 2022
 14:30:50 +0000
Date:   Tue, 4 Jan 2022 10:30:48 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc:     linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH for-rc] IB/hfi1: Insure preempt is held across
 smp_processor_id
Message-ID: <20220104143048.GA2678196@nvidia.com>
References: <20211213141119.177982.15684.stgit@awfm-01.cornelisnetworks.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211213141119.177982.15684.stgit@awfm-01.cornelisnetworks.com>
X-ClientProxiedBy: CH0PR03CA0445.namprd03.prod.outlook.com
 (2603:10b6:610:10e::31) To DM6PR12MB5520.namprd12.prod.outlook.com
 (2603:10b6:5:208::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8fc14d1a-9217-49fa-847a-08d9cf8ecdef
X-MS-TrafficTypeDiagnostic: DM4PR12MB5390:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB53901680A7A905D9A05292FCC24A9@DM4PR12MB5390.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:862;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 93sTDr2Cu2NUPaCKe5TXouTtGBAHubp9/momwL6QhVwUP9CRpRQqcGnE+4pXH4balkSnGVaKPR1VrUUZzvPgAbvRcOHkVNt225q7I85hrs7iYt7WZXvCITRgY3CvDgGDtDJYV/R3i95cBCdKRFJH9yrdzO+31mqQ52/RN+Mhf/0OsysSPGx7WmGg0Qy9ezprSB9JDPxSrCfuWTju6GEgGk2hD1/qrPq5ZTg/PEVCajQcgzYGG4VGDkBfxoapuZJkHlW1wV0oPXRizLJeZ7VWJSZmsU1pdRVc3Y6gpsGie1rHaZE/hOr/rcFLWbqxaYfArDSvkuEsaaoSUuWKHIIHqs/Ev3uF9m/e9o0ayP3y0G9xjVwP/N/yGNoDxF7Xv3E6Z80KowyrR70Axq1cvpVMTn9ShtWQKtwUG3HpgJhAh3JRNJaxkOvVZhBZEt/ow1X0QYDuPaT3mzW504zWSReXr9i8fjmX2USxd7hzFflVJhuK4io8pltG8vrnYXFUa/goK6p499bxIEoBE7gcstkFHJhLHyMLeLTAzSoojCA8CuKP5M+HVBXSZ/UcoI56ad8LKN4g0W3LQnsGAPAICrZZOLeKHpwBCMsi5grOd3fxZnUOCMJCb9lq5CQ3jxbVkzfqt19RtAdDq0zhSxlz7Ybi8HiH3tJomC7lPIn0S42pk4dlqSBtD4bNhPtuB56YEbBp3lvwFps6Oky7AB68UEN2lbL6lNU0EKfbzE41tUbyIyg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5520.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(33656002)(6506007)(86362001)(6512007)(83380400001)(6486002)(2616005)(966005)(4326008)(36756003)(508600001)(186003)(316002)(8936002)(66476007)(26005)(66556008)(6916009)(5660300002)(1076003)(2906002)(66946007)(4744005)(8676002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0XJkPFyOnp2xiMG3HvK8TG2v2rMQebGRPttN2jFagfzF6nTK6WbnheD3GJ+8?=
 =?us-ascii?Q?YqK2DRxTSQeOiXrqCe/YhC0MmQ+QmelXRU4SRnpKyeJLVSSnf+taJJXujuEI?=
 =?us-ascii?Q?meMp4AWgrCaLnt09Np2CNMqIFA05X6+1chdiR2KAmjJWhXh/9DNJmAyoZC6s?=
 =?us-ascii?Q?Bh800AuB4ETsWHfoBdhEE1d1XFMqMGkxfsGGto6bwPGpi1Kj84+XdkH4wHZE?=
 =?us-ascii?Q?QyiCIcBIfvrWWbwUfPX5Xq8oxMKX0MKulIBrhOyOdXwdWMKqyQfPuwWy/OHa?=
 =?us-ascii?Q?IO0+dbrpIzZf+SmsUNA1gMphIs/eBfbDNGSelc64Sn6wCugbJpOsnIMjR/Uh?=
 =?us-ascii?Q?9ZORlLJzqh8HgzA3pbzX0eqG6obLpBjuQTwf0lenn5nA6PRiCnlusoezkvnc?=
 =?us-ascii?Q?oA3234pYUoQmWL9N4dVt+k4eAFx/uGjXc3YnUYZAxAmaemI8vvl4ldfipOdy?=
 =?us-ascii?Q?7rNslihDB/OpJeS/rUJQM5HFs08cYFfy8+NjRkUBDH53uStgUaYCgKGz7cxE?=
 =?us-ascii?Q?ONHeI/JqUozK1XeS2msU4xb1a/aW97hKTflbEolfnW9FEw4G6xPM8h0I96xY?=
 =?us-ascii?Q?bwZoIAvp8VpSAJvDq3H9Xk0mqwJzfPv6nUSnS5SX6C3O2eUrolOvrImPxF2Y?=
 =?us-ascii?Q?3cqsdbkiRYg22hA8i96VR0CzJ/LcsJA+TGziIUIhQ9/CPR8m0R92+EXsjuwf?=
 =?us-ascii?Q?uYPHrqRD+GTpaXIOyqLgLjJtPHbAa+AR1JyOaf1VYEBZvvoX89hkZTF+5T+D?=
 =?us-ascii?Q?ALLfdestRrEVbfMI1VaOFMDZAWu27PtgfLfOqOokyjb/k05y8OrXbf6LTcjo?=
 =?us-ascii?Q?wsk4Tpxh16L4+/np/Y+lq6a+5autuGiz5W9R5T8jVusquJgtfFcuO9BLODNg?=
 =?us-ascii?Q?VLILOVtS/2Ilgn8OdqG7zwvPgE7VXx1Dfv6IyqxFG0vhfu0smWvoDEWX/sQX?=
 =?us-ascii?Q?nutQSOW7LTAVyPNgO25cmkoPZoyUnCm7bospf94A8IT2EnoUIIRZsravqVXT?=
 =?us-ascii?Q?mg5xZkAZAJVIgrfNbQRRjZfSNpTIawC6D4rzUb026R+SnzE6nmV7WX/pMZAZ?=
 =?us-ascii?Q?zP79PZd1VQV5HKgofJH5xGpBXPsNVjZmF2zvmAyeTF1mJuOLnsE2cFVuUkZX?=
 =?us-ascii?Q?XiJ809MRbjr28JonP3wnJsilsWO04g1wzkOSOOzkqSYXt3R2wBQDLOuqz5Hw?=
 =?us-ascii?Q?iG83tN3MOm5VpcbEMvetf+Kd4yBpeunPkAgsNzKFPY5jWdDzTvER8ZqFnvY6?=
 =?us-ascii?Q?PX3JfrSKmh031xlV19ibUYvqpFdl0fg6vwa+ho1pZX0MppKEk7NO1kJqHsI/?=
 =?us-ascii?Q?82bSZ2YA3J7bCw4WGj0L2vQsGwEPX/ZYXre7zBJLLPXARj8Ft2tUkk4vmVf6?=
 =?us-ascii?Q?8DJZMycN6SLTFKqVgTlLAe9ZS0wDsqgM1khVsC2OWyW9ueaAnNT/p9vqflwJ?=
 =?us-ascii?Q?b07SeWWARX7RHieHRtEDRVnHypfoWajHNNSg3PsaJhVlmnLjUBtEbf+fDNKc?=
 =?us-ascii?Q?cOPozH+wzTUAu7Hz3k29zwxL3gj2IYCjgSrqSYgVEgHuuAejU77czcFG0rEE?=
 =?us-ascii?Q?Y0PJEHk8qwVd0v9GSz8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fc14d1a-9217-49fa-847a-08d9cf8ecdef
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB5520.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2022 14:30:50.5716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X6eXdleWFXvipHvwWeI+yzC7488/4FcJsPz8HTZky4v2hkl0qR+jwm4bAdhvYNUq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5390
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 13, 2021 at 09:11:19AM -0500, Dennis Dalessandro wrote:
> From: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
> 
> Despite the patch noted below, the warning still happens with
> certain kernel configs.
> 
> It appears that either check_preemption_disabled() is inconsistent with
> with debug_rcu_read_lock() or the patch incorrectly assumes that an RCU
> critical section will prevent the current cpu from changing.
> 
> A clarification has been solicited via:
> https://lore.kernel.org/linux-rdma/CH0PR01MB71536FB1BD5ECF16E65CB3BFF26F9@CH0PR01MB7153.prod.exchangelabs.com/T/#u

Did nobody answer your thread asking about this?

Jason
