Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6855637664F
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 15:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235891AbhEGNlX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 09:41:23 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:48746 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234529AbhEGNlW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 May 2021 09:41:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1620394822;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XdUiy4X+pwZ6XkN+rhk666PB5OnLQR2t6LXz0jrYmBk=;
        b=DZPKxOwRI52ASqEeaKRQ8bwTQs11kSURvA1nic3PNeYPkgyowUnM9ClcpwCUWZSBSRlBHg
        +id+cpNIgDNpLBNSNHNwmZuWcdasjyeVUYnsm/CioNH0ByxGZTbcozs4dzCSPyUM0bWpvE
        W8c8w45ET1JwVviRoh1M10YTEAIRwCg=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2053.outbound.protection.outlook.com [104.47.13.53]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-29-wFPhCgXwMSuAVo-DPgT0PQ-1; Fri, 07 May 2021 15:40:19 +0200
X-MC-Unique: wFPhCgXwMSuAVo-DPgT0PQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E2p13J9YwaapNWwNTtihY6famIf56Eh0yBxZPYOWH6iATuxP1vIQNLNS5elRFhnmdgJxJFXXdFt4wQHytDGJ8Y3fa7NfNhqtCPnr5WHbYXIxzXfz3fQoL76ermzdZljk8KckbWDY6MGgmCx6wO4kORAOY4VzPgy4BTzXeitPH6j0BHOFNLWiTHCsfLJuI1MezBdiNjqC4WSysLcPivEFOC0Vv/cBd/VtpBLe1Yr6EQICBDjUHguwZ0LOf9qhR5lMu6WeAYoJ3GXuRjzyyp7o4g4BKpCeAOSVPYe0CgQB4HSqFhSCccW/+mhJ+NYhgCbGhD37akF0F2sOtAg3HwVylQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kk7u5FjHajbY0yCO503DJmdhm1zNCMTtG0Y0QKz7V2s=;
 b=LhD6d6+/8DAKCP+KOfl63ir26MYD/103XlR5Oo0+8D/zX7gliKcf1ImzXO2Sbl/8KXsxWm0BRKNDASH5WtS+ddXEQSUNjXKP68ZvP9NHzEMNTmeLLrBmMmxNA4C0opdYMMnYlpA+gcnLwn3Uvszr3mS+jEl1HfQ3cRcHatRJgakRlIO9pj7zCLHu+cWPcIsbwpZ2Jkb39ctVeuYISGB0c6DPE/tcvpcZEbv5KD4h/dQnGp28P0XFsI5sx4e+SFQaY7/o977Ja6ZN2EUnTyj+OHFZjG1YfY3plku+sAPT2xrLKslrcdpW74NDdYRLDT9DQO+sXCNiOMoHWF0wZFpBAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: linux.microsoft.com; dkim=none (message not signed)
 header.d=none;linux.microsoft.com; dmarc=none action=none
 header.from=suse.com;
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com (2603:10a6:208:128::18)
 by AM9PR04MB8307.eurprd04.prod.outlook.com (2603:10a6:20b:3e6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Fri, 7 May
 2021 13:40:18 +0000
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::756a:86b8:8283:733d]) by AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::756a:86b8:8283:733d%6]) with mapi id 15.20.4108.027; Fri, 7 May 2021
 13:40:18 +0000
Subject: Re: [PATCH v2] ipc/mqueue: Avoid relying on a stack reference past
 its expiry
To:     Davidlohr Bueso <dbueso@suse.de>
CC:     linux-kernel@vger.kernel.org,
        Matthias von Faber <matthias.vonfaber@aox-tech.de>,
        stable@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Serge Hallyn <serge@hallyn.com>,
        James Morris <jamorris@linux.microsoft.com>
References: <20210506065621.9292-1-varad.gautam@suse.com>
 <a4584027a60ef6e2d3e6d1006dea9a10@suse.de>
From:   Varad Gautam <varad.gautam@suse.com>
Message-ID: <77fe126b-8a9b-2222-7b34-f1c29db58988@suse.com>
Date:   Fri, 7 May 2021 15:40:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <a4584027a60ef6e2d3e6d1006dea9a10@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [95.90.93.216]
X-ClientProxiedBy: PR0P264CA0120.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:19::36) To AM0PR04MB5650.eurprd04.prod.outlook.com
 (2603:10a6:208:128::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.77.188] (95.90.93.216) by PR0P264CA0120.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:19::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Fri, 7 May 2021 13:40:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 500cc5f4-4f95-4c05-cb19-08d9115da6f1
X-MS-TrafficTypeDiagnostic: AM9PR04MB8307:
X-Microsoft-Antispam-PRVS: <AM9PR04MB8307A4E3DC2E80B28C818A64E0579@AM9PR04MB8307.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YtW8DshcIdvEz1O81DXTCc6iKoIB8yM8EVYp2LKn1wceLCCa+07OxRsKUeiTkJK4tK2IQQRaim+phFT52lVYBo6MC6EiUd0pW4x9Ahc4XRUrqLGpmaPDx+xlWzWjp0B6Ye6/p8g/unLMFgY9WIKkbBwPXbk40bWIFq07LSQjxEdrmUmOussFPyvsnhLZ3goBo3dG9w7wWEPe7y9ik2oh5OO4Y0k2TrLsvdO2dFkk1CJhlt3E6tko8vuOxuAp+AYHeTCjm0yvjrceWR3aj9r0SLUDdAaTY3Xjz/K8yN4q7O9GZfo70TH5gaULowA44xUhuhjilGRcGk1HQ6gJi5/Q/IS3uewhB7kDcPWMXBoe/l+aqq5AQU+osLGFTxSnZLctchO9FxJbkAQpxNgR1FqDE6w2/6r+ClQbfG66tYZMuZ5NQa1XU0EpxQmxeRdiz2q+yvlCS6ISYHxKTVtcarXtjHvhkGUmQhno3zc2YuA5BjpAI4WKlCYj8NI90OJhfaUhv2FgjN497LLR3cNE/yHjA54ko4yeyf3S6pwmkEfe+lKjf7p/hA6Y3640j9jDQ3UIFN/n8Lp9pRwmcp6DceZYnVSCsewwwJw/E+CnsxtcCYMJAsQMT1HOND2MwQJ3OcoZ9TAtUZJGM/sTEFIwDnKGnJ0cZUslp51fGjI6kUJMf7alAO5st9Nup45EryZaRrhOZkBYV9UXeaw59RNSwPBN8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5650.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(376002)(136003)(346002)(366004)(396003)(316002)(8936002)(8676002)(52116002)(16576012)(38350700002)(54906003)(53546011)(31686004)(186003)(478600001)(26005)(31696002)(5660300002)(16526019)(2906002)(38100700002)(4326008)(7416002)(66946007)(44832011)(36756003)(6486002)(6916009)(86362001)(2616005)(956004)(66476007)(66556008)(83380400001)(66574015)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?9NubAmSZbJDmaEMwClqv3T4wEWShw5UW7JvSJSBxeUGrdlUf9n0IshFCmjBB?=
 =?us-ascii?Q?NT+W+5R7JWS+kMTBgnT2EsCWtgSI8NoHnSflg+zXsXTWhEnCwARbg7ZeIPJR?=
 =?us-ascii?Q?KOcoH10vCiArGomv2ilA9kzKYVNG9emLoegAnF+nCpCG+i7hW02weizTgOcu?=
 =?us-ascii?Q?QiWuEtbWi2uOP9tzKBlJhGcK4Llmu3HQFnSbNcdL6iWbF/sx26kvcJQ+nk9g?=
 =?us-ascii?Q?CUyYn16xQylaz8sXIUsID5/sZ2vkQn60GDuqooPgf/aAZdkukcZ1a5Ol2tue?=
 =?us-ascii?Q?CGCSRkB0PODsKKYORiyK7G/xpfNt5IAOoqNlyoZZ8wohCNXvXkqUetA22woR?=
 =?us-ascii?Q?YH6k2AotAMezki7ip8H5wLUJFAriW62x2S3t1bfIkRDP+dyKvSCc1+yS1Yno?=
 =?us-ascii?Q?6TvSQAH6vvqNBrbgbRaL2Y9PBvL+VptdiiYawZRseAj4+xvVmVq8IUVn4li9?=
 =?us-ascii?Q?ov+SHuwAnzG/lCD4WdfgkJWqfCIqY2tZuyCjF0IVK+xRWiDMcCgGizrKE/Qv?=
 =?us-ascii?Q?nGJa+PIS7hvyXdR4q7lezweczMKMvbfxSw3IJ+jc7tBH51GuihkqeMAKm9/H?=
 =?us-ascii?Q?M9TfxkA7CBW2gr3crmWqNez+pikVMxs0hpJ23kTpWTj+JJpZXjZH1MnuDLNa?=
 =?us-ascii?Q?taSDFJ7jIXlyRHICNlLhnWl6PBmqkHAFqYWkcko+40Djv+miT7k25h0e9of8?=
 =?us-ascii?Q?fRmHUshp1o3cf099OngKsb1KGBU3NsdK4oM5rMMSn3Z7pbXn//9cSK70BlMo?=
 =?us-ascii?Q?3B+xelUg7Th/H9uex4OwwhFJxw+BgNWN20EqUGB39Qpl/nihhhz7QvJfAu3M?=
 =?us-ascii?Q?SC31BJ35bzO9ZXH497vHh+putg/S7bUubbR6yH1LL1RPTNmlQQoxAcKNhG4R?=
 =?us-ascii?Q?mxqT38u7V2PWBOWulc2LOykwSr5EUfj3bqQnsIrxDD1TpUMcm/VJ1/dXVwN6?=
 =?us-ascii?Q?8BuVsmQiEerl0PQ2QZUopz4P4LkX/QxAF1aY06qzvnvXw05e5Bf9yOUJtizk?=
 =?us-ascii?Q?cXspwDGew+UQrdIn6HKlu4K2nlaCc7/tfzT573j9+OPchD7Iz+txn7ZCupba?=
 =?us-ascii?Q?5vGnffbR8li/xcD0MayuaZU0Lwl7uKjMe6lYWU6FiiQ2dH0Kwo5lcJsxvTVk?=
 =?us-ascii?Q?K5C/vDnP7zENbjgahVpcWLPsx7fSAr3mj3C6HAhUPKJUnLEI7mxlH6tNqqBQ?=
 =?us-ascii?Q?t5aUiSUI5QiV0bjZoeYjCLtH9gbRPvlkv7ku+gnvg+MkH0NU3oIxrIL1XyYX?=
 =?us-ascii?Q?qN2vnEkQj3gZ38ZQ3/WfLceJ6wcPGcteUUqLITs5AHupJyQ4A1rb0aSaeeCS?=
 =?us-ascii?Q?xRuSGa9w3YzTQERU3P+bZzAU?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 500cc5f4-4f95-4c05-cb19-08d9115da6f1
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5650.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2021 13:40:18.1199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L4ta6iKyInQ+ZY48hQz5xNvjMkPJ1ty4Ai0tMZ6vz1Ek4/Y5Pm1/AuNwKgAQ04neZVO8WZz+LZvwX7fLMoSdsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8307
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/6/21 8:55 PM, Davidlohr Bueso wrote:
> On 2021-05-05 23:56, Varad Gautam wrote:
>> do_mq_timedreceive calls wq_sleep with a stack local address. The
>> sender (do_mq_timedsend) uses this address to later call
>> pipelined_send.
>>
>> This leads to a very hard to trigger race where a do_mq_timedreceive cal=
l
>> might return and leave do_mq_timedsend to rely on an invalid address,
>> causing the following crash:
>>
>> [=C2=A0 240.739977] RIP: 0010:wake_q_add_safe+0x13/0x60
>> [=C2=A0 240.739991] Call Trace:
>> [=C2=A0 240.739999]=C2=A0 __x64_sys_mq_timedsend+0x2a9/0x490
>> [=C2=A0 240.740003]=C2=A0 ? auditd_test_task+0x38/0x40
>> [=C2=A0 240.740007]=C2=A0 ? auditd_test_task+0x38/0x40
>> [=C2=A0 240.740011]=C2=A0 do_syscall_64+0x80/0x680
>> [=C2=A0 240.740017]=C2=A0 entry_SYSCALL_64_after_hwframe+0x44/0xa9
>> [=C2=A0 240.740019] RIP: 0033:0x7f5928e40343
>>
>> The race occurs as:
>>
>> 1. do_mq_timedreceive calls wq_sleep with the address of
>> `struct ext_wait_queue` on function stack (aliased as `ewq_addr` here)
>> - it holds a valid `struct ext_wait_queue *` as long as the stack has
>> not been overwritten.
>>
>> 2. `ewq_addr` gets added to info->e_wait_q[RECV].list in wq_add, and
>> do_mq_timedsend receives it via wq_get_first_waiter(info, RECV) to call
>> __pipelined_op.
>>
>> 3. Sender calls __pipelined_op::smp_store_release(&this->state, STATE_RE=
ADY).
>> Here is where the race window begins. (`this` is `ewq_addr`.)
>>
>> 4. If the receiver wakes up now in do_mq_timedreceive::wq_sleep, it
>> will see `state =3D=3D STATE_READY` and break. `ewq_addr` gets removed f=
rom
>> info->e_wait_q[RECV].list.
>=20
> So when the blocked task sees the lockless STATE_READY and returns it
> won't remove the list entry, instead the waker is in charge of doing so.
>=20

Good catch, changed in v3.

>>
>> 5. do_mq_timedreceive returns, and `ewq_addr` is no longer guaranteed
>> to be a `struct ext_wait_queue *` since it was on do_mq_timedreceive's
>> stack. (Although the address may not get overwritten until another
>> function happens to touch it, which means it can persist around for an
>> indefinite time.)
>>
>> 6. do_mq_timedsend::__pipelined_op() still believes `ewq_addr` is a
>> `struct ext_wait_queue *`, and uses it to find a task_struct to pass
>> to the wake_q_add_safe call. In the lucky case where nothing has
>> overwritten `ewq_addr` yet, `ewq_addr->task` is the right task_struct.
>> In the unlucky case, __pipelined_op::wake_q_add_safe gets handed a
>> bogus address as the receiver's task_struct causing the crash.
>>
>> do_mq_timedsend::__pipelined_op() should not dereference `this` after
>> setting STATE_READY, as the receiver counterpart is now free to return.
>> Change __pipelined_op to call wake_q_add before setting STATE_READY
>> which ensures that the receiver's task_struct can still be found via
>> `this`.
>>
>> Fixes: c5b2cbdbdac563 ("ipc/mqueue.c: update/document memory barriers")
>> Signed-off-by: Varad Gautam <varad.gautam@suse.com>
>> Reported-by: Matthias von Faber <matthias.vonfaber@aox-tech.de>
>> Cc: <stable@vger.kernel.org> # 5.6
>> Cc: Christian Brauner <christian.brauner@ubuntu.com>
>> Cc: Oleg Nesterov <oleg@redhat.com>
>> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
>> Cc: Manfred Spraul <manfred@colorfullife.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Davidlohr Bueso <dbueso@suse.de>
>> ---
>> v2: Call wake_q_add before smp_store_release, instead of using a
>> =C2=A0=C2=A0=C2=A0 get_task_struct/wake_q_add_safe combination across
>> =C2=A0=C2=A0=C2=A0 smp_store_release. (Davidlohr Bueso)
>=20
> LGTM, with some additional nits below:
>=20
> Acked-by: Davidlohr Bueso <dbueso@suse.de>
>=20

Thanks! Included the s/sender/waker change in v3.

Varad

>> + * 2) With wake_q_add(), the receiver task could have returned from the
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ^^^^^^
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 s/receiver/blocked
>> + *=C2=A0=C2=A0=C2=A0 syscall and had its stack-allocated waiter overwri=
tten before the
>> + *=C2=A0=C2=A0=C2=A0 sender could add it to the wake_q
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ^^^^^
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 s/sender/waker
>=20
>> + * Thread A
>> + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 Thread B
>> + * WRITE_ONCE(wait.state, STATE_NONE);
>> + * schedule_hrtimeout()
>> + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 ->state =3D STATE_READY
>> + * <timeout returns>
>=20
> While this comment is fine, for completeness we should document and expan=
d
> the scope of such races, because it's not only timeouts, but can also hap=
pen
> upon a signal or spurious wakeup. Perhaps replacing (in a separate patch)=
:
>=20
> <timeout returns>
>=20
> with
>=20
> <returns: timeout/signal/spurious wakeup>
>=20
> Thanks,
> Davidlohr
>=20

--=20
SUSE Software Solutions Germany GmbH
Maxfeldstr. 5
90409 N=C3=BCrnberg
Germany

HRB 36809, AG N=C3=BCrnberg
Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=B6rffer

