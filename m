Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4438447B9F3
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 07:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233231AbhLUGTZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Dec 2021 01:19:25 -0500
Received: from mail-sn1anam02on2057.outbound.protection.outlook.com ([40.107.96.57]:45314
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233179AbhLUGTY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Dec 2021 01:19:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PbcEXOtWrzbpJbRJS4cr4V4SSfkgk1ClpPAUvy/ytAKwQrTvu/gFEbiMTMeWbuQShLiuI1qS99z/hVvKroeuPZQUY83CE1r2rWuke4Kc4HSSSxvkRW9iKebH31Ag5wxIK7KcdOK7uMBxJdAZvNolMCqkxbc3Mzsaz7VdrSH7Gq4qbM4XdWwbCQOcx+5y3K7g6U2Wn1cN06N8jYiKDmb8PtnyEXb1dQgXF3NY1VFTG43jGsb3xzbMFJSqovuBrAkzVqeqP5TW5qrSa7IcI0eJpKl5BidtPWFlaorCbslRqhdW6/dCo37syUU5G3uUfh4lZTxwXsVMHUApah5J4HsuJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z53hK0SijnQ5AfVyRYH4Xay91UqVv0LMPX9WPz/au1A=;
 b=L7vras6a4bfg6wwvDwY8E/nk444pBGhQpgDK3rV36ExJsM7nLIYh335uJGnqLa/OzoJtIUkzYBoReP1BS3JqgSPugjGSifrwXW4UecLpmh2ZfpdNHuksltaRljuT5PqJ5A1UmjblqLidy0EfxtER0Gm01Dr4JYscg41AJHX8eZC9cmSYdwe3jNmQSjV+cvBnllcq4/V+d+tnVQ338ZZSJM5nXTDBucecKML/kpsAAW5rxwYuUylSOH/uQK4PMrqF8r0HTjtuYa2RsqmA5aJpZE2YGSm85pE1ENNB6uSKbunqkCp9QElqNtaNT7t0tOKjbHTX4jsgwRYuPdPuNunmCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z53hK0SijnQ5AfVyRYH4Xay91UqVv0LMPX9WPz/au1A=;
 b=gW0bmxMSguCtqakQXxTzxriQfwuYiL5kuvdDtFLx/rsYNktX9Q/bL7VjbikNZ7kgfMxib48jmK+QIIDOssK7J0G93juTFqubhD5Rdsd/zsXvXmW4/+EDB3Yt9WhgU8SBBDdPhbP5XqYmiRzM72DIimUM6EocGD3XaZiMOa6xEZ7ZRUnXbcnV2XWqh0KJryh4zZA2ZGFYVcSBGHKpn/7rDJMccRnzYVR7fIz112OLXDVeO1+kzE6p/cVlnLLzEtOMefGjhOSOYpMCQyqaqvfO5XLMyj8BF42pDuQF9n3S84FCSaD+pw8aoyEk56gRbAVYPV435RFyOsIRSlz0rKQClA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY4PR12MB1576.namprd12.prod.outlook.com (2603:10b6:910:10::9)
 by CY4PR12MB1765.namprd12.prod.outlook.com (2603:10b6:903:120::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Tue, 21 Dec
 2021 06:19:22 +0000
Received: from CY4PR12MB1576.namprd12.prod.outlook.com
 ([fe80::24b0:46e7:d3c0:a77b]) by CY4PR12MB1576.namprd12.prod.outlook.com
 ([fe80::24b0:46e7:d3c0:a77b%7]) with mapi id 15.20.4801.020; Tue, 21 Dec 2021
 06:19:22 +0000
Subject: Re: [PATCH v2 1/3] ALSA: hda/tegra: Fix Tegra194 HDA reset failure
To:     Dmitry Osipenko <digetx@gmail.com>, tiwai@suse.com,
        broonie@kernel.org, lgirdwood@gmail.com, robh+dt@kernel.org,
        thierry.reding@gmail.com, perex@perex.cz
Cc:     jonathanh@nvidia.com, mkumard@nvidia.com,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <1640021408-12824-1-git-send-email-spujar@nvidia.com>
 <1640021408-12824-2-git-send-email-spujar@nvidia.com>
 <f859559c-abf1-ae37-6a0f-80329e6f747f@gmail.com>
From:   Sameer Pujar <spujar@nvidia.com>
Message-ID: <f65ae56d-d289-9e3f-1c15-f0bedda3918c@nvidia.com>
Date:   Tue, 21 Dec 2021 11:48:57 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <f859559c-abf1-ae37-6a0f-80329e6f747f@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-ClientProxiedBy: MA1PR01CA0097.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:1::13) To CY4PR12MB1576.namprd12.prod.outlook.com
 (2603:10b6:910:10::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8df6d86d-b8dc-429a-af6e-08d9c449d45c
X-MS-TrafficTypeDiagnostic: CY4PR12MB1765:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1765196E76AF731720371D6BA77C9@CY4PR12MB1765.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KXl+MQ+WZLXtIPTwPYhq44ef+te/79NpKS0cyg8nxadwPWnWirXxZY5IhSRbqpMfptBHO4A3nRJR0D9BDju4WxKVYLOfliUdSH4f3YTeX9VxzyVUM80G+ftM3hrEF7g5A4gpv7FbDZrJs9H+LF/wRD/Qau2fa9PuIOngoyu12L6S3szYjhq6XTmfvQhHA6WLsbveJC0trJEabQIcRx4ar6TnUbt7YwspgE+si7AZ2RQPHBcUoP7e6/9Q+3ScQCKRJC/B1LHlmf+iybQnr8JvEoyWjjA85Xi8ene/rlVfeG42GVNWUwoZgYGC97VWJ+Zus7COYq/POIadLN0+sQLmdK9Xod6jgf8rXZTwSMeXxYfwC1pHfuVtbkRURT/mt9PQ3WwFK2wAGi2Noncc7IYcoVgwyO7Wc/ixrlkWcK6IZhcqRYdS2G832JvbGFCWnUHdScVcwrdByIWWjuH6L/5yza9RWoCMpmPM3BAd7fidhFUzzV7X6xoriRs+UM9p9Rj5LPqd3O9n/ua/asjGRj6KNyoWx0QxWByW3rBD85a/wHnSZB9nr21xUTjqhXGsTh2yiF+LiLjnlhTrk5C2FYUDKVowJy9zyy5ptIzKrKTCf0PgBE9DnGFIL8/6/uf3vDoVf79VcN/+C11LcIuxXhX6b0Kesc+/H71bmv43L64jfr1sRIhP0NvGAIaRrgwxdT1zr9sfYb4G5nF0yj/+x24PZi9eQeR609bYfCn6sNYV8zA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1576.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(31696002)(53546011)(8936002)(6486002)(83380400001)(38100700002)(5660300002)(2616005)(186003)(4326008)(31686004)(508600001)(66556008)(4744005)(6512007)(26005)(7416002)(66946007)(6506007)(2906002)(66476007)(8676002)(6666004)(86362001)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T0hkejk3YUNOdWlTQnI1clUzeitoY2l5WHNTTThoaE5TNVRpNTM3a3FEM1Bz?=
 =?utf-8?B?RG4ySVBkR1NVYkljRm5RNmRtNjhmS01XNzZtU3pzZUNBczEwRW1GVWNUMisr?=
 =?utf-8?B?TTd5bXRFL3FLM0ZMWkxTMzlaOVFGTXcwdlZjVW9mYTlpVE9UUzN3OGxZYUFk?=
 =?utf-8?B?YkpPWkRlaVAwWmNVSWpvNGtOWVFJK0VZR2FQZlBJUDBrWUM4bXVNY2hDSkRW?=
 =?utf-8?B?eklEOFp5MEl2MEhtbWgrcGZCOE9xQXF2Q1Z5aDNpYXR5cXdMOXlZVDQ0WVht?=
 =?utf-8?B?cnZ2YXBnR0JZbDloV1Z6U09XL09iMHN2ZTdpNDYyMEVDV3JtRXNmK3REOEFM?=
 =?utf-8?B?STA4UkpsTng3UXVzQ282dUQ0bGR2QzVncDlKbGFZaUZ6cTFTeUJJbDhKelQ1?=
 =?utf-8?B?aExUSFFVNVppNFY2OFQ2MWVRSkJHdDQzZERkeUZqY3lhVHRUNFFwZ2JESmQ5?=
 =?utf-8?B?eVUzZTFjbE85RGFxSEFYdDBINUlJWGFlWXFFSmhTLzR2N0FVNEk5UzViQ1Q0?=
 =?utf-8?B?c1RVYjJ5M1ZHM1dLVEZSazR4TzVyTnRWdGd5QWxUZmZjTXNIcXJDcU93MXQ1?=
 =?utf-8?B?cUlEQm1SdnVobnVJN3g2SFowSUxhUXhDRmo4RVNPK3VqenZCS0JwQ2o1a3Rz?=
 =?utf-8?B?ekZCM05xczdQZWplanY0OGZTTXpTU3JLRzZRbG03eWFzUWVpK0NYZmU1c1o1?=
 =?utf-8?B?SXBlemRrOFY1RURJamdpUndsc3laajN3Z05RalFzakV4UmU2eVFnUXl2SjVZ?=
 =?utf-8?B?VFFCR01kd2N4Y2tGajRUTmxuemdJSFcwVVdVUXNabnB3NGpYOUVLY2dwQmdJ?=
 =?utf-8?B?a2xCdktPK2dlaExYdXZNNGs1Ym9tRXlpWjBGM0dlbEJrajhnbkZrNmhVUVVB?=
 =?utf-8?B?ZTBHZ3dXWk1keWg3RExjOFYydTZieDJhbmtJeDNDaGVwalJGSnNVWEhvWEFQ?=
 =?utf-8?B?d1BFZ2RzenBXc0ttUFdQWTJUd0F6eUYvQXJqME5vYmpMS1VscCtxTUVNa0d3?=
 =?utf-8?B?eXlwc0N1OTd0bk5nWWtCRTlCcXQxcDVvcE1uN2VKcXVQUlI3NmxZVFVUUlRS?=
 =?utf-8?B?Y2JiM09zc1hBSHdTQ0d0VjdaSFNJdXpHUzh2TlpKeEYzbzdoQjV1bkVFTDE3?=
 =?utf-8?B?ODZXYVJqRUJTRGV2ZmE0akw1NHkrYUdLenJQUjV0VEUzQ2VOSm1yWHliTDVU?=
 =?utf-8?B?WHk4N1VHeit4c01DdXRPb3pOdDFLbEFwUkpNVE9BOFRoOVVTZDNXSVlwQ1JY?=
 =?utf-8?B?ajVZUVhhdGExRDRKcnNHODEzRVp2NGNHWUlDOXhYcno4UHJHL2pnYm9tVlhn?=
 =?utf-8?B?N051U0R2bUN2SERpekJqaFpGNXIwVElrenRqcStTL1Z3eCtsa3g4M0NiVE9i?=
 =?utf-8?B?WVJJN1hxQk4zL3lONThYcC9INjdyOWNLV3hvMEJtQXdReFdqTFRBcDU3eWV2?=
 =?utf-8?B?TlY5ZGVTZStWL3p3dlprWW5RWit3ZlZHUTIwV1dFS0tMV1dGaTk0ZmZIWXp3?=
 =?utf-8?B?UFByYk52NFRTamNTWE9sUVhra3VtNXkrRnN0cmpjS1dnSjdRazA5Z0l5QmZI?=
 =?utf-8?B?bUxUdnBCWlNJdmJ5OUhsNHcwSmJQblM3VGZrL04rcDMxQ0FpdFJqOGovNGVx?=
 =?utf-8?B?SWRvWGo3dFg1NGtZOVlZZW44clI5Zm5uT3hhcVFXL3VrbkZ2RTBJWm5NUHVq?=
 =?utf-8?B?cmZSamJFZFptbEF4SGZkRjdDKzV2V2R5TUJmQjhHanV5YnpDRzZqYzBDMFVv?=
 =?utf-8?B?QTY1RitwajVWb3dyL2Nab3V0MHBTMEc2UTVLc1gyUlFPR2tXREJYb2VUb3BD?=
 =?utf-8?B?anNWT0x4VVcxR3lCQjh5RkVUWmVReEVZV3lJbGxQbmJ3aGhJeHMvdGRMbzYy?=
 =?utf-8?B?aTlGeWc1MGRGYnNDdENZNDhHZlMxM1JZbXNLUllOMW0vL3RRclJBM1doVlk0?=
 =?utf-8?B?RUVGQ0tGZnJLWEdXcEZUSTdzTWYwVlI0WEVGN0lyb2dTaW9wLzErSHBUcldx?=
 =?utf-8?B?RzVGNmNJUHVjT0ZNUGE1MnRZOWtERE50YWNZekhrSWF0SnRySGlmY1ZQZzJY?=
 =?utf-8?B?YVNWSEJ2cC9ONk5uOElZZDV5WDJJdUlTeVVCdEZVWGJiTDJDeDhBRElRV1Ar?=
 =?utf-8?B?WXNna1VlTVpxVy8rUUlUMXJxUEhRK29vcVh3cGFBTytFNDc4VUlDaTY5aUdJ?=
 =?utf-8?Q?UhkDqdTZLEz/OINtx7wvO2A=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8df6d86d-b8dc-429a-af6e-08d9c449d45c
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1576.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2021 06:19:22.5925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6KEI9dlH/Eem646oojH84vGZLQkjtvRDxJGOupt2GNJ+QTgMJ1/SopHjnxe9DYsIdS+orKVzuinYbdVv65l+Iw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1765
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/21/2021 6:51 AM, Dmitry Osipenko wrote:
>
> All stable kernels affected by this problem that don't support the bulk
> reset API are EOL now. Please use bulk reset API like I suggested in the
> comment to v1, it will allow us to have a cleaner and nicer code.

Agree that it would be compact and cleaner, but any specific reset 
failure in the group won't be obvious in the logs. In this case it 
failed silently. If compactness is preferred, then may be I can keep an 
error print at group level so that we see some failure context whenever 
it happens.
