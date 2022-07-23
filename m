Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E921D57EF37
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 15:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233738AbiGWNc2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 09:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiGWNc1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 09:32:27 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2067.outbound.protection.outlook.com [40.107.223.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EECB263B8
        for <stable@vger.kernel.org>; Sat, 23 Jul 2022 06:32:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gy6BOrneZyx8XCZneRPMH9WAY1Q4fv3+MNm4bmsV6XuqB74PwdsSwBvhL66ifOC/88XYvzQrPwHSSqiXNmfYRkV8fUrwACgqQOAtShAV8lL1PesijFdqjn9/BthfAyOCTAQJaj/o1kXR6SPtLmjLPzPsCx8nJ11PFehvGx5PDi7UzKfOpHh3iuD8F8FH977roDkR6JhH2b28HqYUZprcE8yjjkgZ6bweF8+SfrLTZCed07hvwHisDVBZLgOS5BLph1d31qe0wTWLa2A83i/TA9XRNhtpfCH5Cm4tlaG5bjSggl5pgy0nnBV6kSrx8XTyQPANqJAjS0DXOCPpg9DzLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1UEYWGTimmExNGcKHN1G+A3qwFNgvWbXvXQSMi7xc/U=;
 b=UqFCTscFxf+qde6ZZMGL0ZRjuhk2EhyIrtDXyHjmB5mWHulo7SL3+5b7nNaBcuEEmuW+nnezwJIx+U8NffXV/fA3+doe20pyA45MyiUr2NzjAB1OzJTRE2a6s8/S+9piSOUuQCr66WyF/fMPHsmo40z3olPCjTFdMgAaCb3Neb9Ry6+pkNNrs77C8QSE0Jz4DKaXck//6eS9YRO639Kqme7aiMBtYIp3UnF1EAPUZN1nj8kzk/WBIHsnRNUU0xH5+8e1FInfeZ/HFD59nmyAcerwhau+TQX050u2iQ7rpkFDkJzv06b9YvQKWjGaKrq7ME4XouP44yKvO5xfL4PdQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1UEYWGTimmExNGcKHN1G+A3qwFNgvWbXvXQSMi7xc/U=;
 b=S8EiytZ73VZ4KXijhmKUsKtShyaptBcon2l7yJEBe++KeDUvow3ip2i79DhofJvpcb5ZSjToa+MrgUP8n0U5oG+0F8AIcM8i3JI/HC6AzJnZb1QlWKaswLpT654J9zUoiFseBomqFDJgAFyaoAabF1OAkS7a5hVu+P/MSW1Sm1LTPfEXZO/fsVDG0tFLwsK2s1z4TgG+pl+tT/P3cqTnId5Gu0BXTaUohfeTIvWfrEyXoj5xVZ5il8zj7xkFiv7yrfIsiw87uMxdJwbFu7E7BQSbOgjQt/1NxHAERBSa79IxH6N14AjpR8s15MbyN+7FavG27hCiNFGTEGCKcD/nKA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by SA0PR12MB4349.namprd12.prod.outlook.com (2603:10b6:806:98::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Sat, 23 Jul
 2022 13:32:17 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5458.021; Sat, 23 Jul 2022
 13:32:16 +0000
Date:   Sat, 23 Jul 2022 10:32:14 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Ralph Campbell <rcampbell@nvidia.com>
Cc:     linux-mm@kvack.org, Felix Kuehling <felix.kuehling@amd.com>,
        Philip Yang <Philip.Yang@amd.com>,
        Alistair Popple <apopple@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] mm/hmm: fault non-owner device private entries
Message-ID: <20220723133214.GA78800@nvidia.com>
References: <20220722225632.4101276-1-rcampbell@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220722225632.4101276-1-rcampbell@nvidia.com>
X-ClientProxiedBy: MW4P222CA0002.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::7) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 380bbde7-6a37-41f5-b87a-08da6cafc269
X-MS-TrafficTypeDiagnostic: SA0PR12MB4349:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pS1QrnPBHAUdR8Ucai5YkyO4pkw6c4dDh6NWEtjLlDz/81pWY5D8t2HTfcUEj/wPts1IvLJJiEBh2UhL2gWAV5P0bOaEjpWc/+kFYdZ6MZN0osL7Ii38aO75YnreQKV62B9yma6JohRgdZQO220NnzBLzzzurOER9KSvkbTViHVxpgGxBxSYzmetphvEzYqAphmwsSgaRbK47+uTeSlRLQZsn+AI/TBip23XEhOpQocYhEzz85Ix4exAmHEMZYwmkrHuMHV/mT0KjGJg9q6m/jPt7NRA+Tlup1p5pvVtQE5xSqA1ZPr5Pey0bsrKKIwzaPsaBxRNdWhVS5OIPdxopoWMJ+Qz5nzYCC5VLlc7Sq6Zhs7mVM0IQeqZy+Bi4BvjvEGEP0CgFQdly3w7ym7QBMREQv5QLQhmHMV4wx3m4g6cgvRokv9Qq8jEYqVfCeR0i87OLP2Eui4kLoym8Nng4JKJ5W4ybmw3F9BIp32IWsTqoif79PjslYED7YrEwAqzlRXyvKC7bYJsJ2AePuTCKTgCLM8aVwc4GRf4x/rPUo3srw/HwuOFWz5dLaEDYLGEOTzqXgpY5rQ8E8vQ6D413Of2Pua1Ka58weB0hKRYFcWAeavMPMplgLStPK0E3u6G/VCKElvEiaI6hCnzpaPmoB0pnqZkdBUE8flz0yQeUugJnvUrQ7uNJNJZDpv+BiBWaisk4gyETh1mRmFJ/FaQCI3NSlhTgWYxOXf0zmB5MOI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(39860400002)(376002)(346002)(366004)(6486002)(26005)(66556008)(5660300002)(66946007)(8676002)(4326008)(33656002)(66476007)(6862004)(8936002)(478600001)(6512007)(6506007)(6636002)(37006003)(54906003)(1076003)(36756003)(41300700001)(86362001)(186003)(2906002)(316002)(2616005)(4744005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k3+aWXbGA5aoBLq/JdItX7tkML2fjhNEauvc1u/W4kgMwIxMNHMIB2YDN1r8?=
 =?us-ascii?Q?tMqLjJ9pu/FTFd9muYK+j9RI8EOzOD492qOMkGGE2ZJoD9suQxJaJKv+VKm7?=
 =?us-ascii?Q?G2puyxlXa/lKEyZiaPJlXoLimIwC93CzabfoKCjXVx1dZzMij17O/xsKGNXF?=
 =?us-ascii?Q?TdaiMv2dgWPpgZRPzck9m6ZbBpnZPDNLlL9RcaJr2Oc37rOOUCBVyQhpUhgD?=
 =?us-ascii?Q?5w50duJ/ziSdrtTGVvY2sr86F+eY6Xqfmn0lQPsM8R+XHvVVPFctUhz0cnNu?=
 =?us-ascii?Q?gyRefZF2dnHRxfJChr8fblVNlc1uIxMU6j9c7Yx949F3aUzTTb9gnBBju0Wk?=
 =?us-ascii?Q?vENWmWIqGNOlzUqWTDmn0wd4gmWuMm7zEDFIcQOqkFpO7/dASeyxdmjjRztg?=
 =?us-ascii?Q?nm3x5MehgzEjc8xLXzoDiieCVZYchNNlvB0jiXXuGiO4PKJ5Pl1TgDuPAkON?=
 =?us-ascii?Q?ZqT0uzZ8jpzWOXZv37yAP4xkmLMV6ceET6LRvgT4q6+gRna1fJ7TsoyF18z5?=
 =?us-ascii?Q?OrfgsoJFSw/Zy/F0Ij/yViFqquMI5iCQU1mPco4kB1dnFzJeHK+TvGNtPYek?=
 =?us-ascii?Q?puQHmdB82ke/vVO7V4jF6ZhLq0cYVaL0TKlQId/ERTNSpBrwbj0w56ezNnfd?=
 =?us-ascii?Q?uWvGeG8b/VhdldQmsYgKYLNaTI8MUHIZtWNEz4uigx4Jvx+VqrsVFzrDofJQ?=
 =?us-ascii?Q?RM235LM1AyaB28fwFIiDnujLtuyiCezNe0UkTF1lHY7U1xaQhV/sVYDPfdBo?=
 =?us-ascii?Q?PSjW1hIJv3JA6UqTaeejV59HKS+QtxkjVASMaWQ/K7o9Ti/vlpNXXiOl8v7t?=
 =?us-ascii?Q?Kvpjp9VvjbluayXef0DL7quaY5QAUpE+MQyI7SDzA48upnPBrXYDuDWvp6aO?=
 =?us-ascii?Q?O/6b92s98REQbah2XfP4IeePURgEWdGWeGeV+tvu0Lpriq8RIewhTp9NTrN9?=
 =?us-ascii?Q?5TAnx/+GXzCrMRKXFzBEoSyIVanMt3hPQb7+xrxWCNvbZEPhLIYF+nTG2cYO?=
 =?us-ascii?Q?jukO31aO1l2jJNarGZ6CP2L+rnBCPnHZ+B3Sl5Eugg5lMl+/wy1PdvHeU26f?=
 =?us-ascii?Q?CZyIyf/QVlIixmkc+IiF7HYByROvXJLvOAnjX77k6nzHKoUSK5XPwdIDyUE0?=
 =?us-ascii?Q?2gEyzGRpqw31dqd4YEYa9CuQ1Hq86daaVyRhJv8VBfnAfKeJSZmIT4kL/g43?=
 =?us-ascii?Q?QfWXIXNCVKn1KXRdelva7Pe6fqXkzbfAJM4OBMmPm109wsYqmJvWMYWhWqgb?=
 =?us-ascii?Q?MlqCqtBgRSXy8HdDMIAiFrc++Sgtwm6E0whKNzoITPrZDhVk7GHfNJCZZXYW?=
 =?us-ascii?Q?jey/0KY8FE21vanIe/SKl9CfD9OcJRcdpdkzfGDAWMyNl0rY+snEyFRyHGXD?=
 =?us-ascii?Q?gD0cS3Mh60WSCI3XqMlFZ7b31T9400HW1OM4CTH1I5wFSqjSplVvzG5EROJJ?=
 =?us-ascii?Q?TNFnL1lPX7tL/YnIgPv+iOBA57oGY0iGKi2NxhcDrCESMMyih+fZX8g5DX3y?=
 =?us-ascii?Q?zqS3vg9j6v1yRcSQu4oDyuDYgZOSrv3rTKg5LhrX73Y4XQeQPiuoXlpCS5zk?=
 =?us-ascii?Q?NSRolnAe+mvhk8+WLeY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 380bbde7-6a37-41f5-b87a-08da6cafc269
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2022 13:32:16.4849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: psC4+EdKxZugSwLm8KDCRRWmCgXiK5LnwDTz0aoqPetNhdIf21KAoCt1Li8eQQFm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4349
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 22, 2022 at 03:56:32PM -0700, Ralph Campbell wrote:
> If hmm_range_fault() is called with the HMM_PFN_REQ_FAULT flag and a
> device private PTE is found, the hmm_range::dev_private_owner page is
> used to determine if the device private page should not be faulted in.
> However, if the device private page is not owned by the caller,
> hmm_range_fault() returns an error instead of calling migrate_to_ram()
> to fault in the page.
> 
> Cc: stable@vger.kernel.org
> Fixes: 76612d6ce4cc ("mm/hmm: reorganize how !pte_present is handled in hmm_vma_handle_pte()")
> Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
> Reported-by: Felix Kuehling <felix.kuehling@amd.com>
> ---
>  mm/hmm.c | 3 +++
>  1 file changed, 3 insertions(+)

Should we have a test for this ?

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
