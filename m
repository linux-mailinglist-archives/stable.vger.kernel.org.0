Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2A0643753
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 22:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234038AbiLEVuF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 16:50:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233917AbiLEVto (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 16:49:44 -0500
Received: from CAN01-YQB-obe.outbound.protection.outlook.com (mail-yqbcan01on2081.outbound.protection.outlook.com [40.107.116.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2CB05592;
        Mon,  5 Dec 2022 13:46:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PR3KD4LjHn5URRzxE8CN7rmCwj/fR7tMvd31h/RzHyqRtN5xtgcWFe0fZZ56knCzOqS0V2TuTTPXJ6hSGXIew9CuoXXalbkvNaKrKUy0f25g12j3SD/wb10mI4pWRTu7F/BgAsMhWCx8yaCuAKMsv9mpowPCmh/dzMvS0id/TAtqREIDMjuET4mL1X/zqPkhOhrbzSrp5qVhv0VCbOYbFQ1cBkIzR3qcpT0TU019aYrF29f58wBkDevZrz/lFA9pjStpEnZ3EpBwOVgjBsRG1yj99t0koBsVb0TyUmev9EtgbZoUoLlzrOTVDlK78qN7o/RUm6w3l5TDTb/1yHvZmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6rE/MkSHEjAXiLj8hxFHYkDyfdTJh5iCbuauJNidYtU=;
 b=SXHs5l7mvZJ8X5SfQ/TsWM2ezdEjfrbFYqDN21ldVTuFApjvVuStGYgD5YR2bfpzk0MjwZ/NeUnbO6ARK7+DuGIrbioX49+MtC0LxGpuDZfm/8Ivwdok80wA5ZAtzH1Wz5S8YF5JOrY9UphgAQbZgCewIGREm9Emsfr/r5LGIiDdI7dfz2TqCxgi77FMPSuqb3QT3JaC673z4qlBzOucA0TDq/snjtlD8h+O9JbQ15lA4rCMhZRGR0vflQuoQdeNTDaoNLM2XVNbLcdIB8s+DcNKuYbnMDbYRJ2AfXLFgzUeT9LJ0ysPRX4MTV8fXmSzREvqR9QAeSGpHuH0KulpaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6rE/MkSHEjAXiLj8hxFHYkDyfdTJh5iCbuauJNidYtU=;
 b=ne3bFZOS6keVCmbtY1hZr2JuiOL4yeNap8FstDnDQj0aYlZoXCsvujZOKNqGsRUNO1XNGJve22XfKCpJjwF/ZINm6ABzDET//TasXiCxPqkl75HRr8h7UEKo3vIpB4eVugEicM3xtgM+RUFfFnEFvZ/jltLiLiB6K1OMq8McoxSRMnImWycWZqNNhdE7w4TOdNbVg11a1U4at945iapBx5GvgK08IVeoTyaW9N9c3P6j+ovRLdmeGIVG9eTdtEgjEsCoCoogIYVIPDBwIp0MciXAQWK4YwZS+MXlPRQdYEb59iaARquBPkW6yliNuVefJn5HR/HIo4Py1QDahiSj2A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=efficios.com;
Received: from YQBPR0101MB5080.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:24::5)
 by YT2PR01MB5773.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:4d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Mon, 5 Dec
 2022 21:46:22 +0000
Received: from YQBPR0101MB5080.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::2bff:5fa3:434e:517]) by YQBPR0101MB5080.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::2bff:5fa3:434e:517%9]) with mapi id 15.20.5880.014; Mon, 5 Dec 2022
 21:46:22 +0000
Message-ID: <dfe0b9ba-828d-e1a5-f9a3-416c6b5b1cf3@efficios.com>
Date:   Mon, 5 Dec 2022 16:46:18 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] powerpc/ftrace: fix syscall tracing on PPC64_ELF_ABI_V1
Content-Language: en-US
From:   Michael Jeanson <mjeanson@efficios.com>
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
 <323f83c7-38fe-8a12-d77a-0a7249aad316@efficios.com>
In-Reply-To: <323f83c7-38fe-8a12-d77a-0a7249aad316@efficios.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YT4P288CA0040.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d3::21) To YQBPR0101MB5080.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:24::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YQBPR0101MB5080:EE_|YT2PR01MB5773:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ceaf85e-0e89-436f-e458-08dad70a256a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gMU3nW+OC3RtV00fc5qXcFkVBR91XRJr5gtjyZEgfKvmQ5TnvgWwuDYXWaNx+PHKsuRX2G0tJ1O+ETmAx1LNFTpBLZz0QvjUyXquyLC1ATNS9/4tyz0ViUa+wgIlLAqRDfFjV2RZAiBEt7c5i7BE2lSEJnFfGQY6OtelUxQ92BtoBvoRde06IAAGJqH3vQIqnkqw7lfKN2CTDYgXZGFhHd3Ge5l8GZBrD7zMoymBWcmuDsWK4N6Vaoa2JSqVH+FG+FuqZ9Vx1IILLKP09FA5Va2jPrpKSPEgt8mLutaHhDr5IKD//HFp14ah2cypDlSwqZ+e23dGth6pJJwR+zNmBiw48i8vkczm1bTvlS4YBoj55IbBpPuw2XqDLEsjG8AQNNYFvXfGOruhG1WnWTlWaRWfhwCihrOjKjjdojJ9gPstB0/v67whv0N6xCCp3DpHV3x5JCRBHD6OOfb2uC0JZlJyxQor9u3G7PVu5ZOomNImGKO7sv5sHrF0hAeg+gxfo8vqr46E0cgwIx+ngBGdgiF7AWbOSXOBWSSzTRvth7ZS5gLoJuMc0eA0ks1/GIyMWu5mVCnVoJkO+k1WFJBetBzA2JwCjVLjlQsATTcyDphn11vzbMqLu4e5Ub/1AQ8j4FCV9L4J5DSJLtiIBqsMfHMAV5VafBU2u7Ujr29XYsajD+TsJRMyMC0IxeH1nIEq0DqPOSC5eLBSxkYUVo7MZDtNUpzgBHb5SThPWyo13VQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YQBPR0101MB5080.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(136003)(376002)(366004)(39830400003)(451199015)(8936002)(83380400001)(38100700002)(53546011)(5660300002)(4744005)(31686004)(7416002)(2616005)(36756003)(2906002)(41300700001)(6486002)(186003)(478600001)(6666004)(107886003)(4326008)(6506007)(31696002)(66476007)(66946007)(66556008)(8676002)(6512007)(26005)(86362001)(316002)(110136005)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OWhmei9WbitWaDZGcnY5M1ZWREJaRWNOTHQxeXhiQ2lYZkY5SFZMMnlwVFpo?=
 =?utf-8?B?S1dnZWIrbVg2TTJFTGc2WVhBNnNvQ25BZWhRQlRlRGFjVFNGY0creE4vVDcx?=
 =?utf-8?B?aE93ZkNIb1FSZkl0OEIxSHlsbGIvY3lCZE1Mc2lsdlY5N2hwVkZsd2xaTUky?=
 =?utf-8?B?QVU5ZEFycERvMjNyZnpKWWRnU0RsNnFsQjRvZk9NeGNzalBBUnkzZ09VV1F6?=
 =?utf-8?B?Lzkxb0d5OWRmTE5tSXRqamo2SGhIRkxKdnNDc0k5MEtxYS85S1lqcHlteStB?=
 =?utf-8?B?Y2V4dzI0T0lZK24zRFczTjI0dGZ2UitGdzBkbUZSK1U1WDgyc2gvTEZzL2NC?=
 =?utf-8?B?M1FUeVZHT2lzQTdqZUttcFBBV3RrODAycEtRRnZJclNmdFdmb3lDVGg2ZkhM?=
 =?utf-8?B?ZVBKeW80NTZ6VVNEWkF3Z2dxTHlrM3dMLy9Ed0xvQmVyWXdWT0lxU21nNXhz?=
 =?utf-8?B?dnJpNWdjV0FlSWdiYkJpT3FhNjNhQjNyVGhZamtXRUxjdzVHMHFmRHFSbnFD?=
 =?utf-8?B?TTlpaG81N0FvaHJKZld6amNuWDMzYzgvWWQ4S1N2aHJQVTVFSThZUlVodXhV?=
 =?utf-8?B?SUhuVVU5RG5HNmtYUGhMTVJsOGpjbjRCMHFwMGJQR1RtaFRoaXYvdTZrbzZL?=
 =?utf-8?B?b2ZNS0ZuYU9oR0VncnNiTGFzZXZaNFh2ZFVIYjA5aVA5Tis1c096Qmwrak94?=
 =?utf-8?B?S2Q1aE5tQ1pxeUVmUU5UT1lHVEtCaEFubVZrQ3FpN0lQa3ZPMDBEZ1B0MFlH?=
 =?utf-8?B?Z09sVWduRFAyWFpSQy9FTUQxMkNDODlad09KKzZOa1ZNbVN0TXMvOXdFTzhl?=
 =?utf-8?B?SVlDWkhtMzFwUHJYa2Z4ZmgzMVpQWGYzSGFWSnNhNjlDSFVxbVEzVHZvNUov?=
 =?utf-8?B?RnpGY1JYd094WGxJcllNakdabW5ZSFBpcmxUVVl0dERFQWU0TWZUTUVpcGsy?=
 =?utf-8?B?WDNURU1TeGhrcjN1TVF4SnBtbzRtTG5jeFdYN2xUd2RPU2hzRXVpbURCM0py?=
 =?utf-8?B?S0pRdUg4WGNYVnZ4aXBERTNGby9WZjdKSFNpS3hkZmtRcnY0ZmVPbHJXNXZl?=
 =?utf-8?B?dm92MnVvdENwWWp1dk85eTlyQnJDT3VOVkZYTi80bE9ROGtVcDRwN01lMXdh?=
 =?utf-8?B?Z1l5WEp4cWZaaEJsN1hBankrOTd3UXpTZTFqRldKMU4wWXJaVUQ5TEFMV1kr?=
 =?utf-8?B?ZEFIRTRnRnNqQ082a0NnSDUwUE9lMlFuRHVYNUFNZXZaMnRUSENsd29hUmo4?=
 =?utf-8?B?MTEyNkkxUHQxSmpJaDk4dzBHOG1GdmxaL2cwQ3RqWUpBVGFvOTZMWjcwTzJU?=
 =?utf-8?B?Q0t0bXYzS1BwQ3BwV3lVeXA3amxTd3ZMZzJZeitjOEVCOHBrUFRpZEhMeFlN?=
 =?utf-8?B?aWh4T3pCZWI0WlY1cEI2WlZaSCtCU3B5dWpUSVZ1UnFyTlplbDRzcmF6NFNB?=
 =?utf-8?B?NXQrMEh5ZllXUm5LTmhiNi9KaFZVUFZLNDNrNklnUnpFenNDUExOVlU0SnZk?=
 =?utf-8?B?ZS84QXZzTTZ0WW9wZytlQTQ1eGFEakh5b3B6YzJTZjhYUFdXSEtlNk4xbzht?=
 =?utf-8?B?TkJML0cvWWNxek54bkc2NW9XeDJrZTl1UEdWUWtxWk92Wm1JRDRRSjNGTnJz?=
 =?utf-8?B?dWNuUXV4QlF0R2pKQUNvdXQ4dk81SjR6N1kxRnptQThXajRteXJOOEJaYk82?=
 =?utf-8?B?Wkd4T016V1Z5UGVuUTNMTFpFSkNGVnJ4N3dKZTduOFBpdmZ2Qm5uTVZjczJs?=
 =?utf-8?B?eEdRQTVTbGhDY3A3cnF6b0ZCU0RNcFF6VW1NME5WM0Q5eFZHeTJTajR0c3li?=
 =?utf-8?B?RUMzS3dXeTZScnNPYlhWdk84Z25hekE4QkV4YWdJQ0tVTDVRdHlwK0FEN0lT?=
 =?utf-8?B?OTRIOThtUEpBUXFQUWNoMUYyeEU3Q3ZJVEttbVpHekpITlRwMklTandQczZQ?=
 =?utf-8?B?VUNSVXYyQnV6anB5YnN4M1d2d3ZCOHRJUkNGNC93WnFKWElsNm1DTktMVUwx?=
 =?utf-8?B?bW1Hald0dzU0cDUwMVRQTzd0WGROM052YytxZ21McWRpTW5NNHAyU0tVWjda?=
 =?utf-8?B?V1BURmxMd0RhN2YvWm0yK1V4dU9HM3QxS3VnaHprTDcxYXo2Wk51OUtaRXVQ?=
 =?utf-8?Q?tiU/YD2SQdsCnYsMw63XsXfSj?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ceaf85e-0e89-436f-e458-08dad70a256a
X-MS-Exchange-CrossTenant-AuthSource: YQBPR0101MB5080.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 21:46:21.9534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bs/NY5apc/A9eToPrDs5nk13zgga/ooRJmnuvECFmEOxB7sbjzxitm/d2//48QkPSHFanStPCKgqAiYlVaIKXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB5773
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-12-05 15:11, Michael Jeanson wrote:
>>>> Michael Jeanson <mjeanson@efficios.com> writes:
>>>>> In v5.7 the powerpc syscall entry/exit logic was rewritten in C, on
>>>>> PPC64_ELF_ABI_V1 this resulted in the symbols in the syscall table
>>>>> changing from their dot prefixed variant to the non-prefixed ones.
>>>>>
>>>>> Since ftrace prefixes a dot to the syscall names when matching them to
>>>>> build its syscall event list, this resulted in no syscall events being
>>>>> available.
>>>>>
>>>>> Remove the PPC64_ELF_ABI_V1 specific version of
>>>>> arch_syscall_match_sym_name to have the same behavior across all powerpc
>>>>> variants.
>>>>
>>>> This doesn't seem to work for me.
>>>>
>>>> Event with it applied I still don't see anything in
>>>> /sys/kernel/debug/tracing/events/syscalls
>>>>
>>>> Did we break it in some other way recently?
>>>>
>>>> cheers

I did some further testing, my config also enabled KALLSYMS_ALL, when I remove 
it there is indeed no syscall events.

