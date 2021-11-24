Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A08145BF2C
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346225AbhKXMzi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:55:38 -0500
Received: from mail-mw2nam10on2063.outbound.protection.outlook.com ([40.107.94.63]:24192
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1346595AbhKXMxc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:53:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LxaLvaZAIjsl3mt3aDcF/KzzM4QvaAplwSu6kxuEcnCXMxJcm071/SmXE/0OqJp/yWQeIZrXWiN+jvZsPd8K1estCV9Bi/XVUhkXH51fG1EAE09ZFLEC+NKQo+4joeX7E9MOK3pZH+/U7Dy6mnys8OaU9nxJzeU7Z+RVV8VXpE9XR4ClTFhavNQkVElM6aFE5u3dHN2KRtOKgdsKhj+JDj9uZEowALgCRtdxBQf4SrBoiGmxTeZmgzzgCg0eCzRos+jf0BT5wmhS6mN05YqhEt9MRjVL4bGGadsB3D1lvWgzZ3TkQ7wr4pSEN2zm801Gtpto09kNPVDpLQTVEUH2HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wT7fcs/N0l8IblkNVuW4owNj9rJiALLPHNZPoQLIL+I=;
 b=h9HZk5ji0Um93TSfJ0ZFYFgmxi9D3AxM8IhYEj7he/4GI5MZdNogAYDGCqphwP36OKyDLv/aT1fShM5o2ekqrx2sdwZHLNp6eX+fmYF2KIGpgcZ/5gXzAQRcXUQBP3/y09XR+oblTzYtsDGGogSpamBviVt9EeSWEn7NnnA/zKpdvGzecVTHEIoVBvvaYE7udIg7+8ehJEVnxmbtYBqOlGB5Y8R54SR1xitzqhXitLC7MGEsGSHr7l6y7sCFRgPl4BzERKuzgpAbYVrnmjnCo8IEZqvA2MXwncb6zKRp5dh+RDxqiZ2EEUFySne+CuuJJ0YvOeZVqAsNfCbOWbY42g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wT7fcs/N0l8IblkNVuW4owNj9rJiALLPHNZPoQLIL+I=;
 b=oJiQ6/a1PGKjFybptqALUzIsWsNJwfXLkMKTIzv4YVmhnSxhDm8pQbIDdKjhepkw/L0t3S7Fn4X7MDysb+jQcAZsnsmfuvFH0+a5Z4PmcX30xOHZOELPX/LQwWAN5Y4jyDKH49R9ZJGZ7GBRHJABYAjWCARd3Iaru3tGhjr6BOV0lWp4SoBxtlloYLsQJvWkO1rwBtEQgyM0LLmP/+68OFO0L+hFUian/UdIZhXgx9nEZ2ZXqWl2s3WG0DOLhmRSE8MNO7vHbcR+3WDDVj98vS75y7gfCfuwfvhQtwaUBn9K4EVUAkXzGvAs1eIrsAtFWuvh8YFOzqVi0FLMIqCTrQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5361.namprd12.prod.outlook.com (2603:10b6:208:31f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.21; Wed, 24 Nov
 2021 12:50:20 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909%8]) with mapi id 15.20.4734.022; Wed, 24 Nov 2021
 12:50:19 +0000
Date:   Wed, 24 Nov 2021 08:50:18 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+e4df4e1389e28972e955@syzkaller.appspotmail.com,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.14 181/251] net: vlan: fix a UAF in vlan_dev_real_dev()
Message-ID: <20211124125018.GG4670@nvidia.com>
References: <20211124115710.214900256@linuxfoundation.org>
 <20211124115716.547727004@linuxfoundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211124115716.547727004@linuxfoundation.org>
X-ClientProxiedBy: BL1PR13CA0088.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::33) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0088.namprd13.prod.outlook.com (2603:10b6:208:2b8::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.6 via Frontend Transport; Wed, 24 Nov 2021 12:50:19 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mprj8-0010g6-H2; Wed, 24 Nov 2021 08:50:18 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9812c498-e031-4008-03aa-08d9af48f8cf
X-MS-TrafficTypeDiagnostic: BL1PR12MB5361:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5361CA31C90000E7F3947987C2619@BL1PR12MB5361.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:341;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ReZDtf3wRbz2KcDmFxQv7RZJCEvJQ3XN4pELhoLA0etJuH8XKbb4FzDcopCLxmCeeHwSFbAiodoXLNOoP478DHz756mYqZFZDYaPyjS8PZOhwdjlLvErqcNUqygu1XtDstaV0ObobxyG0nNMBByD872n2HR7WzxP6rLmo/v8MTC0d5iLfK51GKNsx+nuuYFV+9JbvelBNpBI+8ZvqC/b5EkjfRag7zWKqpcyGX3i/b4hFKIL362L2pJbRCN7yIYdXSzI/19k+3fPW7UbfspfWdc252aUfdGGjNrSTTeBMuLR8dqG7W3Ml8HGwsRmVSpY2N7dJxRxLd9Tunx+dihBUt49Eheyy0VipJlJIh0P8qOIIqp6XOX59aE/My0lnxmYpeF8hqbxlJ1GiR40cx5PtnmtxO3R9jLP+06xix3LhO8jdYld9/yIPh4TYOAlIQnigsrCpY5bd8MyQIUEhXR3fWc8CVincyUQ5ghF72O3zXMLB3r+pkfnoGf20C6mGQz+h3NJIR8+IMKzPgq/LDW5gfncCEiDmwgelenOJGyfXAK7TKSrF3YW1lxBdFicS6XTStrTrppxiFQc1xFA9/FxnHN8uSBfJLt0QcuKrloz2GAIiB3PNjZGDRgxS++7g6Ub1nLcJb9hBOTRloNix+Y25w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(36756003)(38100700002)(5660300002)(2616005)(83380400001)(8676002)(426003)(26005)(6916009)(9786002)(4326008)(2906002)(33656002)(66556008)(86362001)(1076003)(508600001)(66476007)(9746002)(54906003)(8936002)(316002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Yrp8R8MXlpAkPTqpWv4PMLzNbMnDh8YTJEydgUZd7ZGr5iqkE5vTNoPSbl7b?=
 =?us-ascii?Q?F/2L9CXLOeMLSBKgdee7bvzMJvjulDoLFC+W1stCuFdufck7yngQee6Tu04s?=
 =?us-ascii?Q?qUBh1X1RiwKfyh0HCmzkhyPmZwczFmE0mm2t9KENRblPZLf0J63ztcfqZjOD?=
 =?us-ascii?Q?7jZKXNKc5hBPJYszR7xqNnJN3Omoj1Pz2MeiOewyJkQTxtHTvrwpsR2c7zP9?=
 =?us-ascii?Q?+yAwzR2ZZkScN/Cd3XBaCZRHHcbAHUoXVUGo7qRFRHrzMn47ktzyrlmxYtO1?=
 =?us-ascii?Q?oPJkbKGzoSgmMevmvbaFBj/5pBuNQTNuW3IJk2ZPM1onEhe7wrqxYyULn0u/?=
 =?us-ascii?Q?imT0PpIb8r9i5KoDE+WsYjbdEQM9hM2Xx64z9EYcaNRWOy6obZlFhIDt7otX?=
 =?us-ascii?Q?R4XaqVg0xobephUpOuK7X9bWg3xpAWJd+ee2eoPeXgoPiDY28LG2ABoHXSHW?=
 =?us-ascii?Q?zHvh9n5PFGxK0pbMuN+dTtHfpVmR9PLXYxO2TRj+dW9bOsN08uRjnVAh0nmQ?=
 =?us-ascii?Q?WOSSKZ6hY4yTovVfJeIJRJkB2VmInmYubA4Gi02U/vEy4YuZI03cv6Yqlb4X?=
 =?us-ascii?Q?fIgbY+gHu/fPmdr8u8Vp+xn1GbnT8gMOiMvv1Yg6l+hb1Ta6FfXXSsysA7TH?=
 =?us-ascii?Q?IKC1fIphAIWyV8rRBkYDH2TyyGiHD1u5tV1pA9mHiKtUsSiSaAGm3Fb4XX49?=
 =?us-ascii?Q?bqk9LJnM09Vz1uWs7Grep25bFapwnafAOvroYgTGzoJ9Jom7PpmHG0hubNoO?=
 =?us-ascii?Q?iX3uxqBAviJFZkV0FEGciFEVHHWcJVmJx4UMqb+loKRmDF9WwtLWRrsrJVt+?=
 =?us-ascii?Q?9oUKczHs1s2QTG2C9pBIQfafrwqfPqnOoGed6NgdKN6+K3oaHF1fbvqysKkK?=
 =?us-ascii?Q?jBVB+a4HmtbF4IKsyxpZJdKVn0g87NnUCzG5J6+vz42fdns41ii0svmC0Lha?=
 =?us-ascii?Q?ADAOumTnaRp2Z9Ztx/TZ7T9a1f39N/ARea23GucevH8icJ08OCO54IaeC7bs?=
 =?us-ascii?Q?zTEqUTVuIDeonovxS64gb0P/v6O6VuDKdJB9yqB1LJhxMO7rtfd7mTOjR811?=
 =?us-ascii?Q?VMfmWL9dFYAxnS0t+HclXSHSME8aVoz8xcQV90qEgISQaitfMR81cqZFs5Pg?=
 =?us-ascii?Q?ZOS2sS01Ua2lGo51s57rWvExBsc5fNRNl2B6AcYKuGSGAXiw4+gozWfYrGy/?=
 =?us-ascii?Q?xVVAX7jyKI6kcN98Rc9pkw1vetfELox6mMPVva+IyZV8iPMUMHgc3MDMgYF8?=
 =?us-ascii?Q?u8t6tDjJbJm9ZG8hyVIe8eaH3RfYMVoZUY7QH0FZR5oviEyb0UwaFuzUn3RQ?=
 =?us-ascii?Q?7xm5folHBssmAjoZUiCJ5VC+WUthoTUw9vVAwq0gysf5zZzmBrW0JmVASdWS?=
 =?us-ascii?Q?7C/IZ2Q5uaUn8O57Ys7EXzZ+UAcg2dRqK5lCLTvoR7iiANJg7MNG1HjgRWX3?=
 =?us-ascii?Q?cUF8ISu4vWOXg7+D0dUfnpt8Kzo49+kogynjukJfNuQ+pmx5fMPo5tBzUqFA?=
 =?us-ascii?Q?rop41y0jDSsXlJq5yqszdtREMTeK6Jn/nv2SQxnvKqTb44bl6Iwq7maZMmgx?=
 =?us-ascii?Q?Ovqq1w1j+TBeBa6RMI8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9812c498-e031-4008-03aa-08d9af48f8cf
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2021 12:50:19.8389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k8fprJEGk7+En351/ttS+zCX5WOpmjqIl7YH7JCiSF6pl4Y29pkaL2RDC+m64Ny5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5361
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 24, 2021 at 12:57:03PM +0100, Greg Kroah-Hartman wrote:
> From: Ziyang Xuan <william.xuanziyang@huawei.com>
> 
> [ Upstream commit 563bcbae3ba233c275c244bfce2efe12938f5363 ]
> 
> The real_dev of a vlan net_device may be freed after
> unregister_vlan_dev(). Access the real_dev continually by
> vlan_dev_real_dev() will trigger the UAF problem for the
> real_dev like following:
> 
> ==================================================================
> BUG: KASAN: use-after-free in vlan_dev_real_dev+0xf9/0x120
> Call Trace:
>  kasan_report.cold+0x83/0xdf
>  vlan_dev_real_dev+0xf9/0x120
>  is_eth_port_of_netdev_filter.part.0+0xb1/0x2c0
>  is_eth_port_of_netdev_filter+0x28/0x40
>  ib_enum_roce_netdev+0x1a3/0x300
>  ib_enum_all_roce_netdevs+0xc7/0x140
>  netdevice_event_work_handler+0x9d/0x210
> ...
> 
> Freed by task 9288:
>  kasan_save_stack+0x1b/0x40
>  kasan_set_track+0x1c/0x30
>  kasan_set_free_info+0x20/0x30
>  __kasan_slab_free+0xfc/0x130
>  slab_free_freelist_hook+0xdd/0x240
>  kfree+0xe4/0x690
>  kvfree+0x42/0x50
>  device_release+0x9f/0x240
>  kobject_put+0x1c8/0x530
>  put_device+0x1b/0x30
>  free_netdev+0x370/0x540
>  ppp_destroy_interface+0x313/0x3d0
> ...
> 
> Move the put_device(real_dev) to vlan_dev_free(). Ensure
> real_dev not be freed before vlan_dev unregistered.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: syzbot+e4df4e1389e28972e955@syzkaller.appspotmail.com
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  net/8021q/vlan.c     | 3 ---
>  net/8021q/vlan_dev.c | 3 +++
>  2 files changed, 3 insertions(+), 3 deletions(-)

This patch is known to be broken, it should not be backported

Jason
