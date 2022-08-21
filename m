Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8411259B490
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 16:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbiHUOpK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 10:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiHUOpJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 10:45:09 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130129.outbound.protection.outlook.com [40.107.13.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0D7020F7F;
        Sun, 21 Aug 2022 07:45:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hlXIh0SjVKY2RFhYiUN30us72AAOkMbDSpgHkKWGr+AVnUYvWg0MvlGrWN5y6uBOXSuU/3M4aCy/c2JDsExzGCnPLPisxWawkUHFU1FlfLCBeQzYrGNNig/Ipk8JlyYAzBsmg//OBooosr3yJEDiFRNlsVkL3rGQenpEa56DgsX/jwlWU7rNZusthASLnIhM8SBZkR/j4CQIi12g6h+0m97Z++1izm+wzO6iP4Nh41UOQSY48PYJCcw0qe2QHGneYjdm/XmaAZJGl7oXSwkqSm1X2026J+9ju1NKxSiZXEPWKGIhnejTGox1gKypHHTF11rb0lIu3F4MU9iV5tUlpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4dDHdk9KHee+z/TuhFFTFsdSrT71KqT/iOrKAHl0NCU=;
 b=QJ/E/cCToEXPDzaIKyTfv9M7lBU2BvF5FHBwQkq/eXKG7CcdRD1mSlPL4VhsdUTLA7Ypy/V029i07ruE/aeJtSqjBT/QXTtxSLK5YtJqL3n432EqurlthBxTr+SVpNOyWwkWHUd6Xi2FUZnTm9nGqYQ+kctTXIpLhU6bNM4MsO0ft0/tfry6Ny/AmfKyVWImngbbSzGDIaonYbs00Q8z3IAR4qbNxjt4NodxiIHX80G0OzuS7G+MrUjeyD3rStH1ZtwISorBz1sfO02Ze9MLFDjRrlQdbMfeUmqOnpmGexIAJ0YbRDQE+8bFxp098q4hVF3UT45iNw6nBRGf3aM+TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=axentia.se; dmarc=pass action=none header.from=axentia.se;
 dkim=pass header.d=axentia.se; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=axentia.se;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4dDHdk9KHee+z/TuhFFTFsdSrT71KqT/iOrKAHl0NCU=;
 b=hTgjqqqsrPnwEMe3I6eJW99jBGo3YuyiLCS0WHOJbz3GzVUrigyH/nSazmm8OcgLWIlszzNbeeLKVtlkLFWbFiMEVG5RWLT5TpbgcD1r6IeNTz5G1NTq/qOLYNFhpJDGokgvb5K+grAr2aAYVlvHw8+QrSMthQko9SUew+mFVJA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=axentia.se;
Received: from AM0PR02MB4436.eurprd02.prod.outlook.com (2603:10a6:208:ed::15)
 by VI1PR02MB4959.eurprd02.prod.outlook.com (2603:10a6:803:bc::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.22; Sun, 21 Aug
 2022 14:45:02 +0000
Received: from AM0PR02MB4436.eurprd02.prod.outlook.com
 ([fe80::1d88:3306:c280:3179]) by AM0PR02MB4436.eurprd02.prod.outlook.com
 ([fe80::1d88:3306:c280:3179%6]) with mapi id 15.20.5546.020; Sun, 21 Aug 2022
 14:45:02 +0000
Message-ID: <2b189372-b855-bedc-779a-a834ddbab8d6@axentia.se>
Date:   Sun, 21 Aug 2022 16:45:18 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] mtd: rawnand: atmel: Unmap streaming DMA mappings
Content-Language: en-US
To:     Thorsten Leemhuis <regressions@leemhuis.info>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        miquel.raynal@bootlin.com, richard@nod.at, vigneshr@ti.com
Cc:     nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com,
        claudiu.beznea@microchip.com, bbrezillon@kernel.org,
        linux-mtd@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20220728074014.145406-1-tudor.ambarus@microchip.com>
 <f041e45a-679c-5633-f855-9be0974d0086@leemhuis.info>
From:   Peter Rosin <peda@axentia.se>
In-Reply-To: <f041e45a-679c-5633-f855-9be0974d0086@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BE1P281CA0057.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:23::13) To AM0PR02MB4436.eurprd02.prod.outlook.com
 (2603:10a6:208:ed::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 47702db2-7ba8-41b7-f4c8-08da8383bac5
X-MS-TrafficTypeDiagnostic: VI1PR02MB4959:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aTkpx0RRfrhBVpi+hl46TrkOfhEqUusJTCXIKyZOlHnG5yznonmVds884T7fgJroWv1sHC5KYDXATNnGYoZYlQjetiwMBAnH7GQiigvi2fNRA0tvBPk73QvhDJ/XYj51NGkc1ntleV+M6rFKJdIvBZhbXkOy2U46PNuPl3bm9j9FLXscVzc6EOcb+BcCe+1p3JeRsnXtcuQy5koEt/lc1gks2ncWptBWO7Xb8losjk80VBzM5X3sIkiNAzrZTW9oa4XyYizGoRKjBFV+aMkj+US5cV3Mjz1q1V8k6s49pjfpZxf3Hc89wNtkUIpQ5sK6oIMPRs/h7eli5pLJQii1HBxYSDBYrwJkGt8ZnAu9tyuQ35iDgF1ZUtH/gi22e88YqL2WfwtgeVDO3H0V3+qyekYbgaUfQs6oo4aV+7DxtlkSTRkycSsIo8ccz6pk8idHjLeOevPd++yLB4VqjgIJN5o5A+emK7gOtowNZXw1mwNvkZ5NBGTulpdujqnkyQiTO3ULrOb4hg3KKhpQTG1frfYm7d7eFc1qpEAienpWy4g6nDalzc2hU53WJLJWnapVolqzcqK/YQpjA2wVSa4Oc5g0rb4Baxzwb3W7s249HaXFmTcdE+QwmBvb1tHGP2bbrDt58jvr3YqgTJi1GbdYCpuzBsRmZhm7H88BTuX0jt5Pj8rPfcSsidn+TyOOuBwaeuVdsGuDnKpd9lkUiZDATJ0LJ5BX/QryrbL7MUEZTGdyxBk14nsJx2mRnV16EnslZzmeYI5mCvFR8S2GcX0gFJFw5ejl/nK4hfV81yUt1higYPgLjSZnFesCUx2tEyLH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR02MB4436.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(39830400003)(376002)(366004)(136003)(478600001)(41300700001)(6666004)(53546011)(6506007)(31696002)(86362001)(36756003)(6512007)(26005)(83380400001)(31686004)(2616005)(966005)(6486002)(186003)(66946007)(8676002)(66476007)(4326008)(110136005)(316002)(66556008)(7416002)(5660300002)(8936002)(38100700002)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dCtpZTZOTXJHQ3AxMGJaQ01idU42cVdUWnVpemJxZTNhMWllaVF3VjJybnpM?=
 =?utf-8?B?RGJnbjg0VTFsK2hNVFFVcyt5OHYxL244aGRnUDdIOE9oSzFlSnVHUnZmVGJm?=
 =?utf-8?B?MEVvKzg4NS83UTc3MDBWcVdrTHJTWlY5UlB5Vm0rblRTMXJiTStNRlJ3RDNM?=
 =?utf-8?B?Y0UxQzZiaTdzMW5yY3Q0ejJTejNGa01ZNjI0ZS9hQXVVTGVqRE9xZXJBdTdS?=
 =?utf-8?B?T0I3NlAybUR2MzZCa1RwcVlzNVZ3TVo1eHNoa1JqZmN5T0FUbjc4bnZvZTY0?=
 =?utf-8?B?Q1owY0JRMGtqRlV5UzE1dVFzQmFlN2ZQT3ZTL2wvYjQ3QWRWSW5ibkp2UEJD?=
 =?utf-8?B?V2ZFYTBPcTRDU0laSUhYenlRTTBhcUs0dGczd1czcERmRm9VdHA4R05HT0w5?=
 =?utf-8?B?UDlFc25iU2J0MzRoeVA3eFJCYjBrMGNxVW12YzFHYjk1bnMvaE1LZ1pUUkRu?=
 =?utf-8?B?Z0RYdUVVWWFsRXV3eDhLZkl1SU1aeml0VXZCSjduYjBIVk5IZWxVeGZkYTA1?=
 =?utf-8?B?QklLNndhazNqSDNpWHBhTkpUWjRPUDE5R3F2VGxWTW5ibnd3bU41NFdDVEU3?=
 =?utf-8?B?R0ozU0RwRVIwSGdGUDhzeHNFR1A3KzNMamc0SVBuRjFjNmRyM1BKOEp3aDY2?=
 =?utf-8?B?ZUFPUVdWTU5CTGs2ZVFMaS95WGpERDR5WUppVjRmZjdBQktHb245WW5jbGFh?=
 =?utf-8?B?RUF5cE1hUkE0OHo5ZllYOVpqdnJIeXhIUkZvUnFBOWVvVWoyNExHSGptWGR6?=
 =?utf-8?B?c3Exdkhic2xSQXpLMDFnRnZuTVdseUZQb2FHTXZiZWU4ZlhHV1dObVltOEJp?=
 =?utf-8?B?QjlEWTJUUGROVXMvVi8ycWwvM3dsR3FiWWMrZkhjMm1hdG9BeG0yNG5CRjFC?=
 =?utf-8?B?eG9HTldYdGIyOHJBa2g1c2dZbWhjZVZNOVFlbmpGNlJvSk1YWmpDUjF6TUl2?=
 =?utf-8?B?ZkdqaVk3RFgyUTBqM0RVQ09veFdiVXFyK04rVVFaVVJONFRSd2kwSElpMnBI?=
 =?utf-8?B?R25BN3JHMDFsdERTdVhyTXBBLzl6bGg2bk1qR01LM21LRkRSL2ZkOWg0eG1K?=
 =?utf-8?B?aXpWQkpYZzBHdFBwZ3RtSWhaOS9lMCtMbHdTTUNLN0diK3BkM2d6UnZDb2pH?=
 =?utf-8?B?aE9LU3hESkk0dEVoUk5sOUVJNmZUejkwdkNpZDM2dzVpRVFsY0o0a0t4Tkov?=
 =?utf-8?B?VC9zMCtHemtQRGtiQlV4U3ZkNHkzWkNRaU82Ukt5bmpiTHRLaWRGRGwzQUM1?=
 =?utf-8?B?WVFZVHFtL3BzdmxwYmZiVGdVR3ZQclZYUSsxbFBVc1Y1ZERDTERXWU1lSlFG?=
 =?utf-8?B?eG14Q0U1LzhhKzZYaERsNm9xZFZsTzBKVnEwOVRoT3dTSHFPWHJRZDBzc3Q4?=
 =?utf-8?B?KzdtK0NRSXcwNExFa2l5bkpLZEMwZkxwTWtYQ1J2WktBeGhvTkxwT00vMkpH?=
 =?utf-8?B?VUtiZE55MjNzQ2duZHE5dW4xNFV3Tnd5VFk3K1JjYXlNbngvM3l4c2diME5y?=
 =?utf-8?B?a0pWVkpGcXdldi9IVkV6YnlaT0xCejZtTEp3UWs0czVMNk9WYWxaT25LejZw?=
 =?utf-8?B?ZHYva000dENNNGVWNmJOWVR0KzZsV3FvMU9lNzNuZjNGTndmM3JQQVR2L3RB?=
 =?utf-8?B?b1dPMEJUM1laQ3I4S041WFh2ZGhkekJrTUg2MTVlVnkyVjIwUGphL0Niakta?=
 =?utf-8?B?akF5Z3hBT0tITE83YTZjNnRXV002eENmZk1GbG94V1h2TDhISXBOdytwNEdu?=
 =?utf-8?B?Mjc4ZEFSajBlT2tzbFptNmh5Qm5CNlUyMjk4UzNhRFFKVG9NUHpKZWMycmNL?=
 =?utf-8?B?UEx2K2R0MHRhYi94YVI1UG5kdG93bmJrZ3VBbVY3OXZBVkhDVStPV1puZ0Er?=
 =?utf-8?B?WlNiSTg0OEUxY3dwVnVEN3dYVVdtc0V1bWYwc3J1NFFLRkpVTCtkanRBWm0y?=
 =?utf-8?B?YnRNb2xSYzV0ZjIwOW5SRjFDTVVEZ3VncVRjUHNyaTROQmppblp2SmdOcnZq?=
 =?utf-8?B?Zkc4VGtaNU8zRTJ3U094RFBXMVVUU0JDdHc2S1lqQVhNQTUrRDVubDNGVkRJ?=
 =?utf-8?B?dFlKa292QWpxWTVGVkRWYUorRHpOaVNrSFI3RWlsazdVM1hNN2V4cEhzUTF4?=
 =?utf-8?Q?4slcoZqycw6amFuzNwtyi7NOb?=
X-OriginatorOrg: axentia.se
X-MS-Exchange-CrossTenant-Network-Message-Id: 47702db2-7ba8-41b7-f4c8-08da8383bac5
X-MS-Exchange-CrossTenant-AuthSource: AM0PR02MB4436.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2022 14:45:02.5711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4ee68585-03e1-4785-942a-df9c1871a234
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uq4NmzGXvdMpmwq8QVMQIWI2VDVaIRqzoDd+a85QUAosnvhbB6aK1uVzqinhQbJ+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR02MB4959
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi!

2022-08-17 at 11:28, Thorsten Leemhuis wrote:
> 
> 
> On 28.07.22 09:40, Tudor Ambarus wrote:
>> Every dma_map_single() call should have its dma_unmap_single() counterpart,
>> because the DMA address space is a shared resource and one could render the
>> machine unusable by consuming all DMA addresses.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: f88fc122cc34 ("mtd: nand: Cleanup/rework the atmel_nand driver")
>> Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
> 
> This afaics is missing the following tag:
> 
> Link:
> https://lore.kernel.org/lkml/13c6c9a2-6db5-c3bf-349b-4c127ad3496a@axentia.se/

Indeed, I can confirm that this patch fixes that regression. Yay!

I didn't realize this previously because 1) vacation and 2) many patches
to juggle and I never tried this one on its until this weekend.

Tested-by: Peter Rosin <peda@axentia.se>

Cheers,
Peter

> These tags are considered important by Linus[1] and others, as they
> allow anyone to look into the backstory weeks or years from now. That is
> why they should be placed in cases like this, as
> Documentation/process/submitting-patches.rst and
> Documentation/process/5.Posting.rst explain in more detail. I care
> personally, because these tags make my regression tracking efforts a
> whole lot easier, as they allow my tracking bot 'regzbot' to
> automatically connect reports with patches posted or committed to fix
> tracked regressions.
> 
> [1] see for example:
> https://lore.kernel.org/all/CAHk-=wjMmSZzMJ3Xnskdg4+GGz=5p5p+GSYyFBTh0f-DgvdBWg@mail.gmail.com/
> https://lore.kernel.org/all/CAHk-=wgs38ZrfPvy=nOwVkVzjpM3VFU1zobP37Fwd_h9iAD5JQ@mail.gmail.com/
> https://lore.kernel.org/all/CAHk-=wjxzafG-=J8oT30s7upn4RhBs6TX-uVFZ5rME+L5_DoJA@mail.gmail.com/
> 
> Apropos regzbot, let me tell regzbot to monitor this thread:
> 
> #regzbot ^backmonitor:
> https://lore.kernel.org/lkml/13c6c9a2-6db5-c3bf-349b-4c127ad3496a@axentia.se/
> 
> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
> 
> P.S.: As the Linux kernel's regression tracker I deal with a lot of
> reports and sometimes miss something important when writing mails like
> this. If that's the case here, don't hesitate to tell me in a public
> reply, it's in everyone's interest to set the public record straight.
