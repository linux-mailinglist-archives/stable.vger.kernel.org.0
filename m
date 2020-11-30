Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 891892C7D8E
	for <lists+stable@lfdr.de>; Mon, 30 Nov 2020 05:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbgK3ERg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Nov 2020 23:17:36 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:44357 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726304AbgK3ERg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Nov 2020 23:17:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1606709787;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i7k6FmGsWqkTpoJWoxWrNbCYTChf7pymnn/tjC47NAw=;
        b=NMaUyCImHQQQj67Rj2atEcuVYMYtIXzWEOsmSEgddaaOe6Xaea4/8NzXq3seB80xj4wavD
        ZIBzAqKzK3MtFriSChJAknSYAyNQVA0td9PjOW/7Ww+0kl4f98quhCrzBqUpZmrqCZ6hpC
        arMp+95jn3d4fEhAGnIC8yxKEcKHqvo=
Received: from EUR03-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur03lp2055.outbound.protection.outlook.com [104.47.8.55]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-14-mxhodnWtOi-_pw0fViEzVA-1; Mon, 30 Nov 2020 05:16:25 +0100
X-MC-Unique: mxhodnWtOi-_pw0fViEzVA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O7KC1DupzvPIq/8VgM+WmciJYv1HyJKhTxWPBMRwhmxZ7JxOBvSgMSqzNwb0MlDcLyPhMnZgTCxmMIJO7a0A7vVpxEmFDI4akmSyTKlMzxChjNVe4bVEOeU+NQvd5BhYmPoFSLfVIhFBLx8v5NgNSK1MmAgViVOcz6tf/q1PP6vO1C7NbSNolUXLGQSOazBFx5dlsI4wqBXd0C4zA9QaLYNH0fC1ITCgRnHOe7U0cDd4GbF8LZKmur6KWfktwILgG4UOISFpzOdCkYKcvbSi4M3NY1fBi/A5LHHsTKz1fRGP9Y+oN7l/x5hmFKD3Nq3+yjKTED0a8VpHCzsczqSMtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i7k6FmGsWqkTpoJWoxWrNbCYTChf7pymnn/tjC47NAw=;
 b=DyzudtH3GPDJDx/RcIROixebX75FJT1FEEHmPTn62CoOCUdtCf+02SSm8qY7jQfM+O+3VuAv9Yfim/ZdhJlXewgKaNYOgS7bwD9kiN8xBsy36xg9KmGdj2BrBBcv81kRXAVtVfmMH+c6b1xalqjuZhk5k9EN3NH60HlldhQkZeavbh4+2qznYySb/NuqVwYeK5bOzaCWtrBFykid6n3AQ37t7xs6UtlQl22i6kwzmppZdl2SdrCMlUL4ohZcenwsuRFkAphbkOgHI/2pVPcxxQFSfHDt/RbjUWNSCSfrsjIhjEo04/m/ziXw4/8/0Yb+nzFbjZLtHsqrmm8RBAWlEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB3PR0402MB3673.eurprd04.prod.outlook.com (2603:10a6:8:c::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3611.25; Mon, 30 Nov 2020 04:16:21 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::1c22:83d3:bc1e:6383]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::1c22:83d3:bc1e:6383%4]) with mapi id 15.20.3611.025; Mon, 30 Nov 2020
 04:16:21 +0000
Subject: Re: [PATCH v4 2/2] md/cluster: fix deadlock when node is doing resync
 job
To:     Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        linux-raid@vger.kernel.org, song@kernel.org, xni@redhat.com
Cc:     lidong.zhong@suse.com, neilb@suse.de, colyli@suse.de,
        stable@vger.kernel.org
References: <1605786094-5582-1-git-send-email-heming.zhao@suse.com>
 <1605786094-5582-3-git-send-email-heming.zhao@suse.com>
 <b120e2b5-f322-6dd2-2b3e-8b7eb7f2bc3d@cloud.ionos.com>
From:   "heming.zhao@suse.com" <heming.zhao@suse.com>
Message-ID: <0b73b4d1-17b8-4c07-35d3-37b616a87432@suse.com>
Date:   Mon, 30 Nov 2020 12:16:09 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <b120e2b5-f322-6dd2-2b3e-8b7eb7f2bc3d@cloud.ionos.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [123.123.134.103]
X-ClientProxiedBy: HK2PR02CA0203.apcprd02.prod.outlook.com
 (2603:1096:201:20::15) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.134.103) by HK2PR02CA0203.apcprd02.prod.outlook.com (2603:1096:201:20::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20 via Frontend Transport; Mon, 30 Nov 2020 04:16:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1db72cd1-de61-4de1-77ef-08d894e6b178
X-MS-TrafficTypeDiagnostic: DB3PR0402MB3673:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB3PR0402MB3673A612D9903414012FE08A97F50@DB3PR0402MB3673.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I8G+q7AYHejZS3GsNEXphsMCm5s6G8Ax7ypxKtffXxnn1Y9Jqx7shHKFHDx0XKFCh1DuWTXEER8TEt4KQsfYDrwUH53j1R8xdfy0Xq+JMcu7YAO9SXeydMgzGxEw9WXvfTpM3wlJ2BmeEYYpwB06WZ3Q6w3IOmgPjOie7qpXwxbO9sip7FFeKDg6G1Fic5/cgl/mk+fBNAjUdg4YUWmCTPRVinuKgU/dHIRykPNORmBbRa9T+d+XGUJjKo7Kd8SBhTrLRyWxZLoenP8lAfPeKnNj4EW73lYrK/HuqtI4spBPIis1oj7//Ykvsr8/7xIqyem983Rhe/ncMP+EiuhKpiEcP0JsjXnfrzuwFcElhk+OTO6SiyXpc+iCqHsGIYiLnCpHFdZhkOAR5uCYLIhJOg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(396003)(346002)(39860400002)(376002)(6486002)(316002)(956004)(4326008)(2616005)(26005)(31686004)(2906002)(8936002)(8676002)(52116002)(6512007)(478600001)(186003)(31696002)(16526019)(86362001)(6506007)(36756003)(66946007)(66476007)(66556008)(4744005)(5660300002)(53546011)(6666004)(8886007)(9126006)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZnV3Umg3bVorK1BoWXg2RWYxMHppTzhZWXlmQ0xlWWdHYk9SMHM5VThGNTEv?=
 =?utf-8?B?V0Y2TVRPWUsxdDFpYjlBbW1OTmNnaDZoVTYrT0tENkxrV2R5aURvRnljN05O?=
 =?utf-8?B?N1d1QzFGeWdpdmh0WGNFcTE2WWJNMS9WajFYYzllYWkwaEIzV0k4TENTREda?=
 =?utf-8?B?MDcwOVJBSUk5RVFuUUxNWnd1TFhtOFpETTNFWkFWYVREeFM1Q0VyOUFoWmxo?=
 =?utf-8?B?ZXlhdG03RFhXRWxKRlN2SXlwRmVSd2xWMDg0ZG9qaUsrMGovMlpDWmFUcWdQ?=
 =?utf-8?B?SmVZRC93M1ZtRW91U3hEYkF3dkdJaHFSalIvMGU0QWt3VURoMUdnRWxZeGE5?=
 =?utf-8?B?eHd4Wk9EeHFwQ3U4cmh0NysyVGRQQXdTQ25tRnIrTjV0WHd3TzRFWGhLNWZ1?=
 =?utf-8?B?TFhtZWthUGJaZnp2cDA0dEZiU21XQk5iRDdtZTdnRXVxU243UUM1Q1V0T0w4?=
 =?utf-8?B?MXhjemcrKzE2OTdXTWJkRW9wWlV0UGExVlNGQWxBSHIvOS82MUc2cnhmclFJ?=
 =?utf-8?B?NHNuQW9QNEhWZjNpeUcvS0RDeGJsTzVVUS9qdjNOeWtmbFA3YzRxQThDTDVw?=
 =?utf-8?B?ejNsM3Q2MU9GNXJhcTFhaDVoT1FSdzAvbk82M0VmUjNXUzUxRjdwV1FDdXNU?=
 =?utf-8?B?NnAzWi9TT1N0eUF3ZEVmVnNCZG9kaG4xVG1PTmZiWjVGWEMzVlFwVmxqclFK?=
 =?utf-8?B?dDZuQ0QxUGhwa3RlOU5iYW85NUlRRnBwK0xZSFZxKzdtdll6VnIvYUVZMHZ4?=
 =?utf-8?B?ME1GdmhySlNSZXZtRjcxV0oyR21ETjdjOTFxSDcxUEdnb0tDRStlczNGZUx3?=
 =?utf-8?B?S1oxSExMNjJpVzNIb1B4dGZWcU5oTkpGbGVsWVBZbzhyN3FIZExWSHFJQ21D?=
 =?utf-8?B?ekQyelNzRU5oT2FLcnkvVEJiVkdPQ2JibGxRam0yN29WNlhQTERZRzVYNDJH?=
 =?utf-8?B?eXNFTDJBSXhXOFRHTCtpZlZyLzJDbmdsQ1dhVmxEZFJBQ3l3VHhoZzNUNHNx?=
 =?utf-8?B?WXJiTGgxR0o5bzBoSUlLM0pZQnpNRzNSVzVBZ0dIc1FCRFJmUmhoQXkxbmFU?=
 =?utf-8?B?aGNPMFA4NVZ2WWVvcGFSenpremR0NUgvb2U5TjFGaFpsQXc0V1ZNUEZ1UmNW?=
 =?utf-8?B?VUJTRWxNYTZVYmJBNnB3R3JkV0xYbk9uSEdzc3lqMkJIVnFSSWN0TTJxN2JP?=
 =?utf-8?B?ZCtleVNvVXRLNXkzUzhmY05id2JuOTVsSms4NTNCSzdwVlhkTHNzVVhqVUpB?=
 =?utf-8?B?bjJmWFZ4TlQzMmxoYkpENzJiWVJDTXRURXZNUGlGZU1EbVVnOGRQbFV6em5k?=
 =?utf-8?Q?pgKMRE4Q0qTNV+PHPa05wwF1HBgl5oXoT4?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1db72cd1-de61-4de1-77ef-08d894e6b178
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2020 04:16:21.5415
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yBb66YmqkEPyo/VSt5BN3SxFOkapHJKed4IwRPZsrNtvOUinqHdaQuG68NTCaO7lUxXWJmZy4eySNHOmybrybg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3673
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/30/20 10:31 AM, Guoqing Jiang wrote:
> 
> 
> On 11/19/20 12:41, Zhao Heming wrote:
>> mkfs.xfs /dev/md0
> 
> This would make people think clustered raid can co-work with local fs well ...

This issue came from real customer issue. For easy understanding, I simplify the scenario.
The real usage is customer exports clustered array to only one virtual-machine as storage (xfs on it).
The host side follows clustered rules, use clustered lvm volumes on top of clustered array.

> 
>> mdadm --manage --add /dev/md0 /dev/sdi
>> mdadm --wait /dev/md0
>> mdadm --grow --raid-devices=3 /dev/md0
>>
>> mdadm /dev/md0 --fail /dev/sdg
>> mdadm /dev/md0 --remove /dev/sdg
>> mdadm --grow --raid-devices=2 /dev/md0
> 
> The above is good fit for a new test case in mdadm.
> 
A new test case may name: 02r1_Grow_add_remove
When I have time, I will do this job.

> Thanks,
> Guoqing
> 

Thanks.

