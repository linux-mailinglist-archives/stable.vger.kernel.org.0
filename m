Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F290A5BF0E1
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 01:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbiITXNr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 19:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiITXNq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 19:13:46 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-eastusazon11010003.outbound.protection.outlook.com [52.101.51.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 920D03AB06;
        Tue, 20 Sep 2022 16:13:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CWH67X3Q1PThWCp4Hm3f5qy21kJiV47zazcBaY99fXyK81Ai09AJKGYh2H3c1WIG+QDKE+jDIZ06rh4ekyAFxKc4Y8AiK1eoaNJ7sevYrM7YfEjizo5rA6v0iHSpnKnKMBwRUmhHTPYMP6gCVTiJ53/gNSPNqViGaW2d1NcYn8i6BocAwi3VyF9QKnaMox+JF2qp0d7TxQHgpQITl9YOy+yMJBXsLhPxMbWmUYUcyINEOGtRThw2re1745bPTRSKMpgJAebvt80Dn+0XFko198P1twAUjbHHU6WCE7mU/+3R/se/vgeCftXsaFWhTZv+/ziuSB+Z5hqRqNeeaf4Upg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=03RB6LfgmyXiHHFH53FNt27EtSJryvh35lixGK2//ww=;
 b=CaNrjbsIIU6DoyZflmbUSzlm91FqJscYn0cnaeFF3xa/MgluqEtjkcOp4kiqoqJIYuuY0yqA261YBSplYjU2qAGJskrLxiD9xv4Gxdtp5cbjGy7fG2oNSgjb3cmcrVET5+6FmkK0F3e90iv+kTHxJNax7WcNZcWE28ESerL2+y44zY6fur5v13RLTlm8dWhsOIUh4Ez+KJhuzBCPQLk0KU5TZDUwb4qy4lsBfKvvqO6EF9lv50QU4XO9rV++jUUYqMTklcLi23hCgjmxylhY4yJJ1XKRCJw7XQi+0oJQEqobQVbQXjC8g9JsJ2EhvJQ5GFPwEv7UU0LIf5LdQAbKkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=03RB6LfgmyXiHHFH53FNt27EtSJryvh35lixGK2//ww=;
 b=C/oFcsSI2IPn8/qRqPstVvTsm/PBs6hhtbI+mUz8qyp1CSTcPMEoLSUTpvlaaSrIZm3uHAKOk599Ls6w0ZO/G2XbNCet1CUVAGxwyQFxH0yUYrx6fYjzxgLVujagHyZ/NNyziXoU4+LCsMuyM8vyBEFH+uKd3Ko/cesRPeCBrv8=
Received: from BY3PR05MB8531.namprd05.prod.outlook.com (2603:10b6:a03:3ce::6)
 by MN2PR05MB6767.namprd05.prod.outlook.com (2603:10b6:208:180::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.7; Tue, 20 Sep
 2022 23:13:42 +0000
Received: from BY3PR05MB8531.namprd05.prod.outlook.com
 ([fe80::942c:7d1b:6b3d:85b6]) by BY3PR05MB8531.namprd05.prod.outlook.com
 ([fe80::942c:7d1b:6b3d:85b6%5]) with mapi id 15.20.5654.014; Tue, 20 Sep 2022
 23:13:42 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Nadav Amit <nadav.amit@gmail.com>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: Re: [PATCH] x86/alternative: fix race in try_get_desc()
Thread-Topic: [PATCH] x86/alternative: fix race in try_get_desc()
Thread-Index: AQHYzUKsetLOm0hn3UuxTjzL+E3efq3o8rmA
Date:   Tue, 20 Sep 2022 23:13:42 +0000
Message-ID: <EECE6FD7-FC3D-40E2-A957-151A1BE2B2F9@vmware.com>
References: <20220920224743.3089-1-namit@vmware.com>
In-Reply-To: <20220920224743.3089-1-namit@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY3PR05MB8531:EE_|MN2PR05MB6767:EE_
x-ms-office365-filtering-correlation-id: 9e97b7f8-7e08-4977-57d9-08da9b5dc254
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +H7ARiwc+7hDo/L9x7zDAKBYnGGzfDYlR2wfd4vERJH6RToAeQuHBXFcjbFSjDlQRHKiRvIulpErWuWJRTtIbFP50esOt4pnQeZQMstc4t9/8javzldPOrv0NIkPG/bV19P6VwQE42LaE1CD6ii3e/8/XoqscbevIrOnyad8UmyUh/FfXf11u+P8wrY4eKMNOVdNOyKToZMtaWQojSkjqrWpl8AqwuliCJzPzvx13DziwuazYYOsuELzagbzM8qSeLeEnS31Q+lDBUt9AdzQOg/8HoTS2+Fqal52QmYNLjBX0JCZCorHHl6FcF46VstsbRvOT62qmMOjabW1dbn9i5sVKFxHmIgc/1R3HODLxiURaPGR3BjWcSiDNOAK1VNR5DL8L2tlcBc1QXhC2K/P6W0a+vKkqJRnmcDMZBJKubyFmu5xxoqDWZqWTwNkWVf2ry2SPpSwLpzFLm5RxPy0Z45VGwDbrxppa4qhsa80NTpiiX8VoXyQrtoRHMDQtL9oBb36TrKkk9lRN3KUOCJfxTGk2gWB+vWR07ozVR8pKISYJ4lgVryAwH8iLMTTc2KkwU8n0nZkWwKKVjH+QqtYUADZjhVbFXr7D3nvtTNtUqEQ6E9cHu/0iWFkQTBb0i6I4SV2dlAh/y3P1YL0jJNjTbbjNvCuLCoNgaStrKwxhkSJR+Aw06s2Wo0fbz4sHloe3E9YQoekMXCP347DxzrJR99pG81tGF83eafuUwgEeWGnfhW/LHvZqHH16S+KKSDmuDBLEEP1K7SWZqs3nroJXQKnsqy3fcFhL02GjR10oic=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR05MB8531.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(376002)(346002)(396003)(366004)(451199015)(7416002)(41300700001)(122000001)(8936002)(54906003)(2906002)(36756003)(4326008)(64756008)(186003)(6486002)(66446008)(71200400001)(478600001)(2616005)(83380400001)(66556008)(76116006)(38100700002)(66946007)(66476007)(6506007)(53546011)(38070700005)(5660300002)(316002)(8676002)(86362001)(6512007)(6916009)(33656002)(26005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?e+10XHMTC7GQjhf5ZFGhGk+531R59i99yEKgFiT31r0V7hEZP/ZlOrBR421r?=
 =?us-ascii?Q?0mOnZ8Rttd9fJG0IfQuQiF/6ppqdHzMSi+NhFVkI+UqVhUh3W12KdwnPcyDy?=
 =?us-ascii?Q?P4MMPb9/sUd1Ux1GpH8YJv9mAv3ItOr1to+26Icv7JBaqgSJOu7GrpGUot0l?=
 =?us-ascii?Q?t4QNuOJJqxH5tpfczEr+V+pLhG1c0HHQQdmKZwMppqxKNEBODH+Km3xbCRtQ?=
 =?us-ascii?Q?/pgZnbyM1cqefkoVBhS98xJ4KAOvEv8PFpmpetICza8TmjKLTPrI9rvEUtm6?=
 =?us-ascii?Q?zCD74ZLDJjqdkPzJmWW25FsfwUkFvJJrHrtbnYvsdAjxYT1clvou6KVSjjIz?=
 =?us-ascii?Q?iqng/laWpkbGRwMEgZeZgPrqgbqFH7g460931GXyZNuEXGtynYEKTMtuq9Pv?=
 =?us-ascii?Q?cfVT2vESH5Z++a3FXjoK0EvBxbgz3ov2+qynRTpjebe+8sD6FQ7kwULSVFLB?=
 =?us-ascii?Q?Nf1D+ME0Jbyxru+nQWUKqctZs1eqcyYkFFGFwjlDR4IYb1t4kFio3yCyr2BF?=
 =?us-ascii?Q?+0ZeyuPQ+EAoLTv8P+7pj+NBmzRBH4On8Az4XFB7NbzD67kbXVLK+d7MM5H8?=
 =?us-ascii?Q?c/WRBlC1rbYpBoH+uVjA9gXevW7H5PszmSiPDLWp2LbkCyoGZNaNhylsIv4W?=
 =?us-ascii?Q?SLbMbYkmrmpiRqdpD7EIhaat8fLzQcC3QaG0nv8aCEDyGnc7exuQHZ5rfqx0?=
 =?us-ascii?Q?DtORjnPEFNihp/2RRaCKBEQ6eriDFgPfgQBtG3VOvDD6x2MGfkMbM0G4rezJ?=
 =?us-ascii?Q?ltZ/ec7qRfWphgTngUHFVCnTpWap+b0Fgr7I3Umy/56p2Al3rI+q+6DTYyCI?=
 =?us-ascii?Q?5K5UB/bBbn/q9d1OTVFYIa0JhkUccHIwBHl67JkYhCyfeUfcPhjFYpIpVuqf?=
 =?us-ascii?Q?q8M8Eo0Aut56n/YMvtp50gMy/ZKNnpYr2Cgn8st75dRvEEK9K2p0M5yROJgy?=
 =?us-ascii?Q?uN9WBrMQyB6OthRdzkjT5ibmeZaEBuX0CSxPGahp0U6Zp6fCOwpVmA9N8IeL?=
 =?us-ascii?Q?pTP46ajlgHWcC0UbIqwh8xjdOEbhWZgKiCSQZP5tCB+nwr5rNVYsYrNvAK2t?=
 =?us-ascii?Q?WAV+y69XQPiYferQvNUsu2q2NZChpFcuPuGhRkz6fcZbdccgNZrbgIn+QBQ+?=
 =?us-ascii?Q?h7RCSJgk52XgDYSSDzdbhSSfkMU/YS5wSKVuRPvPHl5IMOO4Cyz8Pv9NV1oj?=
 =?us-ascii?Q?nFvuox1bsSg5/AdqlW5X7iSO2YPvCt5fkQTCkVNRGjjk8S+KpASfhtFDMhvK?=
 =?us-ascii?Q?U93Fq07/qMHQoWp3Qoy1v4adKBWSTRmWoDbe4OSUWQgbOGxdDy6Ew8BDR2Ea?=
 =?us-ascii?Q?IWTW6JCdL/jYCd9veNEYYdtMlDvRbQP1W8OtT+Ux2s4Jbl8T+dkxtHISZkJZ?=
 =?us-ascii?Q?7APvWN9PfJhyt2z1R8Oo6JkMV7T0rVH2L+2a1beZT3weMQF61Yo+1lfSOiSW?=
 =?us-ascii?Q?ogR+HzS6m++j1p+C8m5/7/mH1+/Tf6z+5Q1K6sDOvTXVImWtaoLtIVIX6GeJ?=
 =?us-ascii?Q?96r/QNvnlazolR36nDDmFAKofGNC9htBcKc9K/6PINH8LFdzvsKqf8ZqvgtA?=
 =?us-ascii?Q?K4+eLoLjwvjfx9R1BB7kOYC+ZyDQDvojayq5lZlX?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <753959C1F7862E4B8EEF8D352B85D3C5@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR05MB8531.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e97b7f8-7e08-4977-57d9-08da9b5dc254
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2022 23:13:42.0605
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: io1c43nKF+HSPpMAUUCIUioJ/LKqi4xE/nNWeLpLh05gdrodJoEuDOHPqShqD5W4kn3E95w7DCDkNeOHYubvnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR05MB6767
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sep 20, 2022, at 3:47 PM, Nadav Amit <nadav.amit@gmail.com> wrote:

> From: Nadav Amit <namit@vmware.com>
>=20
> The text poke mechanism claims to have an RCU-like behavior, but it does
> not appear that there is any quiescent state to ensure that nobody holds
> reference to desc. As a result, the following race appears to be
> possible, which can lead to memory corruption.
>=20
>  CPU0					CPU1
>  ----					----
>  text_poke_bp_batch()
>  -> smp_store_release(&bp_desc, &desc)
>=20
>  [ notice that desc is on
>    the stack			]
>=20
> 					poke_int3_handler()
>=20
> 					[ int3 might be kprobe's
> 					  so sync events are do not
> 					  help ]
>=20
> 					-> try_get_desc(descp=3D&bp_desc)
> 					   desc =3D __READ_ONCE(bp_desc)
>=20
> 					   if (!desc) [false, success]
>  WRITE_ONCE(bp_desc, NULL);
>  atomic_dec_and_test(&desc.refs)
>=20
>  [ success, desc space on the stack
>    is being reused and might have
>    non-zero value. ]
> 					arch_atomic_inc_not_zero(&desc->refs)
>=20
> 					[ might succeed since desc points to
> 					  stack memory that was freed and might
> 					  be reused. ]
>=20
> I encountered some occasional crashes of poke_int3_handler() when
> kprobes are set, while accessing desc->vec. The analysis has been done
> offline and I did not corroborate the cause of the crashes. Yet, it
> seems that this race might be the root cause.
>=20
> Fix this issue with small backportable patch. Instead of trying to make
> RCU-like behavior for bp_desc, just eliminate the unnecessary level of
> indirection of bp_desc, and hold the whole descriptor on the stack.
> Anyhow, there is only a single descriptor at any given moment.
>=20
> Fixes: 1f676247f36a4 ("x86/alternatives: Implement a better poke_int3_han=
dler() completion scheme"

A bracket is mistakenly missing after the patch title. Sorry.


