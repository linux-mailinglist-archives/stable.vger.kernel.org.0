Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64D045803B1
	for <lists+stable@lfdr.de>; Mon, 25 Jul 2022 19:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbiGYR41 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jul 2022 13:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbiGYR4Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jul 2022 13:56:25 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2077.outbound.protection.outlook.com [40.107.243.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B4D6BCBB
        for <stable@vger.kernel.org>; Mon, 25 Jul 2022 10:56:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gzbnnmfImif5eJCvC7Y0DYdJNYKt03XIbYReDmC9FikHMqdpZ6YlIZM0un8aDQvalnTPHT8LkuQR8g3YV7zuyB71Ma6vtmIrjRGS9Khp2NAe/zdJYvXi7rN9XEraa1bWzDKNTCkUohmMgJW53k9j+x7FejlcvVVp+Ainvv3cOEgCd5+E0Z1Mk2yyuReapl8iGJ3ExYlQfCET7IJAxI5EAygzi0aBDF7lP7GR+e+uLkAGA5X5UjukdKlE4W00JRQYE3o4xHbHi7hdWIdBjIABqPfTzJHLfB91C8hoZMk3T52eZDi5d1hIkEbLYXGfIuA3XMlh99UyJQDKGOjUatHoig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7+US225JqQmvhx4x5VO1ypLXrZVd27/VTbjJ8yU+xO8=;
 b=ZJ/mF+hoj7lHcGvSW9+X07zNKPCXFK5bc7GoNmXaZPPa0XaCy4P6NSDp6wICx9I5zL4EttR8ZWffUi2ETC9iF/60u22cWoA6yypNd/97tPKFSje0oK1+XnHSET+KZ93f3mvBowsVU2LqIphsV/ELDBKCdEoGHXWK57vjehx7XRrPvYVsLZuTZnbTcgNuJsvgeSETTHQbP9mtwbAXAtzA9/pJpSmE/HZlQZ1xkCaO/ezfCBXf3cNTVqf/o+20psEM6GlkQKd9sQQMkEUacs5E8K2a/RQwh6tcSW6C4wJ8QXIHNrdxUD4CIFQsmQCXN3RCgHLwY9j4I+vF6Tq2W06cPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7+US225JqQmvhx4x5VO1ypLXrZVd27/VTbjJ8yU+xO8=;
 b=mJ8NYbE+b5iFOnEXmEsn840/9EauIs+EqcBlcIWPXZTh8WGrITkgkqQPPf4iOzKHYxFNIFQTQ05Qw9hR2qs6Jz6Yi+t2/dfmKqTgVsCT9CfGY9p/2lkn7q6XbMhI1iVUIOL4uEsHUB/VTSONMtHG1muvRiSMYqMUmEvvBFES+zxQjard9wewRPdxaO1r1K8Y5lp1X1MwIsFHnGFIDXqMxpz9qgoVUF0NYLtWcumUmxcf9U2cQ2KK2SHkwvOXxUWAxNdwq8x/23vb/ofDYrrTKF64BKUAWGdF+SimDc+yQNubXa7oUJ7ivxPIOI89GkeZXG8bMjcHWW+YJgw4BXPqZA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB6150.namprd12.prod.outlook.com (2603:10b6:208:3c6::11)
 by MWHPR1201MB0207.namprd12.prod.outlook.com (2603:10b6:301:4d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Mon, 25 Jul
 2022 17:56:21 +0000
Received: from MN0PR12MB6150.namprd12.prod.outlook.com
 ([fe80::30b4:54b4:c046:2e14]) by MN0PR12MB6150.namprd12.prod.outlook.com
 ([fe80::30b4:54b4:c046:2e14%3]) with mapi id 15.20.5458.024; Mon, 25 Jul 2022
 17:56:21 +0000
Message-ID: <afd72eec-1a91-7985-db2b-d2dd0516e819@nvidia.com>
Date:   Mon, 25 Jul 2022 10:56:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] mm/hmm: fault non-owner device private entries
Content-Language: en-US
To:     Alistair Popple <apopple@nvidia.com>
Cc:     linux-mm@kvack.org, Felix Kuehling <felix.kuehling@amd.com>,
        Philip Yang <Philip.Yang@amd.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
References: <20220722225632.4101276-1-rcampbell@nvidia.com>
 <878rohbkeg.fsf@nvdebian.thelocal>
From:   Ralph Campbell <rcampbell@nvidia.com>
In-Reply-To: <878rohbkeg.fsf@nvdebian.thelocal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR03CA0001.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::6) To MN0PR12MB6150.namprd12.prod.outlook.com
 (2603:10b6:208:3c6::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e078f347-e2cd-4444-070b-08da6e66fb65
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0207:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vsWaUPVU3LuaOUYH4UzVwzvjOfJMDUulItrYWH4KwB42fbftX0WKWANEC4afnQKFk7g3neiAQzngTfgAgke7NpaIGxhq69SFDeHHLI/o9tnWVJkfPZUexmv9KBBa9J+t8Twisy1EaiQk5pX+jfNqKniSw8zcQhlFB2UAzN/xr8LYrXGFgkRue0yxR7TGPwdt2qGTirpHPJINfQomCDD5LGz8XReyjX0Z3mOjp7iMIlavPOvc6whfO47cZXXwmW2GKgeeY8C2tw1kXoSRat8zdZmf/F28VGnoKtM+AswMvS4E/Oiqm5GqsB3XasUl/1UYIaD0bauyPSlR9MxrTYw85iM0NSEhAUfkhEF+P4VMOf6c/CxBi651xi6WVQvlqEiMMmP2qiOvidrt7PelzgxLElcXXxRNfXXDdpr4T9yXbnCWUDq6eKUrdCjGQEM8Jnz1wz40xLzeS/MiR3Y20YileCKg0yqRv2n5jr8YgJ/Pvvv1NfaK+ouiyC0B/xJoQeXiEXjW43dz9fLgjOSEXmAl1Q2hiN1MVNFHaLY+lEIAaydEScJhRN3CyJ7Ziyq+k+6q7JiCUOyFXZv4ffBS3Hisd8KlpB0CKgMEGvC8UrOQRiCOE4Ui7+lE0kJ7Ntd5uJDdzMRXADhNqCVXDdAG6WL3TmOSU3INErV5Mvl/KqBT4WcC61xupmkGw16KcHPJd63t5ON11TzL12p5KZ65QGGOpKi1bRewM2s7Gq4s2imqNbdimuflGX6OpLArhlFenJj2fWvXBRAuLhOzPNnR0i4qK/BJn0zBmAtUwUyL9O9bmdmbW6gcxq7P1h4M5pU7B0DgB53+BsvI7/9lKrWUbItqPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6150.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(136003)(376002)(396003)(346002)(38100700002)(86362001)(8936002)(186003)(6862004)(4744005)(5660300002)(31696002)(66556008)(66476007)(2616005)(478600001)(41300700001)(66946007)(6512007)(6486002)(2906002)(8676002)(4326008)(54906003)(37006003)(316002)(6506007)(6666004)(53546011)(36756003)(31686004)(6636002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YTFTYUdWVitIRE1Bb2NSU3ZiVnd0S1NVOTFaNXJ6NFErSXZTdS9Wa3hicEE2?=
 =?utf-8?B?QjBiZUFsRVN5aENBcjNGVTMrVG9zNllIQ0w5Z2lDcmRscHlvY3V0SU5RK2J6?=
 =?utf-8?B?eXEyUC9Jbkc2UHcvMHZmaUIvSThwU1JwaFlxK0x3STYrSXlRVVpCa0NReU9N?=
 =?utf-8?B?OXpqVnVDclNpalArR3FkY29RWTM2KzlWR3J0bzdlZXRKbEZ6SXJFcGI2YURM?=
 =?utf-8?B?a0k0Y1AyQkZPUjB3Q1BhVHdFZzRnTnRIWG9LejYvcjBxQnc5aTJxdUZ6QnBN?=
 =?utf-8?B?dFY1L1crUHNadlJTYXBwVGNjY08xWHJtVkZINU52Zm1xVFFKbW1nRGpSQ2R0?=
 =?utf-8?B?TmF0ZTk1dVNtNVlOM1pKZlZkZjZVVUlkdk53QUtLelBZWDZXdVBHZU9YYk5i?=
 =?utf-8?B?MCt4VEltQnFYSWRub3h6VVJVeGMrUGNOL1VCK0pUQzlGanJscEFRWlJmb1ph?=
 =?utf-8?B?YXg5V2dMUE5KRlNUZmsrSERrVS93VDAwamZEU0tKZmpmcXBZRGczNTFETUtE?=
 =?utf-8?B?U2Y1YWcxemNvOWZWa1l0VFFKUjdrSVJTNGhDVllnS01rV0tOUGliYWRMZUhW?=
 =?utf-8?B?eEcxMUxKSXhrRzg5MmQwRnR4VXZ1eldlUjErdmNTcEpwK0NBY1dQNlMvZDQx?=
 =?utf-8?B?L0hFNHU4M3ppRytGSUNkOWJsY1QrNkZxbUh3cWN4NUQrRGFzT0N2Q1g3ZEti?=
 =?utf-8?B?MWtXWjZpZFRrYm5FdURJeW5NWngvbC92OFhYMFFwT0xiNzhXWTFsSUhBZm5w?=
 =?utf-8?B?UlhqTjMvQnRoM0pwVy96Z3BabWFMbWpSTjFjR0VkME81QUhtaGpYaXFlVy82?=
 =?utf-8?B?bDhmVkY5ODluQldZQVN2YVkvc1RzZkZCYnV6VUVnK1Y3emkrMkwyaFBHUDRx?=
 =?utf-8?B?ZHhZQW44bmlQZStxRlNId21HNjdxbjZGWVdKSkEwbUM2QmUyK2toeEgzMytF?=
 =?utf-8?B?dERmQ0dLYzQ5a2FnWTRmZC9RL1JqRVUwWU9yNTVkZmRqUi9ocDIwVlRML3BL?=
 =?utf-8?B?b0JnNUJ0bHVyc3NoVTJ5c09JQzhtdHhzYjI0WURtclVUcVhMb256emhEUXRn?=
 =?utf-8?B?bFgyZ0tLUmw0MmZROTltSnQ2dUJEZVcxc2EzNVNWeXJGVHdVSk1TR05YRDYz?=
 =?utf-8?B?b3ZidjlQNFJYQ1MxRU52bnc0OUxkK1JiTG5QQUErbTA0VGdBVW50aTZXdmZS?=
 =?utf-8?B?STR4a0svbE9NR04rUmkyN1JWMCtqdURxZEJQV0dRZEl0dGw1aUlJMTVIdjNw?=
 =?utf-8?B?VWtRQVY2bGdZMkhUTUMrNzAzeVVrTnRBZlh4aSt2bWVMV055c2ZkS2FzcnMv?=
 =?utf-8?B?MFdWR2E0Y1liZnF5KzNnRDVlUzlhaVFsc3N1aHdnY2d6ZmhYeDk4UUZoNGRv?=
 =?utf-8?B?a0RyeG5CRkE3b0lBd1p4cUVsNHJmYllIMkt4QWNTVDhqcXByOTZHTmNQTjVi?=
 =?utf-8?B?b3E4dGRrWVRJUmM0Zlg2NDVVU3VDcmh1SGIzb0NYSkZzVWtrdjdGUXkyc08z?=
 =?utf-8?B?UnJ4ZmpzWkdpellWdFR3TWU1VEZ0U2JNa0llQzUwaFVhQlFNbmRMd0FIQ015?=
 =?utf-8?B?cXZkYWNuREVQRXQ0YWFlN0h6elQwN1BRZHZGSXlSYVU3cjE1UkxHTEE0d0FD?=
 =?utf-8?B?cmp2c3BWTk1lU2JNTHlZUWdiSjZGZDdvYWM4cEJsM3J5dWJFcUZ4OUh1ZzVP?=
 =?utf-8?B?RkZ2b29aQm5CT2pnVjROVGYzR055Nk95VXMyL2RCWkdKczg2TURiUW9qZjdL?=
 =?utf-8?B?ek1YSERyQzVZVG1zT3d3WHdCRkFPMm52NGpXajFUS3hmTDM2dFJ2TFZmTGUz?=
 =?utf-8?B?ZUtwVEhMTnd2WG9ibGI2emZXSXZ1S2ROcW5vWGFNU0JCcmlSTWFyVUNPbkJ3?=
 =?utf-8?B?dFFHVWdKTG5BNzhuUU1tYjVONDBwTEJzanFCQ05nTzVzaTA3NDhhN0thNFJH?=
 =?utf-8?B?QkdUV3VPUS9ZdTBpMUxTYjd1ZlFaRGllSWtPK2N4RndkZTgzUFNPcmUrcDd4?=
 =?utf-8?B?eHBYTnRmRjJadnF3RzV1b0dyOHFoWDIydk9DUmFub3MxTmU0bFFiWXdJelNv?=
 =?utf-8?B?dThlS0Z6bE1DTjhta0NLVXdvdGxsZjVBV0x5NWxDb09lbm83SjVYRlRSN3po?=
 =?utf-8?B?U1pyZjF2MjJERjArYVBoeEdyTW5wYmFGMmladGZMdUpXUUIyUmZXc3dTQWF1?=
 =?utf-8?Q?rV9K51Jf9zPGVgOO1KHe9gs=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e078f347-e2cd-4444-070b-08da6e66fb65
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6150.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 17:56:21.1955
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jXiV9+S2cJIDTrnzaEbOGMmmyUca2+tdDKio7hbj0DEbckSPI/KOC5T0/FIfRKvg8ATwKW5jMdO5h9D4V3bmMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0207
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 7/25/22 02:32, Alistair Popple wrote:
> Ralph Campbell <rcampbell@nvidia.com> writes:
>
>> If hmm_range_fault() is called with the HMM_PFN_REQ_FAULT flag and a
>> device private PTE is found, the hmm_range::dev_private_owner page is
>> used to determine if the device private page should not be faulted in.
>> However, if the device private page is not owned by the caller,
>> hmm_range_fault() returns an error instead of calling migrate_to_ram()
>> to fault in the page.
> 		/*
> 		 * Never fault in device private pages, but just report
> 		 * the PFN even if not present.
> 		 */
>
> This comment needs updating because it will be possible to fault in
> device private pages now.
>
> It also looks a bit strange to be checking for device private entries
> twice - I think it would be clearer if hmm_is_device_private_entry() is
> removed and the ownership check done directly in hmm_vma_handle_pte().
>
>   - Alistair

I'll fix this in v2. Thanks for the review.

