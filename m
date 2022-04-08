Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11EE34F9AFB
	for <lists+stable@lfdr.de>; Fri,  8 Apr 2022 18:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233950AbiDHQuf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Apr 2022 12:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233889AbiDHQue (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Apr 2022 12:50:34 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2040.outbound.protection.outlook.com [40.107.243.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE3335881E;
        Fri,  8 Apr 2022 09:48:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GgWlKZvdRk3WmjexvD334aoJ23c/UW3C27uc8HKpfNqVyUm8ZrpfPvEQREz8oTHefJzJcD/CIp5ia+j88gT1xZA/+C9F1F4PDGMF/fSqwLDUtiVJ3hiR22TS/ooalingN9A5HemI2KhvyNGU1MCAQ8798WAYgfTagIn/p27aESg6Md1WHlTS0kFVmlzgXtk9zcluSvct+9kuy2HvbiqARLsiN2f3gcqpK9c0hS93N2R18ILU1MaNUTGuSRE3IqNrBCEpq6QJdHi3RMXOSGts2eZmb5TMx9a9r/CE1Fp/J35YA0SROqcfqwDXNCQemhgiQOkLTBdFio1v8t0ozvOZYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UIiHjkPgJn67EU/NGUZDCagPn8C6jDFbWj1AsTi3YgQ=;
 b=EW3LaPafW8xv+iCkOiGnCy5R/ayCkTLv64IFISNJLg0rxRLgyiiucTghrPbtnO4nGJWjY9nnHJGOY8Nk8tqWtPOXIyOI/K7pKR/B0O2bn7nLyX2HtQQijHm6bmN8xYo5kU3Bu9qHy9uHHOOHNcY8qjgkLBIPxDORGpA57pR99+HRg5f2bKS0OEpSkvoWytcgSMPcefiSf3ZICwTIPCh8plF/4EuC/qytyDZpf5nKDEVgpZ0ueLTNnzh1NdE9T4O1YUTc4rmpyhkiKQcCyuRA29sQeWZYKPQgjqXidXBr8cbRChPzc+rG0XFk1PwHT9WJOIexG2/Cp9DizfVlRDuQmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UIiHjkPgJn67EU/NGUZDCagPn8C6jDFbWj1AsTi3YgQ=;
 b=Gd5+7vewIvWhVj2iiB8nbZGXb+z8ra1U7WmRt30G3JQahSwBT0zAP2QReIrr/QWrGpBvNbeBHLXQtFcersQsmjR60Vsk6nofPQu/ZfvSW3hlRW/411oVn7H1tGFH4Dhcg9LDOzpGQpV0pDr11loy4ex6P3XmF0jXCne9mavGKzlqf4Bj9jufzEHXcmcJK/iwFxkhGbyZILuBpksRJosSWbIlLju4D464Z9Vl6vSPf3q+yLxwHIK24pvSJmpHrAl2+8EdKKV+cQsBaEZNjM+8gblnQhV42wINljVIxLEGnothLE941EU+Lxty+AqCUK9O0knz/E1b+af5PCVV0TiFzA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB3275.namprd12.prod.outlook.com (2603:10b6:5:185::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.26; Fri, 8 Apr
 2022 16:48:28 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374%6]) with mapi id 15.20.5144.026; Fri, 8 Apr 2022
 16:48:27 +0000
Date:   Fri, 8 Apr 2022 13:48:26 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc:     linux-rdma@vger.kernel.org, leonro@nvidia.com,
        Douglas Miller <doug.miller@cornelisnetworks.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH for-rc] RDMA/hfi1: Fix use-after-free bug for mm struct
Message-ID: <20220408164826.GA3618264@nvidia.com>
References: <20220408133523.122165.72975.stgit@awfm-01.cornelisnetworks.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220408133523.122165.72975.stgit@awfm-01.cornelisnetworks.com>
X-ClientProxiedBy: BL1PR13CA0278.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::13) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 70011d79-6e23-4515-4615-08da197f9af0
X-MS-TrafficTypeDiagnostic: DM6PR12MB3275:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB327538E3DC33A6E91CEB9F4BC2E99@DM6PR12MB3275.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ArcZt357konTjYJPH35SEAI22263uLo148dwUNiRboa0tkUWB124M3yxTS0yPG/IG1H6VxmIZD4OuuR0rcOOR65D7w3WFsiCFJPF4GWW24IkfBrVpW71UofNqXAP5VbCqQiQxDNj9s3bwXZj2+R5rFjwIW9Zh1md61gcBkIWN8IMQ7Ncgoa6s5uy/6Ep+vq+U7BLA+ixzw5p9OXeehql2TAhkyS2TujpWFVq9SCpXiFnCyBgFAoyAOFgyN3IDd0WVVizg1sXJ8HYAiGUCjGdp2oJOJ5kNxRZg2OWLncAK290o94/1rGonfms+WFSWAoip8UqB5kmPlf89Gq0J12QX+sAoKSBA3vPEowjtS5ItVw+dg7r1oi1ysrl9C/NIqlGWAZDpvkkzflylZfQeagOiXBRDNVZ9l2tmhmCKcMCe17X4S6vnXMDv4m97yfSNbnfjsHxUYDhA32pxiuNwnl0EYgfLio3RhfxImL4Sj/9CbEYrU0K0K+VXZ80ekaHXOUZSBH9bXULh+YqlPGRLLl89TtSIeQvjKmbAqyxhglEJD/Inr+iaAqI72VUKs8gz7RG7Txw1FRpiNTN9HbfLtcsLQuY8T1UxPeXxC5/T2xf/5wwJAkks6d5UtV+tjwVewkEw/jhwQfXJZRqvyATq3OKoA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(6916009)(33656002)(8936002)(38100700002)(6512007)(2616005)(6506007)(6486002)(2906002)(316002)(8676002)(66946007)(66476007)(66556008)(4326008)(186003)(1076003)(5660300002)(36756003)(26005)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IsKDbUfkhvXKrcIlScRCi84/CmUuvjw6U/cxNwtQbvPI5tJgOeY35cf9LzVe?=
 =?us-ascii?Q?U7qchzMT1TN/0akR6cjq0CG7nW1fas4aymOfSfDQia7WNX1Rdyz2Lw7x/E6u?=
 =?us-ascii?Q?J4xn7x48sqkdR9FYfSOT6fALst36JLRH9qiYvZLEQCtOMOV/tv4IjKtiuqLJ?=
 =?us-ascii?Q?64g8j2F1Tec2/705ukKJIa0rlk9y8i9qmVbl+aUfth7mS1rps42ebnVihX8A?=
 =?us-ascii?Q?dbITT+eWU3lVwYLlpJCw5AW1Ufo0SKiwRjzIm5xWU6XrdEMkZwHCD+t4Qb7G?=
 =?us-ascii?Q?rPhonO/Vd2QCy0c7bc59J42+WtvI6yE4uh4wzXt6yLvsSj0sl/BKtEYaq8Sc?=
 =?us-ascii?Q?gwRBXTeN2s8UTLKHDYaLWRws949hLwA7My3M2LWhmlVh0d7XTUhVVwBbd+Ib?=
 =?us-ascii?Q?LQFJ+gfwiBRfqo9Qgzchh4zw7rBtAYFP3uLgpEvYe1HYTAN+RUJYrQmPpQjz?=
 =?us-ascii?Q?CIpQAyUsk7IVO/UtGaRX+LL8Pt9CRlWxbeOc28LJj7rfMRm9NbwFqKu0rWFN?=
 =?us-ascii?Q?43X7qDS8W3zFkwsE5bJm8BdxGu1SKrCnuhWTL9ZjbR5GvmscC3zoFMVc5wj7?=
 =?us-ascii?Q?rY6ceAVtT0Xdh3Iesbkd0SKfMb7c2mHeDLzucydoqI/71noeBcShr+elzCl7?=
 =?us-ascii?Q?iJSlJGGXWu+kRLtGQQsoLmwuzRXIFBNuxB0Bk7YV9TjEk0GEtIQJkXiiGrqA?=
 =?us-ascii?Q?BZtmnQ98PeIGOLnR0VM1Wp3hg6dHBFp6MVxbgP0bUIhhCDrggDDqAQQe2dFg?=
 =?us-ascii?Q?fHf3pHp3wSH7UguDsiDDBYmBOdd1pGP7LxvILtFqY5xdRV+a7w8qQX8DiNqd?=
 =?us-ascii?Q?oTdzrTvOqHGWSVWdVo7tUFfhclm90PY00kiEJJfA/17pXg5x6nMxcCdnAVkg?=
 =?us-ascii?Q?7glMiZGAP+auzSvNczZjcAxuHL1/+mIIWNCo4gszS//ZPG3SSSwN4oWZfniS?=
 =?us-ascii?Q?cbGED+98Q5rdEv1ZRwzVVnoMWnsKWMO+bnMd1nMhQZZm0Ztz00FTalp1lu31?=
 =?us-ascii?Q?VR4fauG/dBrVCcC9Rkyb+H0rPJZcdyo8mYACbjwpJYPlU3UO+pZN5tezvZ2H?=
 =?us-ascii?Q?2G6MVsoE8QLkoBayYqGyjkXYxlLmqOCJsGt3+ShRklIc6g0W58e6ty5kKDAB?=
 =?us-ascii?Q?CM1qD+gKbaz4nQ5hngAThz09SyVce53A3EqKJzC/qfvebSo7HEZL89FezycH?=
 =?us-ascii?Q?xqY3uT8LLHfmFSgmMbSJRfFJcGhp4YU93Ce7eGWPSn9aijEqqJehjcEQqhF/?=
 =?us-ascii?Q?15K4jRboGM3Byg3NdmSVMD+r+z06aqfGYcaCE+F+sPs/CFAGZfRlx3LIpxUv?=
 =?us-ascii?Q?xH0wPOxQM+cNGjEi0N3f1yhp+vV8Imc+c+KkD3M/3CtR3eiPsnYowkXXO4aV?=
 =?us-ascii?Q?YiJPj48cdQNXYyclk42p+qVBeYYMOElrqUoGV159xyJvGmLs63TRD9dX/uu9?=
 =?us-ascii?Q?ewKgLUlwbv3/zGmZuxarMdTqGQgNhnjWJEWWmqr4LxYUBBY/++pGQV+Yb8HJ?=
 =?us-ascii?Q?euyZR34ewA1Z/TrgKyxNvx38IT3LSEOr4xgByRPeU+ofTRd5Pp7yuJwSAotX?=
 =?us-ascii?Q?zEZC1A4iYZxSBqag2KHX4QK5V+DGQiucJ23h6zahNZ7ID+aZyv44iAEYNrHf?=
 =?us-ascii?Q?mbWYRVO42MfDASyvKzF6DfzmKF1Cp7pVFYdtv2Jx47JbqUw42ZdaxmL5LS1c?=
 =?us-ascii?Q?TLl4Dg7u8/K8YJ/7SAB4gn6iZ3LeWz5/tKDQw7urZsKrPWW01/X1oBSHZNxg?=
 =?us-ascii?Q?y6PrFIS2TA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70011d79-6e23-4515-4615-08da197f9af0
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 16:48:27.8731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YYyKTlABdOuosUIayAV/MGQSX3oNCTX159YKs3566wGk9ys3oNmwd7BhsbbPpI//
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3275
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 08, 2022 at 09:35:23AM -0400, Dennis Dalessandro wrote:
> From: Douglas Miller <doug.miller@cornelisnetworks.com>
> 
> Under certain conditions, such as MPI_Abort, the hfi1 cleanup
> code may represent the last reference held on the task mm.
> hfi1_mmu_rb_unregister() then drops the last reference and the mm is
> freed before the final use in hfi1_release_user_pages().  A new task
> may allocate the mm structure while it is still being used, resulting in
> problems. One manifestation is corruption of the mmap_sem counter leading
> to a hang in down_write().  Another is corruption of an mm struct that
> is in use by another task.
> 
> Fixes: 3d2a9d642512 ("IB/hfi1: Ensure correct mm is used at all times")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Douglas Miller <doug.miller@cornelisnetworks.com>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
> ---
>  drivers/infiniband/hw/hfi1/mmu_rb.c |    6 ++++++
>  1 file changed, 6 insertions(+)

Applied to for-rc, thanks

Jason
