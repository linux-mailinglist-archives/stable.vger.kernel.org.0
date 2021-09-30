Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E62D341D5EE
	for <lists+stable@lfdr.de>; Thu, 30 Sep 2021 11:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348853AbhI3JGH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Sep 2021 05:06:07 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:50018 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348400AbhI3JGG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Sep 2021 05:06:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1632992663;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l80TdmVvMm1PIwJjjTwcwBscdM/81Wb15BML+/V+OE8=;
        b=aYo5F2QZorKkhfev8Qz4X5Kq3aT636dzHnza6LvU9kA6RvxXOi4Y90lGz1xE8Tb2LfB1Cy
        aFMK0EiiUYS5R61cYBZjr5tHiDCfbHFZ65SIvyV37+7E1taX+c51qa7nAxvdnUvMzPF1Pn
        DXU2VexYKqPopi1uCJtY+U/6fODwi8I=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2175.outbound.protection.outlook.com [104.47.17.175])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-11-qn9EPX_aNN6aTZOyLnafAQ-1; Thu, 30 Sep 2021 11:04:22 +0200
X-MC-Unique: qn9EPX_aNN6aTZOyLnafAQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ps1ovnoWm86L5hyhqIOAkc5eb+yUa9jfQXyOxZgVMAAQsPrY819K9nDcYjTend9lAmjDs2Z5iA2AIxtirTgR2ICaY5q1/X1bZg0nSCZ9nuhCh7/DNEln4YxZlQ23SmnbRnhdMLcK0b7iFU04WzI6qVHkvW07Csj6rd+yOez2SvyotbnY++W3kKcUhEXHf1gthcTg08c82wIw2U9bGVwHmPX2RJ4JNW12nJ7TwLZ9puGiVsShId0USPeIJERrGRsjJi2MEaAc0ujPjbsDE1J/Bf8VwOHfXHjRKIVIaxqG3pj4sQepRYz+yi+ELrIklYKl49hAlehuhVEpBb4xvwMKzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=l80TdmVvMm1PIwJjjTwcwBscdM/81Wb15BML+/V+OE8=;
 b=BkPTYhs4x89KacS7OgAgwCvLX1MlsJYaVeBKGzfmiQHDAvkQr3HmEtkrQwpYAicO/x3Y9ZOC4bIpNhLfVKcHD1PL/xwYRRPUtPLV52BIFpDFU3zjsJBFhYC5RweR8bY3xfynED7PdeRMaSJuCi/F4e95BNwXjTso2icxGY32zHJ9q921NaVeBxSj2VmhRZWAkvkUjTjmjV/AV2hK/SEBklD3MBC+/yxRV8zK2BcxYgIQykVwa6hxkKAwTWwjDQXbAAuuLIp8/vnLXfTwmpz7S9GlWreeMHo3tsfIsQEywhFdTdxez/3SR1KQYtnMEkavxkFUk+Shagk2wj4GDDyxlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com (2603:10a6:10:22::23)
 by DB7PR04MB5177.eurprd04.prod.outlook.com (2603:10a6:10:20::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Thu, 30 Sep
 2021 09:04:21 +0000
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::61c5:2592:9e7f:a390]) by DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::61c5:2592:9e7f:a390%5]) with mapi id 15.20.4566.014; Thu, 30 Sep 2021
 09:04:21 +0000
Subject: Re: [PATCH 1/2] USB: cdc-acm: fix racy tty buffer accesses
To:     Johan Hovold <johan@kernel.org>, Oliver Neukum <oneukum@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20210929090937.7410-1-johan@kernel.org>
 <20210929090937.7410-2-johan@kernel.org>
From:   Oliver Neukum <oneukum@suse.com>
Message-ID: <de1fd28a-0c7c-23ae-8b9d-83a682c169e3@suse.com>
Date:   Thu, 30 Sep 2021 11:04:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <20210929090937.7410-2-johan@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AM6PR02CA0014.eurprd02.prod.outlook.com
 (2603:10a6:20b:6e::27) To DB7PR04MB5050.eurprd04.prod.outlook.com
 (2603:10a6:10:22::23)
MIME-Version: 1.0
Received: from linux.fritz.box (2001:a61:3b0d:4601:21ab:d1da:15e9:ca07) by AM6PR02CA0014.eurprd02.prod.outlook.com (2603:10a6:20b:6e::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Thu, 30 Sep 2021 09:04:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0cd71c57-354a-4829-9f6d-08d983f14a73
X-MS-TrafficTypeDiagnostic: DB7PR04MB5177:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB5177891CB62C4505FA82079AC7AA9@DB7PR04MB5177.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aThPOMiv1Q8ItDShVr9Z3bLAzapsuy6QkmenDyxjd8RKCj9/2qWbetZcIfLSr0wPM+V9hTOSBwktj/0/SBfqXJVRtt1q4wcRLsnzC7645vtIRN7Kt7sRbhTRniiTLwrAtbQuK7py5k5XvpHGzD+AA8lxCKnaKCuz+A8GTA5/VY4Y5g0eltSDmHD2vbLUakADVbLraUQsqwg8D0xXRJQ4IT3sQHSCGIoN9aeoqtD0PNZNjaftL3lN/00PRPbtaMZx6J2lvuPnwLaXnm4UP9DAl5hsSdbLe09FXyWVfvX+jjxYok7N9HC5N7Ups2QbCM4F7Sw5O/WBdSepbclvEPxsdaR1rUatjxkkevIP5HBpC/GTVa8VUNh7L9sbdGidINFugDXtZkiFjR3UU5vlWD+vjfgp9/u8E6QP0p5o2MIbGkAd4JPj7BjuT3BHXuNrATdgn96CKndUJaS0HUXIjswYj9bMTy2JnUwjn7Jey1Fx4gm+nWuUDeC6RaGC7OE2asErHLYGklC2EIigHTzSj2qGfnCBtBlbIosSjKmuNqGeBuiL3PPD3F4EDGzZv5Ba6RbltkpPuN3/6xYIoLViVHgZmZ05UEcJyrkcIBbpWEF3jTQOzb6cmvk2C3KFRG3WdNvnLUYUSFBSHKk6lqnnVuqQetKUFKEJ1dT/Cf/e8Vo/rU6cYjPOCI1UFkPU7A/BTrtJ8gyVLZAoGgtVOxcNbL5H9I7o8zj8zQ78GKjd0Miahds=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5050.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(31696002)(2616005)(66946007)(36756003)(2906002)(8676002)(86362001)(508600001)(66476007)(66556008)(4744005)(316002)(8936002)(6486002)(110136005)(186003)(6506007)(4326008)(5660300002)(53546011)(6512007)(31686004)(38100700002)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NkdoSVFCS1U4bFNtaElzSXhJQWljcFg3TWg2bXhqUjJ1UzFwZzlGK2lHQzla?=
 =?utf-8?B?T0wxN2NlVGhZbXFCdS9uQ0VxaFZ3UjdiRWxxNlNWcmpBWWo2MGJMUEJMbFgw?=
 =?utf-8?B?NkpZQk1seEhYOHFoRWlka3JOa3pHd3JMcVZkdmpNcjZyR2hXZFlGUkJMZDdT?=
 =?utf-8?B?b20vbmhFNEZmQy92RlBwTnRSODh3YWVYTkthWU1tVGVLaVE1Sm8yb0E2SFF4?=
 =?utf-8?B?SUU2MlR0bjZVWUhra1l0bFZJdGcydDgvRExGWW1JRjcyaFVNanZFdDdHK3hT?=
 =?utf-8?B?aXF2UFp2S0s2L3k3cDZhUWxqTEJ0YjVLWWRXN09HdXF6R1VyUmdPbVRWZHdY?=
 =?utf-8?B?Y3RwVzJGY0pld3NhVnBHZVk5R1cybTRIb21kbE5HWExkV0s0NzJjRGhCRlU0?=
 =?utf-8?B?cGFVQTV2TSttNG5ZbHRsclRTSDFUNnNPZDhlSWFkNldZeXlHQnpnSC84WGda?=
 =?utf-8?B?c1ljcmxKR1hoYmh3MCsvNHdBTTdJNkxrYmJscjVyNGg0WHNuNE5pcnhvYUdB?=
 =?utf-8?B?YXlZWlFyY1Q2RjJYUmFKeE1sdUNWYlNNL2pFUXBUeGVsMFpyTEJuVXh3KzV0?=
 =?utf-8?B?dlNSRUVKeE1WdTBpVXU2Uld4eGQ2aGhlSWhnRDhyTUNwQzBrOVRKSHZWTFBh?=
 =?utf-8?B?cjR0T01HNlRzdTFqRkk3bk5HRnMzNEcvcno4OVVDaDY2TTRUNGhtaStHNmMr?=
 =?utf-8?B?RE1LTzI2WWZOYVFKcG0vbThmRm0vSHVoZkRISTlnWTVCeUk0Yk54MlU2bitz?=
 =?utf-8?B?cERyT0NBYzA1dVZBemFSTG1nc2x1eW9ObTRiTFhWdng5aTFiQkRrOEUyUXdV?=
 =?utf-8?B?TFFReThMcUd1ZER1ZnFGWW1Uby90aUxlQ053WERhWjhUYVI1WWIxOXhFOVlx?=
 =?utf-8?B?K3QzOENGYXhtMWpoQ1E2aU1KT0cyTHNNYUl3ZzZNVkF3bDNHWEZ6SWtBbGtL?=
 =?utf-8?B?NHQzdHN5eXBoU2tQZ3Q4Zkg0TjZZaXB2NHg3K0NmRzJISCt6YVZOVytaTy9N?=
 =?utf-8?B?VWxTOCtHQlZqTE1BWkFHWlUzcXd3WXIwakxobS9uQUEzeDl3elZsZnJqNFVx?=
 =?utf-8?B?UFNVZU54bVlOWHJPRXNkMUpYT1lPZnBWRCthSDlBbFByem1kcXg2RGdkTjNk?=
 =?utf-8?B?bkpnTFRtTUtiRy9zMDhWd2QrUXh4RzhVc3V4eVRPM1lvVVNyaXFiL3ZQZ2E5?=
 =?utf-8?B?OE1jcG9PNDgyT0wxN09WcUlseEhCRlhtckFhVVBjdnRTQm9BRHE1RTMwdWtx?=
 =?utf-8?B?UkxscmE3WnREMkN2Y1pQd1QwQ2JoMGxmQjNkT2ZHaFM2NGg2R0J1aG5mczQx?=
 =?utf-8?B?U3lCNFp1UFJZNXJkazQyMjFEbEROaEJYRFVHdkZRSENTbnR1Y1Jka3lCMVJl?=
 =?utf-8?B?d0s1S3M5S2o0ODgrc2Fjbm9HeHN0R2llRU9EOWwrdlR1WXN3WEROU08ra0Rq?=
 =?utf-8?B?OHZkSGdDak5USVNQVVlCeXNBay9HMVhRTEJjYzdheDJiTXdsV0NVYnc1NThT?=
 =?utf-8?B?WFRENVJ0bHEwMitibHlJaWJrejhXSHBRVlpBcTE2a2hHMWhMcjg1MFJzUjdN?=
 =?utf-8?B?QUtzOGNpZHdRRTEzSUgybHMwQVNVeTNBS0wzSVdBc1hOTWlTMlUwRlVHOHo2?=
 =?utf-8?B?VGYrbW9aNFBvdEpmaXlsSVg1WnVJbXpOczd3RDRHQjk2blluQUd5T3pNTXE0?=
 =?utf-8?B?T21tZTZBOWVUbXFrZ2c3WitOV1VuTnVZNE1Ba3ZaQTNGazVCNUQzNXpPWWFY?=
 =?utf-8?B?MEFIQ1M4aDJ0TGtzOEVGSG5qaWpwR0hsS2VpbVlWZmRrZHNXZEhvMVZVWHVa?=
 =?utf-8?B?UEtkNnYvT2xvc3k4WTRmVFRreTQ0T09xdjdna0Z2YkpaKzRUSVVjVFA3b0h3?=
 =?utf-8?Q?hpHjjrWPiX7P+?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cd71c57-354a-4829-9f6d-08d983f14a73
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5050.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 09:04:21.0653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ta0a0bger/rIWjslP69f54ScWHsmwJZt51YY2oFAdgd+0rytLcAJpu8PYNhbMDXEBnXZ7hS6eIRetGR4UdGwMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5177
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 29.09.21 11:09, Johan Hovold wrote:
> A recent change that started reporting break events to the line
> discipline caused the tty-buffer insertions to no longer be serialised
> by inserting events also from the completion handler for the interrupt
> endpoint.
>
> Completion calls for distinct endpoints are not guaranteed to be
> serialised. For example, in case a host-controller driver uses
> bottom-half completion, the interrupt and bulk-in completion handlers
> can end up running in parallel on two CPUs (high-and low-prio tasklets,
> respectively) thereby breaking the tty layer's single producer
> assumption.
>
> Fix this by holding the read lock also when inserting characters from
> the bulk endpoint.
>
> Fixes: 08dff274edda ("cdc-acm: fix BREAK rx code path adding necessary calls")
> Cc: stable@vger.kernel.org
> Signed-off-by: Johan Hovold <johan@kernel.org>
Acked-by: Oliver Neukum <oneukum@suse.com>

