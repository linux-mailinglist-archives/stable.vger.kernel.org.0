Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC74627606
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 07:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234021AbiKNGnZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 01:43:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbiKNGnY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 01:43:24 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2088.outbound.protection.outlook.com [40.107.244.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 008E8D7A;
        Sun, 13 Nov 2022 22:43:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AViqGaBl2jeDaRW+GP25IxEWVLTa+vEbhojLrzl0PqnL1OBtDWevLBQ4PuTfEyjot5ZpkYw++Uw8b61pGiTZyyQq2SvEnZUiubilxq/B6tMYA/KMcpJZV0S/3R+4LFXzkzZAQdBzTJKFlJ2SZIE6B4pai4EJFPEm5g99Pf7RJv8/Tdmbj6jibf9dCjONiatiSNo8mS/DXuVK1Kf3T4fhLajiT4dLiPxY8tKfzMu2e55nIvIqLTZ9Tnzaq0JApBp90DhMydiZpwlRn59Ito9G4ZbDWlvb6cGMsxRXzBz9atj1y7yxS3eYTcLVISfivwBC5Fluqhn1r/or5LSclv+WEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GY4i1PHAO9JNYwNEMbjxTJeZOx5paz/Z9i/dhgm0eng=;
 b=bazDJNGiR288RqfmbVh8wiMr2ELbOwwDr9k+k/kG8Cb6k+03WjDfEiyR19Tr3+VFWYU4Ck5fdENmpY0nfPmUXwfK4hkDrEPmoKmdiXypWtakmaHZfyThqXe7QInBUeQVX+npmDJae6quSB0nYPCDUQX5QKS8K5JnTseTwBbSCZtg8a61wKT9z7Xb+ssoGRHv82xyKPxY2ZOXcvORuBjHRUuR/0RCt8m9F9gT4ZSCoHP7FQQn/LPMOaY4WWpiXv6Ce7oB+sJtKBrvcOv3MA18dtbp3efWMFdZ+4efzttXunD1WjKaGmm+GtJgkns1fwnNhpn0gSWX6GyqFjUKDZSkEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GY4i1PHAO9JNYwNEMbjxTJeZOx5paz/Z9i/dhgm0eng=;
 b=NVPi8eLBgjab5FahE15Bi/CugoZ4bSOemU0nyb6aodN/Nmb9Qky5I0snmnXlcC49sbb2IFXYZ+7CTeW4SOXpVFQZM689lkHfCN0OQ8H4j3iASQfKndN9CF3vfIVFSo604wAvIBm3KIm7TDnwuHQ1utd/nXqKb8vT/9vzM0JgPpsB3gDt4+qR3Y0JEMpts5QtjK6NF/hwyGqiqh2mMuGyQukNTS/demTT2HhCw0IUAT/xlKk91n8MO7EQkH9WSABkYp3rPITP8v0RV748mZ1XKBU9PwsNHKsHVUYjMY73yOE2GjLhAOylhN9Fm+5mwOlv5/lDRO6nU9Ccf0uP5QOA6Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by IA1PR12MB7688.namprd12.prod.outlook.com (2603:10b6:208:420::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Mon, 14 Nov
 2022 06:43:21 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::a60d:334d:2531:d031]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::a60d:334d:2531:d031%7]) with mapi id 15.20.5813.017; Mon, 14 Nov 2022
 06:43:20 +0000
References: <20221110203132.1498183-1-peterx@redhat.com>
 <20221110203132.1498183-2-peterx@redhat.com> <87tu36icej.fsf@nvidia.com>
 <Y3GELocAJ+p+gKpc@x1n>
User-agent: mu4e 1.8.10; emacs 28.2
From:   Alistair Popple <apopple@nvidia.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Ives van Hoorne <ives@codesandbox.io>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/migrate: Fix read-only page got writable when
 recover pte
Date:   Mon, 14 Nov 2022 17:22:15 +1100
In-reply-to: <Y3GELocAJ+p+gKpc@x1n>
Message-ID: <871qq6vxx6.fsf@nvidia.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0P220CA0023.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::21) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|IA1PR12MB7688:EE_
X-MS-Office365-Filtering-Correlation-Id: 19b13f5c-9541-4524-217b-08dac60b8508
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ppY5opRO3zWsvMhxi9j8Gwl8CHyLxx9MJVsKT/5shzk9/nUbNNqtSkA7N464uWKG/b9WYTdsO7DvLU9/C9FJXRqsDikjZjpd2FfmbmcQHiYisT+MhSoAXT7EDzdSbeQCI4lPEnmcOtXxrpF1sgMQ/hCm7XJhO2BvVgqvtp+rHzH0I1j1DaOUzWUZNDCjnOaUYcNykxWb23hNtyPy1R0EqOUPIp6rHl77/1kLVdSn0dejuF7NNdYsAXPZY/WHT3Tqxs/tuz1cTPDk6tumVaIEEL5kJBiSoLsfPsD2aRNj9NY+hFVOgLeZFLqVdO6lLZjeriMKQ+yUhTTfZr4g/GsPJ2a2jQp0xLQbxrp1wqYeGPqiK9/dC4W5Th5mQ/Y0CeYNrkJJAhNKsYqXtj1CtYVPKqtUr68yQnqci77p1U2FixXN+QIrM2qDRL8D8AMWhjOjQSFG7+H29ONO6Mll3v1sd74GHRJOcU3kLEqZuRjmb4rzjFpoPscigSZne6p8dmWXr7ziVnTMk61wPcgcMX32x2WUwfw4aCjgKbO6/2JCr4hSbKj+DwXgOuaS80MCHvtTzDZkLeEKY89NBacMC2wym9vpwR44S38D//M9B6vIMKHNamU6r6I8dHcYEjEfxWrM98pGJBO1A2oXyikbaPBNYE1tQ5HGkAd5ObciIWicpitciPb0iC3BiMeOhXYEzxky
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(366004)(39860400002)(136003)(346002)(451199015)(2906002)(41300700001)(36756003)(8936002)(7416002)(5660300002)(186003)(66946007)(2616005)(8676002)(4326008)(66476007)(66556008)(86362001)(6512007)(6916009)(54906003)(6486002)(83380400001)(26005)(316002)(6506007)(6666004)(38100700002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4Or/2CJih7cszDrgL9l5lOhCbm/iR3a0gK/G5MWf7SCVZ/dWkbCF4JrVzQae?=
 =?us-ascii?Q?jOuCuHvr7Yf260BgvB28iEX+1ccfoibaXOXK44ZtS38f3dEOYLcCVf5uRQVK?=
 =?us-ascii?Q?zyIibc6f6cFcSsPG50Bk4a3iu5oRmyWD4nDadR3K4yFRQI7IiGMw5fiQO6Bi?=
 =?us-ascii?Q?3YRz2KihSdvOpJBOSlypAwwahdcnTwUNi515kczPKFIl/t9QcE/oMmQyD6oc?=
 =?us-ascii?Q?LRPNRMU/Yj9F1ti1qZuXpv1DlGLP0C9XJUFnFlHtUw/3PZ0KnJY1NkMxYYWN?=
 =?us-ascii?Q?3HCD7NHxBQWmOleAOHIU+Huriv+LGoBediH+pA0Uvu8S5Qq+XU+OwrKUQjsv?=
 =?us-ascii?Q?O4yJ4yfBZrsh1BLDV7HEaKkzjlFU46j8iTP0bO/kUDJah7m5kan9eE6QrRYk?=
 =?us-ascii?Q?WII2GXyfln7U6EcpziTnMw6WWgP3Ibqsen1WHN/Mtql/r+xeAYbAhiP40fo/?=
 =?us-ascii?Q?DjAaodIyyZkX1oliEMCyaQtByzkioSjxPyxbRZ/spXPdfq17cdTHOkmvHd6I?=
 =?us-ascii?Q?OH258DlAXGLaYsaH/mDEpNttIlBCtAlXdNZey6oqwxy+vWaktIU2C5CZDlSJ?=
 =?us-ascii?Q?d+7WNkUHSkze2AlBmdrMq0DI54jmv1d+VTSZ4ZTAh8YQD4cOjljLpsIfW2sx?=
 =?us-ascii?Q?Xgu/nOuCMcVSlOdMIFrb6mCbF4eebGBMFp9SXsFC+EbrPgjK71hoyJbnv2No?=
 =?us-ascii?Q?TPZRB8lRSMaTB+XjjNBI3lLJdcGYMPnrp3Qs7givOKL1Mlpji1honGocYoBd?=
 =?us-ascii?Q?wnXHKhF1+iEcQZTwas7biweNYk4y9J1t3Zy+UwANsMrTDAYz7SYtK192p94/?=
 =?us-ascii?Q?yhatGfsfY78RuUEiJEz2T5g8BSuAgIQXKn+ViBVl2H57tfW1Q/DcV+OfZMC2?=
 =?us-ascii?Q?wCp+5EyXW+89cL8AnwgexKZEIQnzr1FKypbMMA6XUCB1PnvMXyixLrIcyNgY?=
 =?us-ascii?Q?OJ/UknAsUe7xVm0C6JlaI1BuWbEllbNSnREGE8Gqus3yg2peJ9YBT+vAUiMP?=
 =?us-ascii?Q?E0vFiqqm6GIc5w2ezC6/FtJC1SgLgrNHd5evMbNAv2YaMueWuwmrH6hxp/3L?=
 =?us-ascii?Q?0TyCBHiChNDCHx7kbXhbz+oWfxNYo2tr4w+7t+AzVftWsV7dhzHU6YuJbcjr?=
 =?us-ascii?Q?UcMld710K2u/Im1VsD3Zn7yP0XWwgtqP4TApkbGr+RrZoo/HWqyNZYbJjUnm?=
 =?us-ascii?Q?kKoaKSXrr5jCzffN1PnIrU3WjevXX8/z1E149jQOXCtzRX1WL+QvJKThVfXX?=
 =?us-ascii?Q?JJWGzdy3NLqyoH6j8k/0k89JK7EZU2HYO7hJ+F0Zvh/xOiMXahQ0VrLV/pxo?=
 =?us-ascii?Q?lXDRjgkFiAkkOBEyinyVHnCQSu8AQf8hGu1PYQc1Oscd6IzPDm4dTOnMonJD?=
 =?us-ascii?Q?6jkUhCdM2IOXO10jTy7czduf89cAzmcejsDiteNR/AFCPz+clM05PijANfH9?=
 =?us-ascii?Q?MGaGk/LCje1U175ZOiYK7XFTZUUI1M7URqhEHAf8mxk5wIWjE1VIzv+YO7g+?=
 =?us-ascii?Q?jAcX+fcXOaxLZIOG7xu0nibmblrW02/1DP93eVEfzauNUbD416qtMLxEIt9R?=
 =?us-ascii?Q?LSzouP2u4bKc7nF0wc2RaJQ5Fh/cswv9a12jSKef?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19b13f5c-9541-4524-217b-08dac60b8508
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2022 06:43:20.7845
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZSZSW4bxzUqK4Wh0ISXCRZbjBIFs5w94MiwLh9p1lTsa+PNVnBgDW0nqhYxjlT/lT2tgmSejAKKBdxbbUQmykg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7688
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Peter Xu <peterx@redhat.com> writes:

> On Fri, Nov 11, 2022 at 10:42:13AM +1100, Alistair Popple wrote:
>> Hi Peter, for the patch feel free to add:
>> 
>> Reviewed-by: Alistair Popple <apopple@nvidia.com>
>
> Will do, thanks.
>
>> 
>> I did wonder if this should be backported further for migrate_vma as
>> well given that a migration failure there might lead a shmem read-only
>> PTE to become read-write. I couldn't think of an obvious reason why that
>> would cause an actual problem though.
>> 
>> I think folio_mkclean() will wrprotect the pte for writeback to swap,
>> but it holds the page lock which prevents migrate_vma installing
>> migration entries in the first place.
>> 
>> I suppose there is a small window there because migrate_vma will unlock
>> the page before removing the migration entries. So to be safe we could
>> consider going back to 8763cb45ab96 ("mm/migrate: new memory migration
>> helper for use with device memory") but I doubt in practice it's a real
>> problem.
>
> IIRC migrate_vma API only supports anonymous memory, then it's not
> affected by this issue?

It does only support anonymous memory, but it doesn't actually check
that until after the page mapping has already been replaced with
migration entries.

So I was worried that could remap a previously read-only page as
read-write and what interaction that would have with a page that was
swapped out to disk say. But I haven't tought of a case where that would
be a problem, and I'm pretty convinced it isn't. It's just I haven't had
the time to entirely prove that for myself.

> One thing reminded me is I thought mprotect could be affected but I think
> it's actually not, because mprotect is vma-based, and that should always be
> fine with current mk_pte().  I'll remove the paragraph on mprotect in the
> commit message; that could be slightly misleading.

