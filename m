Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74D80403B7D
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 16:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348814AbhIHO33 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 10:29:29 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:33606 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229600AbhIHO33 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Sep 2021 10:29:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1631111300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j6d9ZMxRtBBb6+QUt6hwEKx14KSM3R+s8pNB7AtZApw=;
        b=i4L+HTWOLsBdeoUMs1vUJHtyCG6yF1IEDR8q5DpcKtCqkzGyEmrO0huf4obSDNaGsBlLh4
        knYufTN7ME3bnozoBVgW4xj3wUhVBxV1AT/p9b82bxaQ7QW3XjdBETkrlGc5FB8t6zVCsR
        PeFK+/QeptokyvCyxu/b8FvHVDOkLqo=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2169.outbound.protection.outlook.com [104.47.17.169])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-24-rM9ZSgQDPbG-VEFVfUScTA-1; Wed, 08 Sep 2021 16:28:19 +0200
X-MC-Unique: rM9ZSgQDPbG-VEFVfUScTA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K1f64Qoh67yKL/yyrd/J7B6Wv+f6AuZw1zvesc4pj+aVTmxpIrEgvPfoxOJeCCub6iUPXa5ha6VE7fAz3Qirgc0qs77HDEMnAsBdKZhzhZyyLFGLQh9U+4eCjUIROcWeZ2+wIFMBdMgm7vKW5levxk1cPcGCV7YeL3AQ8WUeOskXvGl10WqJTrnVVNVepsR5PgVlT9jkvhEixagRDKEddTX0gJBOSOYbS8jvUIxsU01GST+YAhZqLHlIyacfqIxBepw7276eMmRn+YK1R981tAiSrPUKZ1E9BmK3yLylWGFI3LSnF5/gUhHNrKcl2BYDAJphVBZpfH4iAtV7ZxGhOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=j6d9ZMxRtBBb6+QUt6hwEKx14KSM3R+s8pNB7AtZApw=;
 b=npA9YXS37OZ9eCnFZevG1Oe9sCiM53wc7KNME7aoBBxslib9tjgw8wUF1cUlCTJ3ku53+0dil6g3nvXPModqWf7WJE9QztQ+vFYHaFMEA9egf3nSCIrbm4EtvfrR4ZeiBJ++1TNerw7OosPCyFKcwYmsZVaoqGjsKAnlXjAVnoxM6mARgh5vpYa7t6K4wfBzJXnYkM+onOmACC31jERPaJn5z1vlnc8NmOFF51y9shoIhTZkQBFYZf/cx6Bf9GY5FervdZl/K1fnmXQ7jmTzSW6N/eXTDK99tz5h+f969GmERKBS4bHq6pwHXPUZgsjziL2eX0gcTzXUQ0WckOhsuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from VI1PR04MB5600.eurprd04.prod.outlook.com (2603:10a6:803:e7::16)
 by VI1PR04MB2959.eurprd04.prod.outlook.com (2603:10a6:802:8::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.21; Wed, 8 Sep
 2021 14:28:17 +0000
Received: from VI1PR04MB5600.eurprd04.prod.outlook.com
 ([fe80::4d37:ec64:4e90:b16b]) by VI1PR04MB5600.eurprd04.prod.outlook.com
 ([fe80::4d37:ec64:4e90:b16b%7]) with mapi id 15.20.4500.014; Wed, 8 Sep 2021
 14:28:17 +0000
Subject: Re: [PATCH] xen: fix usage of pmd/pud_poplulate in mremap for pv
 guests
To:     Juergen Gross <jgross@suse.com>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org,
        Sander Eikelenboom <linux@eikelenboom.it>,
        xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
References: <20210908073640.11299-1-jgross@suse.com>
 <5a4859db-d173-88dd-5ea9-dd5fd893d934@suse.com>
 <34afed98-5072-c563-5d29-97e09a0b4ebd@suse.com>
From:   Jan Beulich <jbeulich@suse.com>
Message-ID: <6862566d-4d55-dc5c-082a-da4fbcafcfce@suse.com>
Date:   Wed, 8 Sep 2021 16:28:14 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <34afed98-5072-c563-5d29-97e09a0b4ebd@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR3P195CA0020.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:102:b6::25) To VI1PR04MB5600.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.156.60.236] (37.24.206.209) by PR3P195CA0020.EURP195.PROD.OUTLOOK.COM (2603:10a6:102:b6::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Wed, 8 Sep 2021 14:28:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 258b01ef-e0ae-46eb-7640-08d972d4e62e
X-MS-TrafficTypeDiagnostic: VI1PR04MB2959:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB2959EDA1DDB7FA1ECD996FE3B3D49@VI1PR04MB2959.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pKOgsU6+d/BzhFdtn8fh0taiwakbEhUB4cGrV4YJGeZx6uJheMl0QFP1qCVz/Y9rVXjg0c4ZWho3SFYoXhLCk6IuUAODrS1AHgiM3hXoWF9j8wEbVg/CNEqffJkhmMFh3h3m4qPsWBJUnBafY/fMgOoPyAgjP90JK3Dxr1bmGlUTkD/eh14I8aKxAdppUnAHUM3sRGXneDCqHu4JMvEBBf/tqdJC10TVqD4t+dJzrh5+TAY71YX5+hWD0IKJha/5mLg6C9WuzOLMi4wOcCcthufurIDHHzAFZr5J5TY0TNTqLsuiBjme28ycGGsnc6ZHJWM2qDBNxjPnTSdkM1z600TX2nobFm+wctOdmQH4IQpqJN8y/fjfn9fANUfW6u9RhJcdyBYmGxdSjl3kbCQtRxh3otu1hpOBwlaPW+8qxG1VfnziZMx54ujwFwDUQq9L9vp7h7S8bDdASgsTSxcFx6/3HWFzIV/+x9OcppjZCdBYFpMkHOwTr7B2z9NqQxSZMOWDz/ufAmk9tMWHijcCNWueP2WHzCbd9UZYl6Ukouzje16hHH0x7QDoJoiIL2JlXDFptUdOE+tuSsgyWNMg8K0Y8QVs9KYW2J1z63A48b0Rhy0+944PbAaSuzvl42amq8x0g34xIVRPLg2RdEQjAzqBwCgs9p5U39rw7p2DQf1sK3f4mWQaZlRj7byxYZRrAmtaY6ltOpFzFawL/L85GXyTVZh+4osq82na8lyc+60=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5600.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36756003)(53546011)(26005)(186003)(16576012)(2906002)(37006003)(508600001)(66556008)(66946007)(31696002)(316002)(4326008)(54906003)(86362001)(2616005)(956004)(8936002)(8676002)(5660300002)(6636002)(31686004)(38100700002)(4744005)(6486002)(6862004)(66476007)(83380400001)(7416002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eHBYWWRFK3dNeERISXZVOTlPVENqSlA5ZmRXTmV5NEkzN2hIRHFsMkZISG8y?=
 =?utf-8?B?KzRJY1Q5Yk5sRExraldkNW9Db1NPalMyV0p3VndwL2NEZlBLQW5acmtISGNy?=
 =?utf-8?B?THY5STdVWEIzeGRPMm5NMmZaSlpyTVNQdmUzZHJPKzBRR3E3QU5ycGs5VUxz?=
 =?utf-8?B?ZjgxUFNYZjFpK2sxRDQzVDdpblExa25ubCtYUis3K1ZvaTM0RTIxc0s4N2xC?=
 =?utf-8?B?enczaW4vVU1BN3VkTENWRURLQjUwaDNSdzFYS2dIZ29KMDhseG92aVk1UUtt?=
 =?utf-8?B?N2pVd0RiaVM1K2JqZ3JSTzZEeXJibVpHanlpRnpLbUo5SWVjM2lPZzFLa1hm?=
 =?utf-8?B?eUQ3ZWFoUUdYdWNBdFV1NGM1L01hVW1Dd0w3SnVnTytPdjFOT2V0Yy9wMEZa?=
 =?utf-8?B?VERiV2ptMmd3WWhWTmVIT0RUUGRrdXJOZEZ0U2h1aUIxYlE1Z3JBaElJWHN5?=
 =?utf-8?B?em5EK3pzL3JCTFQvN3hEVFRiWG5QR0JXckY2K3kreUpMVjBDM1ZleVZMRzFQ?=
 =?utf-8?B?eUdIeHcrQVROYnUrNURCK3I1MTR5NGZmYVZqRmZqeWYrNlVBYUxaekc2cng5?=
 =?utf-8?B?dFdmSTdRZktrQ1YxbWx6bFc4OVJ5ZkFoSDFzT0ZpUkVvU2o3SDd5ekZpT3Qx?=
 =?utf-8?B?aXVEeVd5Slc1VWpqZVlPVGpKeSt6TzVCQklLSjUxd25TOFh0VlJNcWYvOU9q?=
 =?utf-8?B?QXpOKzdCQ2RqSVJ4Z1VoR2hkNEpQdzZ4RDV4NVZrcWh4U1ZwWWRoNVNsZzYy?=
 =?utf-8?B?eG1XUmF3cUtaR3VNSDNZZ1BrTW13bTdwMDM0WFRGN05INkVNN2xmWS9uRkl5?=
 =?utf-8?B?Tm5NM25iNE9acUNCcHU1ZFl0Yzh1SVBxTUlhcHdFY09HRVRwSmYvMkxmaVRs?=
 =?utf-8?B?WnlwM1JGTGFzSkxDbmJSdnBtc01GcFRnaDVxV3lxc0RpZGEzV2JtLzBqWlU0?=
 =?utf-8?B?ODg4RmMwOW1jWDlQZ3ZwV0dIUk42VUdidWtEQlFvMVhBR3lFcndmMjg2cGRy?=
 =?utf-8?B?Y0c1R1RpTGhUR0ljZkYycnV1bmhWZFhvS0p6cWxGWXZaRkllWTI3YVg1Snpk?=
 =?utf-8?B?LzFYenhqSnFSenZTMmdGSjlGS1huNVhrSXh1NnpaUTd1SnU1b0lzYjM2by94?=
 =?utf-8?B?cC8rV091Tmx1L0p1N2xkMUlvSklmNXl1QWM4dkRncWt1UzVMMWt4KytkVW5M?=
 =?utf-8?B?dExHSHhTZ0c0WEQrUWNSZDhacnRuSWxLdURIM3kvL2FvMTVQVlNEY2hsaTBY?=
 =?utf-8?B?YkF3SEp2NlJ2d25tdG1xcWpmL01YbGtMTGZEdVZTaGRlSkx4a2RxTVlxTE41?=
 =?utf-8?B?OWFDQVpUaTZCSlM0elpUWU55M0w5cTZGVzJwTktsT1VSSFFiOTN6UW1zNDFj?=
 =?utf-8?B?OVlTYjJmTmZJRFhPTThQc0ttMWw5MEd3dkp0UG5PcDdDa0ZZTHRWODlaaUVV?=
 =?utf-8?B?WkpqRlpZMWkxV2txdmJtSHB6VzQ5RnVZQmVibVNqd0VUQUZoc1NENlhCbTRo?=
 =?utf-8?B?MC9adjI0eERYeloyVmpBUUtmbnZRUzNZK1JnSkhxYTI1a3Y3eFF0YUVXeGpN?=
 =?utf-8?B?aWlXM1RDb3o0OE1OR1hpK05yVXJUM1hTK1JVTzFIbmRhVDB0Um9lZ2FxS1k4?=
 =?utf-8?B?YjJNcUlJVXR2MmVpWk4zZDA5WmVEaUI2Q2MwRE5BN0dkV2pNak9lUE1aQVAz?=
 =?utf-8?B?ZDFoUE94R3dBeTcrQmcwZmJQTm14bzNGTC9meFBnSml0eVdibnlleFlzcFNI?=
 =?utf-8?Q?w4hJH51wQZ2r4e8i5xaXpdtXBY1J6m9XlJy/gm4?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 258b01ef-e0ae-46eb-7640-08d972d4e62e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5600.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2021 14:28:17.2422
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rmo54oSoWhokqMYSYw/bukK2rNAcW4qnvYcwxpAZO8m7VQPetOe1DN2n4eJXfNCnPZibptN2wZOv6TFZKKN1VQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB2959
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08.09.2021 15:32, Juergen Gross wrote:
> On 08.09.21 13:07, Jan Beulich wrote:
>> On 08.09.2021 09:36, Juergen Gross wrote:
>>> Commit 0881ace292b662 ("mm/mremap: use pmd/pud_poplulate to update page
>>> table entries") introduced a regression when running as Xen PV guest.
>>
>> The description of that change starts with "pmd/pud_populate is the
>> right interface to be used to set the respective page table entries."
>> If this is deemed true, I don't think pmd_populate() should call
>> paravirt_alloc_pte(): The latter function, as its name says, is
>> supposed to be called for newly allocated page tables only (aiui).
> 
> In theory you are correct, but my experience with reality tells me that
> another set of macros for this case will not be appreciated.

Perhaps a new parameter to the macros / inlines identifying fresh
vs moved? Or perhaps the offending change wasn't really correct in
what its description said?

Jan

