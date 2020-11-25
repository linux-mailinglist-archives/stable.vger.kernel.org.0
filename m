Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93DEC2C4819
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 20:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgKYTPv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 14:15:51 -0500
Received: from mail-bn7nam10on2118.outbound.protection.outlook.com ([40.107.92.118]:16993
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725989AbgKYTPv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Nov 2020 14:15:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aw1ILoJRP56MNw6cGX194RTD/eBobMHAfci7L72mo+MXulOKORK96sQ86oHuexY3TaV7bjwhaoPLiGiWsEQCVVsQ05p64BTn1kl2W35XIPGz+GLEadXc9wLqDGadh/Opyr83OTGQmRQh8jmQBn0kLoUp3iMH0d/tEbY0nwote27Rv3IlKNjAwBjjXsjin+kIctsBAdd05svjKpKkbDP5GFhGEMh6MG1tSaKT5H+sRfbeltnTAgqPZVzKFvlC8dLMDUaynrcBGRnAGFXiv5mx40yzbEw9yekyZXWbwOCl3B1yVBgwmTTOt93RyXZsb1D2baVPGwqe96amS+8vxGrM8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lBrBH6LcpFMd1F6plQ6dSCXqKrkmSHB8aorCiN2xXgg=;
 b=g0oZfck0iu865PYjMHT+/w9cgnHFABWVK+9r932mfQTHuXYPQKjezeNHU2aFop8hJoqPZhy17cvjUDUBj9msdJTE9X5Z365z6pizwk6eDnJ/wPnWOcgmZRgYcCb22h2KvQA7ERNmCffty0OjCbvB9xvowSwesuV+QWfAsVmQG4fsgPwno3OUfmYjoxb0MK6ln798x7J7PO1vwWaaraxpS1neMq3iSIfKUMoJlJ/C3NCwkXN7Qb7Eq4GvDvuKsl7SLOnoMnMtv6Vk+zgfwS5MaU6zxv4FHlU8RthKq5NaiHP3OEjUdkLi1MbAokyDvo/ZzlUOKxvLjK53t0ikg+Tcbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass action=none
 header.from=cornelisnetworks.com; dkim=pass header.d=cornelisnetworks.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=CornelisNetworks.onmicrosoft.com;
 s=selector1-CornelisNetworks-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lBrBH6LcpFMd1F6plQ6dSCXqKrkmSHB8aorCiN2xXgg=;
 b=J8Ufrsk8L6Md/y55hMSGvwTYdykWqedcor5Gko2xmVedKLQWblhpjmLKPGb0sfzmORi+Al/7JgaFDsTon1xwr6z3Yy8OcaVugZQJFdDNM887E+yUj0QYfZqPg/6Z6NvsGHJwRZPbivwJBEp9dkcPCz5zChd1v/p2TH07T/88I2XVmGS0nYFgGyl5PUtds+VUZVpZAA9/IxEZOF4IIHY5MK12ngAKUubOcCZb9xXt+43NMuBfSuNhaIkeNRWzF7FQh/riFCd5sk9Mh1vqXPKXsbf6Ovsx3OaTRsqiKvHD9qh5G/8KfNNXj/ThfjTqNt0o4TETCuQ4/ECBoTVrkKIk1A==
Authentication-Results: cornelisnetworks.com; dkim=none (message not signed)
 header.d=none;cornelisnetworks.com; dmarc=none action=none
 header.from=cornelisnetworks.com;
Received: from PH0PR01MB6439.prod.exchangelabs.com (2603:10b6:510:d::22) by
 PH0PR01MB6200.prod.exchangelabs.com (2603:10b6:510:9::5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3611.21; Wed, 25 Nov 2020 19:15:46 +0000
Received: from PH0PR01MB6439.prod.exchangelabs.com
 ([fe80::8b2:9c60:5983:2896]) by PH0PR01MB6439.prod.exchangelabs.com
 ([fe80::8b2:9c60:5983:2896%4]) with mapi id 15.20.3611.022; Wed, 25 Nov 2020
 19:15:46 +0000
Subject: Re: [PATCH for-rc v4] IB/hfi1: Ensure correct mm is used at all times
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     dledford@redhat.com, linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        stable@vger.kernel.org, linux-mm@kvack.org,
        Ira Weiny <ira.weiny@intel.com>
References: <20201123165024.158913.71029.stgit@awfm-01.aw.intel.com>
 <20201125150224.GO5487@ziepe.ca>
From:   Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Message-ID: <cc07055a-b221-359f-7f2c-052a81007499@cornelisnetworks.com>
Date:   Wed, 25 Nov 2020 14:15:42 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
In-Reply-To: <20201125150224.GO5487@ziepe.ca>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.55.54.40]
X-ClientProxiedBy: SJ0PR05CA0036.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::11) To PH0PR01MB6439.prod.exchangelabs.com
 (2603:10b6:510:d::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.55.54.40] (192.55.54.40) by SJ0PR05CA0036.namprd05.prod.outlook.com (2603:10b6:a03:33f::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.6 via Frontend Transport; Wed, 25 Nov 2020 19:15:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a6a37739-a8ef-4717-584d-08d8917682f4
X-MS-TrafficTypeDiagnostic: PH0PR01MB6200:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR01MB6200C5824F031002EF908EE5F4FA0@PH0PR01MB6200.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v4GIxY2SgjbDDzYVnXkPaL8JwSK0RFDbzRLw3lkghQxXGkjX4d/GN/6LegdNwdsRnss5kmf6PMJfIaT0HLKa1oG6QR1wNXoao/sbKeS2lB51FekdJsfWTXRmbhqc+SJXqBa9AmxcKStB7e87D2aNws0RT9Apkhqt2Ex8LJp5od9S40BvvFOauBBRGOddNzMBH3zd//VixAKVOpcAOLAkSnVte/kRv8Muu38nWqT86jg5W3ZyjCLcENUcIvFhfWHdywKFOXdSIDNedrYrvDJe9qKEhGkps/MxrOtEAjDPQ+G8wbKm36z4F87xzpIIj+9Oele6DUvIjL6IA/nWxIk8gtcMks5V3y4V7efy3hG6vYPm9t4Hn9dhzwS8JPFO3PUN/03LSGbibt7f5zVJQjeOavAR7gyJptFDiYHzaSskSXU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR01MB6439.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(376002)(366004)(39830400003)(66476007)(66556008)(316002)(66946007)(4326008)(31686004)(26005)(8936002)(16526019)(6486002)(52116002)(8676002)(53546011)(54906003)(2906002)(44832011)(5660300002)(6916009)(186003)(2616005)(83380400001)(956004)(478600001)(86362001)(36756003)(16576012)(6706004)(31696002)(3940600001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VHgwOHVtcUhpcjJmNHJDNjdKSkxhVDNSaDRSSEh2QmkzczliQ2RuSWFvd0dW?=
 =?utf-8?B?MlV4T3FQYm8wVXhLbUV5SVpqRW9Sa2hqYW1uK21zVGl5UzVFeEFZQzVhbzlE?=
 =?utf-8?B?RGxNOVFnNEtRMzk4MVc0ZlhLV01sdmE1UW9SbHJRWWgyTjB2QTR5NUJGYnhn?=
 =?utf-8?B?S0lCbSt2enZlcWFTTzc0bVY5UlVKVnRYUTk4TGJSSytBNnI0TzJac0tQL0Zu?=
 =?utf-8?B?Qy9PZHlDeUxEVXpzSXNnMDlCcjlrWmQyWHRSZEhuYTFLZmxma2REYTBUTjlS?=
 =?utf-8?B?WEs2citpT2ZySFBId1JMK01FTzUwbTdEaFVrYnpCVjY0VzMybHdWRE1pNWUv?=
 =?utf-8?B?d2xhUDlwUkpPaXMzYWFLc0lrU0lvSkV1RDNnejhJSnBnUVpPLy9IMllHRXYz?=
 =?utf-8?B?ckFoQmtFVFN4alZNd1ZodkJqMS9nWnRUS2prTjFzY3BpejdGdHFqTHBtZnhU?=
 =?utf-8?B?emJEOVRsZjVZa1ZJZUpvcEhyeXo1UFVJQkZUYWVoVTlxUnVrOUpSb2tydDJs?=
 =?utf-8?B?N2hTMWxROVdzODBySk9SZ28waWtPTnZkRjFGUUtRSnU5ZlRlVkJQdUVwbWJD?=
 =?utf-8?B?Q0g5ZGFHcGxJY2I1RjFacUwwVGlpaCtqdTk0dVdqYVlmdllUVk9VTFNOcUlh?=
 =?utf-8?B?bmg1ZmwvQzRUL1h3WnYrTGJLeVNkd0ZRVzVDSElhOE1zY0JQQWU5dmM1aFYw?=
 =?utf-8?B?VkNDNEwxUndwK211V2xNZWFQT0RwbjJ5aEJuQnYwSTBCaVVXY2F6UmFEY1Z2?=
 =?utf-8?B?b0NOVU5XZFJzNDF2WHB3OHNLT3JXRTRMVWlkSlRTZkt3UUlrRDNvY1BPcllH?=
 =?utf-8?B?UHBGV2dFQ2RDNkpKYVY4bGtGODcrN2JwTUlWNGhEa01JdXNGWTZRcS9JZzFR?=
 =?utf-8?B?K3VsN1Y0RnB3djZ2TjhzcDJYaWtaZUI0S0VGYzU3LzFUdHp5THhidFpuK1lK?=
 =?utf-8?B?SHVqOWZ4aWFiVU1sRnQxVVUzNW45TG5ITHd5VDlsZGJ3bHN4Vy9xcGJTQ01J?=
 =?utf-8?B?aTNOcnpwMU1xQTI2L0lQZ2hKWk9xYThkM0ljY25YWU10MDljOWw4cnpUVFNh?=
 =?utf-8?B?TTdiQXNkM1pBVjZlV2RDQWNyeWR5MnRmOUVJemtVdzVKaEZ1cGxWSTFxYm1v?=
 =?utf-8?B?WFV6dEE1Rm4rbWtjTXJyYjA4d1RZdXdnSjVZcUdjM3ltYy9QaTYzUTNJUWo0?=
 =?utf-8?B?MHZINFRyMi8yL1FjT3IzQkJjVDUrNnMrL3h1K1h3MXkrei9tOVZVbHBHWXJ4?=
 =?utf-8?B?dXZDaWxrUlNpc2NENUNzOFBuUWpCYm83WmNaWmhOcVpXSDZKNGpaMTloRXg3?=
 =?utf-8?Q?NJKN6F6I5rKxLkwrX8u3oK21lqWtDv4MG8?=
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6a37739-a8ef-4717-584d-08d8917682f4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR01MB6439.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2020 19:15:46.3439
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: geecfXP1SQ9tqeh4l5nJM1Uxr4zLHOOgp2m9Wtte+AMszflKJgquT3U7l7f1BiqkAHmxnoKAV0O9Ho74BKzUA4af1HuCsFrSqrIg1IdxDJvrpvCQBCeg2o5sdBUwkp/n
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR01MB6200
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/25/2020 10:02 AM, Jason Gunthorpe wrote:
> On Mon, Nov 23, 2020 at 11:50:24AM -0500, Dennis Dalessandro wrote:
>> @@ -133,8 +121,16 @@ void hfi1_mmu_rb_unregister(struct mmu_rb_handler *handler)
>>   	unsigned long flags;
>>   	struct list_head del_list;
>>   
>> +	/*
>> +	 * do_exit() calls exit_mm() before exit_files() which would call close
>> +	 * and end up in here. If there is no mm, then its a kernel thread and
>> +	 * we need to let it continue the removal.
>> +	 */
>> +	if (current->mm && (handler->mn.mm != current->mm))
>> +		return;
>> +
>>   	/* Unregister first so we don't get any more notifications. */
>> -	mmu_notifier_unregister(&handler->mn, handler->mm);
>> +	mmu_notifier_unregister(&handler->mn, handler->mn.mm);
> 
> This logic cannot be right.. The only caller does:
> 
> 		if (pq->handler)
> 			hfi1_mmu_rb_unregister(pq->handler);
> [..]
> 		kfree(pq);
> 
> So this is leaking the mmu_notifier registration if the user manages
> to trigger hfi1_user_sdma_free_queues() from another process.
> 
> Since hfi1_user_sdma_free_queues() is called from close() it doesn't
> look OK.
> 
> When the object that creates the notifier is destroyed the notifier
> should be deleted unconditionally.
> 
> Only accesses to a VA should be qualified to ensure that a notifier is
> registered on current->mm before touching the VA.

Ah yes. I think this just all goes away then. The context init and pq 
allocation is what triggers the registration, whenever we tear it down 
it should do the de-registration. v5 coming up after running tests.

-Denny

