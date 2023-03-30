Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D41FD6CF97F
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 05:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjC3DQB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 23:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjC3DP6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 23:15:58 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2053.outbound.protection.outlook.com [40.107.244.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A04F55BF
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 20:15:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b6B4PZrkLM8vKzFM1hLZJz6aFKIxZfv48sllfALXOYtYEioGTZGxevd9llORIp1cw2tEUm+e+v+zm9LT4AYQzsGDFlcTr4ENKfVCO9OkjNkgEJS6UIU66OcSlv6tewmErjggI5YpxGVQP02u96LL/zCAvlS3XVTA1nEdeYSjKE4KtzLZY9rcUHbiPWyBS8mxVeTSB8SKMcdxVC+Ic7NzbhRDoEa3lgrDZxfAZFRPe3GtnUhqwsOoEgM8cGcBfFurMYWA4OIH6H00P+sDO9YXkBL1TsPLk/fcMc33x89QNfKrduMgqj2htMoSZC1RW9J6uYP2iQrKS1G+w6IWlDsuQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s0Ukv29Hkts/Ni4uxasjMZSuQa6STa91LkmbyXGJ/gE=;
 b=mO1NYyp5aJmWhMPw42bsViMwLj+itzpYH1wrxpApLkMd5PIE3EBzeZkgS6C6Q1MPOzq4CnidjxBIAkVjLAGIjx2L0NiiAmd8wg0EvyCMCfNWH2+eFlo5Ii4rpq1sy2fC1wguv1/PoIxajQ+bw3qtiE/bvqVvuqVYDbQAhEygd9lVhBSkQFIzMp9y4byANwoA4arnNaU7mBZOrcCI6qYlxTW6RrCFf1SACiEkhc1FxL8m5DsxK0UdWsU+uOr8m9KrJ9nOrE1VcutXjrSDPC8/1gTzSiGqZtpPs+7Jt5dCHAfynlz4tswOOvUqvQtqY1qUmujyXXK3iS0sdgF70VyCXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s0Ukv29Hkts/Ni4uxasjMZSuQa6STa91LkmbyXGJ/gE=;
 b=KOejPDDwkiyAVCW8JOBhbJrYl4mfj4TdS5DGFllr3vgV83lEmML9frNTw227n4kxzbcvLDv97T096I67xh2YK92hBySM1a0tP9GyzFtty+SZGrzGCSaRZNDiXBTAyG2JGvP869XtsZARkURiJWgT0EUc+cJubsWCEaet6gy16YK65vu6h8VKruJXwPCxsambR6eLpPL7bOc1/tgfjWs42xOnBQ51e5naIJeNjteBK6U7QHCvAh7GUlxPdlQ0CF2zG+2v3xwfdP+gNbWp7ALasJ8niON5MUMnDtyCKfjwC87k8uMOf9UQ+BYL1tp4fGWq/4vk6xU0+UToJ7FPc0H6xg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by SN7PR12MB6814.namprd12.prod.outlook.com (2603:10b6:806:266::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Thu, 30 Mar
 2023 03:15:48 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::84b1:7c9:e9f0:bab5]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::84b1:7c9:e9f0:bab5%7]) with mapi id 15.20.6222.035; Thu, 30 Mar 2023
 03:15:47 +0000
References: <20230330012519.804116-1-apopple@nvidia.com>
 <ZCTykyabcaS98Jnm@infradead.org>
User-agent: mu4e 1.8.10; emacs 28.2
From:   Alistair Popple <apopple@nvidia.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Ralph Campbell <rcampbell@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        nouveau@lists.freedesktop.org,
        Matthew Wilcox <willy@infradead.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm: Take a page reference when removing device
 exclusive entries
Date:   Thu, 30 Mar 2023 14:11:29 +1100
In-reply-to: <ZCTykyabcaS98Jnm@infradead.org>
Message-ID: <875yajapzz.fsf@nvidia.com>
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0058.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::33) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|SN7PR12MB6814:EE_
X-MS-Office365-Filtering-Correlation-Id: 1fef56df-2df1-474a-8d4b-08db30cd0e8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZesSMmalGWW6VGT6RMWXsYerP7WVA0CpLdTWiKb/M+vR8fwbb/a6m+VnwgqbUXbgqDwxcLuqZgglBy7XMvDUPtG39XsQjKz2odWav2KPJ4Fhty967+Kh6N0quqdUMJLDgVpxhx8TdgK0LDVpD44mvUjO1fzEx+RKPsJGvjjLaT/xzzXDDquvwFHfDvhGGVtrft6EQ7f4dKc0tFVqrNr1lp963IFuwFfdb/3e+FZk2voMk1JqDN7M+U3/mhiYPPiEb0GtztKAYvobp2JJEIwVJClvuPy1zW8oH+B0tJd+HhE4iJx2mADQKbG/GgBlEhsMPkQxjJqm93FR428dpI/Wd+8ctXDenXwQYYLy3KQMFNtn3OWOuxyWKiHPcNh5MdmIzJYTuVCG1jVsa5vYaa4lSDAdMsuyMyCDbIQUtQKL38PbCOUoIPmUh1Kwxt3fWs40Sl4nIBaJZyq/k+qbXRdomdf4PpIpVEXH7oG0XvL+EOAUGQKVYSdQXCliBrLJAHE51vKBDcPh/TibpjQo1i/Y0L1aXyUUiIJIMDBQoHXHqoDIpGCRthgFdpQy9sMmwx+1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(376002)(366004)(136003)(346002)(451199021)(38100700002)(36756003)(86362001)(66899021)(6506007)(54906003)(186003)(478600001)(6512007)(316002)(66946007)(41300700001)(4744005)(4326008)(26005)(8676002)(2616005)(6916009)(2906002)(6486002)(66476007)(66556008)(6666004)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aofK7z8sOWu7XPzFCEChIQ2tomgJVBzJKusrpZbR4cHhf1fMJ4fMZXXel3dE?=
 =?us-ascii?Q?gd8iNz1B9gO5kKA85eyeY0AOjI90qCI1+GRkpFU4FPMAt1M1/zTLW5DS5YA1?=
 =?us-ascii?Q?uD8mUViG0h30I0xX285Zrc7vcc2oEb1mEsLOcrMZ9HPkLvrBCpSQvxjJKvDs?=
 =?us-ascii?Q?rRo4v692cR74y9fPUdrrKE9agWYml5zzk2RZmIpH1/RHiJbuvi945+9ebQkp?=
 =?us-ascii?Q?LBMOHk/xfeYk292ljfVMeEkgZRgQK9N4ifEgPaZzwHCfZxS6FLswyxXdmECb?=
 =?us-ascii?Q?TitDJShYRYtfU2ZAkl2mpAX32PG2UE5PR+5ppbuvv8mh1FGj2uTKESOz7Svk?=
 =?us-ascii?Q?gMZtaGnPURB2g880YH7hdYfNzSJNXKuVGnjCMkONelXjlCeUqq8mdYMt0gWG?=
 =?us-ascii?Q?HWcnA0YdprkS+0R42ehRuIPuoiHVRZ+DNlYPz5wxfRFGRF8qLvGvU2GDRE+E?=
 =?us-ascii?Q?8wvs0Cjzdje2vNKpTKL8iA6oJ74TMxKbT8zk0InPc1XgE8SGGM44mDxqQNvS?=
 =?us-ascii?Q?6mbUw/ukGhBW67Xuc99cc2qVK7DJAI1tMgQhRKCLXIAzcOdUE/AVQSu3UDPS?=
 =?us-ascii?Q?r5knApKV+Bz+vuqbvIwQa9nuU+mDL5J2jl4mzeeJ/D3E0IUob28SCNe+YF3Q?=
 =?us-ascii?Q?dgJg8WlazYRiG9LRRBheEFS/Td8zKEzeGCBucEN+8p3ju9ntVBoHB4y1l+rc?=
 =?us-ascii?Q?GaDiVz1GOxjQg42/4v8tjzFD0PCtd842EJFzstivBxfl58+j2//KBJKY3VzV?=
 =?us-ascii?Q?kretdaLLgBIUArsxj3xp/YvZyjqofbDeSCj47wnzTdcnJ+z0NZMP7OgnD0BT?=
 =?us-ascii?Q?+PlnUXpnJfBesNZ6aIgpJfB3lC+ahVSLhkPOjumitFWa5nYGalgHvLPePj4V?=
 =?us-ascii?Q?eGKqX2x7wg6+uNkH0VWFGpBSoB63f/vK8m5libU78oPUwhyB5Q4g0xBZx8lY?=
 =?us-ascii?Q?kCIg9oDw10BursQXgki/OSSxbfH+HbDSLMc4aDo5UApSopx/fcRklEH3ZF3j?=
 =?us-ascii?Q?ZnLIQZZekaZcuw6NQ7Gb82uWeMUNKJ0DBgSC1TizB8ghxjFVdTwjA6j2odEA?=
 =?us-ascii?Q?ccGr3hYCfM/wgtdqnwMky1hcYz7T8ff9JFGv9LHDauVXMGwELXaHReukaRro?=
 =?us-ascii?Q?2wTYpwJWa29kGE3GhbqqFwBvqCEzpv5ffUXuM4TQwfprJvsTIOxvebF6RshG?=
 =?us-ascii?Q?yeynvHTiXUXnZhLRSNdtOvTGQBDS6e1IKDwhQxrSXlKkMg5I4ekDf5vlThkF?=
 =?us-ascii?Q?LFk7v6iiI9cUQNidC2WAFh+/Z/Q9BEbbF7dNRB4uTCOlR0CsSBKTDdqSC19y?=
 =?us-ascii?Q?MYHzh4NL2ASiWAWKd8Vcw16FsKuMmZXTte7W8emKQnAnPzJ95qsStYgeOEoo?=
 =?us-ascii?Q?9gkoZX+jC+u0hE3n3vsgnTa3cO0FD+v4s5H8jxP15SRmpBAJEoVwzkPms2RV?=
 =?us-ascii?Q?SYBlPgR3ajdcY+iUqWUmBgxaUVvJR+nI8NXzIDlIFZnFAfy4f+NBWOBtk9ca?=
 =?us-ascii?Q?cbaimNb5zcqvWNYOgcfuCCWFQmTZ024+Jqg6ecJvgZrayjA+AF4fhPLHHYWJ?=
 =?us-ascii?Q?HoWM9ANvVEbnN7v10nOLhBa79adT69J+D9aNGmTc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fef56df-2df1-474a-8d4b-08db30cd0e8b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 03:15:47.5409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aH0kc+MJF4PQvUafZV/znLk5IBsUHV1zXiz6fSAcNZuRUOsoX1m2l3g6gC4KMXF0/qR86icQNj1Vp+KPS/84bQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6814
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Christoph Hellwig <hch@infradead.org> writes:

> s/page/folio/ in the entire commit log?

I debated that but settled on leaving it as is because device exclusive
entries only deal with non-compound pages for now and didn't want to
give any other impression. Happy to change that though if people think
it would be better/clearer.
