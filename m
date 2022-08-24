Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53F8559F8FE
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 14:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233776AbiHXMFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 08:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232759AbiHXMFi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 08:05:38 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2087.outbound.protection.outlook.com [40.107.212.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 040A218379
        for <stable@vger.kernel.org>; Wed, 24 Aug 2022 05:05:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nNo6S7BFm5NNDYxi16f8NF7/M0y49MTUxAe8+nCv9vEugpQ1FqA+tIC1y2xl5gWFAykRx4VbTjf2V7SyNXmi5zbila3qq30Ctozdl/oM8x7q0nhprp+XSckkXSCkdzDKtqmwyXrKckVfLKqY8DqnOtp2xxOnkb930JLWkPVNfIpHyuFdk+JQ/V2Moiiqht/U4Y8mYrdTHZ6Y/6WUeE060RetPn0mTai226hGEZ5Ktv62fgVw5k4SCbCy15LARImS9qdCFg2MJeILwr3Tn4ME1FFumKUTPHLVmfjrigQLHvWIAYWr1fFFjzoNE8bHeJnsIvjSa5wIeMr17lS0M5rrUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=84bMMu4MC8tKouoPQeuCphUHfkZTl2+g+LBJzXIv9PM=;
 b=eaHfNf8O1Il1LK88gJlytyyEVsH1qJi5o53mz2Z6dpEhIh+JLNvhOWJQCu4Jwi345P/u+sI4byYeOD6HDl534K4MV4plHeAGGElp590ntReoMwKy3hL2gTuCqoizc7eZ9L5ajTdYF/xTzArnodKT13ieT8VX3yFL0u9o5KgboH0p3pxYQcS5lCa7csAmQULpJqyQjdAE+9TWrpHtLEzM5U9+lUOVqsDAr0L7BjvDJkiEDfY27VCeCMZ76uUsVuBIvSseF+AIe9wfOiqVaNe8JHjI4QrWbeGJ8X5z/5ypGoa2fD6Pv8cChcBYmuM400cuo9AYXAmNrCs9D8pbwP7dgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=84bMMu4MC8tKouoPQeuCphUHfkZTl2+g+LBJzXIv9PM=;
 b=MN3UsIigRL45T7o/wBzR69M3mib9Tz/7Q8RIGcMF0MMXEvRdl4nqauypMd+F1N+LNgrKL3NhPF7eH6tFBgcIw666OkvEssUOKQivg96S8n6qUADiFAR0ycBXpvvyH2sAYqzh9pd67vFQj/15Oh1hTVfeMyckx2864+YID0chq6s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by BN7PR12MB2641.namprd12.prod.outlook.com (2603:10b6:408:30::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.21; Wed, 24 Aug
 2022 12:05:30 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::e00a:1f8c:dcd1:afc3]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::e00a:1f8c:dcd1:afc3%5]) with mapi id 15.20.5546.022; Wed, 24 Aug 2022
 12:05:30 +0000
Message-ID: <6ce41d24-5eed-5ffc-d4ee-3dd702833347@amd.com>
Date:   Wed, 24 Aug 2022 07:05:25 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: FAILED: patch "[PATCH] pinctrl: amd: Don't save/restore interrupt
 status and wake" failed to apply to 5.10-stable tree
Content-Language: en-US
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Natikar, Basavaraj" <Basavaraj.Natikar@amd.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>
References: <166115772810989@kroah.com>
 <MN0PR12MB610100C31BEDC1E3C46264C6E2709@MN0PR12MB6101.namprd12.prod.outlook.com>
 <YwXLPecNOtqcy1NI@kroah.com>
From:   Mario Limonciello <mario.limonciello@amd.com>
In-Reply-To: <YwXLPecNOtqcy1NI@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1PR02CA0011.namprd02.prod.outlook.com
 (2603:10b6:806:2cf::28) To MN0PR12MB6101.namprd12.prod.outlook.com
 (2603:10b6:208:3cb::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 47567238-6172-41b3-69af-08da85c8f079
X-MS-TrafficTypeDiagnostic: BN7PR12MB2641:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: db5Ji5ugxqlNDXTVFCaOyTQWQcTYCm+85PZ5sSk9xrB+aZuVuhegHGOWmeZpHBnPeydhqUYiPC0q/cZ+qOLNCaymU4PovjQqAmdr8i1rNPswrNBLTlJyNe6gRHhvhCtUkBBIs/4z7SfwXo0kBP/qHf1sZ/KPh931fxXXxtMiqKVXEm2T8Mpy368rUiO7kJ833SClo9RMLkXGBf0DBuRI9i4QSwU4F0SHrNjfu1ba9vlRzoAuoYws6TXK0TpNFkOtxY6i0QIc4X30I52CAbg6UAR0zYHQKmjN4Z3ulPFJV42HA33c+9/GZePMEBG8FyxUzPvFSd7W5kASUV/WTx7kFXB/i1U8IL8PKV3p9X9OxicI0lvjULtDZxZVj+khW/vMrxyAZxCgiYK4iell5SivrcpA+dHDH1ViemrHakjsfRNluPkYSHu/YQVv65likLgjGVUyhO8amYRlpB1F9a3lyU340BdUONDEpfx/cAWMbS+i30Xc45HEyturEbXSF/2PqmMBy+JsiCIhjZcWevQp6JfIaJCDzp8L/DyO38CU1qKk1xl+XSF5qkiZxc3ZpZaIXUS38jBahO6T4NLNB0uB+8v6Kfec6LfFPf7PcVdTxBErYrPgemAh86nneO0KX3NJ97ZLJYjhx5cuphtvzatN0yGN8I8JMln9b2pgESMuBIA5sDieor3c30+aC0uRJqL8A7XPtgpGffFSRbqdtT10HNnnGwP6zRBX4+qpgoatdektZXjLeyz3fUBfv4lOhbSHXIdIbxCIiKtH/C2f+f2PPV1ii7Cry2H/4MvJKjzDmbc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(39860400002)(396003)(366004)(136003)(83380400001)(8676002)(38100700002)(36756003)(66556008)(4326008)(66476007)(66946007)(6512007)(8936002)(6506007)(6666004)(5660300002)(44832011)(6486002)(2906002)(31686004)(478600001)(316002)(6916009)(31696002)(41300700001)(54906003)(86362001)(26005)(2616005)(53546011)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cU41M2ZNWmlxTGlTOUFVMFdUeUx2ZU5kY29mMi9ka1FET281RVIyM2xnZGpx?=
 =?utf-8?B?SUc3SlVHUndGcUtDeTAyTW9NUTdhdXlMQkl5aytLL1pRUEdIY3NsRlRtNHF5?=
 =?utf-8?B?U0tIQkpPVzVwblRWL1BIbXg5OFhaK2M5Zkw5UnBUZHFtMGI1MnBBYWp5Nk9D?=
 =?utf-8?B?MWlHOGRLOXhuV1RqeS93aE9tUGZaSGdVK0VCU2E0dG5mREMzeUo0TEpiM0NH?=
 =?utf-8?B?N3Bnem1WUW5Ud1RuOGtlMEZqbnd2Rk1mK254U0tCS1hMU2g3M25oSTBXSjF5?=
 =?utf-8?B?cWxMZ3hGYjZYa3Y5Vk5Ibm9WeWFOZTVVbWF2RXA5dGxhWlNiSnVFd0JvalI5?=
 =?utf-8?B?OW8zdXVFaVBmcUs5QzJDSzlNQjkrWitLVjd2Skpta2tWMFJqMTVvR2FNa2pE?=
 =?utf-8?B?OUMxQis0ekVFNWVzTERyMW9ZQU83MU1wKzgvbWVmVGRGMzNrYTlqVW1pY1lR?=
 =?utf-8?B?UmRCSTdsLzA5enExZFBrRlVPUEhkR2lGZ092a2hrbGRKaGRFVHdWM1lUbjlS?=
 =?utf-8?B?Tjk0L3ZJM0hMazI0UzNxQStkTk9UdXVKdzZLalJWeVlVVFNwaHdpVzlCOHpE?=
 =?utf-8?B?bGhDd05FNm1hSUlVQnVKVVA4MEM1QlY3Y1N4UnlFQU44Qm54YWFUb0k5NnlQ?=
 =?utf-8?B?OFBxK0JXeld5L0RRSFRmcytReGw1R3ptSUNsL0p3UVd4Q3hIajRWUWduQkp3?=
 =?utf-8?B?MlhaL1ZjL1VuUTFRUXhES0dHeE5Lb21zWFFuM2ZCT0szcS9rVDNydUp6dTVt?=
 =?utf-8?B?SyszcUVjUnhvbzA1VWNWVDlJRjZpZnIxN2FlVk5GVmNaZVJlRFlUNENxZ1Zv?=
 =?utf-8?B?TTFyOStlME9PdHViNEg0Vll6cUpIbXh0ZWIzaVhHWjZNa2R0dW9vNmtQY3hi?=
 =?utf-8?B?dWNJbXE4K3lqanpBTnFGQW1wM2xJdEhHME9BQ3dDMFYreEJZUTA1aXRpWTVr?=
 =?utf-8?B?Q2pwY1EzK04rY01WMnR6MVpac3BSQjlEaHcxT0NnMjdsVjFISmZTRUxCcC9G?=
 =?utf-8?B?azNTOVBuZlNJY1RIRXBWelBtbmk3aitTc1g4OEpmTlhOQkVhRVFMVkluSURo?=
 =?utf-8?B?ellqTWsydlRVeTlJZnM3ZjJNQjljRXllbHI1YXJEWFNBT1loTGxJMXBRUklv?=
 =?utf-8?B?d2tyd1NTeDd4NEtQVUpwekhFd0x2ZWhBaE9ZeHB4VWtIQk9XNllKT1dUblhn?=
 =?utf-8?B?anhNbDZvZ0hEeDllZTNuV2xibTRqV1YzTlhVeGQveGJEWTdFWENtZG1PMTVP?=
 =?utf-8?B?ZnhnY3dxWFJXa2VNdWU3bGQvQjY5SHlTYThzdGg2Ym5jejVzN2FEQkJBcmgz?=
 =?utf-8?B?N3BneUdlRTZHOEpmYVZ1VzNWT3RtZTRoSkVrb05adHJXR3FZblFxVVF1QUx6?=
 =?utf-8?B?dUY4QUhUL3hGWnFVN0hSOE9wSjk5Yzh0WUZyeks3dlQxWE10UlNDVzVqZ05L?=
 =?utf-8?B?Q3o4clNnMTJxM2FXTkNJeS9yOUNqRi9BZ3hNc1NibFlOQkRESEZoVTRxNlc0?=
 =?utf-8?B?N0NIWGs0amZ5R1Fjc1JQYjdWcHk3VXBseDREQW50dkdjb2o5V214S3F4aWd0?=
 =?utf-8?B?N3hoblBwRWgvL2xjdmdmUitYMC82Y0FyZlpJUjlEeTlXWjlFSTdoT0N2T2Y3?=
 =?utf-8?B?dVNxaklaRDRkT1VQQnd3ZlhYUjFYZXArMm0wVWxJejZDYng0VC85MGhvQzhT?=
 =?utf-8?B?b0dySFBRRExRU3RxL3FsZkxsTzdvRTczWE1HTTNjd2lHclZnUGV0SjZrc0M5?=
 =?utf-8?B?cndnUWN6WWtTOWZuWjliUkVWdWJRQnJHK0RJZXZMeFFBak0yamFiYjYwTmwv?=
 =?utf-8?B?aVhmZ2haWjZGRDZnd2xuUzZXVHM0Y0p3aklOdThKcFAvNlVMV3VQTGowTFVT?=
 =?utf-8?B?SnlyVWkxc05mU3pHc1E0cHJuWDgyaS9PQ0N1aHpzSlFzd0Z5dzF0K3VIRXpP?=
 =?utf-8?B?Skg0Ri96VE5YMXd1MTlGb0FYbTVPVU8wZXFraHBxUitTdUl4S1lxQ3BWbEYy?=
 =?utf-8?B?TVpkR05iL1V2SHNLYjIyb1dMYWN4SHdMVTV5RFRxV09ESFlJdmNQb2VmZ0Z2?=
 =?utf-8?B?c1RRK1l0dlpsbVh0NUpSWjVGL3J4Sm42YSs4M1JtYS9leVh4UERPZWNSaXUw?=
 =?utf-8?Q?lvuf3YhLpd5wJHGKThn6UoqEH?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47567238-6172-41b3-69af-08da85c8f079
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2022 12:05:30.3131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: on1VyqDHsqojtBb655iOeiJR0/btAHTwnnh2iPatawcw7OED6lmkMWn947wsyxZMo80CMv8j3M+2KjcZk9NduA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2641
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/24/22 01:54, gregkh@linuxfoundation.org wrote:
> On Tue, Aug 23, 2022 at 08:36:20PM +0000, Limonciello, Mario wrote:
>> [Public]
>>
>>> -----Original Message-----
>>> From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
>>> Sent: Monday, August 22, 2022 03:42
>>> To: Natikar, Basavaraj <Basavaraj.Natikar@amd.com>;
>>> linus.walleij@linaro.org; Limonciello, Mario <Mario.Limonciello@amd.com>
>>> Cc: stable@vger.kernel.org
>>> Subject: FAILED: patch "[PATCH] pinctrl: amd: Don't save/restore interrupt
>>> status and wake" failed to apply to 5.10-stable tree
>>>
>>>
>>> The patch below does not apply to the 5.10-stable tree.
>>> If someone wants it applied there, or to any other stable or longterm
>>> tree, then please email the backport, including the original git commit
>>> id to <stable@vger.kernel.org>.
>>
>> I had a look at this and the other ones that failed to apply.  I tried to apply this commit
>> ( commit b8c824a869f220c6b46df724f85794349bafbf23 ) to all of them and then built it.
>>
>> 5.10.y: success
> 
> $ patch -p1 < ../pinctrl-amd-don-t-save-restore-interrupt-status-and-wake-status-bits.patch
> patching file drivers/pinctrl/pinctrl-amd.c
> Hunk #1 succeeded at 833 (offset -85 lines).
> Hunk #2 FAILED at 927.
> Hunk #3 FAILED at 937.
> Hunk #4 succeeded at 842 (offset -103 lines).
> 2 out of 4 hunks FAILED -- saving rejects to file drivers/pinctrl/pinctrl-amd.c.rej
> 
> Doesn't work for me, how did you apply it?

I checked out the different branches mentioned and did "git cherry-pick 
-x b8c824a869f220c6b46df724f85794349bafbf23" followed by building.

> 
> thanks,
> 
> greg k-h

