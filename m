Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 887D86D9C9F
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 17:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238637AbjDFPrQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 11:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238701AbjDFPrM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 11:47:12 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2112.outbound.protection.outlook.com [40.107.113.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CADC9008;
        Thu,  6 Apr 2023 08:47:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qbc1efAea5eYfIEvd9BCBep4ga3yOB6CTj1Q5OVtsm7I15Rq2sFHCIXjz9H31/vckwJ6OIvJI8WtCmpMKhsFyMUqY9kv42bSPwHE9s81xXM000rg08eVfpleVwjaIC+7z4+hl2OkO2cTImJ/WGCzJdJo0HFfiNPwAAjtmxdLGTR07zkFygtthEyEOPsxiJeTewNCEuiM+PqHn+icxt0Hp0GQmYVebeyl8f743NWrv1BNRB7OP2ypOHm8pcImAhELZ8650PaQqY2sQF1BD9G5kcK2yVn/+U/F95a0ZlakEzWFgqV9PR00Wwhhv2GDa0prZ7krqWxfWqw8pw0THqgMwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W0ONaHqpSlqxPq2+3DvHO+vcrtJdSaSh6CKhehQUTEc=;
 b=QpftJb4C9yAEfRTl1W0ed46RApLjQsqs2IUVKxzdSC1ynwi1ht+0ipMt4tkBPJiZyAfyOaMmGvIJz4RHs4vIy12qYnHBy67S2g2JmlbLxuqkD0qAAyoG3dbrLIsh1A1acxuobtnVPosVSEkZP9CUVPSJBW6c43IWcpFDjWKIcYj+W0TSnYdjcCiUnhl2uXXiPxrd4ZwaBGBpzfJFoUP25KjImW/3kvuND24phTOSRoGjo2TEuSwwfjVK0LRc6s/DDGTItZmLbGdloUU3IYIECxXITcrP1vbko/XEt6zGb7jzu3r8CmGTJqY5yNXNFitVNwX/uiEEXZJNO7y/tOmrZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W0ONaHqpSlqxPq2+3DvHO+vcrtJdSaSh6CKhehQUTEc=;
 b=S+ETPhsVlX1QzIET6Min/m8UzAqb69RRHt6oUlP1mfQPgsNfSwzUzn3UDmXaLz4NKMxkQks0ZLbyAV9UAlepjVt+1U73/pMc3v/fI1iOugM65pvEKB6rtMAKtjSyo8JDZSulsH6Kxmm/ES+M/7GPkLIwDsSX6fWubTMFBxNJjyo=
Received: from TY2PR01MB3788.jpnprd01.prod.outlook.com (2603:1096:404:dd::14)
 by TYAPR01MB5595.jpnprd01.prod.outlook.com (2603:1096:404:805a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31; Thu, 6 Apr
 2023 15:47:08 +0000
Received: from TY2PR01MB3788.jpnprd01.prod.outlook.com
 ([fe80::8b5:5f09:5a0f:370]) by TY2PR01MB3788.jpnprd01.prod.outlook.com
 ([fe80::8b5:5f09:5a0f:370%6]) with mapi id 15.20.6277.030; Thu, 6 Apr 2023
 15:47:08 +0000
From:   Chris Paterson <Chris.Paterson2@renesas.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "patches@lists.linux.dev" <patches@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "patches@kernelci.org" <patches@kernelci.org>,
        "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
        "pavel@denx.de" <pavel@denx.de>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "sudipm.mukherjee@gmail.com" <sudipm.mukherjee@gmail.com>,
        "srw@sladewatkins.net" <srw@sladewatkins.net>,
        "rwarsow@gmx.de" <rwarsow@gmx.de>
Subject: RE: [PATCH 6.2 000/185] 6.2.10-rc2 review
Thread-Topic: [PATCH 6.2 000/185] 6.2.10-rc2 review
Thread-Index: AQHZZ6X79ReHx8vcS0SMKkIzcJttTK8ebnKQ
Date:   Thu, 6 Apr 2023 15:47:08 +0000
Message-ID: <TY2PR01MB37882B36A127F47E2121C1C6B7919@TY2PR01MB3788.jpnprd01.prod.outlook.com>
References: <20230405100309.298748790@linuxfoundation.org>
In-Reply-To: <20230405100309.298748790@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY2PR01MB3788:EE_|TYAPR01MB5595:EE_
x-ms-office365-filtering-correlation-id: d4da6dba-8442-4c1f-a711-08db36b62deb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2xApYsGiexBaeSot1teYCIINy5Bvp32IbDLLz6RMPGq1yReQjJsm/ZutR1jopXIvWdDo2XTz30cOYhzS9su9oVKf5sDRxhx1gIhOgGBJReANbodhKZP/b81l8J08YpfIRbIiKdPNptf00Tdffhct2V6LvktEwpCIqCsemiQgD9ygdbU1n6Kc2jBa7n1hjtGiDLGo43/MYJxjCv+Imcp0OzO6PSYUWvamiNiPjii+nKOnBZwd9H8aFVy1/34tulX9iAI5WJF2NdDAvUTd4I/j5yty5eKushgkyAPd+MnEq1xMquVKATO+zf1rM9EfDurIcD7U2rhCAxG+ftsI6Z9+n9QBAeS3N5jtWHRL2UsHAHwZjuS5a1zSJVrKxPTiYXv1iHoSUnFvvQG1z9JT2W20w02XNk4YZIINZUnLiqZ4/gCQy2lgG6stS5h6ihl3FNw3F7sHFoLrESvRtlpYNVb8ba1LerjgXNfDpRaONGDgvaUXtf0QVdYyQ5b4Mvm0BPA6NiHD4le3kZopEOo/ccZ+b8vbIqn3xsINNVdLZxAHKU7i47iWrh9z7eu/Ay9LsHOFHYvBZAAeP9ymXof2NSM4AvwrTBnrPFkvkxdW5D3AgsbKeiK4Hl7kGC8dtILVgRzlSwCkd/BR/NVJ9CoJUqDYng==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB3788.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(346002)(136003)(366004)(396003)(451199021)(86362001)(33656002)(38070700005)(110136005)(316002)(76116006)(41300700001)(66946007)(66556008)(66476007)(66446008)(64756008)(8676002)(4326008)(966005)(7696005)(54906003)(478600001)(71200400001)(55016003)(5660300002)(8936002)(7416002)(52536014)(2906002)(4744005)(38100700002)(122000001)(186003)(9686003)(6506007)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VUN5eFQyWFlCTmF3OWIwKzBjU1REbTc3Y3ExMGo2eUdEUzlLU1RIbEtNNmx6?=
 =?utf-8?B?di9Fd2dQdjlac3FuUWxoeWd4Y0g5YWxwazUyK290ejVlYVVPUWt3S0lVb1FU?=
 =?utf-8?B?SkVKWWhrNGZrRktEcDlsb1dIdjBqUjJjRWFONWVlcXNjQjFRdkZvZElFemk1?=
 =?utf-8?B?SFJadXYwMm5VaEZaMUZhOGUzdEFwVXVjbmluMDl0ZWczeTY5M0RIOXJaSVVI?=
 =?utf-8?B?ZWVlclBheUN2L3dIWHRCSVJFS1MzVFFVaUZjS0xraHVBNURiZHg3WTRrMHNy?=
 =?utf-8?B?RnI1OGNXVER5bHk3R0cyREkyTm5WK3BrV3VCV0RVR0hCZHZNOWE4Yzc1YWFs?=
 =?utf-8?B?MVR3V1NkU1hhZHhnT3NrelNnQ01Kc05CdjlMYTJwMXJIOWJDWUc1bFE2UFZo?=
 =?utf-8?B?MHo5UEJzME5BbTlYT3JBV1pJeDdWc2RybmRsdGZyaG9xU0JhWXZyczBGZlM3?=
 =?utf-8?B?WE1kUEZBc2RpSWI0S2hCVE9LcXd5Q0ltTEFzZjY2ZmlJa2QrZ3JhVDBWbGZL?=
 =?utf-8?B?N0Vuckt2R1RRWGtXNC9RTWVOWkp1eTJvYVlPd05xa1pQOFpmZXlUSG1iRFdT?=
 =?utf-8?B?Ni96UFdoUGlFcjFNNDJTYU9kR3hFaHo1QnE1SFZOckdzSHRaRlBnRnMwdlY2?=
 =?utf-8?B?SmpwVFlXdzJGRG1lMEFiQk9yK0c0U2QwRHh5eXBZdEo2bTdnVHcweG8reVcy?=
 =?utf-8?B?N2NIYnhKKzIxb00zeE1MclNiL2xmSG5KOWVQUXZTc2NuQUkzbUlOUEd1RE9z?=
 =?utf-8?B?RmdNZnBzd0dRckJBN2psQjVkcXk2bzhxNE9aWU1wZ1A3aWtZVVNSb3diZXRV?=
 =?utf-8?B?dCs5MUorZmdHcERyMkJsajE1eDM0QlFrWlVlQUwySTBjRmNRcG9ab21uUGNV?=
 =?utf-8?B?eUgvVzZPcERrQ3R3ZUJZZVN0M1lYNzdpa0ZWWElHazF1SEdvN1pjU3hOdy92?=
 =?utf-8?B?ZmlEc0xBWVZtZ1FEVEhjUmpRTnlyMzlLMGhKWXprQnYwRjhUNVd3NmVDYnVY?=
 =?utf-8?B?OGNPcGtJMURNNFI5V1NpZzVqbHltRldhWFNRY0IvWEsyMjEwQk4yaVMzVlUz?=
 =?utf-8?B?SC83Y1poNHFQS3JiQklJUHNya2RLay82a2hMek5sQUZqbkFVemZRM0c3RkZp?=
 =?utf-8?B?WWcxSlluVzFteXZBcGVOejF1ZytNR2RHa2xiRWtGLytuVUR5QkM3R0JmdkZr?=
 =?utf-8?B?elZaaGtYUDdsaGdEaU1MT0tjblNqbFRBd1doOTlUZTg3WHpsSk5HSENUbnov?=
 =?utf-8?B?Y0IrZ2xYcjdhQjFzVSt0UWxBdUgvZzRDaVprU0haUzRrdWUrMmZIUi9iMXJ3?=
 =?utf-8?B?RlAwamsweWlFTVMvQXVZQ0lrZU05L1Iyekx6SmttUzJaVUxmd2l2ZkIzWXFL?=
 =?utf-8?B?SE03b1VwNWxVQ0habXZ4aVpYZDNrc3JWKzJLZ2Z1YTh2TnVIOHBidWhuN1Zz?=
 =?utf-8?B?UnNvUjlVUlRRdE1UZWpqbDJDdlhqZTdSUDlacFVGWE5wS2hrZWtUb1o3aFFp?=
 =?utf-8?B?eDJNUy9tL3lKZk1jdTBvZnRQZW00RHdnQ0xWd0lnYUNHMkhNcnVVbTVjOXdF?=
 =?utf-8?B?b0V5VnpUSkZrUit3WUkzZjlFTWdiVkhRNmtkd1BzSTRMOW5YQ3ZuMHllWGJo?=
 =?utf-8?B?NGN1bUNURUxRWEVCZG9ObFkwYnFlZ0xiU0FlQUxYdFduMnk5MHJvQ1l3SmtW?=
 =?utf-8?B?WS9rWk9adHFoUDBCTzBpaHBYSGR1UnU0NEc4czlISUVzWnVYV0x0dGVBRXNJ?=
 =?utf-8?B?L05rYktzT0pNdUthUnZ3c3ByZmcvUnZ4OHFFQVFpcFk5Q3dFK1NtaU9Cbjhu?=
 =?utf-8?B?QWY4T2MreUlNS1hwdlFZMXdVeGVobFFqWjJLM3hkcmhKL0YxSGRrZXo3bG91?=
 =?utf-8?B?Q2Y2K05xQmZsNCtxaHdGZDl1Vm1BYW42NGF6Qkd3QnpFRjR4S2llMGM2WVor?=
 =?utf-8?B?T2d0b0Q2WGYrRHBQbFhERVNCbERaTmlTUG5SbG5YQlcwR1RjOURJOTRjTXpL?=
 =?utf-8?B?SjlxQmlyVVJhUVN1cTBEUFEwSnpBZTR4ZHNQaWZ6ZHhNTjR5U1E5WHUweEFO?=
 =?utf-8?B?Mi90d3RVVkdkWHROZHZnaUNTTzRGUStJT0wxWCtRUEdPRXpKblExbmRiNkRo?=
 =?utf-8?B?dHRDd0w5eTZNOVE4NUk3aEFYVEcvVlVxSU04VEh0U2phWlVBVmJSeTIyZTQ3?=
 =?utf-8?B?V2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB3788.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4da6dba-8442-4c1f-a711-08db36b62deb
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2023 15:47:08.5130
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fz5Zf4DYJ+VUvFG8+SDIv2xEKkbb5jhVUPIa+NDKAsz7rmEf+Wj45orwyUyew6g3RgCH3JTDvdDVlnOQwxWd3152TecDg+SJzJ71XFNC5QA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB5595
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGVsbG8gR3JlZywNCg0KPiBGcm9tOiBHcmVnIEtyb2FoLUhhcnRtYW4gPGdyZWdraEBsaW51eGZv
dW5kYXRpb24ub3JnPg0KPiBTZW50OiBXZWRuZXNkYXksIEFwcmlsIDUsIDIwMjMgMTE6MDQgQU0N
Cj4gDQo+IFRoaXMgaXMgdGhlIHN0YXJ0IG9mIHRoZSBzdGFibGUgcmV2aWV3IGN5Y2xlIGZvciB0
aGUgNi4yLjEwIHJlbGVhc2UuDQo+IFRoZXJlIGFyZSAxODUgcGF0Y2hlcyBpbiB0aGlzIHNlcmll
cywgYWxsIHdpbGwgYmUgcG9zdGVkIGFzIGEgcmVzcG9uc2UNCj4gdG8gdGhpcyBvbmUuICBJZiBh
bnlvbmUgaGFzIGFueSBpc3N1ZXMgd2l0aCB0aGVzZSBiZWluZyBhcHBsaWVkLCBwbGVhc2UNCj4g
bGV0IG1lIGtub3cuDQo+IA0KPiBSZXNwb25zZXMgc2hvdWxkIGJlIG1hZGUgYnkgRnJpLCAwNyBB
cHIgMjAyMyAxMDowMjozMiArMDAwMC4NCj4gQW55dGhpbmcgcmVjZWl2ZWQgYWZ0ZXIgdGhhdCB0
aW1lIG1pZ2h0IGJlIHRvbyBsYXRlLg0KDQpDSVAgY29uZmlndXJhdGlvbnMgYnVpbHQgYW5kIGJv
b3RlZCB3aXRoIExpbnV4IDYuMi4xMC1yYzIgKDU3MmI2ZTllNGViYyk6DQpodHRwczovL2dpdGxh
Yi5jb20vY2lwLXByb2plY3QvY2lwLXRlc3RpbmcvbGludXgtc3RhYmxlLXJjLWNpLy0vcGlwZWxp
bmVzLzgyODY4NzM0NQ0KaHR0cHM6Ly9naXRsYWIuY29tL2NpcC1wcm9qZWN0L2NpcC10ZXN0aW5n
L2xpbnV4LXN0YWJsZS1yYy1jaS8tL2NvbW1pdHMvbGludXgtNi4yLnkNCg0KVGVzdGVkLWJ5OiBD
aHJpcyBQYXRlcnNvbiAoQ0lQKSA8Y2hyaXMucGF0ZXJzb24yQHJlbmVzYXMuY29tPg0KDQpLaW5k
IHJlZ2FyZHMsIENocmlzDQogDQoNCg==
