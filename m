Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14A9A643558
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 21:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232636AbiLEUL0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 15:11:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232414AbiLEULP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 15:11:15 -0500
Received: from CAN01-YT3-obe.outbound.protection.outlook.com (mail-yt3can01on2086.outbound.protection.outlook.com [40.107.115.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DABB2790D;
        Mon,  5 Dec 2022 12:11:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Po+U40hONbcC+mg/FXi+mAiT+RvPOODWv4mV6snxuz4FYpH/LKsH5h7n3wjiaS6M2C0lRJuDee6BqtViQGLXQTLijSCnlrgAH3CrE4nij76I3DXjj56R2n8FaQoM2JJP/0HVYyFoD9dHC3vkkod4H9MMucERZeQuGESt1sGUE5NhmaZrFw/SRqbruKxjJN/B/TZFyaPt0bES2a8MW1NZCpGycOLbS9aPv6DExt1dlZS78P8Tel59yDJwbijokhIlowwPoianuG5mH/Q0IJn+PnQZwao5alSKEqzCL6/py6pdCMqpo2oF44InMXCTTPqPoofv5y2rQZGqPHNs6wgd9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O1GS8gZh13jGJCws645054if+4IOvINXyo4Ckl5u2JI=;
 b=UkHUPC5oAGC/K7pmJlPIE0rGsLYjm9Z40lH22cn3vlOwLZ2E79F166WK0Df9nX182yUpWXzQFtm72lhtxhZF8E1vohE3joZDIvNwZFxYdHBVxTv+cK1OnfwjwnndjQWd1KggydkrMVKs7vDAAx2tFp5cCl2n5mUWlDf+g23Wuit1Gdc8L4vPGZyxHLqqokE39496nJdIdYGjevN2lTsKbL6oGbR8QvbVSwxYIxBEsoFIkfCFhp4E+Ab+Q51930MIGCsrgHQlvFgtXxK8OVjE5clUigZlu6Zp9uU4HV+57Nhdl28Sg43QhlAz9Emjkn3ei/YtqYCgVAJXp2V8sWbotg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O1GS8gZh13jGJCws645054if+4IOvINXyo4Ckl5u2JI=;
 b=T5wl12uU85qxmDjbeBn72FHk5Pbs+C+LoGOsv4b9OzOYC8cejMzlKv0rqce9ovyYm5bKPv9GGRDokQlLtcOVV5iu4S3cXEPUVwgGAJSkbZf2neJd+VQ5UEm3SZmuLUYE2ey1A3YG7KQXNPY9YDpvxv6Vo6092snGv3RG1zRACfSm1nzTsMpNUmL8UToferUFs3yrjGzitKs63Mrzaaw6xM6pwGhGxzBaFmm3MqykFS+H7xOkf4VloRPDtc4/H21Uft7nSfz31uTWxem4Zx3dMNGUrjab6UjQADS/jCtIT29TKulaudM2Pn0vp5sddjzdcsoRReMAvVMkwjAj+O1mCA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=efficios.com;
Received: from YQBPR0101MB5080.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:24::5)
 by YT3PR01MB8611.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:78::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Mon, 5 Dec
 2022 20:11:09 +0000
Received: from YQBPR0101MB5080.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::2bff:5fa3:434e:517]) by YQBPR0101MB5080.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::2bff:5fa3:434e:517%9]) with mapi id 15.20.5880.014; Mon, 5 Dec 2022
 20:11:09 +0000
Message-ID: <323f83c7-38fe-8a12-d77a-0a7249aad316@efficios.com>
Date:   Mon, 5 Dec 2022 15:11:07 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] powerpc/ftrace: fix syscall tracing on PPC64_ELF_ABI_V1
Content-Language: en-US
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michal Suchanek <msuchanek@suse.de>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
References: <20221201161442.2127231-1-mjeanson@efficios.com>
 <87pmcys9ae.fsf@mpe.ellerman.id.au>
 <d5dd1491-5d59-7987-9b5b-83f5fb1b29ee@efficios.com>
 <219580de-7473-f142-5ef2-1ed40e41d13d@csgroup.eu>
From:   Michael Jeanson <mjeanson@efficios.com>
In-Reply-To: <219580de-7473-f142-5ef2-1ed40e41d13d@csgroup.eu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: YQBPR01CA0018.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01::26)
 To YQBPR0101MB5080.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:24::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YQBPR0101MB5080:EE_|YT3PR01MB8611:EE_
X-MS-Office365-Filtering-Correlation-Id: b3871620-dc50-4f62-7ce3-08dad6fcd91e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JMIO0U5w1IB5fA543lBINZUEFUg992UXB1h0iWd0RMj+8bKxKrTNh2KyK0f8fW99cko14V2p7PM8zLzIjYpoJhIWrKwYYtE+qCbpKegFj2vrxcbn1aUdrjlc/y1jMDyfNN1E67Nr1qTYTtOCsSTdZFJboS9fQRQPI2TN1prEIMA4IPRFHP5fJGFxNeu/fliWZtezpKyXDKXgbiB/2sD40GTH4kgi0d9FhBzxKhJgs43S/Xy/JFsa0hIXqKKcngU6QYfqhOb6PUyRBBf1C4R/TW8zuAIjf+VyAqMTFwhAanOxH1fUUCjsXLbsjjkDXXN4xCelZ0C8bCilsRKV8GD6AevtOmarTHjB22f/mWocowVz9CM67PVUvWHAKEm7/OYSROv2GAFmFmYl0UqQnyfbrhyqaBWYltQ1XbqdIN0RvrASpbfULiRSyMTpmBy9OHVt6HjKEHWASNCJa7KTEVCykBbPM5oEqIZOkuYyZkXGzu147fzvZnciB0iwoI3ZlZ+p6zRtQvpk+2IJ+vreFwlRBljWC+iA9mDlCg3hj28KnwAklRu7c5CEMNDQ+WHWEj+86ZjfqUXdGzq6CPlRUbKslmw9noCrOM+4IKdKjRmhG9u9y6R2rPRlTOQXbto/pS9Lhfk+P2PCAHXyTpNMrpqqFLSaBEF+it7Tm2ZmpVJybPJlhrjVA2sSi9nPdTiNfEs+RQHOJqwOsVATepydw+9xv65G0ZOeW/yQSFGoZe0YkLA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YQBPR0101MB5080.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(39830400003)(136003)(396003)(376002)(451199015)(6486002)(53546011)(966005)(31686004)(6506007)(6512007)(4326008)(26005)(316002)(110136005)(54906003)(86362001)(31696002)(66476007)(66556008)(66946007)(8676002)(2906002)(186003)(41300700001)(2616005)(38100700002)(7416002)(66574015)(8936002)(107886003)(478600001)(83380400001)(5660300002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bllOb2tHTW1sTDZZQ04zY05nZWdXQVJQeWZJSEEyNXUyRWhEUnhTZ2lITlA3?=
 =?utf-8?B?b01mMWNQMmIyci9UTWs1Q1VVUEtWMU1wVjF2T1RBL0tUT25PYWxvU3R3WUF0?=
 =?utf-8?B?OHhTbmZBOXEzRkRzMGJVRmFrQmkrYU8wNVpkdUtFT1psUmNHcXZ2bnJwdDZk?=
 =?utf-8?B?ZXVQaEFaRGQ5cWF5Vyt1aTd2RnJDZTdUOVZBaDJqcEhYd2JqbkJZRDNHVHJo?=
 =?utf-8?B?empsZkxKU29Rb0thdldQN1hFWnNTcHNmZ0JDakw2aitvakQvTkVMS2lzdG12?=
 =?utf-8?B?Z1B0UUhFclFUZS9mZUhkYVJuOTVHWmFHN3JjSWpxNTArVkdOcGpFTnlwNVlX?=
 =?utf-8?B?eXlUaWJBcDlwbFdMcHFYNUtxUmgxSVdwazlEQmRnZlhBVFNIZThoL1ZiVjBS?=
 =?utf-8?B?czNBSjBQNmMydExMM1BpTmJyRWFTWWI3WXAvRlN3ZVRPYmNKbXRIRVRIbjM3?=
 =?utf-8?B?QmFJam1LK0VEcUJWVHo4dDluS2p6RmRXZ2oyNkQ3WERaS3MrUWhGc2tsdWQv?=
 =?utf-8?B?R0hyaG5kZUcxQ29kSTVzS3J0UDljZ2QrTTZMM1RCZEFFdU9aRnp1YlVKU3A1?=
 =?utf-8?B?YW5RREpHOTYwMGV1RU9waVcrdEFRc3ZOLzJxOTRnb05zdGRPcm9NOVRKRC9M?=
 =?utf-8?B?RGRXRG90N0VLUUJaUE1ITitZRFlKTWo2YVB1T1lENElBZExhR2psaU4rTkgx?=
 =?utf-8?B?UEpBcXc4MWhKREo2MEI0ekZCNjdtL0xFSk5aNjh3OFh1NHhRSncrRWZpdDhK?=
 =?utf-8?B?MjZyNW9aZXZlT1MyM0s3S1FIWVRNcnJhR09pZ25yOTRqTFlLWmhEQWcvNVRj?=
 =?utf-8?B?NjJIUEw2UFY0c3FkMXN3OVBvV0hCQVBBU0l1RDRhd2pGOG5jQ0VUaDBzczBr?=
 =?utf-8?B?eERsbzJkb2Y4Y00yajJpRWNJVVFzZVdtOHA3a3RXZFRPcDNOK1FocC9obkZt?=
 =?utf-8?B?cHJJV3pCSG5wOURSNXBjZGRBQmZuRDhxQXBZUyt6NFNFUCtISzE2aGZSVm1a?=
 =?utf-8?B?a3FMRzY1Nm9LVzJZUmZLNGhaWERJbUZWRUR4SUtZOHhvbkszS1Y2TEJXWmdx?=
 =?utf-8?B?ZlhMTTlKRHdzeEVSR0VacmxRZElsMXhVOEpaWG5sYkgxNmJ6aDJockMzWUww?=
 =?utf-8?B?NWUwV3pObzlBYlpmdkdiR2RQMVVHNmdWMVVzTFR2dGl4K2dybzVQbU9FODEr?=
 =?utf-8?B?VkhabGQ5cWl6d0NCNnFhRVNUbzdGMjBwZm9MK3J1L2FueHFTZkl3cmtjQWN6?=
 =?utf-8?B?NnR0VWFlRkNUY2FGVVp1eldYWUtxMm1DODVRSG1JaDZTa3pwSCs4QVVWemRR?=
 =?utf-8?B?a0c4a295UTlYWFB1ZWZqUy9MNE44OHh3M0Q5aDZtQ2FlVW1xdjJKekxZU3E2?=
 =?utf-8?B?blZQL1BML1Y5Zm9pNkt3WExXd3VVaVNQMHFSeGxwTytMZThCT0Z5MjM5Y1c2?=
 =?utf-8?B?YnpYRGVoQ2tJNXBONWJCeFh1OFAwaElITWh6M2pxRVZGREF6alN3OVpvVGNV?=
 =?utf-8?B?bnJ1Sit2a3FyRzRvaW5ZT3h5dnFhWHVSeXhHRnZhR2FxM0FmeW9xeVpxM3Av?=
 =?utf-8?B?a1BzOEpTWXlJeXVsSFA0WnVJUXZucDZqL2t0ajNEOGQ0ZExwRi9ZeHRkdzVN?=
 =?utf-8?B?OXAxbHpWOENhay9acEZzZ0hxQlFmOGNzS3RvN1MwL25Jc01vSk03WUMxUVNH?=
 =?utf-8?B?c2lyR2NIdXV1WEVJRlR1WUsvL1J5RTdXMHl2NUtkU2xaZlZNTnVsUDQ1aWxz?=
 =?utf-8?B?TEFIMGF1cjNKSWYvdGFYdGdWOUlWWlZDV3dOS0NHQkJzYitUZ3BBbnZwc0hh?=
 =?utf-8?B?d0JHekNBTWNwK2pBRSt5YWNwc2hrMDRFdC9MNktReUVjU29KYXF3cDBIc2sr?=
 =?utf-8?B?OVRxRTlCbUh3T3hDdkYvdi8rN2NVam0vOTdtQjJTUlVhWDNna1dsWFYvNFBR?=
 =?utf-8?B?RjA3Rnl5T2RkQmpTaVNET1RtZWYvT1N2YVlReHhaSzUvNkErR3QydFBmb1dr?=
 =?utf-8?B?K2tWM0JZOUZDQUEwajFaUnZwcm41UFhSaTdaL3hUYXl4S1RXWWsyZGlraEJk?=
 =?utf-8?B?ekJjWUdwa3kxQi9jT2didzdnZEE5VmF6c2JlZUlTUXJQY2czd0g0eE1ubWdu?=
 =?utf-8?Q?pC82foX/efdpTCCXSVo6UwROb?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3871620-dc50-4f62-7ce3-08dad6fcd91e
X-MS-Exchange-CrossTenant-AuthSource: YQBPR0101MB5080.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 20:11:09.0196
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wY6CAcxOdqd8K1Sx/kFoYsP5SJNZlegRFoe+vkhTDxSHzjFotBaF2Z18wktTugIbibD5/Z5XhapO8bb42MFoOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB8611
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-12-05 13:56, Christophe Leroy wrote:
> 
> 
> Le 05/12/2022 à 19:19, Michael Jeanson a écrit :
>> [Vous ne recevez pas souvent de courriers de mjeanson@efficios.com.
>> Découvrez pourquoi ceci est important à
>> https://aka.ms/LearnAboutSenderIdentification ]
>>
>> On 2022-12-05 00:34, Michael Ellerman wrote:
>>> Michael Jeanson <mjeanson@efficios.com> writes:
>>>> In v5.7 the powerpc syscall entry/exit logic was rewritten in C, on
>>>> PPC64_ELF_ABI_V1 this resulted in the symbols in the syscall table
>>>> changing from their dot prefixed variant to the non-prefixed ones.
>>>>
>>>> Since ftrace prefixes a dot to the syscall names when matching them to
>>>> build its syscall event list, this resulted in no syscall events being
>>>> available.
>>>>
>>>> Remove the PPC64_ELF_ABI_V1 specific version of
>>>> arch_syscall_match_sym_name to have the same behavior across all powerpc
>>>> variants.
>>>
>>> This doesn't seem to work for me.
>>>
>>> Event with it applied I still don't see anything in
>>> /sys/kernel/debug/tracing/events/syscalls
>>>
>>> Did we break it in some other way recently?
>>>
>>> cheers
>>
>> I've just tried this change on top of v6.1-rc8 in qemu with a base
>> config of
>> 'corenet32_smp_defconfig' and these options on top:
>>
>> CONFIG_FTRACE=y
>> CONFIG_FTRACE_SYSCALLS=y
>>
>> And I can trace syscalls with ftrace.
>>
>> What kernel tree and config are you using?
> 
> If you are using a ppc32 config, CONFIG_PPC64_ELF_ABI_V1 won't be set,
> so it doesn't matter whether this change is there or not.
> 
> You should try corenet64_smp_defconfig if you want
> CONFIG_PPC64_ELF_ABI_V1 to be set.
> 
> You can also use ppc64_defconfig, that's a different platform but it
> also has CONFIG_PPC64_ELF_ABI_V1.

You are absolutely right, I used the wrong environment, I blame Monday 
morning. I tested again this time using 'corenet64_smp_defconfig' with the 
same options and syscall tracing with ftrace also works.

I double checked that /proc/config.gz contained CONFIG_PPC64_ELF_ABI_V1 to be 
sure.

> 
> Christophe
> 
>>
>> Thanks for looking into this.
>>

