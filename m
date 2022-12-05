Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9650642FC4
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 19:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbiLESTm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 13:19:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231949AbiLESTk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 13:19:40 -0500
Received: from CAN01-YT3-obe.outbound.protection.outlook.com (mail-yt3can01on2072.outbound.protection.outlook.com [40.107.115.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B52D315A38;
        Mon,  5 Dec 2022 10:19:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g9mCyS/YJ11bzOuQoQ8Hst0iSs2ICahvIdkX/SGqgIz7JYAczbCkoszv2zYfR4kIV3DmawRyn6XmIgfxbjGkkreWgGhJ6ezvmLFP4TrJw5w1g71RlrZPIiG2FQkHYLwkUwM6rSX8K5FDVhrm0lefWlClOcAhH2mU4gCE5MwJP1bBhdE7RZGMh4gr8zA+VzthcOQeYyYZDVn7nm5Ciq1n9CyNX/al3XaujgrsIs7qwcIdtdUqaN3DzFoa3oROaWEMFGLOdDggZHgmS27+PEJiqvi3wPpdHv4vQByB8j51gG7wXXS2pWRruQa+8mKduwvp3ociSiEK82n/Jvd5aaAa6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WMnMbx4rJanvF5XYl7vu/KqMDWlxDbdBuO9UUzu2JJQ=;
 b=C3h/JYY21tqUP++RqxqVOPkzZT0CkBkN08UQSvMdtZiN5SjM6POjgvbJv9BHdvxjBinfN6+BLjOlHfJxhh3yytcQ8iOfYPzwRTRVJQJmn4ZvP0HtvHgBdRcG6wJ5j+JzRZxMp8EC4sT3Lj6NAvX0nwH1RxN9XDjGmNTrr+HP5CUcHhVshBkfQw4+nRMHnepV9n037e4HBkbCggQ9A3PklhTEHgOCmMUqCQqcFZoCUG4Hhfcmw0BgU4RqsfVoYTXO/5OYGxLIIjoePTcg3vHkjjuS7ZA7drkZFCQyCtfizWNDIET+N49KzFBMVTUMrH7JPX6yVkTl6dsZTrbZ9s7+mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WMnMbx4rJanvF5XYl7vu/KqMDWlxDbdBuO9UUzu2JJQ=;
 b=kbmFv4oDZDxF6LmBmta9BNS+oEkIsliQVL7VqaySn3lSpp8Ln/8cD9GfSsBZyT3RuzSINKJ93s5UCRNQ+3W32oo5ZhAf6lqb4w1LnASGNvoM6KvKuW57x7iuugG3BLwHygmV6qnKklZo+d2PUj8AQoIcBf+79OeSWSrtKRJJ/QPi4O7FEzQwk0WEt/6s49aVozO70aQaqR3hgKJnDxsiDzrFHnF2n1uDAj35csV/DMSwf1b0PzE6mwolS3qD+WsE73Ca+sD5uHXsZDL9t+bCJNZoPWl/21lfaHdtjyDCoEZV22rYr5QL6a5PHicpBTXIucJ1NptHyTCeeb/R7ai+kg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=efficios.com;
Received: from YQBPR0101MB5080.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:24::5)
 by YT3PR01MB5529.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:61::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Mon, 5 Dec
 2022 18:19:36 +0000
Received: from YQBPR0101MB5080.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::2bff:5fa3:434e:517]) by YQBPR0101MB5080.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::2bff:5fa3:434e:517%9]) with mapi id 15.20.5880.014; Mon, 5 Dec 2022
 18:19:36 +0000
Message-ID: <d5dd1491-5d59-7987-9b5b-83f5fb1b29ee@efficios.com>
Date:   Mon, 5 Dec 2022 13:19:34 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] powerpc/ftrace: fix syscall tracing on PPC64_ELF_ABI_V1
Content-Language: en-US
To:     Michael Ellerman <mpe@ellerman.id.au>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michal Suchanek <msuchanek@suse.de>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
References: <20221201161442.2127231-1-mjeanson@efficios.com>
 <87pmcys9ae.fsf@mpe.ellerman.id.au>
From:   Michael Jeanson <mjeanson@efficios.com>
In-Reply-To: <87pmcys9ae.fsf@mpe.ellerman.id.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQBPR01CA0019.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01::27)
 To YQBPR0101MB5080.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:24::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YQBPR0101MB5080:EE_|YT3PR01MB5529:EE_
X-MS-Office365-Filtering-Correlation-Id: aabf21d6-815d-4cb0-03ab-08dad6ed43bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cx9YD518GG3AnWdxhj9HPLeu6xPFQRAAxCTs5nRkOoayrm3CK1vKsiaLpb4ZVPdkiyqGymu+77IxK4CoMEClUZ8IomNmKpLOMp0fdhtQ0lS+DC/qZZMCACyUKRfmgFRn7JBtpIVig743YNSUd5QraBe426EhfWWjGD8Hu/t8YFODmgc7QcuqwpP9zmX0APH47ZcBywprnkv6vm+MAe5Vll83+gQXZOI3MVKy1kGK/MwjJL69AZloJN34QSGmpfWu+JQK82QDOkHrwL+TqhwimmkwOteJhnUVxXUrGDRz8cmIGHGKiBNJwcIyYUWWjsdZFbnJFPyNZBY19+HtOPWRTVyrTO0j05rhXw6ZTJ4/aB5LvNIdhy+W4evPHcM2U1s9c6xC2khMbTQNFGDkZjWXD+wrchZkHh5PFEtr/KcG7eTFXG5r0hQ8TmJ4IsKHid+FGm1qiwdRLv1mlmGKlefGqsylqnJDaauTOtGADsyFa0u5CJLw8DK3qbHc6v9V2jSq/o6MwrFj96shWTIQGJqEtJd4YPxXFfh2g29x/QpekNC0uS6qITdXWpNqVzCnhJ1Dlo3OTI6LxzD7YSjR/SB3OGNb9IB2FPDepU4p9a6Cz/0Jq9xyZse3TbYNFsIJwp8ZB8X+975SqoUIZM8X0ATOhch6PFm7HZBwsR3g1I55sNCyxWjsBNKZsG+Y9UZfCU2q6ABRs6CoeWi0FvZQrGvIaMjvMhkwT6kbuSNpWIK+SRM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YQBPR0101MB5080.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(39830400003)(136003)(366004)(396003)(451199015)(316002)(2906002)(66946007)(8676002)(66556008)(4326008)(66476007)(36756003)(6512007)(38100700002)(26005)(186003)(478600001)(6486002)(53546011)(110136005)(54906003)(2616005)(107886003)(86362001)(31696002)(6506007)(8936002)(41300700001)(83380400001)(31686004)(5660300002)(7416002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WFZvY2o3QVIvcEhERVhmT1R6Mkd6TTVQQ0NRcjFURG9CaUNnNW1QTzJMMVIr?=
 =?utf-8?B?Tk05WkhWd1pRLzRtUm9SQTRnc0hXNGh5V0JXVDlheG5kc2ZMMzZaQW1aRnAx?=
 =?utf-8?B?QThNV3hJWGVCblZlYUhVaDlnM1BZUWk3eXo2MG1KZ1NYbzhMSkVEazh1ZGl0?=
 =?utf-8?B?aUpQblJPMnhBQ2NnOWVTK2JHSzM3RFpneWdUbGoxcFAyalh4cWVoaEY2Zndx?=
 =?utf-8?B?N0hVd3lPckYvYTlSK1J6TGd2QTVIT2tuTGxiSit6eUpMQSt6aFF2K1hHOVcz?=
 =?utf-8?B?citDMFpjWEdWMnVxcTdJWGMremdNbVJCV29MdmhTZURTQ2tWZ1dPQVp3dGZt?=
 =?utf-8?B?RFpyUDNPdFVKbEVHRFlrSW1QNDB5Q1htRWpha294YVZLMHc5SEZmSGFDa1lp?=
 =?utf-8?B?OUZZOEJobGNDNDdxeE82cW9NY3Vqb1RvZ2k0ZmMxSkhrR3MzSnBvTHROQi9G?=
 =?utf-8?B?TkhQMU1iU2gwTzBZdFNqVGlPQllaa05Wa0g5c1plY1h2ZGx0bThUbkpOTjNJ?=
 =?utf-8?B?K3FrUVpGR2ZPQjNxaW5LbFhaOEpMbHltSlZ1T1FmOUJsWTU5elBiSmttSk9B?=
 =?utf-8?B?MkFha3BvZjByQWVTOWFKOGlxMHJpc2RzcUVmMkR4MVllMC9pZG80UG1QSGV1?=
 =?utf-8?B?ZDhaRkRqMkFUZEFNQjFCQmI2MjdpSUhrRnhyNGpHU09rZXlmSjIvU3VST3hL?=
 =?utf-8?B?SGpxM1NNalVmSjhKRmJmdTUrZEU3UjNhZmVCMW9Zd0xpeVk4OXVXWFRiK0Vs?=
 =?utf-8?B?MXhzcHFPY1IzeDFaRk1lQWpYaGk2SUl1T3lXR21YK3VRaGxuM3g1a3pKVVNQ?=
 =?utf-8?B?OGxGeHF4Z3c3bW5HNjN6TlpsUk5kWGk2VW4yQk91Z09WUkZ5NjNYcW1ObmV5?=
 =?utf-8?B?NS9zOC9kWlcwaWhZeUh0VE4zalpJVUoybEE4NnBOMjAzSVdxMzI3WncwRTVN?=
 =?utf-8?B?d0haV2EyM2ZEZldnR3RjQXVxa0lmUGxHTythN0pqM3N1d3JocGNRNGFOa0Fk?=
 =?utf-8?B?bjhKbjJXY1dTRzdocnZuZGdGNzc4dXZ3Y2cyWlNDQzlTMlMwQnJGS2d3TFY3?=
 =?utf-8?B?Rit2LzloeXdMSEZrVDVlN1l2V3NaNFFFbVJ2djNzeTNzRHJjYS9jQ1FaRlZ4?=
 =?utf-8?B?aDZGd0lDMUV0aVNZbkZweEpDUm5BK1V6dCs0QktUWUc5elBXZVJxRGZnbzBn?=
 =?utf-8?B?U0NGM3JYamp6bGJaRGZLUmxFSEdrcmxtYXRqMVFEZVRZREViam1iTS9pUUJ2?=
 =?utf-8?B?bmlnWm5ZWnJORndPM01hTGNVNURSZ0VDRzBXdmdpbnJkNlNhcmk0bGprZzlh?=
 =?utf-8?B?bzNHdG10RkJHTHB4TzBFRDJ1WU8rZGNZNVJpYzNxMzU2dGZzOWlFTXluWjFn?=
 =?utf-8?B?MlpEV281UUtSVzVoLzVzZEdoQW1CMENBMU95a3JaYW1zeFUxYm14ckFEQ1pt?=
 =?utf-8?B?NUZwaXJ6SkNEWXVWV1FoQ1dxYzNoNDhKMjIzS0Q3V0JRZDZpWHlqamc5Y1lp?=
 =?utf-8?B?M3Z3TnZEOEIyU2lzbXVGaytUZ1Ara3RxNmp4WW5tUExYdjFSMUpUUUxxakI4?=
 =?utf-8?B?ZTlCRjlPVTNVTmM4QVUvUU4zV2VzZXd5dzdVZXQxU1pjaVhVMlRSSGtWeXNa?=
 =?utf-8?B?K0hQS1VaVWZySWgzZE5zTzU0Q1diMUlJbFFodFB5MGMxU3VheWdiQ1pXeVNa?=
 =?utf-8?B?ZHlRM3FUWThaYjdGWUFkYjQzaTYyRnh1RnZwbEVZYnMwQUs0MkhXaW9jK2V1?=
 =?utf-8?B?S0ZrWWorYTNNSGc0WVNwSVN2b3ovamZYZG01bGlhaEVnb1RrbTZPNVZOckdZ?=
 =?utf-8?B?ZG1BWUE1V2VUNXVJTkN6OTJQTFMvM3ZDSmtBSTM3OEpYNVFVM2h0YW42cEZj?=
 =?utf-8?B?L3IxeHhSNzFUUTJJekEvZEI4RWdxQ1RITExITTlET2Y1TlRqRXEyeWxURWJ4?=
 =?utf-8?B?NG5ON0srZVR0NnNTbzZGRithTEdoZkpZVlkvUFRCVUJWdlI4SlNnbG5ITnVs?=
 =?utf-8?B?eWZsOXQ2TnJDcjQ5SUMrZ2NLYnd2Skl0VkNrQnpFV05XZ0ZKWTlTK1drbVd0?=
 =?utf-8?B?QVZHWUpYRWFiWDh1ejV6ZmpGN2dKdmo0NmtQNXRXSjlZa25UT2p2ZTlPWWpm?=
 =?utf-8?Q?QxkjtzCiGL23PkXciwo+BPez/?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aabf21d6-815d-4cb0-03ab-08dad6ed43bf
X-MS-Exchange-CrossTenant-AuthSource: YQBPR0101MB5080.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 18:19:35.9937
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vP5j47LlmzGHVvLbZbS0h05TdFdc3K8UZ5R5g0abCNvwnlyD85z/AU5rBykDKB35GcmuJhfCgvPLf5gKzwFbtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB5529
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-12-05 00:34, Michael Ellerman wrote:
> Michael Jeanson <mjeanson@efficios.com> writes:
>> In v5.7 the powerpc syscall entry/exit logic was rewritten in C, on
>> PPC64_ELF_ABI_V1 this resulted in the symbols in the syscall table
>> changing from their dot prefixed variant to the non-prefixed ones.
>>
>> Since ftrace prefixes a dot to the syscall names when matching them to
>> build its syscall event list, this resulted in no syscall events being
>> available.
>>
>> Remove the PPC64_ELF_ABI_V1 specific version of
>> arch_syscall_match_sym_name to have the same behavior across all powerpc
>> variants.
> 
> This doesn't seem to work for me.
> 
> Event with it applied I still don't see anything in /sys/kernel/debug/tracing/events/syscalls
> 
> Did we break it in some other way recently?
> 
> cheers

I've just tried this change on top of v6.1-rc8 in qemu with a base config of 
'corenet32_smp_defconfig' and these options on top:

CONFIG_FTRACE=y
CONFIG_FTRACE_SYSCALLS=y

And I can trace syscalls with ftrace.

What kernel tree and config are you using?

Thanks for looking into this.

> 
> 
>> Fixes: 68b34588e202 ("powerpc/64/sycall: Implement syscall entry/exit logic in C")
>> Cc: stable@vger.kernel.org # v5.7+
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: Masami Hiramatsu <mhiramat@kernel.org>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: Michael Ellerman <mpe@ellerman.id.au>
>> Cc: Nicholas Piggin <npiggin@gmail.com>
>> Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
>> Cc: Michal Suchanek <msuchanek@suse.de>
>> Cc: linuxppc-dev@lists.ozlabs.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Michael Jeanson <mjeanson@efficios.com>
>> Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>> ---
>>   arch/powerpc/include/asm/ftrace.h | 12 ------------
>>   1 file changed, 12 deletions(-)
>>
>> diff --git a/arch/powerpc/include/asm/ftrace.h b/arch/powerpc/include/asm/ftrace.h
>> index 3cee7115441b..e3d1f377bc5b 100644
>> --- a/arch/powerpc/include/asm/ftrace.h
>> +++ b/arch/powerpc/include/asm/ftrace.h
>> @@ -64,17 +64,6 @@ void ftrace_graph_func(unsigned long ip, unsigned long parent_ip,
>>    * those.
>>    */
>>   #define ARCH_HAS_SYSCALL_MATCH_SYM_NAME
>> -#ifdef CONFIG_PPC64_ELF_ABI_V1
>> -static inline bool arch_syscall_match_sym_name(const char *sym, const char *name)
>> -{
>> -	/* We need to skip past the initial dot, and the __se_sys alias */
>> -	return !strcmp(sym + 1, name) ||
>> -		(!strncmp(sym, ".__se_sys", 9) && !strcmp(sym + 6, name)) ||
>> -		(!strncmp(sym, ".ppc_", 5) && !strcmp(sym + 5, name + 4)) ||
>> -		(!strncmp(sym, ".ppc32_", 7) && !strcmp(sym + 7, name + 4)) ||
>> -		(!strncmp(sym, ".ppc64_", 7) && !strcmp(sym + 7, name + 4));
>> -}
>> -#else
>>   static inline bool arch_syscall_match_sym_name(const char *sym, const char *name)
>>   {
>>   	return !strcmp(sym, name) ||
>> @@ -83,7 +72,6 @@ static inline bool arch_syscall_match_sym_name(const char *sym, const char *name
>>   		(!strncmp(sym, "ppc32_", 6) && !strcmp(sym + 6, name + 4)) ||
>>   		(!strncmp(sym, "ppc64_", 6) && !strcmp(sym + 6, name + 4));
>>   }
>> -#endif /* CONFIG_PPC64_ELF_ABI_V1 */
>>   #endif /* CONFIG_FTRACE_SYSCALLS */
>>   
>>   #if defined(CONFIG_PPC64) && defined(CONFIG_FUNCTION_TRACER)
>> -- 
>> 2.34.1

