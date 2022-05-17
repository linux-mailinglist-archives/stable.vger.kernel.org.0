Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F771529C8C
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 10:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242653AbiEQIca (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 04:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237104AbiEQIc1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 04:32:27 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2059.outbound.protection.outlook.com [40.107.93.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC507433BB;
        Tue, 17 May 2022 01:32:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WFlgttFxzpHf00cLipTrXEZk4gA3HNWxE4lPA+1OJPggb1AhFjhfc8Bmh+ZaT5E04cAR87+iFWit6Wa1qQOe6yCplaqoBxVNRHmArqUHMUN1jDNeZgzwITrymwLLiq1rf/K+u0rj/jRmmjYFALUb9S925UsoP6Af/WlwnmozkTV8AMaYD77wOz6zTY09kzBbpdtZSpmTCleskE2UrI90fk4ldDacbCuaBZMmhVUPm2VxrdDX9RhImsLwpj/SzhcorY+0fT2sMyssomfFTpdueQgJa8VIrT9jvCJIFDunXP4PpqwzBHA/ImcjvtZ1PyPVCdSBNm08jIBqZvrcSK6ZEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gddNG/DjYswX5/5T9BmkppfIwsBGYQ0LbqjmIcA7ALY=;
 b=IWa1d8EDT7MfuJjyF+XyNRO7Vrj1kSoJ1j1ek2klNOykLDJfBiGSkNealFSF3i5qjj2tvrReGKy8sHse/qr81UQdXd58+6+/hXlalWTY1rNd3+xzq8piiQIUxkkQHnLNypI/wSqgeArJNwGht4gFpoUPlUNRDVjCcWoZU0lsOgYIhSFOsE9RPoYIglRsrp6o42m43lbyggpepja4r1nwd7S8udC07zwsFK88TvkuMiUE+aqXH/ldxRs5vBmXWqSqOaCIx/oMwuP1nlvnXxal7phGjsGFdN8HIFg/hm7thYSfq2F8mCkaC7CS8pAov9Ze9LcwzP1CgjpBaljTVXk6Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gddNG/DjYswX5/5T9BmkppfIwsBGYQ0LbqjmIcA7ALY=;
 b=DJtqZmthIZnt+ILbMUpcmqS0PMCBN0yYXB6lWeBk2ip74TsnqAaeuN53SsAdnKztbGdF03Ue8JR1rdR2DhZkpcBXiITsNqFGh3OyH8PbFAhDngNqcraavvRUkHSXAyv1qtbfhAbjtSRnnAnYtKwV1DFbdlapQmH6S22/p5MHx8c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by BL3PR11MB6530.namprd11.prod.outlook.com (2603:10b6:208:38d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.13; Tue, 17 May
 2022 08:32:23 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::f8c2:3f6c:3211:7b29]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::f8c2:3f6c:3211:7b29%6]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 08:32:23 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jason Ekstrand <jason@jlekstrand.net>,
        Pekka Paalanen <pekka.paalanen@collabora.com>,
        Christian =?ISO-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] dma-buf: fix use of DMA_BUF_SET_NAME_{A,B} in userspace
Date:   Tue, 17 May 2022 10:32:15 +0200
Message-ID: <3847797.kQq0lBPeGt@pc-42>
Organization: Silicon Labs
In-Reply-To: <c1479285-7fd8-b73a-9672-6e0d7db4cbdf@amd.com>
References: <20220517072708.245265-1-Jerome.Pouiller@silabs.com> <c1479285-7fd8-b73a-9672-6e0d7db4cbdf@amd.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-ClientProxiedBy: MR2P264CA0063.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:31::27) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cc4127d0-46be-458d-0090-08da37dfc3ff
X-MS-TrafficTypeDiagnostic: BL3PR11MB6530:EE_
X-Microsoft-Antispam-PRVS: <BL3PR11MB6530D5CDC012E8DA410303E393CE9@BL3PR11MB6530.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5vrJ6ejEppJunN2nlBDM2xdR6TOJwv7jQ1Z5063lccJJICwwNoDnZEl+2GLahgzJ5L1tUzpeeIZDCVAPf9b2cytbygB63Hn/3WfBb5nH5iCRqdJKJHfEt9V2jILaXg7iPmQR2IV7pUaZvdRDm7qXJayagdG+BSKvm1J8T8Tps81p6CCdRAwlJsfxsWE537VH5y/X4kvUFxg0gO1J2o230yG03IyFUd5DozeZ5qWU04tWsxmlZx5Pqj38a9AUOU+0269bH9/5msl73ZG7y6GXyVA+YjRyP7d4FML81od5Mkmz1GUGCEIoOgbcKt53F2vh5RLObfYp0aiOwU6UimWrOGRe5SaNkCPTpLUxanzbg5sg8P1/b9m4UjuuEOdfp1Xmk5gxatIfSf/9f/frmkECB2wylLHf9/xHlbEKB3ovjX38jNXVyf0k38YHAeEWw3+HFoRRXGQ7Zk1yxraD1mP6zQI3k73GoryweYtWpT4M4OFQY0GEGX6qpJVOK9Qw/tSwZKUvvTvY4BtOxWeNC6k5gtK0gEeMoqNW0NivMy/3DftrxKCbJsxK4kO1pLSlw6XF3Wh9VzQbBOVgf/hGx78SrU0IwaqsV0jneKnQtjz9kYizommsgXwf2KHfKRfUbVGOCkFI/TB7AemG//YnY/HBn97hWrY7LzPFsMlPjL7en6HSv1+eTe6fZEhCGyLcg7iMCsDAYSVsLD5AB0MZPj8Iprz7jDCIt6uwhaIXxutMPx2S2sE+U9WIXKcgdyqAOZuK51P2rmD1mj7R1bgnwQ5RwbGdIAH3V3XbtDilnvYH8j+AhwiTT9MJZxWrXxA0cKfA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(186003)(38350700002)(38100700002)(86362001)(52116002)(5660300002)(66476007)(4326008)(66556008)(8676002)(8936002)(66946007)(33716001)(6666004)(2906002)(6506007)(6486002)(45080400002)(26005)(6512007)(508600001)(9686003)(966005)(36916002)(110136005)(316002)(39026012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eTFlZzRkTG1VeG93aWdyeU5tWU1zNHg1MmJMa1ZYZXZTMGJ5Ti9PdmQxN2pP?=
 =?utf-8?B?enBsU2F4MTkrOCtEb1JNVFp6L0ZWR1Eyc0pnKzhUalRmYUMrd2hnWVZCTzV2?=
 =?utf-8?B?QUdGNXV5OU12TkZ4RkZSZ082TVp0VU56QzFNWjFBUTBtbHpLNWNraVBDRlM0?=
 =?utf-8?B?U2JtcUVQL3cxQnBmbTFLd2gya29IY1MyUEdSdFphRXpYendaVDRzR0xJSllo?=
 =?utf-8?B?d3VWS1pkR2JNbzFGdXNGcVZnTE1SdjZ6OG9jSG16dXZqT1NoSkRrbzFTeXpq?=
 =?utf-8?B?a0dBL3NvSFU0Vmp4ekk4cGZidkQxWGQ5cWZFNDlNZXlUZ09HTHdpL1ptbVB5?=
 =?utf-8?B?VFFELzFQNHl6ZmkwYkRobExzSWtDSkFsUFhZSVNmYmtvUVYrZlU0TmM1VFRG?=
 =?utf-8?B?cnhlcEZYM3ozd2hqV0tyVmtaWFhKR0tSbWxFSi92UmhxM0hmSzRneDFNcS83?=
 =?utf-8?B?M3BzTGdoVzdYeXJleTdQMUVjMWx0MjlHN0JodWF2UzY2ejJudVVFZHlaRTF6?=
 =?utf-8?B?cnBtcTdFbzNQYkF0TDF5MWNCU2ZvTmI2NktBbHQ4dzR5UytkNDR5ejRyVjM0?=
 =?utf-8?B?SzB5QWovRGJKNkdZQTRqbktXa3VvNndGZHZJVVdRejdsUDNUdHladnBkWjNK?=
 =?utf-8?B?dmM3WkIyZUxLYSs1WHo2QTE4SEI5cXVkWldhY0lNS1hlZUtMYjZsSGc2UWtC?=
 =?utf-8?B?YWt5Y3NvOE5xU3N4Tk5scWhDRlBCb3F2dTNKTFdIOFVzMTc1WllaQ3lKaE1s?=
 =?utf-8?B?WWxpaTlCNnV6NllnbnV2SVA1RE80b0dmbnpvdUVaRENNRVVXNFR6dm9xbitL?=
 =?utf-8?B?QnFqSXlEY2Y3bW1lZGZlNHczbTBpYnRBWXVJYkhyQzM5anVmWHNPTGhON2VF?=
 =?utf-8?B?YnkyMlUzU3dBZFdaMUYzUUM3WFdLclFPVVVJTDUvYTZvbkU4Yy8vSWhublZS?=
 =?utf-8?B?M0FRQnlJaiszcXhxYlQ4cktYY1ZRYkNYU0wzeTlEa0dua0ZvdVhIaEV6Q1Nz?=
 =?utf-8?B?R3hPcjUyTGFiVzlWODNaQVoydklkeHVqKzBXRDZzNjB4WGFuSWNjaFkwYVJV?=
 =?utf-8?B?T3UrajA1eCtZMUI4akc4NG1HTzhMSnh6SzgrVWFBL0RndE93U2E5WnZaZ1RU?=
 =?utf-8?B?M1RaRURUNFFmQmNvbjlSdFZPb21vR01PQThLd2MreVk5ck5DYTZ1YjNGTGs2?=
 =?utf-8?B?Z1YxYVRzS2lZQU5LWWgrNk9NV1M0d1lRemhEUVJaRGRTSVdMNm9ERDdUQTlz?=
 =?utf-8?B?Nm1aaXJ5RHlqWllES2YyTGh3QzhTaW1GN0h6WWpWazV0RTBueVdwTU9PSyto?=
 =?utf-8?B?YkFJWUpJUDhva0NvRUh3SkY5UmV3NzljdDU5YnV2VnF6OEpHRjkvSm9SRlBw?=
 =?utf-8?B?NVk2Sisyck1rbVlwc1dwL0w3bkwrczUwZjlZcnJ2YlF2a0NXdVJ1Tlp0cnVj?=
 =?utf-8?B?VEROUkhVVnhrN0tHMUNsWVdPMlhneFlwWVJ5YVU5cFV4d1N3UnZKaUliSGky?=
 =?utf-8?B?Z2NUOExuQ2xNK1o2bXBLTEVhSncrbkt0VUlCZklRMmgrK2s2OEQ5L2tsbUQv?=
 =?utf-8?B?Wjc4dU1KcjZhdXVQV3lsQVh6WUhPdjdabTE3SGk3WERSUUUxQTVEZmd0bER4?=
 =?utf-8?B?bnpkemRNempzSU1NOEtOTFBOaHFRelVFRjJGL1EvaTEyYTYwUXcxanM5VHlN?=
 =?utf-8?B?SURGNVBuanJMKzN1ZTA2MnNsVXpIODVCVUd3WFFPVFZ0R0lNcWpLQ09JTnVS?=
 =?utf-8?B?Q2phakw1ejJZc2NDNDk0VDB3QnZPN0w2VkJVU2U0MTN6VTI4WmI5M2VFNTNa?=
 =?utf-8?B?bG8raUhkV3BWM2tGOUZuK0dLSk9ZRTRGS2tsdWxaOFlqYmE4dDllWlA0Q1Q1?=
 =?utf-8?B?Y0NzVDFpcEFON2ZkRmRldWx3MyszV1Rxdlp5ZkNETzl1MWVjTUJMYkdNNUpF?=
 =?utf-8?B?NnVPcktBZ280bjFJVHltOG9PanZxQTZSVE9tTUptTDZQWXFBVExyZ2ZWb0ND?=
 =?utf-8?B?ZGU4VU1MSjBMeUN1K09CaFYzajZMWGZkRkxWL0RtZ3BDQ08rbGVlYnN0aDVY?=
 =?utf-8?B?VHR1bDR4b0JpYkQ3cTJSbTloK1ZmWG51U2xocEpUVHNGcVN4RmF4S0c2UDFr?=
 =?utf-8?B?SW1PQmFlcTRuSWF4NlZGSWJZdmoxMlN4ekl0a2xKSFFyVVJUc1RGdnRvQS8w?=
 =?utf-8?B?a3Bqays0eFllN0lZbVdnYlRHc1RKRG9VbHB1SnMwc0tKOW54Qm5tUnZwOVBa?=
 =?utf-8?B?eWxuUzJpaWw4SWt1OFFvdkhzQTZ6c1JqdlpoNTJaNjl3M3NDM1VMbU5mYnMx?=
 =?utf-8?B?OE1pZ3pxVkM0dWVjVHhUQ2tkczVIMVh5a0plNmNkV0U5cW1TcDh4QT09?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc4127d0-46be-458d-0090-08da37dfc3ff
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 08:32:23.3567
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bVlVaR3uQ7lX3YJrldfVFGFbxtGtppOTTdwij4TOl6Cw+yIAma6jo57o/KtpxTqqeY995R4TI0CzEgt2K8NByA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6530
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[add stable@vger.kernel.org to the recipients]

On Tuesday 17 May 2022 09:30:24 CEST Christian K=C3=B6nig wrote:
> Am 17.05.22 um 09:27 schrieb Jerome Pouiller:
> > From: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>
> >
> > The typedefs u32 and u64 are not available in userspace. Thus user get
> > an error he try to use DMA_BUF_SET_NAME_A or DMA_BUF_SET_NAME_B:
> >
> >      $ gcc -Wall   -c -MMD -c -o ioctls_list.o ioctls_list.c
> >      In file included from /usr/include/x86_64-linux-gnu/asm/ioctl.h:1,
> >                       from /usr/include/linux/ioctl.h:5,
> >                       from /usr/include/asm-generic/ioctls.h:5,
> >                       from ioctls_list.c:11:
> >      ioctls_list.c:463:29: error: =E2=80=98u32=E2=80=99 undeclared here=
 (not in a function)
> >        463 |     { "DMA_BUF_SET_NAME_A", DMA_BUF_SET_NAME_A, -1, -1 }, =
// linux/dma-buf.h
> >            |                             ^~~~~~~~~~~~~~~~~~
> >      ioctls_list.c:464:29: error: =E2=80=98u64=E2=80=99 undeclared here=
 (not in a function)
> >        464 |     { "DMA_BUF_SET_NAME_B", DMA_BUF_SET_NAME_B, -1, -1 }, =
// linux/dma-buf.h
> >            |                             ^~~~~~~~~~~~~~~~~~
> >
> > The issue was initially reported here[1].
> >
> > [1]: https://urldefense.com/v3/__https://nam11.safelinks.protection.out=
look.com/?url=3Dhttps*3A*2F*2Fgithub.com*2Fjerome-pouiller*2Fioctl*2Fpull*2=
F14&amp;data=3D05*7C01*7Cchristian.koenig*40amd.com*7C4b665e3c2222463014ec0=
8da37d6b3f4*7C3dd8961fe4884e608e11a82d994e183d*7C0*7C0*7C637883692533547283=
*7CUnknown*7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haW=
wiLCJXVCI6Mn0*3D*7C3000*7C*7C*7C&amp;sdata=3Dprj*2BSOuf*2B1IWK1XKGD381LhDuL=
9qOoj7lYy8xMoV*2B6o*3D&amp;reserved=3D0__;JSUlJSUlJSUlJSUlJSUlJSUlJSUlJSUlJ=
SU!!N30Cs7Jr!Vp-6M6kuBq4uqEHaYTbkJbN3BTkd85DAeGS7xNYLPbNMp00kBlbD0iQPjJdQ5O=
VCFeCp_XVrsYIhxvLlpLQDmRhK5QXhQA$
> >
> > Signed-off-by: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>
>=20
> Good catch, Reviewed-by: Christian K=C3=B6nig <christian.koenig@amd.com>
>=20
> CC: stable?

Done

> Fixes: ?

Fixes: a5bff92eaac4 ("dma-buf: Fix SET_NAME ioctl uapi")

--=20
J=C3=A9r=C3=B4me Pouiller


