Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A48CF6B9828
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 15:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbjCNOkv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 10:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231309AbjCNOkt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 10:40:49 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2077.outbound.protection.outlook.com [40.107.237.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85D8C960AF;
        Tue, 14 Mar 2023 07:40:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=euH87olSDoZZ76Hio1Pn/U9XuJF5/1rqU/b3Z86Fltso04pW+RTBpipB8cMGP83rOAHQnW3oD6rm+GCADDPzVIKhQNvy/N/e8s1uVtPDo4Z75XOBmTWm/s9K3J+m+5jeA+ANlR1DRWkjlywYX+IZCDGKW6LsRFGUiha694Ul+oS70S7HPnvUq6e+tYR1tNZcEppVSWP0d0FYYFUGR0Vi/+qDlOU8pe0gtpVVsCyH22GMC/GBp6BN8EMSNlB15SyVEjCaQYI1fFC0aKKpEq5Mjj2SqjwBUkBgRtgphpnKf6oexNd7ax+4ZJl3rgQLmoUOKHhPlgT5jPhO/bbr9L5bcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3DnILiPN9BwYs1tjzAp5MF5+BbUYPsMmHIwiBXjcPZM=;
 b=l7B+LQZ6blr8FVYRrkVDNG6iXztphb1GsRA9I2iXEdvHvvoJ/QFosbat/5603JX/n/gLiLaFFzXLqZUsiz3AdP9/X1MYeUBgNSdb0HHCwGVssollws4nyHJM+0xyuuC3GFdnR+z2uuoyq07Dw/rIMflcJBwRRY2Uu4PCHKJW1O0VitIer7t5uMNgo0ZUNpvxbV5Hk6CPLbGI7nkb/9UylXFhMv3DnpoKyTJfaJ0aaZClAS9gsWKM7dHjLpNJY8eNfNx4MM29uT+SiaQwC2cjBLgcmwAD0F7WXGRFjOm0SrYpz1p+L/eU3lpIhIJkoqmezgumJz8zOnghFXfOkx4eEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3DnILiPN9BwYs1tjzAp5MF5+BbUYPsMmHIwiBXjcPZM=;
 b=5DUCx2y9MAJV+AB1Vyeor2amd4UUXWqquINMouhfuNAzfZvdE1QeYxB94LNXffzI7BNImWKqkD4hBb/ZElGeoziL+UfSL0dZOy87amVSnSrRkIr2sqyLb+QE/OoCtyvJ8uQGJSkg80ljRLh8ug4z59k+0sbY+pnUiz3pYjpNNi4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BN8PR12MB3108.namprd12.prod.outlook.com (2603:10b6:408:40::20)
 by DM8PR12MB5429.namprd12.prod.outlook.com (2603:10b6:8:29::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 14:40:36 +0000
Received: from BN8PR12MB3108.namprd12.prod.outlook.com
 ([fe80::e62f:89e5:df27:9e45]) by BN8PR12MB3108.namprd12.prod.outlook.com
 ([fe80::e62f:89e5:df27:9e45%6]) with mapi id 15.20.6178.024; Tue, 14 Mar 2023
 14:40:36 +0000
Date:   Tue, 14 Mar 2023 14:40:32 +0000
From:   Yazen Ghannam <yazen.ghannam@amd.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-tip-commits@vger.kernel.org,
        "Borislav Petkov (AMD)" <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>, stable@vger.kernel.org,
        x86@kernel.org
Subject: Re: [tip: ras/urgent] x86/mce: Make sure logged MCEs are processed
 after sysfs update
Message-ID: <ZBCHYHq34nlLlXKc@yaz-fattaah>
References: <20230301221420.2203184-1-yazen.ghannam@amd.com>
 <167865351393.5837.17719714572303479044.tip-bot2@tip-bot2>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167865351393.5837.17719714572303479044.tip-bot2@tip-bot2>
X-ClientProxiedBy: CH2PR07CA0018.namprd07.prod.outlook.com
 (2603:10b6:610:20::31) To BN8PR12MB3108.namprd12.prod.outlook.com
 (2603:10b6:408:40::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8PR12MB3108:EE_|DM8PR12MB5429:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d7d431e-e41d-4360-de92-08db249a12a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vbDxMSqK5miz5DF4t69HKleMYGJZVRKG1nCqStbFlTB7z+T5lt+6TfUW+Ewrsjf2MSNZzwY3+4fFbyYtYOUx4GTtIx75j3WK7Wi8X6NckKKHJgF030WNi1xhHu2keuHCrjSoZSZ/IgOHNOkBsP5Y2bJGxRGbyXnPbZBUQx09c3xaNis1n+LH6szpeewSYwWH6+mU5H/7IJxG85Yf4fa+XTBy1SR5UmReEwQEUFpjAo7CGKVl9ckHdSMtfCFfdSM4vU+cXHGWXNYlJh0jllvrx4LfT7BnkIcVKqBvepAStz8T7WX7OB3Lyk2CKmJ1j6XPdMP7D6kPe9u71UjpR/Ne8xgqPqDkWPSDGW++NP3G7FBqMMthSQlB98hneh39Pg9JcFqrj+E2JZHXtOZn+Do6n6uYByesm1yqWiI8RM3rM5UGuNXUBHrcG+Odbj/iNf3RdoqEgY6WoiYwhef7sjCGOEr3mx/GHT5c3KjhU8p4DJwPLW9UR9MT8qQ2skaQrX+yYfnj+5ZR1vbCPAzwm/K8/AiWc13HvR7zRwwA1EQ0Bi/uR8uZYjLpbNDAD6bCcGsbzhPrKqDuLbzr7MrEycbrkCOvJkKlpc/tumXBChB1U79rnCa+SxfONpkjeBGEJaM0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3108.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(136003)(396003)(366004)(39860400002)(376002)(346002)(451199018)(5660300002)(44832011)(83380400001)(186003)(478600001)(26005)(6486002)(6506007)(6666004)(966005)(6512007)(33716001)(9686003)(4326008)(38100700002)(66946007)(6916009)(66476007)(8676002)(66556008)(41300700001)(54906003)(86362001)(316002)(8936002)(15650500001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iod0hOg9eiTUj1q1LckNsJwatYGw/Kjs19ro5WCl/7D1GGoU+hpOzsLgXNwP?=
 =?us-ascii?Q?wkvAllLaNlXRR6ulibKLW3hMwmY/D+dGBMuss6PhcmvCz6XIoAeNPGsnVe4X?=
 =?us-ascii?Q?73D4nfRXkmyf3GiF2La+oWfR/YaFTBl0H2BAciTdMRZ6Fg3bUjQG/NjJujmt?=
 =?us-ascii?Q?1u8gB9+kFX/QohPt9VNrOFh8XseGIxz/eHZMRyf34XFXozecW7z9ogNHmr6/?=
 =?us-ascii?Q?yySjIi7MLEqebl112jlkJJLu/RzxFDmJ+eqVHuuPVky9P1iWLQF+9+9woy6x?=
 =?us-ascii?Q?EzLB73/mxl75RB2+gIEkOx3hrv0v25wB8qDd+RPz3ChcQdl/w+wuN3fBCfx8?=
 =?us-ascii?Q?V9tcxObo8QGb+Qaao4S3ptAk5jA77UGeppYCpSHYX5bVmHhLi24u36V65ugM?=
 =?us-ascii?Q?Tb5xRjHlYmHl2mQq5jDLRy/JXcrzPMWg96ZOrQB6Or7dKXX8QL8vP2B4uFjw?=
 =?us-ascii?Q?XPjMZdWeBchXvijBxwY1HJhNdDlj6cw9GGF+duE0SeGMQlQ9aVejEg0dhgf1?=
 =?us-ascii?Q?La+RaAqzbQy9JfWaahpIcbwfNxRQ/dDgBUYJAWAgQhHkpxiChGzjUCCc5E4h?=
 =?us-ascii?Q?OYp5boLDVZlMJuKe2FdRzeSNALarIVsOYQN0CzJxQ91FvSShDBtOOqwCp2fP?=
 =?us-ascii?Q?+KUGm7BGsQaJUr7K95FvLU5RdaB9zqo15Uci/VALq9WpPA/enqS7/z/rZ34A?=
 =?us-ascii?Q?eMQtPq+ZpPwBaUKlAWPIGY5qx3v6ZaYye707aFMYlmKkgfO09kAYstFgFUNm?=
 =?us-ascii?Q?guemvBmV5V80AGmMJFWZDVxiRgsNIujU6/1slNjEEZ8sVLgqf2rmsGVlTYHD?=
 =?us-ascii?Q?DpP9sc7B6+7hgQvQgl/mmP66RCgLfaCzQDSQ1jKzSSOHg/XB4IS3ifPSx9Fh?=
 =?us-ascii?Q?b5lmHseJRhVwq6BLBbw/gZpCLbbdxTvqaW9hTMBjjCjmqT3npfUcxtxUTnSZ?=
 =?us-ascii?Q?BEq49IOvk2u/ul0oFxY4CWwVwo1jVBlK/dSOMM+cR6CDc+MjNEo2300Yh/sF?=
 =?us-ascii?Q?tmAQFlUg72JPSDa9HjzYNSlGLebMQziZmBbpHehXgSFKSJFQGHQta2Xni3aO?=
 =?us-ascii?Q?S/xCq43/bn7hBAOZj25iTg25oVEi2IiPz5fgXBwqRrXlvCuYvDm86AzoqF3f?=
 =?us-ascii?Q?703dyzO7RSRRHryNWyIi3XqKZc+li8JB4ukELT6r40g/8sMRKxZ43hA22iRn?=
 =?us-ascii?Q?J1hz+Ci7bJd3tUG9uS9mXys3nZcTtHEZNIf3CS8/AMSbOZtdXbBvgaEIaNoi?=
 =?us-ascii?Q?VC9RdDvGtmDo1pCUHotmjUBcNoaJC6kbSaKgnrCceLnYDnBXhF/UdwX/iuSy?=
 =?us-ascii?Q?LJZtmj6TexErI0YHwDVO454jTKAwhCpV7MgXFm7L0iLhLZHGXUj4P/WkCVwT?=
 =?us-ascii?Q?L4R/xe3YeFP65j0hotmzyA7vH3qDNyqrZKf1IAhZcCGQfDDdLkuxTjqw8PtR?=
 =?us-ascii?Q?QH9i1sauYKKE9LzFAZIT+ZhL7g7evZrJHo+grLOSn1Ush/K+Oy3abomUS29h?=
 =?us-ascii?Q?mX1lZ0cYJek1H8QgV2z54E6dzGnE7mcGOlWVlKoBrAQGiPW5HwMPl63V352y?=
 =?us-ascii?Q?53AkepGBHQpQAXymiNDhjf35SCf8REpa97p5Wr3o?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d7d431e-e41d-4360-de92-08db249a12a1
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB3108.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 14:40:36.0312
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q5n+LZJ3bWiWC3kUq8KEshSjs4M7cF8VNw87MrtLEzLvIFg8WKGW1YmV4tkvKuEKNxgBkPIbRQLdPPhklvJJ7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5429
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 12, 2023 at 08:38:33PM -0000, tip-bot2 for Yazen Ghannam wrote:
> The following commit has been merged into the ras/urgent branch of tip:
> 
> Commit-ID:     4783b9cb374af02d49740e00e2da19fd4ed6dec4
> Gitweb:        https://git.kernel.org/tip/4783b9cb374af02d49740e00e2da19fd4ed6dec4
> Author:        Yazen Ghannam <yazen.ghannam@amd.com>
> AuthorDate:    Wed, 01 Mar 2023 22:14:20 
> Committer:     Borislav Petkov (AMD) <bp@alien8.de>
> CommitterDate: Sun, 12 Mar 2023 21:12:21 +01:00
> 
> x86/mce: Make sure logged MCEs are processed after sysfs update
> 
> A recent change introduced a flag to queue up errors found during
> boot-time polling. These errors will be processed during late init once
> the MCE subsystem is fully set up.
> 
> A number of sysfs updates call mce_restart() which goes through a subset
> of the CPU init flow. This includes polling MCA banks and logging any
> errors found. Since the same function is used as boot-time polling,
> errors will be queued. However, the system is now past late init, so the
> errors will remain queued until another error is found and the workqueue
> is triggered.
> 
> Call mce_schedule_work() at the end of mce_restart() so that queued
> errors are processed.
> 
> Fixes: 3bff147b187d ("x86/mce: Defer processing of early errors")
> Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
> Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
> Reviewed-by: Tony Luck <tony.luck@intel.com>

Thank you!

-Yazen
