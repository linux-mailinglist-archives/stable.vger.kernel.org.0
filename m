Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6B4417141
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 13:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245440AbhIXLvO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 07:51:14 -0400
Received: from mail-mw2nam08on2071.outbound.protection.outlook.com ([40.107.101.71]:65377
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245635AbhIXLvN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 07:51:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RksHnvNmYXPIZCAlXlcpWHx/g1c1O2NXf/+WwADsD+E2yps7YGNkEmF//2Yv3ISyp31G1fUfGtDxkSRz8rO21u/V5A0a6gkK71J51uLwVc9l2lp5YWVg+WR27YXPFLuDuYKhPtLC3/JRt8U99vZdN4MToFBAiEG1J8qgxfLtFcoZog7gbS3vZiMlLCD5Ajhtrdx60mjlrXp32lIIuSolceT631poY409SX92ru95KitlQCrl9J7RG2HHW+IButxIDS9isdaheYgurbTQgegV2lBeweXTts4AcN+Hms1yZnSMud23dcMOG+kqNpSiQ6+DolykDMD5YyYd1CnoTtlCCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=BF3RT2t8HXJ1VbIQpjxrjBo/DehWrS6/ZNfMuqmgzWs=;
 b=fiAI4Q4dvcRQVifdN0l9P12Q84vdB0NXY5zCmmZYEZ8yZtgNb8U0/0jaPcgevTfLJZHb2pPScIVDBuPxUhzG3g53Geearr+dSOAgbKXT68JwpDroCjfc5+hFcVv7xTAK46AXbLkWEFEQvmq+QudQf0t+ybFhR9LNLE2WUWqvGOhJuEMxS8z0dmwVWP5NLmVpYaAwKPmXYjUgFOLMmXmGjDA/VU14c73wGa2yEj4yvhypvU2xwRu0b13DdfBTCjKcTNxqDq4u1DZcwULNweppzhfBzSZLmMpU4EX5bHgK/K52KoSPiPyPqL1bgD36q2zP5+EXsKWAzsiuth5wHbOQUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BF3RT2t8HXJ1VbIQpjxrjBo/DehWrS6/ZNfMuqmgzWs=;
 b=NBi7A/BcehsBWX/utl8diCLCKwJUFdqgXQAu+71E85ubXzI727qiNrUgzDxjrjZUdESEGDup74jk3jZqewF6TWUtRED6yyXpTIbTokagjc/EKKIn9NOoQEQFFxPeysIR++h/y8MQY61gXIVyEhiZJigEM1+GPa3359Xewu25ZjGaUALRBKV4CYefoLI2Loy+07nuYKwSXZ5Yw7Nrx9HW4gAmNInbKPVJemEDGnxf5uBEe1/UMy3X/9K/2XPthtc4P7Oca3Du0hsDi5e8wO9McnNurFYqAq/1YoNn10x/oNSdEB+hPB0a1k8KoD9IyczHBSdCqi09xaaBLixIAUlFtw==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5096.namprd12.prod.outlook.com (2603:10b6:208:316::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Fri, 24 Sep
 2021 11:49:37 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4544.018; Fri, 24 Sep 2021
 11:49:34 +0000
Date:   Fri, 24 Sep 2021 08:49:33 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc:     stable-commits@vger.kernel.org,
        Mike Marciniszyn <infinipath@intel.com>,
        Doug Ledford <dledford@redhat.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>
Subject: Re: Patch "IB/qib: Fix null pointer subtraction compiler warning"
 has been added to the 5.14-stable tree
Message-ID: <20210924114933.GV964074@nvidia.com>
References: <20210924114420.106491-1-sashal@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210924114420.106491-1-sashal@kernel.org>
X-ClientProxiedBy: MN2PR06CA0025.namprd06.prod.outlook.com
 (2603:10b6:208:23d::30) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR06CA0025.namprd06.prod.outlook.com (2603:10b6:208:23d::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Fri, 24 Sep 2021 11:49:33 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mTjht-004s9q-2n; Fri, 24 Sep 2021 08:49:33 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e73bdf18-df6f-4afb-e280-08d97f51607d
X-MS-TrafficTypeDiagnostic: BL1PR12MB5096:
X-Microsoft-Antispam-PRVS: <BL1PR12MB50961694668CA58155FD6AF0C2A49@BL1PR12MB5096.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q9zUm4cfC3xzV7vtxE8RB5G7/Yo3OLukWXcXI0nQSXm9s5CbeTluAcb5aPJSw9pqfupz8OVBfu8sdh/P6is+MENrMayPJaUk80KnOHUW7weVDCeMkLj2Z6NLUiSqIejLkeloVr3gdfFThqcZrnTGtj4U6Z+7T9ZoVyiGXfSapaF7JKjwuD+ZtVV47HSDjf08O0yFuUBLtbwDdQduhF4nvP6WuvpTA2XUPicXWlUdAeytHxx2DcdBy52oMgusyefr//qqKQtGnczGTgxmjDZIEL4jTH4/aGC9AGi4NqRq/0Fm1nzT9xxU3ZLejULCCFA72X1brMf2GFvod/imRijL8rWZXMJ/op7hfOX8GO7JKvkoUcaxQLAjb/2q9NlSxgTgo5zkqSHAQ6VtVUXwOCgfqBDJa4d1lHgkO7uX9iUYH4H9+ma9iJoF/hBcuZZiIatgKuAWzgSLmK0tX+bcwjotUqpTin+3m2fiMRcFi2PCpzVFvvo1l7AyyJXUhx0uotgkDZ7p5/iuC+gKXjqHQPvdehT8IM7EiB8q56Md6CSlU6wU3jvwwVMCdPMvDKgmC88FXoFKdX8jyjgmIfqvPWGW1dGXF3zflrQy3Rs0UA15hQahqehuXpfx+PmaVdkIMA+85DCc/4ZL7kWxPE4gOAz4/T4RbR+we1Jon93ots8YdjUzmd9m/nkIlwy4kOqrK2Wm9TKi0VSf0/8o8i/XoeNmS7sBcmq4PT0OLOCVRoBFE+KLsuAaayRA/hA3XvrHtwqL3PM0VShgLikCcHp27tLaoA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(33656002)(66946007)(26005)(508600001)(38100700002)(86362001)(66476007)(66556008)(8676002)(316002)(36756003)(83380400001)(1076003)(8936002)(186003)(54906003)(966005)(4744005)(426003)(9746002)(9786002)(4326008)(2616005)(5660300002)(2906002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GBD8W4eLX8HfQkrlxToPrlemhtPl0ohqgQ8lzoqmRD9ISj/bF9H5u2JDrl11?=
 =?us-ascii?Q?3O2P8e845yz6YOPQBkrMnym0F96scXflM/nivVMXB+NPf65j4WucBj2oQ2iT?=
 =?us-ascii?Q?HWH4LMeS1WSmYYwuYho0qxJBBVAbm4WRoDcqC5JI9/r7/6lUz98VtZ7p+SVK?=
 =?us-ascii?Q?YkulPy3NsqdUuaKR3Wq8J2rd4dTsKVPZgtg+f/Wxf+biSHOE/9xZOUDZSGTg?=
 =?us-ascii?Q?93IhFfuF0rNAtkKJIzDLAUJZLinE1CTjWlZUa7tKLp8lq5t7RuXeRu1AyHba?=
 =?us-ascii?Q?8q8dsN9AIKBlRpLjntuZ1wMYPMQsVqeVo4Md32AW1uX/zXZt9+MDQrAz1eMp?=
 =?us-ascii?Q?NmzQbzSDAO9lxrDunV4oge4w1XP7qTy74/N3vmzdlGoU/DfYOA9MFBF0m8lW?=
 =?us-ascii?Q?5spVqW+pLHmtGBflLfrve6NuI22ndw4IsvHcFhzD3F+5hYfN6OCn0NismcJP?=
 =?us-ascii?Q?SEI2hDGhB7a5sXF71mcBiCzRSGbPvUhDsS3ZBibOMvQDAet7x5pFaeyBoliI?=
 =?us-ascii?Q?DUoVY2g+L8mJm4IrZsO8zV+Hsl8jVcccfFfmaIqn880Ge0WZJfcB4FgWzQJl?=
 =?us-ascii?Q?LVvjIqw6X9h4omex4CckTfaB38XKydLqWJOnE1vsyjn9oudrvP19UFZHOAMG?=
 =?us-ascii?Q?xGxAbZqroY0zgGyTDfOZ6fWdXrMsmsRIm6jbm9w2Iyz30/x/xTHcAgj95FRw?=
 =?us-ascii?Q?6Ujuoifb7jb0D7I0OzDVfXzUKJFxXM7u7owBCTV40siYQkjT9atk52Blghw7?=
 =?us-ascii?Q?ZPLX0wuTxD1AcqwFs9A+KtvcRJBgYA/XxV4QokS6QIwpcubIEPSb1cWFvJn9?=
 =?us-ascii?Q?YTzH1k4p8+qrBXkDvocUEqwXLs347B5P0Aui8OgepW+kuOk2n5KH0Q0+h7mU?=
 =?us-ascii?Q?sG1b/ySbRy4GignmdqQfLmlh8j7bQanRQ1CPJevJLOd1G+KI9w9JcRLEg5PX?=
 =?us-ascii?Q?JQxC5DxEkQbdQenMfoxFwuReHYryMx8qgIzs/isMUlJx2vcisfotU3Z5Jy5H?=
 =?us-ascii?Q?QIaVXAkQtSbats3/4QnxCtvWMYF0l1z6XKq2n6Pe+sazC9zk89N0BnZYgwcU?=
 =?us-ascii?Q?k/sCFaXELq8xQD3mSyAzS7MPtTqa34oHDa7E2jkjxXrLXyLjKu71vfpThWYW?=
 =?us-ascii?Q?D1yPL0JNmO8tgkJd7drkdnZUM+3GriWgD1AAgDwNsgfovEjFnQpE9jglIok3?=
 =?us-ascii?Q?iIEbjhUueeAOYALcM7atWY0SvbDHdvJzW6s+fpM3cIQVcu3lozoszAqgKalG?=
 =?us-ascii?Q?ciKRyOyM1EohbXIuAOGUBooDLhL/XleijTQbz8m5p2f2mQVEHWgXgOQ95aIp?=
 =?us-ascii?Q?jjB+SDu/5QJLUxwmXHpy4qNx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e73bdf18-df6f-4afb-e280-08d97f51607d
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2021 11:49:33.9090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uQr9l7MCn9klMAUlHJJhwLtSscNCbdbEFxb7e3gG9stE8HJvtyKAh9o1gnLW6fdJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5096
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 24, 2021 at 07:44:20AM -0400, Sasha Levin wrote:
> This is a note to let you know that I've just added the patch titled
> 
>     IB/qib: Fix null pointer subtraction compiler warning
> 
> to the 5.14-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>      ib-qib-fix-null-pointer-subtraction-compiler-warning.patch
> and it can be found in the queue-5.14 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.

Please don't take this one, it causes compilation failures on some
clang versions. I have another fix queued up that will sort it out
for all compiler versions.

Jason
