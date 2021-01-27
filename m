Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54C59305ED9
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 15:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235118AbhA0O5z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 09:57:55 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:44551 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234398AbhA0OzG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jan 2021 09:55:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1611759233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zIJiPYieEGMw3HEPoaciUxdI6Z+vZp0M6793naW/nCg=;
        b=E1Axr0cHALpQihEJGn6ULdxore7h1JIEJmfjnl8t/ADA8dFCkPFfZnngpj0XJV98GlKX0G
        sVSXO9ACjBmjemGuZpZWa1hLeI7nFm0LXe1xmwNaP4bU04gPJcTnzBBCT+YbiS+5pbCtNR
        jXPhnC9qDwhrnI/sLkmtFIPmUXyh/SI=
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05lp2106.outbound.protection.outlook.com [104.47.18.106])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-32-wR7SsDN3N2GDaRBgXj152A-1; Wed, 27 Jan 2021 15:53:52 +0100
X-MC-Unique: wR7SsDN3N2GDaRBgXj152A-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LUokHLRWOMfAovg/a59opQ+voMMRN163irT7hJFES7ncfpMyLw1VwjnwB5nypK0CDj8/Iaq1ETiQg3Pj2pNTwDaLEOj9MbtiTtYng5yFPkHgem/GAaaCZzTdwqfaJGbxe8qdvsvfYPHvDbv/RlzB7goqa2zbxROv/kCpoJm+cRKbZtZJt41ngHJ2E2q5xFoDhk1/TdWO5UGjlyUVRlh+JpWHu39b6K1IjOnbz8ngRQDNxaX8WrlLvi2TL9V3ppgZHPaJ8IARXY4GAr1TVcmHtV30AqHS+cPRPSBVExdyy7RzuqNa1Kg9glnmb9D/QfKgkO8EeaON5b9nnUzBRhJeuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zIJiPYieEGMw3HEPoaciUxdI6Z+vZp0M6793naW/nCg=;
 b=lIfgVTdy2NLTf3Cc5PGddQ/L19FVMFx75pjrzTcc6vxCJJo4m4NuOFS28e6e6PEWwaPtoEchU+YsCpkVnO568Bsv1dCmfB/UqXo3smLf9hRHP+BBVG/Ou9eJTLbeMzY9y/Qc9PQqXgIvba7MMZI8QmuKUb/CdVV+m1X7MMh4YX828jdVpmfyc730OiQA81MJPwRHe2e1fAVJMMf4gzFxQeGYYDQvQwNC2GNJt1lFezFZ2QJtphrk1cMRx7DcuP1EnnxhRJpBcXbRJLj41Jz7hLq0z40LneWRffFq513hq1qkZiKQqz5SW2nBnjbJxoRThvW9kFh97jYk9u3Q2BoNyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM5PR04MB3268.eurprd04.prod.outlook.com (2603:10a6:206:8::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Wed, 27 Jan
 2021 14:53:48 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::c60:6150:342e:e042]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::c60:6150:342e:e042%6]) with mapi id 15.20.3805.016; Wed, 27 Jan 2021
 14:53:48 +0000
Subject: Re: [PATCH] fnic: fixup patch to resolve stack frame issues
To:     Greg KH <gregkh@linuxfoundation.org>,
        Lee Duncan <leeman.duncan@gmail.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>, stable@vger.kernel.org
References: <20210127012124.22241-1-leeman.duncan@gmail.com>
 <YBEaQEs6gvrSm6dA@kroah.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <98317a6b-8710-00c6-2b97-6c73749373e8@suse.com>
Date:   Wed, 27 Jan 2021 06:53:44 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <YBEaQEs6gvrSm6dA@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: AM9P191CA0005.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::10) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by AM9P191CA0005.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:21c::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17 via Frontend Transport; Wed, 27 Jan 2021 14:53:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1c820e9e-4862-49d7-cfcd-08d8c2d35a6f
X-MS-TrafficTypeDiagnostic: AM5PR04MB3268:
X-Microsoft-Antispam-PRVS: <AM5PR04MB3268BC96F54BAA831D632F13DABB0@AM5PR04MB3268.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5d8P2NiXjuG2aPflfPGQB98itk0t3Jl1Js+baLYLR8Q1HKpqdyy6dwOkIoAXAilF3otFxZHFgjOwXLVCvMxbIX/Ly9gJnK/p+vl68XNautTWyrTe6H+2eFFHvKfPbL8OfJ7d6iXf/hJ1ic9cE3MH1QdyLtatGTB/+jP4JcggDDG+kGOnMz2C9F8bbKsKEvAZ8S85+L/XvmSZUQZXB9rNG5lmmFFJfTfFcZixx3XINcPL0ak2LqQNBKMUsrMq81ZnM7kAGrIa+475yAtNT1Ha5fWNycoakcAFPwWpM6AybfmN8vpfQiHZvaGpev+9OiLFbRFWAU64NBgFoYhNg7BGHUBaMkou5ScuxqjMJb5ahTq5mVRF0/9Ag8hyni2R5/53hiHX4P2dlJdZxNnMJNa6+vrfHw5HkWrmmrUWpoe2nrxGHhS0txDWSachHoAm5DXrUsWtFZnXQ3igrtlJd9PbJPl5b2r4IY9Up4JlBgLs4ihbfZbgDK9loeW7nUWb5O7wR8Y6cHVeDODocolCPhOM3Fbx+ygSf4PibiCjpJVv9yWWZYPhBW24pwwW79YBq3KouWM/vKpd9jpfaPZHC382mKfXvIvJVonnCbSiqjp5b7s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(346002)(396003)(366004)(136003)(376002)(53546011)(478600001)(16576012)(2906002)(8676002)(4326008)(6486002)(316002)(8936002)(52116002)(36756003)(110136005)(956004)(26005)(66556008)(86362001)(186003)(16526019)(4744005)(6666004)(5660300002)(31696002)(66476007)(83380400001)(31686004)(2616005)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NkhTNnhqa3VrbFVzWDJmdXJITVlSTTBVRDdPWVM4UE1NTWR4Z2xzYTFDQ0I2?=
 =?utf-8?B?bnhINjlLcUxvWHdJbUJ1VkF4eUV3VUIwK1V4djdBTUZJTm5wMDRPRUF1Si9w?=
 =?utf-8?B?emtsZ1JJUmQ5NjA0V1VLenhVczNHMXU5ZHp4bVZVei9Iblk0UWViUDRweE9s?=
 =?utf-8?B?SFFYZWYwQWFVSStXOGJaOW1HeVNhcWp2VEpnUWpBbHhHL0dyWC9rTFROZEg0?=
 =?utf-8?B?MmNwYjQ1dGJOT1N5OW1FdVNqSnRCRGtjd1dYRnVSSG5zMHlaRDV0YnQvWE9N?=
 =?utf-8?B?R2s3T0VqWWxYYnFJZGFtQ2k2aDJVVGxhUUJ2dFVscVNJck04Nk5UUk1mQmdU?=
 =?utf-8?B?cVhkY0tLWk1GVHVvMHRmNEUyZ0llUkNtUytRMExoVTdZdXZzSm9KNy9QbmNi?=
 =?utf-8?B?ZzV5MG5GdlNQNnJkZ2oyaGErOEMwOSttSmVZQ085cWNkRHZOcmdMcU4weGE2?=
 =?utf-8?B?bndNVDJoQ3I0N0VaVnJUMVl0UkpJNkNwOHFoVFFhNTdTS0RTUkhOdjl5cUgv?=
 =?utf-8?B?VXFHMzdoMEJkaVNvbWZYVXdrMUpxNFB3NjQyNCtFUTFuK0lGeVJwend3NFEy?=
 =?utf-8?B?ZlUzOGUxQTg3QzNvZEMyOVd1VDZGa1JURWZHUUxNcXhvR1RBRzJNNWxYUEtT?=
 =?utf-8?B?ZUdNa3pGaEdzaEdFeTc0NU9GZWY5Nnd6ZTFEbjhMZEtYalpLQ0YvVnJDVDZw?=
 =?utf-8?B?Q2ZXSE16UlM3eDBGdE1YUWoyckxJT1VpVFRhZndiWWE4V25UZHlmTXdCRlZk?=
 =?utf-8?B?Y2syMDlQb2J2QUdmamlPamhKM2lNbTVFZ3RIWFN1SXZhWkZSYzE3RnErN1Rs?=
 =?utf-8?B?M0luOGo4SndYanhEMjlGQnJzbklSOEM5Mkd0V2VWd05pWUQ2VWNVSUZUWitE?=
 =?utf-8?B?UkVpQ3FUYnNOczRVQU5DNVF1aHoySXVBcld1cDBLODB3M0RzcW9xV3FjK3hX?=
 =?utf-8?B?VzZTOWN1WGgrZ0xnckFSa0ZDY291WTZsczdFbExTdllqNGdmQkJGT1c3cm1t?=
 =?utf-8?B?VDcrdWo3WjBudE1OaXE1dkxReDJnWEw1dW9FaXVGYlJ5Y081YjRSd1Q4WGZr?=
 =?utf-8?B?Q2xFdE1DeVhDMW5jYXZaK0VLWTBSQitjMktxY0RZOVNad0UxTHRZdFJwV1NW?=
 =?utf-8?B?SE4zL3hXTEl0NENxM3Zkd3BqTHd3Wm5Iekk2bnF3alF2dlJPRTBwUXBuS3Ey?=
 =?utf-8?B?ZkpwV1NVS1l4aVhhQkg2R3lpcGVuWW5XV2JQbWlLZTI3UjZXVkJDRkM4R2gx?=
 =?utf-8?B?c3RaK1dLM2trdVhQMkNQeTFEVzNCTmJLSk1YT0w2ZTJJNXZRbERDeU54dDc4?=
 =?utf-8?B?VEtpTWxyZ2xqNUZmRTA0Tmp6aDdIOGJRcGhLL1hkRlNXNkNCaHRFZWNPRW94?=
 =?utf-8?B?QjFDTmxIMTlHdkVXSUJPR0Rvbm9iVVlrSk9aWE1NQnU2ZmI5SmFlVEpIVjV5?=
 =?utf-8?Q?5XV37kcN?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c820e9e-4862-49d7-cfcd-08d8c2d35a6f
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2021 14:53:48.5919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nISvsI09ZY1QNh5lheNTwNTbcW8Z5Wr96JkLz3VxHFfoTAlsTpWCgJv/bAMU+PcGwc9p6/d5zSSuRVvBAxYgOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR04MB3268
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/26/21 11:46 PM, Greg KH wrote:
> On Tue, Jan 26, 2021 at 05:21:24PM -0800, Lee Duncan wrote:
>> From: Hannes Reinecke <hare@suse.de>
>>
>> Commit 42ec15ceaea7 fixed a gcc issue with unused variables, but
>> introduced errors since it allocated an array of two u64-s but
>> then used more than that. Set the arrays to the proper size.
>>
>> Fixes: 42ec15ceaea74b5f7a621fc6686cbf69ca66c4cf
> 
> Please use the documented way to show sha1 commit ids to make it easier
> to understand:
> 
> 	42ec15ceaea7 ("scsi: fnic: fix invalid stack access")
> 
> thanks,
> 
> greg k-h
> 

I will Greg. Thank you.

Please delete this patch, though. It is not correct.

My apologies for the churn.
-- 
Lee Duncan

