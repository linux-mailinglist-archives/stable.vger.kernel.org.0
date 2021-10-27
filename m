Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 029E943CF72
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 19:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238143AbhJ0RH1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 13:07:27 -0400
Received: from mail-bn8nam12on2048.outbound.protection.outlook.com ([40.107.237.48]:57850
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235317AbhJ0RH1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Oct 2021 13:07:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GHlhByQivMT98/ojTP4Nz+b6hCMe6dr3DXvs/hsS1yOnkrsmck3xpf58dgVsQV8stltrypz21ESLod8502DfA3CyIGWq33wPad6pTxrB5SNlIwdD9EgNUDrP8ov73/ZcO4F8VoKzgxqrHLdd+dKn8rqpRhqIXUIsvBfM7V26KvuKqAjByCLeAfDmKvnHyzbLzSKO5n+IY0LXUZk0mS1Zhmz1xm9F/iKxFJzZvDrNZCLzDHhRSMpt19/r2pzks0Gk8GVATR3sQnz7r1Vp3P4koKuRILRdlyRRC5Uf7zE7645jUG5OkLQYCxRKw2WiWEesiROALDnzrcO8sU4FmtiPDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y8f8IX+i5Fg3Ga3YQ1TrmzzH4AnceDQA7y/FisDK6xQ=;
 b=OrYVyw0psjZZdMgXqKo25gpFvyp92yEMRSGQl+/wU5iSktAckBVXimyHOeBH+XjRhg/2bJrK07KSAYtjyiD1uDToOcfePZj6gEy3N0TCN137F7jMg7mIsbQu07GXn5u8jxXl2S7LHfg5WspRgmozrsugESvZVmJdC0PZvnzhM9yhObaBZincosujBEcrTcoNm4x0Qe8vxtEyX79i7X3JE/g/286Ytusqg3NDMTdYPK8D7mWABqO1StxgFkHNyWhNIZh49Nm1pyppAS1Haid0IsYBcHekx64jpxUsBemBhoc6QcQwJ4Ud9H10XzPaFLNn246C5yqqmjhyFwWEhSWmsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y8f8IX+i5Fg3Ga3YQ1TrmzzH4AnceDQA7y/FisDK6xQ=;
 b=uaH/wujQ8vnj1nXHb99pCPM/dqalAji6mDCPiSTMRrKk09O2n13zEA48HQsS6xrdzuBt2RvHihwiKPuzvonhjNyVHWPX51XhZc8/U3jdrYRn1MIysE8Y25kuQe1Av/+IFmQ2MKR8UETeBZGI3yAneqZcFgkUcfrJZ0RtBjGa28w=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM8PR12MB5477.namprd12.prod.outlook.com (2603:10b6:8:35::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Wed, 27 Oct
 2021 17:04:58 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::a87d:568d:994f:c5f9]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::a87d:568d:994f:c5f9%7]) with mapi id 15.20.4628.020; Wed, 27 Oct 2021
 17:04:58 +0000
Subject: Re: [PATCH v2] x86/sme: Explicitly map new EFI memmap table as
 encrypted
To:     Ard Biesheuvel <ardb@kernel.org>, Borislav Petkov <bp@alien8.de>
Cc:     linux-efi <linux-efi@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>
References: <8afff0c64feb6b96db36112cb865243f4ae280ca.1634922135.git.thomas.lendacky@amd.com>
 <c997e8a2-b364-2a8e-d247-438e9d937a1e@amd.com>
 <CAMj1kXGH7aGR==o1L2dnA9U9L==gM0__10UGznnyZwkHrT84sw@mail.gmail.com>
 <YXmEo8iMNIn1esYC@zn.tnic>
 <CAMj1kXEZkw99MPssHWFRL_k0okeGF47VYL+o8p72hBWkqW927g@mail.gmail.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <f939e968-149f-1caf-c1fb-5939eafae31c@amd.com>
Date:   Wed, 27 Oct 2021 12:04:56 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <CAMj1kXEZkw99MPssHWFRL_k0okeGF47VYL+o8p72hBWkqW927g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0401CA0011.namprd04.prod.outlook.com
 (2603:10b6:803:21::21) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from office-ryzen.texastahm.com (67.79.209.213) by SN4PR0401CA0011.namprd04.prod.outlook.com (2603:10b6:803:21::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Wed, 27 Oct 2021 17:04:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 622b9600-a044-49bc-9a24-08d9996be813
X-MS-TrafficTypeDiagnostic: DM8PR12MB5477:
X-Microsoft-Antispam-PRVS: <DM8PR12MB5477A84BF6DF67F063888B8CEC859@DM8PR12MB5477.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pFFRSDNMkej/+PtywX1hwYZgC29orlwPzRyAeOK/vsnmHH3m44/atm+wl3lMDLHzbKLwSnFftoPMSMgIofxR26jnqpfWj1hGFY4GZ1TBszuhnHmnhPQKi17k7rAw5D+caAiH8iEpyOusGu9JDAB/OHy+Un02S49b81BMxRkfbXzPeVBwurB03xE38SioWqR8ZPkE1GvTkFLc44L+hZ+ItySm9ffGegWJ821nwX9ticP5drhpFrkRcfw+weHAxj6EkBXwxyl0/pi/Oev/PQHGhZnQlS5+Y14GvFm0IIlJO/2cXcCzVGCt5VumcDPU9+/VE+7u/s1YsESHL3mK3h78uWCELA6wmzTi9SE8DPwQEehTqLDW9zaD0cCFZl2jwkBvGe6lA/8ySluWpqPQKJUpKonFulRa53FrSGtA7SzjCC+qbgJQozIjmxQcKNi030Yl0rpDzLHfieYk4xnAuWqJ0gGxa6Ud3NdYAPcb1lnlHCBUtWqm8pg4Q1NcUNkM0cTzrKBhrcFXYAINWDK58tUk3GtHFGXQJGD+EOTjqZmxNmfocfRTQTwJ4yVplSDYNJUtaY+Nvhrtc5fP9S2BHCfJR9DQrXtFKVBwSaechDRD2WiqEGdgS6j3PScW8konKKcEcCc04SebKQMv5DyOLJCeSXvelXQs++OwjXLcpY71hQLmhWZp7e/xGcvvlDw4jMSzuGKupBD+aYRw7FL0BEr5jU6IjAMn+EqrLyazIAN9Avo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(5660300002)(6486002)(66556008)(508600001)(8936002)(83380400001)(66946007)(7416002)(31686004)(31696002)(956004)(38100700002)(6512007)(2616005)(26005)(186003)(54906003)(110136005)(316002)(2906002)(8676002)(86362001)(4744005)(4326008)(36756003)(6506007)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SFJxMjRFTGV4eWM5c0ZKa2lCWFBYaEhRQ0hDeENmOTdCVVN6YlBPTU0rSWtR?=
 =?utf-8?B?elYvTGJVb2crbG5zM29NdDY1Vlg4ZHVFc3J0c24vdXR2SEVOdVNUbXBHYVdZ?=
 =?utf-8?B?NjVWbk5FL3NxS1RGU1ozRktrUUZxbUh6ektqam0wajhHZ0pHa3RYQUY2bjlr?=
 =?utf-8?B?MFpFL3JKcnUrM0QrVDdNYm5jbTcvTmo0MW4yaWJyQ1hWcVFWcTh4OC9yV2ZZ?=
 =?utf-8?B?cno5SWJtbWRoUHdoazhrVVlqcklhbkNpR09ZeGRjZ0JjdlBQaWp5MWI2c1pQ?=
 =?utf-8?B?Q2Q4cTdVTGExNGJUQmtadm1VSmhseHZUbmw0dWlyc3g5M3FrODR2QnU2SWJS?=
 =?utf-8?B?RzJhWEpjbmhWeFhmaCtTcGxDR3BmamVhdGFTK1FXUlB3Uzl5K09IOVMrSmxB?=
 =?utf-8?B?b0pyRzRQck1NUytkVGd4NFl1YWMzTE5Jcjk4eml5V2cyTFhFY3FIaDZrVTJt?=
 =?utf-8?B?VkxLaExhL0JUQ2VJQnFRVlRNNnhodkJWdVlDSmkyWUpVRk93Zmt6cU5ZMmxz?=
 =?utf-8?B?MkVxenlPNEF5OUFBZGp6UkRYV3JBK1pHbWlwN2hiZ1QvSm50ZzUwWFJRT2hT?=
 =?utf-8?B?eXhYV0lCMllOOHJ2YVh2bzVtVjFtd1o5dElUVUxoclpIQU94ajBnTlBVWDBU?=
 =?utf-8?B?MktWMjk1ZDhRYXAxTXAxNWd6eWJsMEpTMmNsaTdoaVBqU3REazBhc3NBRVNJ?=
 =?utf-8?B?SUVFcW9aalFWMUZrNkpMMUhzbVZoUEMzajFtb21DQXd1VzVTVzBjWlB6VktF?=
 =?utf-8?B?MWIvVlNCWFp4N29RSmRPY2gyRkVkWlpsTUxBRVY3NERwWUxCTU0yRENVdDBH?=
 =?utf-8?B?UlBoTFhQQU1SVi9PdncyWHA2RjRvQ3JZY08yUTZRTlFOTm1HbDdaSks3OWxu?=
 =?utf-8?B?bTlVL2FBU2dpcHF6MW9DNTJKdGlSMDIzclFKV1lrV2F0bU1NVGJJZExIbE52?=
 =?utf-8?B?RUtSTDhVRnlhRktGUnJ1a3hYaEVVUGtlQmw0UzVoZnpoZ1dRVFQySHJNOGR5?=
 =?utf-8?B?YnJCVTltUlJSTTZVclRwOTdEcUV5ZGxKTDBhRWNKOFk1dVhoZ3B2anloMUVj?=
 =?utf-8?B?dGtOSGdMbC9pWitJbFQxMVZWeGZjbG11cFFVNlBVV2tqcURkdVNkaXhka1Az?=
 =?utf-8?B?RHQveFM1WitnRm9KSU43SFlWblVib2F0ZnV4MjFVZE4vL2RxVWhLakV1QmxO?=
 =?utf-8?B?emY1WExua0pKaWxLNnc4TlpBNzhMcjduTzhIRDZKMTZTbGxnYXRpTFJFNFEz?=
 =?utf-8?B?NFU2dlZDWGkwY1RBQTJmOG5JSVdDMTBNdTNkbFhjRUxQcURyeXM1cGt1L3NC?=
 =?utf-8?B?b1NqZVRoM0ZGam9GOFN1VmVYNFEwY2Z5alJvRE95dWtKZTdQOTlGRW1FYVdW?=
 =?utf-8?B?RlJJN001bG1US0JzT1NHL25rUm9lTi9pR2FaaWU5N28xRUpqL3daaHUzNkNX?=
 =?utf-8?B?dkpuYjhTT241OEZab0hRallmVjlNbEN0WGJWanlJazdmQUVHTlFDTWpZUFkz?=
 =?utf-8?B?T0JCWFJiOGFsRS9JcGJyWWJuMjFNQlZWYzNkcXBhd3hoZURmaFhHQTNzQVdP?=
 =?utf-8?B?aEkwbnU3MjNUQ3V6YzV4bHc4VFFzbk9zUXFLV2FiaW56aHJ2b1BiMExnMGdx?=
 =?utf-8?B?WktXMkNLT2JyUGp1S1I2ZkhMQjdWY2tLS0szTEN5NGp4MUJyTW5IMG4wVWp3?=
 =?utf-8?B?ZFNkekNkRmRzanlYWFRCWVFCNG1CNk54V1YwUmloakg5SG1UM2l0cTF2VE93?=
 =?utf-8?B?dHJQd1pmZW1hYkhydUNNai9QZzNpZDlyUEJGRExucVlvSDZwNnR5eDluWVZu?=
 =?utf-8?B?UVFjQ3NxWmJUbFQzUzY5RU1LSVpDdkFocTE4VmRwVGFzR3dEcXc5MlE3NWJP?=
 =?utf-8?B?QUw0TFhrZHZoaGdVb1R2cFNUMkU0SmpFZEFTNzVOSnNWeHdhUys2WlIyNDVQ?=
 =?utf-8?B?bmVNaWMzVDVYVVZJcnM5N2hQN2p5NGNOTWx2SXY3UzlOZ2p4TXpXMmJXR29F?=
 =?utf-8?B?MUFpUjZyVFJ3MENlM3lOdng0eDBhK0l5RFVjZzgrbTRicTI2bFh2R2diZnV4?=
 =?utf-8?B?M1FtUnpLVnZIZ2YvaTVPTkVHMWVaUjZRLzFtVFo0YjVEakxIcFVQNE9CbFZx?=
 =?utf-8?B?ZS96dnp3VEdycTJWaUR2RmlkMFVHMGdzZ1ZEUDRiSnQvMmNzWUFxM2JBZHd0?=
 =?utf-8?Q?gPLx+7YtF53kPhDKAU4VPtU=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 622b9600-a044-49bc-9a24-08d9996be813
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 17:04:58.5527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Adb1jcZCRR7K9itwVpwQ2WcbG+f/cef6eoBnBu/fiM4AVwGV7uZ7PWRynybv0crA9YxuUIArLK2WZXqvm02ICg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5477
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 10/27/21 11:59 AM, Ard Biesheuvel wrote:
> On Wed, 27 Oct 2021 at 18:56, Borislav Petkov <bp@alien8.de> wrote:
>>
>> On Wed, Oct 27, 2021 at 05:14:35PM +0200, Ard Biesheuvel wrote:
>>> I could take it, but since it will ultimately go through -tip anyway,
>>> perhaps better if they just take it directly? (This will change after
>>> the next -rc1 though)
>>>
>>> Boris?
>>
>> Yeah, I'm being told this is not urgent enough to rush in now so you
>> could queue it into your fixes branch for 5.16 once -rc1 is out and send
>> it to Linus then. The stable tag is just so it gets backported to the
>> respective trees.
>>
>> But if you prefer I should take it, then I can queue it after -rc1.
>> It'll boil down to the same thing though.
>>
> 
> No, in that case, I can take it myself.
> 
> Tom, does that work for you?

Yup, that works for me. Thanks guys!

Tom

> 
