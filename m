Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD7A83781F1
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231790AbhEJKbC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:31:02 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:31355 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231528AbhEJK3S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 06:29:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1620642492;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4H1K0uNOv3/osIQTk1Vzys0E/kGulq31EEVJ0t7df8g=;
        b=HzqfjgS1wi8y6g+BzCbmf5Xx1Q9DSooRYlXXYY9JjBksJ9wsVQpxv7QWbqISpcia4dZRRk
        iqxaoBwsKR2EfFiEff1GdVGpOaORTH3iGIqSPCHCM8Fsblpmc8PSODXR1yTPJ1PSztR00Y
        dm3QkhX2j9mL0r3ejphII1Up0WtFE3U=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2171.outbound.protection.outlook.com [104.47.17.171])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-6-lfz3l3nUNJOty_8eQEtlLQ-1; Mon, 10 May 2021 12:26:29 +0200
X-MC-Unique: lfz3l3nUNJOty_8eQEtlLQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BqGNgK21eM9mdYcDG+QsyAGaQfttXIk+m0StjlRh5wVi994W8H/0QRj9uaiqtrL95A9KSGthn1H0XK/JCuwNPm+S3FieZaRhnUjjP6ZcUCs6ZIez3U+F5ZEcjA1fxDz7QR57irCMPUh3wZdKDCVMwypmJAu7m3Nvoap5K/PhDzgzMs/oR75s+ldt28fG7dK8VpYObT4cds5WJZpTGcPjc9LqpZZJLt50ikuh3rw08+7P8doskd3pni/uLfANuzJJg/JxIdBC2SfujPw21ZqugHPDCyNKcvzxjTsC2WuS59Tz/qSKvCL+syH3n3+BSX++U+odR81PWPLWZAPZoRAcEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q3ZeUisals9k1BfSrNvziBdqE68hdCmi1LIyWXrXYeY=;
 b=QO5b9DJrdlzL+TRDEAjSWwY3xoagmVytQ4eHNybpr+u95eNWbS4EP9UBrZ3e/nlyAzaSOysFhmj7TWhH7Mbk1LuuJ0CmPbfRY6PD7Y919Cq2AbU3p1wkd+4knGddBLwTJjoPMRygcgHqyXPB/uorvOJHAHDffp0cPO+P8UljLNNqI1PXmxcGpOhOBOgZQ10tjrPaLkxUkauW3FKh8YhAv3s0gKjqEjyHi77UP/6rVoYhw+xKjsUyVfaOQaxxWmdHPevWFL/8NNTvTF65ipf10MP8PZ2nxFjeFKnxQpo2BzotE+qamMpe4i9SjUTsQvvgy+j3r02btb8gbkv1DB4zBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: hallyn.com; dkim=none (message not signed)
 header.d=none;hallyn.com; dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com (2603:10a6:208:128::18)
 by AM0PR0402MB3395.eurprd04.prod.outlook.com (2603:10a6:208:1a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Mon, 10 May
 2021 10:26:26 +0000
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::756a:86b8:8283:733d]) by AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::756a:86b8:8283:733d%6]) with mapi id 15.20.4108.031; Mon, 10 May 2021
 10:26:25 +0000
To:     Davidlohr Bueso <dbueso@suse.de>,
        Manfred Spraul <manfred@colorfullife.com>
CC:     linux-kernel@vger.kernel.org,
        Matthias von Faber <matthias.vonfaber@aox-tech.de>,
        stable@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Morris <jamorris@linux.microsoft.com>,
        Serge Hallyn <serge@hallyn.com>
References: <20210507133805.11678-1-varad.gautam@suse.com>
 <71c74711-75d6-494e-6ff7-2be49b274477@colorfullife.com>
 <6d36d89bc8f299a76efe8fce9c07e7b5@suse.de>
From:   Varad Gautam <varad.gautam@suse.com>
Subject: Re: [PATCH v3] ipc/mqueue: Avoid relying on a stack reference past
 its expiry
Message-ID: <f4f08bc4-bdf8-cfd7-7453-e512ff0bbc67@suse.com>
Date:   Mon, 10 May 2021 12:26:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <6d36d89bc8f299a76efe8fce9c07e7b5@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [95.90.93.216]
X-ClientProxiedBy: PR3P189CA0036.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:53::11) To AM0PR04MB5650.eurprd04.prod.outlook.com
 (2603:10a6:208:128::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.77.69] (95.90.93.216) by PR3P189CA0036.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:53::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Mon, 10 May 2021 10:26:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a04034a8-5fd4-4cda-06bc-08d9139e10cd
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3395:
X-Microsoft-Antispam-PRVS: <AM0PR0402MB33955D67A193505DF237A7C7E0549@AM0PR0402MB3395.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +kTArpyL91QD9b7CFCKpBfaVESxOKlBAH5sdn1MWcmRv1BfsbwRKofE3fGw8muYDYpMccq/ZNLnretjv4y1GddHFHl3sJAuuj3yqTFrGEOykDamzoRwup30HNxDLx6OIN9xRIda5ZvlBOTdRjzUHrgupJsdLxRTXFeQyU2EmL7ggqwSOEFI7ElFQnh83Amy7+DJpBm8pXmnCXw/yelQyVelJBRrSeWgbgHbT7yHMWqoREgROkic5usgLeU3du5Qywv3fP+FkUZst+G4KQKIdEojcHEEWlQ1xowmXnZTxOram3epRwFiC+C1ZfX5E69qfmX8V3IvVflONhJ1gGUGAFcm0zn1zpKJzAj+YRqZorckvZIWloiDu3ohncRK8i/J+81zdT43yDZHj6AgIxWYTsZj+Om2aSf+6PqGllzt6y7OHS2NjDCDYfiniG4xCnAWTu+Yjz0eYXiVkEvKeR2C+ah0T9RhTQ8Dhss+0afdjKF98Dd/7a9vrn8wFJnx3nNdzhkOj+imBKSZcIZldIUu1dvgL8wnpgBm+0QlYNoQrDwfkrjSOic/ZpRit0sCZVr81VIb8ZjCnvVlYs+0qJ8CM4X1G4RXz4FaD1SpxRUS4HkqKInIWnarYUEVmD25O030jRy5H2QpkNBSJk92bnKTwqVHyij2ZJcdjSELlGZDrlMQU6MmlSpyxEFYRI1Pc+BUhBKN27R8j8tmCibHTdAAe6HEE2TXzZHletCRw4NC+d+h4kU3JsIzjVrpDUMcp16vXdtm6VpTOu0ustkSpbKujlUrtnH3Wg587XjeACGg/cKY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5650.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(39840400004)(396003)(346002)(366004)(38100700002)(83380400001)(52116002)(38350700002)(31696002)(478600001)(36756003)(66574015)(86362001)(2616005)(956004)(26005)(66476007)(66556008)(4326008)(6486002)(53546011)(54906003)(966005)(7416002)(186003)(5660300002)(110136005)(6666004)(8676002)(16526019)(316002)(16576012)(44832011)(8936002)(2906002)(31686004)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?N+ccn/CFeIaoLESDQCXVJqHqBe2TJ4kfMziiWx/umVVY3BV9zWbUGTyGea2k?=
 =?us-ascii?Q?ot8Dh9OIoWhbkFYu80virH8+4ZfukLzUzhWgIQvVs0UBZ9MDiJQ1Ou30e3Ym?=
 =?us-ascii?Q?ZPIVFrgTZ7hqHjiBtcO+MJ8YbIPC3KC5Rgjbgr7jYtf0Y9LBGVe5TxF6/Fbw?=
 =?us-ascii?Q?ATCZnmNujVTgTXL6sHgfWQjnz+4JJWxjhmTw2fdjO6B086cgBlpZm0FU18fk?=
 =?us-ascii?Q?eLZC3ohQnDA7qHRFywS7yfImw/n+3E8B75rUhY1BUrIqLZ/lg6iqGEtOBO9y?=
 =?us-ascii?Q?Dwq4+yW8/fmBPwk6sJPfP5ByxuBtrEp7K8NxwY+xS4B8DvpmYzl469rLt4Gs?=
 =?us-ascii?Q?BN68s5VuNIyzjyspVbvEFuFauoue50jPoASM4VzBfCdLhnC0o3tFoey2n9We?=
 =?us-ascii?Q?aegWBVlgqv97rmc1YY32fIncHf66ya+XjCB8z1PDNPO87Vcjz0To1JRrsVQa?=
 =?us-ascii?Q?wqUXNG44rmdNElXvT7KVuWU1s1GYX3ia0jjyUpQl9kpIsEy5WaqAHa7jpHNm?=
 =?us-ascii?Q?D0yVygS7lDgBZUSdhy9XT7I+R8poM7iHNy3wfnPN2KohonJ9mzH4RgnKbiCH?=
 =?us-ascii?Q?h7Xgq5HBg7YV33DkoEQwA3NclQ4if4JgS5+3w3MvwAJ6Mn8PZjTj9CS22prr?=
 =?us-ascii?Q?/owV8DZFutlobiKhqn4l6oK1vuebrvzaK2MRcZrLlQFAmdHys1IqztyutE4K?=
 =?us-ascii?Q?nfavPa8OuEdDlp/kz3R6p4btOQFz+Az7wDTttK4t9xZDKeROhIycvyjaBrMp?=
 =?us-ascii?Q?qrUErlq0JuOVZ6N0Oar/xK11z3A878fNomTMEBzmSBTAzO1/bNyAkNfcIX72?=
 =?us-ascii?Q?34pMzJ9f+58qrKciax4zlGBhPGBbS8TevBcjQtIM6fsVMTgfgN+XANk2b0bS?=
 =?us-ascii?Q?6N6FiS3pNi0gojJKkG0A3TU3ipuIeXWCCkFho0Mi4fbHqmTDxqQhIdlAa2Ir?=
 =?us-ascii?Q?+/tHjisB11YLC77evdAQcusyRvQjD+/dXOVyWUcApLm/e94JO+jqofIEv7Eg?=
 =?us-ascii?Q?1AsSzEdBWKpZFvMtJILz1Jaa0c0KB1BH0Evkz943D1to3+JEnmoc302dk+u+?=
 =?us-ascii?Q?/VrWUOvHzFNou+tWsVzvN5eWJOZtukazgWFWRWnlXfaoX9ZOUPkNncwgmttM?=
 =?us-ascii?Q?dfeRw+6VMZxJ+PcXEaDEnb6pvogPR/ApOYir7pfuPwMgjIIyDq4rCZib7J2g?=
 =?us-ascii?Q?Z8WxEbPrcd1eJy6QDXo0zYmRX1h9CD+AX3ZxuBNp9BNypoKmgmhodezJ/jbT?=
 =?us-ascii?Q?ak1E8gbu/95ADU5vvRMK19PUyqLVGbDOzju2B5w/x6y7LZ/9NkkeP7+4KmuD?=
 =?us-ascii?Q?fa2mCySmduf1VBOcb63orzBz?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a04034a8-5fd4-4cda-06bc-08d9139e10cd
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5650.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2021 10:26:25.8667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WiaCFDHH5kXuF5Fz5hTJZL9/+dJquMazSjgj6vpE3KoBBVGkdLbjwgOcQN/lumX/DUdE4xziYOeaRc18y7rQNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3395
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/10/21 3:10 AM, Davidlohr Bueso wrote:
> On 2021-05-08 12:23, Manfred Spraul wrote:
>> Hi Varad,
>>
>> On 5/7/21 3:38 PM, Varad Gautam wrote:
>>> @@ -1005,11 +1022,9 @@ static inline void __pipelined_op(struct wake_q_=
head *wake_q,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct ext_wait_queue *this)
>>> =C2=A0 {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 list_del(&this->list);
>>> -=C2=A0=C2=A0=C2=A0 get_task_struct(this->task);
>>> -
>>> +=C2=A0=C2=A0=C2=A0 wake_q_add(wake_q, this->task);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* see MQ_BARRIER for purpose/pairing */
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 smp_store_release(&this->state, STATE_RE=
ADY);
>>> -=C2=A0=C2=A0=C2=A0 wake_q_add_safe(wake_q, this->task);
>>> =C2=A0 }
>>> =C2=A0=C2=A0=C2=A0 /* pipelined_send() - send a message directly to the=
 task waiting in
>>
>> First, I was too fast: I had assumed that wake_q_add() before
>> smp_store_release() would be a potential lost wakeup.
>=20
> Yeah you need wake_up_q() to actually wake anything up.
>=20
>>
>> As __pipelined_op() is called within spin_lock(&info->lock), and as
>> wq_sleep() will reread this->state after acquiring
>> spin_lock(&info->lock), I do not see a bug anymore.
>=20
> Right, and when I proposed this version of the fix I was mostly focusing =
on STATE_READY
> being set as the last operation, but the fact of the matter is we had mov=
ed to the
> wake_q_add_safe() version for two reasons:
>=20
> (1) Ensuring the ->state =3D STATE_READY is done after the reference coun=
t and avoid
> racing with exit. In mqueue's original use of wake_q we were relying on t=
he call's
> implied barrier from wake_q_add() in order to avoid reordering of setting=
 the state.
> But this turned out to be insufficient hence the explicit smp_store_relea=
se().
>=20
> (2) In order to prevent a potential lost wakeup when the blocked task is =
already queued
> for wakeup by another task (the failed cmpxchg case in wake_q_add), and t=
herefore we need
> to set the return condition (->state =3D STATE_READY) before adding the t=
ask to the wake_q.
>=20
> But I'm not seeing how race (2) can happen in mqueue. The race was always=
 theoretical to
> begin with, with the exception of rwsems[1] in which actually the wakee t=
ask could end up in
> the waker's wake_q without actually blocking.
>=20
> So all in all I now agree that we should keep the order of how we current=
ly have things,
> just to be on the safer side, if nothing else.
>=20

Considering that moving the wake_q_add call in v2 / v3 has the potential to=
 cause lost
wakeups which has shown up in other cases, I would argue for merging the ap=
proach from v1
as the path of least surprises in favor of first factoring out the race [1]=
. I will
resurrect it for a v4.

[1] https://lore.kernel.org/lkml/20210504155534.17270-1-varad.gautam@suse.c=
om/

Thanks,
Varad

> [1] https://lore.kernel.org/lkml/1543495830-2644-1-git-send-email-xieyong=
ji@baidu.com
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

