Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75299348BEA
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 09:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbhCYIvr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 04:51:47 -0400
Received: from mail-co1nam11on2046.outbound.protection.outlook.com ([40.107.220.46]:43969
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229461AbhCYIva (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 04:51:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VT52TnS7lFqdrHuh1Psp5KMypaQk/QtQm4sW/BvG6XDy6EvkSAnCzVLIdAZ2GvucSZxRt+fCEDOOECMyfYaQV/jHIWoGxJ82flvm5z6deIIL7sP1F3UKWPlqAzsVq9ipvuF38CzA0kGty6kn2tkqbdfQ17n09l8ZCWCDhnQ1bcxm+SaeDW4upuFXg3xoTkJiUub1BWieN1D2+uVkaNBLA/EaCoJm7NvoPodGFtVvtxWlcROKcI4vE/HqhSHUp3zrXeDOBxESExOgI5uvcthq7MvYqLdNzHYHUKgywiTHt/TYfkUSEK8oq9xkXT+HjYLjjSE5J2+mcDYkji8MbbOacg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VG8dgnJL4Dg89DY6spJOG0YF7akXBrxAnuyNdC6tlxY=;
 b=YMA68fJgC0s16M/EzN76uev/CtMKLd2yFsVTWgZMLJIkRoID8ia8aZF2bXIqKT3j9Zj9G/TDe7bcl4dLxILnGEYv9qY6ixdz4hmQv0rH7kA9mP+bVFQrdLr3xHI8II948HOC7W6CP6FsVZYU17eSkzSr3n/2HaQlZ4ZRrEfVLqi1GnYjT0RidhNgKDMryPFQb9CV1tP5TX1Om8yFMJDSoHtKgtsUSYQUZo7Qt8eqC+V83KfKedTIwpjHvgNRBO6cBjffsG6nbxjlpFg+nJ1QrdGoSacgwDv5dQGHhOa/sXxFcYRxWnF/e7cHNWFE2O3b+IqVdV1iMZ/4w/3JUKbBXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VG8dgnJL4Dg89DY6spJOG0YF7akXBrxAnuyNdC6tlxY=;
 b=20ddLd7Y8V4gRd0DFGkzNlYOcqbaEn3LASrMhIJTlWKSv9TiETxQ1tQBiqBiFHZXX2bKwST2bF+/heL1bQpVP031nV7bAICAn+tTS1xgPuqJFfiSoOx/b4l+nIMgJshP+af8RoT9YaOBM9xvDSe5IYi6WHMFJmSKsMPI5+aGYxc=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from BY5PR12MB3764.namprd12.prod.outlook.com (2603:10b6:a03:1ac::17)
 by BY5PR12MB4068.namprd12.prod.outlook.com (2603:10b6:a03:203::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26; Thu, 25 Mar
 2021 08:51:27 +0000
Received: from BY5PR12MB3764.namprd12.prod.outlook.com
 ([fe80::11bb:b39e:3f42:d2af]) by BY5PR12MB3764.namprd12.prod.outlook.com
 ([fe80::11bb:b39e:3f42:d2af%7]) with mapi id 15.20.3977.025; Thu, 25 Mar 2021
 08:51:27 +0000
Subject: Re: [PATCH 5.11 073/120] drm/ttm: Warn on pinning without holding a
 reference
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Huang Rui <ray.huang@amd.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Sasha Levin <sashal@kernel.org>
References: <20210322121929.669628946@linuxfoundation.org>
 <20210322121932.109281887@linuxfoundation.org>
 <8c3da8bc-0bf3-496f-1fd6-4f65a07b2d13@amd.com> <YFxOuFsO2I7LlEis@kroah.com>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <0b19b066-c05f-3788-a150-0e387f9dc64a@amd.com>
Date:   Thu, 25 Mar 2021 09:51:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <YFxOuFsO2I7LlEis@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [2a02:908:1252:fb60:a792:596e:3412:8626]
X-ClientProxiedBy: AM0PR02CA0215.eurprd02.prod.outlook.com
 (2603:10a6:20b:28f::22) To BY5PR12MB3764.namprd12.prod.outlook.com
 (2603:10b6:a03:1ac::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a02:908:1252:fb60:a792:596e:3412:8626] (2a02:908:1252:fb60:a792:596e:3412:8626) by AM0PR02CA0215.eurprd02.prod.outlook.com (2603:10a6:20b:28f::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Thu, 25 Mar 2021 08:51:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: eb350ef3-4ef6-49fa-a666-08d8ef6b2ce6
X-MS-TrafficTypeDiagnostic: BY5PR12MB4068:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR12MB40681C1D09BA01B6A6B60C2483629@BY5PR12MB4068.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h1oDAicpXN1jW872eLhZpm1/qanIGTYd2wP+3h2pAgocw8fvBlUPyu/cWmUHsL5TSH8Lo7zHN1v0K+1MzQGwWAt1XtZm3kJnQqmKOGN9muXRscn5EnTYtgp5VlJHQ/U6U5SF3Gdab3sOHDzdK2zKAXSM0VRQN2IpBG7ahQzuaYWegxZXzsWDpk3DUaxCf0gxpNqIbeJiMsIo7CGw0ay1TF7utYi5gg+ZO1xryTr5jDsOeC7rnuXSnZN/DDD2uFHtl1bgmHfIzgroyjGkuXWrGT+DdQrLreeUvD1YIkG1zYh6glLeUqWv7jp/XbppFqB3dSebPMZCMhL5P4GdiFryRRdnBM6qHqGk5yzbu3h143sLC+7lFSeTr8XnsNyFmO0S6ny62lWMRbwx+14KSrtK+TAeg7b23DrhprIZDxkG9bzLZOozp7MWn6aHCcGA8ywiXAlBgmx0FNVKgKpGcIIwfW6EST0KliDaTskOfACvE9sZTu1ZHC+gnweNudCvyKSKgM49qUF6/OtwL7USe2E9WRQznx3/yf+tdr6WsyHkV9C3zbMTS/18op7N3PX/FzYFdaQNMJIOPb53JtYcOLbKVr654FF1jIn4+hQRDZuPTWuMojQ2idWZrnt2OglnMz+z/aqh0AprbQo0SI1wCAmXudnRic6smzmWnLnMcX+ETofGIuv29JCv/xfFhl/1l+OmarEYKb9su0MDqAnqF4rw99H3sT23NCypOIajE0SKNK4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB3764.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(136003)(366004)(376002)(346002)(2906002)(83380400001)(186003)(6486002)(52116002)(31696002)(66946007)(4326008)(6916009)(16526019)(66556008)(6666004)(5660300002)(66476007)(8936002)(4744005)(36756003)(316002)(478600001)(54906003)(31686004)(2616005)(8676002)(38100700001)(86362001)(66574015)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WEFKMUdrSThDSkU5b0UzOTFjUTFkbnFDQW4wamhhSFBhN1RnZFlZbTFmc1FH?=
 =?utf-8?B?clM5YkVIYmx5enR3eGROWHN2WTc3c0ZNYWhOZEFkQ3dpUkZpRG40VGVPNVoz?=
 =?utf-8?B?bHZnOWtVYmdCOWFKbGVBM0cwTlpRTkxZdTUzWlVITFkvS24rci9kYmJ5bjJu?=
 =?utf-8?B?cXN1ZXVudU1sRkc4dlE5S0Q0czA2SWFlOFVKbStpUWtOQy9wWGUxbjZNYkUw?=
 =?utf-8?B?Z1F0WXlSd3l0b3BsbGUwbVVVLzBQdk12aVRvN3dnWkpEOGxjbDFjcHVGQTdU?=
 =?utf-8?B?ZmN6M3RwY3RmSmZTaVVwUjViQVlUNVM0QkNrS2pNd1RtNkNuck8xeXVwM05s?=
 =?utf-8?B?RVRSZ0tWTm5KZnFTMFRwSmswOHFCL2xwaGJTNXlMbkN6RWtaNkVPUnRaRDNU?=
 =?utf-8?B?aGRZVVFQMGcwR1VOUGpzajB3Nng1TTJMeXNVZXplVEdBRENCS0hJdXFqUkZi?=
 =?utf-8?B?aEpjNjhxVFdkdllxdmJDSTUwQklHZSt0OTlCRDFxb0N1Z0NQV1NESDk5WDNJ?=
 =?utf-8?B?RWRGd2tCTGdoL1ZZT2dOSFRNR3cwNHRaSkFrRzdaRHhrQ1kvZHdtVWxpS2R4?=
 =?utf-8?B?dmdIUUlHbm5talFWYmhzSjU2NkNzeE9yODhpbi9SL29LTlNSbGYxYlpvRDRI?=
 =?utf-8?B?dUVqRlA1YzRWdGMrUFZKU0JQbTRocXRna0lVMkRZbzlJaHNkOVJPQ010V1Fm?=
 =?utf-8?B?VFNJYTdoWG1EbTVJaDRaSEVvSEY3b3VMbCtYMkRIRWFJZVcycnhRVk1zOTg0?=
 =?utf-8?B?OFZnd3N3ajN1NytFMkpLazllQzVFb0dNYUQ1VTFKdWVZNk9oc3Y5RkRyYlA0?=
 =?utf-8?B?YmJBRGxUUFBWL1huYlZyWUx4NEhNSnU5djZndk9pbUpqOWF4MDFRK1pjOGRv?=
 =?utf-8?B?bWUwbWNIdDBiMHQzZHNEM2dKKzZsWms2Q2lQa29ITE5laUU4U1hIWVNKRkl3?=
 =?utf-8?B?SUZKYTJqVnZCNFlLRStscncyUFY2eGJGTTQxQWl5S1VlcXhLbmhhUFo4UElL?=
 =?utf-8?B?OVJ2NXE1ZjhKOUI3MVhYcVB3N2hzajg2cjJpNXBnay94UnBuKzRiRWZIa2hi?=
 =?utf-8?B?UlgydVBXVHRCVUdOY2V0UUdJQXlEZDU0aXZqU0YxVU5TVGJpRzczWjJxdWcy?=
 =?utf-8?B?TVNPYXAzNmxWNlZsYk5ud1dVcmtPaXhnVEwyUXlZaDBCRk10c1FOTW9wWGZZ?=
 =?utf-8?B?aWJQYXZ4Zmx0U2pSUWlXL3VDVytmZ09uZ0QrbGZJTXpsOWN2M0JRN3JmWWRn?=
 =?utf-8?B?Z2NPYTZFVXgxbDl0eUNpZUFpeEI0SStuOUx2MjZXZUFEYzlueWF3N0JJL0M4?=
 =?utf-8?B?UnIyTkNYSmI0TmxIQ1VhUDNab0pGYmpoN0R0QXpMTHdNK1N1N3lzTDA3eXRT?=
 =?utf-8?B?MlhNYzMyRVVpaEtGN1hYRFV2ZVgyQnA4ODJqUitKL0NtS0pNbEdidnZNaVJK?=
 =?utf-8?B?M1J0TjJhWSthMWVya3pZeTk5eHhXcDlsRWpPVUZzOTczU3NlVlhTZDdsOEY1?=
 =?utf-8?B?bW5DY3pMYndsamlZVXA3Qlg1aE45bG9hTGJVZ2FITG01UGg1eUlqRnluQ2ph?=
 =?utf-8?B?bUpYS3JQOW9iSTFmYlZRNVlyR3FYc0dvTG9qVHV6SEk4V1QyN0lHbGwrTmpH?=
 =?utf-8?B?dkJXd2ZMekhac1hPVmgwWHh5YjV2bFV3bGU2VS91NDRZWElTZ1RMYktVVWlZ?=
 =?utf-8?B?N2ZNTUxla0xFZDhydEtTaUlES0p1UTRKbzlmZjIxZlRxV0RaZVgrU0dWd0RR?=
 =?utf-8?B?V1hsYzJvcjEwRk1LKzdQdkd1MHZPUVJ0NGplc29kamQyeFVaZVo2bjBPTGIz?=
 =?utf-8?B?MkgreUZWeTNCZ0NRams0UEU0WlNRT2ZCY2VtdTNVVWxFMVlFR1dLV0gzbHly?=
 =?utf-8?Q?HpuVSg6AHha45?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb350ef3-4ef6-49fa-a666-08d8ef6b2ce6
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB3764.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2021 08:51:26.9336
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YdZyag0zjtD3R8ScUS67switE/x+nWoQCO7K63c4bI1vg/ZGwE0pUaONGGHWPW/c
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4068
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 25.03.21 um 09:50 schrieb Greg Kroah-Hartman:
> On Thu, Mar 25, 2021 at 09:14:59AM +0100, Christian König wrote:
>> Hi Greg,
>>
>> sorry just realized this after users started to complain. This patch
>> shouldn't been backported to 5.11 in the first place.
>>
>> The warning itself is a good idea, but we also have patch for drivers and
>> TTM in the pipeline for 5.12 so that the warning isn't triggered any more.
>>
>> Without backporting all of that we now get a rain of warnings in 5.11.9.
>>
>> My suggestion is to revert this patch from the 5.11 branch.
> Thanks, will go do so right now and push out a new 5.11 release with
> that in it to keep the noise down for you.

Thanks a lot for that! I got a bit swamped this morning because of mails 
and bug reports.

Christian.

>
> greg k-h

