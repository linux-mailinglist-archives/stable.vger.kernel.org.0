Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E993462F546
	for <lists+stable@lfdr.de>; Fri, 18 Nov 2022 13:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241918AbiKRMry (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 07:47:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241967AbiKRMrt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 07:47:49 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2070.outbound.protection.outlook.com [40.107.237.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1241B9150C;
        Fri, 18 Nov 2022 04:47:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B9MkV3s/yFakTRuzFMTBOjHPDqXuWODqbOcT5+pGUz1bq83RO8r9PEFD+vMoF1zuE42klCD3/7LR8vBuOvRgse5iHLzPWDY8gvQMIJdmgsZlmAtkwReY1XV8+UQvg4N5BlWMWva1L2oaMzUz3paZDa4zCIuVWcJqLO9vY8pCD2ozeT5ZeWWyJuNJQJMTJQ7loXW0FOarzVBbVQHGuK4j3X+JESdBL1XtILgQFabpHqoD+exxmpVylEm837peakgiabNZXbdyTMULONLV1rQgqnYYICeax0k0lHoC/TAI0/L5VqUR7cKkXwh+Ez/luHtIsiWbwsEaEEQypApKAaCYRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WLGKxUiaLJaytQFbWdT+tBZ5yq82MoFaPc2QnQ5EAEk=;
 b=iZck3JqsCgOx+zKXCa+984iOKxn9rphl3Wat98UINM+BQN1hqMbAbI2+n2OK23+bUJNTb3j72KqUrsU9HibqGC9Lm39zAHe7q6zF6jEKBbL9TR3TUxSzRWXDll91zO5KhiltWj8l+qYqwF1F9UpMjTzQWIFpGONvpmuPNXyxn0ywpSCDcRxKeQmhR+2Hphe826tBuEZg7SPI8Ki1pqB/w2XF9pBtUWz3ShH4n6OII7dxuSFlcERZ2Yde9GVdEYwXKD5PVcCUN5C/CR0RoSxdKe+JgOcUbVLIZ5n6tl6Me/OQdVIAu/0AOTz68WaJxkpD3dvafCvVrzcrFbHn1SUV2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WLGKxUiaLJaytQFbWdT+tBZ5yq82MoFaPc2QnQ5EAEk=;
 b=h2pUOWpwS+lqdJbcevm/dnfxor58seuYjSj6QDteM6ac1UB0pxeLrb6cRoiKxC3ZQmza36mSmR/rUvKY7PP0TB/B7rlVLwdQ3o0jqtvFDhmBHB6uEY9gKMpnTrdbf+7Kz4Rcny9d9HVrs6bUoKRAGFj7WwT7ntyDpn73x4f8VmbMGv8/8gE2X635LM7v7g36Q5bX8ngzuwec8jFkk2Ng4VxxXA3aopf1bzoTFuTN8WkZWDJfUa0n6F0joR20ubNJP/R2dlD1D/EkiXJOi9gc98ime6Fez/kh/SusV56J/tgFt4fxwh/2BUncO0QvQ9a0hJEDhtI+Q0J3jCVCvu4PPA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB6435.namprd12.prod.outlook.com (2603:10b6:208:3ad::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.9; Fri, 18 Nov
 2022 12:47:46 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%7]) with mapi id 15.20.5813.017; Fri, 18 Nov 2022
 12:47:46 +0000
Date:   Fri, 18 Nov 2022 08:47:45 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Qi Zheng <zhengqi.arch@bytedance.com>
Cc:     akpm@linux-foundation.org, akinobu.mita@gmail.com,
        dvyukov@google.com, willy@infradead.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] mm: fix unexpected changes to
 {failslab|fail_page_alloc}.attr
Message-ID: <Y3d+8dgq05akRC14@nvidia.com>
References: <20221118100011.2634-1-zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221118100011.2634-1-zhengqi.arch@bytedance.com>
X-ClientProxiedBy: BL1PR13CA0438.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::23) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB6435:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c37910d-49e9-4bec-d272-08dac963179e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7xMVKqymIfXqAoKjJ/AeApzRs1IcF009VxmuFtJywmdj/Y1q7CPxWfwYj+XiyZSqzz/VKpjTgO1SH3ikWsGge4nZgcS9KTVBGF0kZbngTFlzlhVLYAfOGk9Qwunj2o2b5RP8l2hmKDlNjuTGWRAJJ2vsB9Txbwe8rgTgiBcNgL6CTzxHdwdC7jzBPX2OZnkj3cjUmj9MS0BReRan7XwQnXTtw+xIuD3UdsxqVT0tcb1k/1K2YWyEAqpWSc3AN+V/WVBwC2kCMu/2+OEEHNJFTXrp8BXV93Bu6fL2b+FB5xyQ1neXlzYYn9q7IMb7e+aalcCbgdnxQq+2EZ/tlBy2O7iIL6tVr/WIBgUbjuQRYYX+Y90K7jhud+5MWVnZ0xC3dK05ZyPmawDgdXW949qRMh41ahMy5sqW5OM5g1O1KumAVv4OavnRJs3G1kMRvBZ9WqgHcJRGZmA4pO1ySBTurBoOL1AOrZY9ZNANexYN6hb0meY80pkKLoJpzCjVV6b+AaGlJ4jqvu2LGXiAQ6qzucotT8CWp6RsmJ7HTSLc5FWx1P2GiyJXQHe77nVnpr6MBwFxMsT+QDnHV0s8esDS9iB4D1pL2HCuDxt6+o9Qry7+SqDAPFsjaCFL1UivUB1nxOGj4DZsVcxDlrfoCYCjDcdM7M5EpoiNF3si+rKvaQq5zuG0/8Em5p5lu1Z0vwF/D+7UwDGzECwBumaSi+bB65cFUT5Ak3DcWRTyNAuG/WljP0tiOVzMycB3GmmjuQK+dTIQGfy7klFQ2g8kV+aZnEza9jnutmUGDKIDYJDxWvU9X9ysvFAh2PUm+UlXCJTp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(376002)(136003)(396003)(39860400002)(451199015)(86362001)(2906002)(4744005)(41300700001)(8936002)(5660300002)(478600001)(83380400001)(966005)(6486002)(26005)(6506007)(6512007)(186003)(2616005)(66946007)(38100700002)(4326008)(8676002)(66476007)(66556008)(6916009)(316002)(36756003)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ypT8aGU2uk/GeY0kj2cmSxfkQpVwUf0BznsbbPs9QW4fPt3ubdM/Q2XJaPwb?=
 =?us-ascii?Q?8t2ZFbIjXIjqJGXWPM4mTkBnUhJdnHm2GXaxfJvh6FWN+ytuzou27+pfyeSj?=
 =?us-ascii?Q?DYyM+d3wjwZP1tWezoha514zjtBTuSfowaLVP19Z/OBUpo8AkQmyxQOeUmuP?=
 =?us-ascii?Q?h1BRF4cY8g3WLhyUIFu7c5CJ/UiTae6aG48kOPolX2q51nozRTR5UurlLxVZ?=
 =?us-ascii?Q?GxUqE31QGjfWiHcLZFax6/5A/TNM+pRVZ51+mnh2OWFZt1836dkGB0pcu5A1?=
 =?us-ascii?Q?b6PES2StdfrXSf02neoYuZAFTVJDQuEmpbm5/NwPYOS8wEBZUrOqsatf4OXx?=
 =?us-ascii?Q?qTuReKFZPv4wsnI0I7jS/m6tJw7JraRETvKpNv0c49Vjezc+OH/jzvisuSri?=
 =?us-ascii?Q?BQs1UnxP4UEMKAKzFYm+sHatUxYGk5jrbXaJdmu8NzKrqB+a01vVsWfDBFom?=
 =?us-ascii?Q?x9F2bCREP1Zwx8uzu+DKhnWqv+wIO0nlZtWUNM/uUCRyo+ngyQomz7oEpVTv?=
 =?us-ascii?Q?a856GUp6Nut2HYgDNfwv8Piy+sgIflnfFqfuJhUTuARxyOYgldsmJVed/DWK?=
 =?us-ascii?Q?91hBbt7DmIJn6HUXaH8rH+vvBd80uyiPUCM8itUAeCvIyJUzSOI2vRx4c7UI?=
 =?us-ascii?Q?OeobFSmQmzpn8X34U+h2ac7By+H9KVcgp0LHnXtjeW4Jl3GSmgGrQ4JoQwJ2?=
 =?us-ascii?Q?m0+2VbvckzQW8l2uPMBHmXUM+2i+yCjn0T2pD1CXOw6LQYUiZQnoMa6G5It4?=
 =?us-ascii?Q?2lelPGT8zqWY0T6gzJgRGSw0SbsRxS5X34NVxeK2Hx79ijNPQMfnV4f5G1qP?=
 =?us-ascii?Q?WPzni9fm7+0jdtG6LfjU4RTRHd8nEwaUTkLBBaFXYJj44qweLYTGZr7h87lt?=
 =?us-ascii?Q?x2s9GKN9nGfRjPWx658LA6lbnbgm9L6bzbzyVrdoGRQrYUpIJHm0uG5x9IXp?=
 =?us-ascii?Q?2iDy7A5vkGHEzYh1BtY/Bn6uasCEQFdxN1IAE1UqcJ8/E7J2UPmhbEDJN9L4?=
 =?us-ascii?Q?hxnUEoqU8TjvEGGijJUxuZoHrQ0SQkQIgG2fsiAC9DsIY14/3jVdc+BEPN1R?=
 =?us-ascii?Q?kANIUjJm+VvB+OMf18T6nlt8+w4LId5LwVUmGOlGe99Oe0769XMQDVtAMJec?=
 =?us-ascii?Q?s5Z4i8D5Cz9gmIiEMIYaW+n1OQKRypZFf00KDQHkBgNi8oVO0LkKI6EwDpeg?=
 =?us-ascii?Q?1K8iYd9n1pUfsD/DvOWtJUHwqf9D/6ucCp5a3YpHqTmZqs3UVP2xgIVgIzTf?=
 =?us-ascii?Q?JuSInuOxoOpwK9PH5x6PG5sPz/rptNvFtrqpBST/6Zy7rhlH+morPKkeMK8/?=
 =?us-ascii?Q?JkqeFUGPDFZSB23VVjzlK5ye9r0oF7xBLCF4QTHY+J5TURDr7j+JzWddTspG?=
 =?us-ascii?Q?LQSr2Dnou3ivMcbu/UOFenMxDvb6G7qqh+a/j/vP7/PlPgrmGwx2adJl2zEv?=
 =?us-ascii?Q?1cNs3UqAKzfs2VLsVNWB9T8dqI2t5rVbU35W+dGmXWSon/Uo1C60yEbjoR0F?=
 =?us-ascii?Q?Sh3lHRg31Lb81Sg5FJucuqxnBIxZzo4MGQfC57LhTSU6ASLfvujt4ZBTz8AS?=
 =?us-ascii?Q?8aVOPDhnrD/q0hbmpZk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c37910d-49e9-4bec-d272-08dac963179e
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2022 12:47:46.3607
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M7cKFK1gpoQDuNieUpFM0meofcmev9g2mz6ojeTXs3nfz/2c04bQ1zGbAwF2a4pj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6435
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 18, 2022 at 06:00:11PM +0800, Qi Zheng wrote:
> When we specify __GFP_NOWARN, we only expect that no warnings
> will be issued for current caller. But in the __should_failslab()
> and __should_fail_alloc_page(), the local GFP flags alter the
> global {failslab|fail_page_alloc}.attr, which is persistent and
> shared by all tasks. This is not what we expected, let's fix it.
> 
> Cc: stable@vger.kernel.org
> Fixes: 3f913fc5f974 ("mm: fix missing handler for __GFP_NOWARN")
> Reported-by: Dmitry Vyukov <dvyukov@google.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
>  v1: https://lore.kernel.org/lkml/20221107033109.59709-1-zhengqi.arch@bytedance.com/
>  v2: https://lore.kernel.org/lkml/20221108035232.87180-1-zhengqi.arch@bytedance.com/

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
