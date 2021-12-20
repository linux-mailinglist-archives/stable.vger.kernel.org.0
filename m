Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96E3947A764
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 10:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbhLTJqw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 04:46:52 -0500
Received: from mail-db5eur01lp2057.outbound.protection.outlook.com ([104.47.2.57]:6095
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229623AbhLTJqw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Dec 2021 04:46:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fux3QjhHcFPNrJoT2qr7NacFkeHMjBaZKd0rxQnyjWSMvrfftKxF79OXDaOGbwkni/JqEnyAA+eEOsi/QqqDsCcQ1DUSIGgXVL5TPVYscQAigVbdhMOjGNXEY/QvgctslO6foWbIJJoi+bjkeaPvvKHJ9m0lH1BiDWFL5Av4psoG+L4Oe4+WtHvsemD6COSQJl4IejxLhpiZ+SNh2KLC6IqQdJBHMrtTCcGR26SAWODlarYxtY+l5dqigiA++Ra07jEY2PMJmsUzO9dMP70OnkKQibfajryxiLszv7eKMDHdk4QazBv5adHxXc6PE+zYYNSiT+q1e1mFe7o+5874oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VNLlkbrDEn7LMXyn8rAzqst9WLLlqEkBpjb1hYIea+w=;
 b=Q0qvRTOVFH+Nh9HLynGXpffcsyaaiXNPuMNjaF9mb0QeCuDsWWMCmu46EHO7yJ2Ugyn3l+iC0NAqpFcTOPx3oMvPnNBD2m2kOh8MADsBVL3HhEMflzluJJi7OC010DodwK6kja1MeX2ItH5kInBDir0uo/EMy1zp0oL5jhQpfCOrw/TBcPzz3A4+pjQP3Udr3rpudqZDB0NCNImkFXYV/jYz83UxSbJnnIm3UJr2lpPJa/OmdJw2TdDx6wE5O3JZJzICwnyAhyxrTvMLO8K4ul0os7zmg1RjhEFTkkC9taA5L8zxMvI08MrZQMubByubbINpzWsJiVUnMyCHCcmz4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VNLlkbrDEn7LMXyn8rAzqst9WLLlqEkBpjb1hYIea+w=;
 b=PsCTGsQveiZmYkjEwaRRv/3oWBGOOd6snSKK5+o4B1IM2ZWguYCa4u0jTW8mW9RTANvf96GDJoepi9ZLvJzfTk6bF/zdGhnqxgDO+/ZkXkWxMs3Xpc/ZL7TbxZqpTFN+3bcnZWC+n4s2c8nEdIibwqXdgNsd2Acq4RLDOOoYk/k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nokia.com;
Received: from AM0PR07MB4531.eurprd07.prod.outlook.com (2603:10a6:208:6e::15)
 by AM0PR07MB3876.eurprd07.prod.outlook.com (2603:10a6:208:44::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.14; Mon, 20 Dec
 2021 09:46:47 +0000
Received: from AM0PR07MB4531.eurprd07.prod.outlook.com
 ([fe80::4515:de1:dc1f:db8f]) by AM0PR07MB4531.eurprd07.prod.outlook.com
 ([fe80::4515:de1:dc1f:db8f%4]) with mapi id 15.20.4823.014; Mon, 20 Dec 2021
 09:46:47 +0000
Message-ID: <08d6657c-afa9-8739-196b-1e66d802e614@nokia.com>
Date:   Mon, 20 Dec 2021 10:46:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v2] mtd: spi-nor: Check for zero erase size in
 spi_nor_find_best_erase_type()
Content-Language: en-US
To:     Tudor.Ambarus@microchip.com, linux-mtd@lists.infradead.org
Cc:     p.yadav@ti.com, michael@walle.cc, miquel.raynal@bootlin.com,
        richard@nod.at, vigneshr@ti.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20211119081412.29732-1-alexander.sverdlin@nokia.com>
 <0cabce03-bc22-eb3d-fa77-a1f5f787784d@microchip.com>
From:   Alexander Sverdlin <alexander.sverdlin@nokia.com>
In-Reply-To: <0cabce03-bc22-eb3d-fa77-a1f5f787784d@microchip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM5PR0601CA0080.eurprd06.prod.outlook.com
 (2603:10a6:206::45) To AM0PR07MB4531.eurprd07.prod.outlook.com
 (2603:10a6:208:6e::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3bc506e2-8cfb-48bb-f635-08d9c39da3ae
X-MS-TrafficTypeDiagnostic: AM0PR07MB3876:EE_
X-Microsoft-Antispam-PRVS: <AM0PR07MB38766A26391DAFF498AA01A9887B9@AM0PR07MB3876.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cTcPtxxNo4USSP4P32IxnSI7yinCDeaxNnwt/jgOZQQE61kSCG+edWleq0eNmXKKtra7/8jtZ0GRCqXBetuL4ssmZx9PEJPbBilBPbj+P20f/BDP8q9AjRy2N/98wFMd1mmIV6g5FF6Yyi4XYR/cSS1AWxlc88alNdFrSpsEwwp6pVLYPMrs9C0TIzxPfQ8LLtWF6+eoSXbblPE8vNSJk3YzFIy7vHr38E8uVDrgA3+0QI3tYgJZirvtI1PTaRXZ55FuyZKC26vF1bS2U2WGqbzNp6HD7JxRediVWpcv9WcTS3ytOFnBgaGbSk5WoJT/usyICewLpmuWkJr8odKq0gQOpxOgQuKQ4+ffGQ5hOkffKJhu1mXFnMg5WKEhNc6P454w8K/AWv79rvqCe5f3NqMXhgZaHmR3fp+iuWcjUjC8prmbRHNH5CLStXpBFKviw1JSOsCyfuplkyCQ9KqbkHjUGjFt/6fVIv6JOk9H6fz/opfsqdwy5loiYGk8pBO6g0sWe51abuaV20q6Jsy4XX4vani/tyzIyL0MXPyHNNJqFgvlTmObfEeRDJKodILOCFwiP9AQIC/0VXbJmsOCo3m3ftciuDGlkkL69edJH3MpCGvLJtrj6cN4ibvQDn0BpzmsVk6YmqXhIXLQaXd0/yctS3lxn6eZiIl4Pr7bTuiEEBVWkL/+xTvmlBNwgGQfEKjUnu+yUFwCQqAg5BxPZcy9xRXugt+n2lqG7jIjb9dczbhBlecSbei8s0A/q9jqMazTM4ym2n3LjuUIs+L2p2CwojJWdxSlTb1nIstPvqHgY2t3hMQm9GV7E8FXjTbbdj5j7qthdAg8F1sPmDTCxYS0tfJv/+e1geE79nh3fXzFgyxDFTxacWVS7IffZ5W7o7WBdOEwhGFa8CRQfOFKxw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR07MB4531.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(31686004)(44832011)(2906002)(4326008)(38350700002)(38100700002)(6666004)(66476007)(316002)(66946007)(82960400001)(5660300002)(8936002)(508600001)(966005)(86362001)(66556008)(31696002)(52116002)(6506007)(6512007)(8676002)(26005)(2616005)(186003)(6486002)(53546011)(36756003)(83380400001)(43740500002)(45980500001)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TUZPNzZ0eTFPNE0zK1hJQkxmanVSNUF0Nlp5eUJyR3Q5SzhmRmhtLzMrZS92?=
 =?utf-8?B?cGxPTUswNGpTQ2JMVUZNOXdFbzBIZ1ZKOW1Sa3g3Vm91MW10RnpRMHM5dDhH?=
 =?utf-8?B?TkdicDRINnp0RzRmUjdGVU9WUHN3ZVNmMEZhNkRpV0pTS0ttRjdldXAxS3c1?=
 =?utf-8?B?a0hscXljSDErTi93ejFxS28xWFRKM3pDcThuWExzYmQ0eFkzK2RSd1VSeEVt?=
 =?utf-8?B?cjB5OEJ1NDFCZndBTzJ6ZTZSbjgxNjFXbVJqTHAzWlVRaUlZRm1MZnYxTk82?=
 =?utf-8?B?SjBESFpPYUxpa1dEbFpEWXAxdjBTSlozclNqL2hpOFNRQWowTHl2NGhiT25p?=
 =?utf-8?B?TkJCSjRaVkxGcDB5KzBlWWZXN3czYnA1MGlOUHRIck9jeENYZlJOQVZaamRm?=
 =?utf-8?B?U1RlcldEbGtQSlg2SUMxc1cwY2NnTzRNTi91WXk0WVVRSjBTVEQ0MG5YTnY4?=
 =?utf-8?B?TW45RUVsYWNpeUx6aDdva2JtZk5aTjRoOTg1M0REQzhtM0dvRHgwQ3QyTXVZ?=
 =?utf-8?B?OVZubE15ZlR0LzkvT0xoZWlxeWh6eDZoby9yNHpKVmtGU2xuSzlrdFJONDVS?=
 =?utf-8?B?VWtZd0J6U3hUMWxiNG9mWTRrY2VBOEFkOWdTdXdkUTNJM1RKZDFtVkRjNk5B?=
 =?utf-8?B?SXFnNHE3SlFGQzFxMUZIQkdPOE94b08rVGFtOGh6YVNKckt5Z3lTYTFrc3F1?=
 =?utf-8?B?R0h3SzNTaTZQdi90d3dJVTNiWk1YU3YvS3lkYzhlTFdvaG9WY1NBbjJtdi9K?=
 =?utf-8?B?UHdkZzB1MWgrQ1dXZytkQUxlUVZlUWxIVG41eDJ3bStOZExud2pwUFEvOG5B?=
 =?utf-8?B?OURwdFV5SDdOc25xZkNLcUora2pLVm80Y29qMllxbzBKRTFpdXEyejF4WnBs?=
 =?utf-8?B?RW5xRndibFBsV1Y5VTdjSzRCeE5qOVNJTTJ1aG9rd21vZnY0RklnMFpkL0U0?=
 =?utf-8?B?T2VTV2NvVER3ZlBWWkhuNStVU2hUbERVUFcyV214anphU0JDTTRyaXZNY0lO?=
 =?utf-8?B?L0drMWRvZUZUTU1XVUV3azdlbnBKVkduNHNvM0xpWWdGTXJ4ZWl0ZVowQ1pS?=
 =?utf-8?B?Y2MvbEJuMHRzRE1ma0E1N05jOWdNNU1QajU2NStRb2ZlN1BrYmRGQk5LVjR1?=
 =?utf-8?B?dWl4UmkxMmZUVmUzMEFha0p1R3A3NXdkdGxUMXBraXRiNVVKNzYvdjhJSW5E?=
 =?utf-8?B?a0YvMURTbjNpd3l3S3BzcnNxaTVwTU1QenJ6dnNaWkJySXlVQUsxZnRQQ0pw?=
 =?utf-8?B?R0R6ZXRHYkV4S2dmbnFSL3ozeDQ0Y2R5OG9KTHd3SGk5YjBCK1JBNk00cFZY?=
 =?utf-8?B?bCsxWmVERE5JeXp5VnM1Z2ExdlFDSnRoNWFYUElSUk5TbEIzSHhENlV0cElr?=
 =?utf-8?B?bUR5NldSd1ozdWpySUtKTVk5SEhQV1A2aVAycjEybEtlQVB6VFovR0dtZFVN?=
 =?utf-8?B?UytzTDVIelBlQ0VyakViSkQxQzhzRk9zUWtKRS9lTys1eTNwQzNXS2xVWGdp?=
 =?utf-8?B?UVJETlZpVnJ1Q1pxdExkK1Y3TGN5c096TU5naW5UdDI0blVMZDA2S3FuMjg5?=
 =?utf-8?B?SXltMFpaNjNCUkdKSlFhVS8rVUVSWUp1c080MmgrMDFZOFNGUGRmSGV3WHkz?=
 =?utf-8?B?cnEyV2lpZ21CSEJsMStzTnNPZUduUndJUWpVVm5KUUlUZFcrejY3U3llT0xS?=
 =?utf-8?B?RUY5TEZaOG5qY1I3WmozNFAveVBQNDdxNkZQUHlabTNUT0NjTSsrcWc2Uk9i?=
 =?utf-8?B?ZExieWxOamZrU01jc21YSGdhb1A4R1hacStSQWdza21NWHlTMVVLTWJYeHNS?=
 =?utf-8?B?VDU3MUpWWWplODdvMFpxa3pKaWNqNloyNVZ1WVlQTllKSEdwY3F6a2ZxYkhK?=
 =?utf-8?B?cjhjcGhnUUhTRURlUE1DMStwcVdHZVpWZXNWbk1TSG9kS0NxNXpnczJwbDZs?=
 =?utf-8?B?UXpPZzFSYnlZL1IyNVUxeFVnSExWSVJSUHhaUkJJc3QvVTZIamlrcGlEdWJq?=
 =?utf-8?B?bHN3Vnh1REVVbEgvNGExUVRERWlRRGJIdkpKODN0R0RtU1c0ZEFGK3VpTFVR?=
 =?utf-8?B?Smt0RVdiSnhNbGZocVowc3ZFUmJ1bmpRRTNnMW9XM1gyQjlGMjYrN2dNRGFL?=
 =?utf-8?B?ektsZmkyK205ZVJHL0R1dUhmb2hYZzcra0pNQ2pBa1ZRK0I0cXFuQSt6cWZL?=
 =?utf-8?B?cGxtNG56SndHS1VoM3duQm9sSmFOeDZNaldCbkN5dW5lVlU3a29IdHRra3Nv?=
 =?utf-8?B?OGtsN1hiemtRajZ2WVlNcDZxTE9nPT0=?=
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bc506e2-8cfb-48bb-f635-08d9c39da3ae
X-MS-Exchange-CrossTenant-AuthSource: AM0PR07MB4531.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2021 09:46:47.5882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zn6ASIKSP2g4WHvCYLQpy8RxZ+eEsYKLFDoF8T3R0OZH/tbQ1huRRInJ78R1OSp1+fSgSh8tpSgM+ygLAa2+1h2rtjHpzb11n+UuAaoDzuA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR07MB3876
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Tudor,

On 18/12/2021 02:31, Tudor.Ambarus@microchip.com wrote:
>> Erase can be zeroed in spi_nor_parse_4bait() or
>> spi_nor_init_non_uniform_erase_map(). In practice it happened with
>> mt25qu256a, which supports 4K, 32K, 64K erases with 3b address commands,
>> but only 4K and 64K erase with 4b address commands.
> 
> :D
> 
>>
>> Fixes: dc92843159a7 ("mtd: spi-nor: fix erase_type array to indicate current map conf")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
>> ---
>> Changes in v2:
>> erase->opcode -> erase->size
>>
>>  drivers/mtd/spi-nor/core.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/mtd/spi-nor/core.c b/drivers/mtd/spi-nor/core.c
>> index 88dd090..183ea9d 100644
>> --- a/drivers/mtd/spi-nor/core.c
>> +++ b/drivers/mtd/spi-nor/core.c
>> @@ -1400,6 +1400,8 @@ spi_nor_find_best_erase_type(const struct spi_nor_erase_map *map,
>>                         continue;
>>
>>                 erase = &map->erase_type[i];
>> +               if (!erase->size)
>> +                       continue;
> 
> I need a bit of context here. Does mt25qu256a has a uniform erase layout?

You caught me, the bug will not be visible with this flash type without the patch
which has been ignored for long time:
https://www.spinics.net/lists/linux-mtd/msg11510.html

I however run the above patch because of the reasons described in the commit message.
Nevertheless, the bug fixed now remains a bug no matter what triggers it.

> i.e. Does your flash has sectors of more than one size or does not allow
> the 4K and 64K erase types to be applied on all sectors in the 4B case?
> If no, you should have been in the spi_nor_has_uniform_erase() case, and
> if this case does not suit you, maybe we should update the code for this
> specific case instead.
> 
> On a short look I see that this flash defines just BFPT and 4BAIT table,
> so no SMPT. It looks like you're forcing the flash to behave as it had defined
> SMPT. Am I wrong?
> 
> Also, should we update the region's erase mask instead and mask out the
> unsupported erase type? I would love to hear more about your use case.

-- 
Best regards,
Alexander Sverdlin.
