Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31A6454E2D2
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 16:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377424AbiFPOBR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 10:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377356AbiFPOBQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 10:01:16 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2059.outbound.protection.outlook.com [40.107.95.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F98B1117D;
        Thu, 16 Jun 2022 07:01:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bmRESAIfPJAfwtP5opbZy/fHFvz4jqbA7URJzrnItErrtzIkbxuQt7k50uAhgBM6F0ik3ENxsXLw/X8HDnUjaqdHFNxQ/ZDfIW1mzTFhFPMkokpiixU4ckG+AG8YzcDsBtuaUXmqQ9vP9E02Hj99DvPDKDdNa/nkiKO7jp3tTobigBios7JAe13G+JvmoRpkkSrzYE6tbx+E8Sih/mxfHxXKab+F+aMQ8O08wAAV8RgtHYHrxr0Nvrh1NUqptWbj6eSnOosf+3Htdl7dm2LUAwqVEN8F2XJgu9sM0SSKrKWJZ9q1okbschPb/mxhUzcfRnzKG9/PjkuenqfmdhspKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lxv/jCKJ1asN0rWGUUh1vXWEaN3OA40XEAT1j4gBg5A=;
 b=PmYsoyPJkyuCbxtKETd4Cg0U1ZUwdRJjceAMC2WTNSfSfEam6vcu3JsLffMuAE3PKaqmYNofob5CA/B5kJZGEtsP7tDbyOkee7YvvEuJjBpudodjNQ0mZEalIpIZSVfrWOm68UY5YospgeTd93Cw2wvoMMGaAgShMq0ZOYUMYB47zDxLwjKgzvsL5dfCSAiFAGBkoglJqGnJFqpSFQNO18hJxpFaxOdITGGpFeKc7H/ZOajH96n6GLC96FRhZNljr2iDuxJSBG553y6rAUU2okfb2xgrnz8jB+ZMv8ukzsWqv+evaBEQ5KAERzlWITv3Awwod/x6QVrc9D1DhQjS2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lxv/jCKJ1asN0rWGUUh1vXWEaN3OA40XEAT1j4gBg5A=;
 b=cujtyoF78e4ES1qKNXWptN3lB4FwtHe4MuMToOWHteurN3sp8sTRYgpI70WXumnRBJMwHhro8T6zyFVm3v/2kJjL4EF111e2BrMycM7QExMUhiJ1FhKsP0PwDSdudgYOIcWV7zZo9jA5YpSNETX9NcBHlGAMQA2WVFYWs2KAvsOUkpC6KrIh1qsDaA+P1HXD+MCsw8uRAzlAOkl7yR+gjPpaCO7M1qhAVsVbqq3fIiDgro83efLDJ2XqdZMPQDRF/8sZ7krRyBP65kFcFLdml9PPiTEuwKmVcJKPdTFV0xhM5DcQX6TERfAaNhce4wnpesXZ8zjK2OmKqL2HspYWMQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB5744.namprd12.prod.outlook.com (2603:10b6:8:73::18) by
 MN2PR12MB3199.namprd12.prod.outlook.com (2603:10b6:208:ae::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5332.16; Thu, 16 Jun 2022 14:01:13 +0000
Received: from DS7PR12MB5744.namprd12.prod.outlook.com
 ([fe80::2030:d898:6e2f:3471]) by DS7PR12MB5744.namprd12.prod.outlook.com
 ([fe80::2030:d898:6e2f:3471%9]) with mapi id 15.20.5332.022; Thu, 16 Jun 2022
 14:01:13 +0000
From:   Zi Yan <ziy@nvidia.com>
To:     Xianting Tian <xianting.tian@linux.alibaba.com>
Cc:     Guo Ren <guoren@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, huanyi.xj@alibaba-inc.com,
        zjb194813@alibaba-inc.com, tianhu.hh@alibaba-inc.com,
        Hanjun Guo <guohanjun@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Laura Abbott <labbott@redhat.com>
Subject: Re: [RESEND PATCH] mm: page_alloc: validate buddy before check the
 migratetype
Date:   Thu, 16 Jun 2022 10:01:10 -0400
X-Mailer: MailMate (1.14r5898)
Message-ID: <417EC421-DC05-4B35-954B-35DF873A2C40@nvidia.com>
In-Reply-To: <5526fab6-c7e1-bddc-912b-e4d9b2769d4e@linux.alibaba.com>
References: <20220613131046.3009889-1-xianting.tian@linux.alibaba.com>
 <0262A4FB-5A9B-47D3-8F1A-995509F56279@nvidia.com>
 <CAJF2gTQGXAubtas4wAzrg298dGQJntu38X48V2OzcK8xZ_vPJg@mail.gmail.com>
 <D667F530-E286-4E75-B7CE-63E120E440C8@nvidia.com>
 <CAJF2gTSsaaseds=T_y-Ddt5Np2rYhk3ENumzSZDZUSXFwT3u-g@mail.gmail.com>
 <435B45C3-E6A5-43B2-A5A2-318C748691FC@nvidia.com>
 <b65b9edd-ff3e-aa44-029a-49fa5ba66b47@linux.alibaba.com>
 <18330D9A-F433-4136-A226-F24173293BF3@nvidia.com>
 <5526fab6-c7e1-bddc-912b-e4d9b2769d4e@linux.alibaba.com>
Content-Type: multipart/signed;
 boundary="=_MailMate_9B1CEB9B-AE92-4814-B080-AAE217B6F75A_=";
 micalg=pgp-sha512; protocol="application/pgp-signature"
X-ClientProxiedBy: MN2PR18CA0015.namprd18.prod.outlook.com
 (2603:10b6:208:23c::20) To DS7PR12MB5744.namprd12.prod.outlook.com
 (2603:10b6:8:73::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 41ba1d17-acfb-4ad2-49cb-08da4fa0ac60
X-MS-TrafficTypeDiagnostic: MN2PR12MB3199:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB31990FC191DC4CB6202DCE2CC2AC9@MN2PR12MB3199.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ry7DtX2PpoLQ3HuoyigMX5sWoFph7x0qfnFiGvB6v1kXHHMsqUHtKkQA+SfCiw80cBm7rscrzgJTzYD+MKJ1gtpIRhpUQZssNtC+iHqjrnYHrqLCFidsJFxenpgNJ6MmgMpmQoeAbnjsWzax1duzv8ZWdHCEfHzh1ocSSsQ5ogL+hz4EvsqhxpkivqfKquS6qb0wVGSSd2G7OuKrXyEa2n03xWs3vZ/HOGnkVfASZvSsegLJZWkDd+E63QAr3ylXzmBeGDke9xxnXgUc9iU4B7YHSubnFc0XO19rnDI2yEPHShhhFpMex+M7Dylkh35sKyiq1soA/uuO0S2ZuBzbhb1YM6nr2bPzKJKX+/q339R1M6CqACterCK+mHNTb+I0r7zKdkyfysU++RRRSIBO6VLQq5oYy1ZoDZJy5lJ6+YQ/nICkFSkYbPu8H+D1Com7IARvFmUwJWMIKlkRRTkZiMaMaHrwrjb5SzbIuS7G8AISPuaCMZ4y8ici06Iddqd0j8w3lhmygRdhYXHNc1Qp7MJRFybpuV7L6z3vTKqV6lnjF55/lz6Dyh6mP8omes9twBKEUqtUhe1gFaxGgYiOvZ39DxYyjTvK8AxOer9dAYmX/ECdC+7oMaAVrSsiAcxpcKqUY/ygXFFQNHd/J1hmiq0qkso/btIGhozTFXRXBG4KoL7uiw630bh5OKWjQyJWtzWX8ZP6e+54GaYXEJzNJCH2N6JV907N34j9y/v3EGY4HVI9NlL5gBL5K+NJnTOaHk06KNLqFncUWp9rViCcNHqCJrr0iD64BPYYs6Z+qrnHK3TQ37aGLzC+4XdIJCau
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB5744.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(966005)(66946007)(8936002)(6486002)(86362001)(8676002)(4326008)(66476007)(66556008)(7416002)(508600001)(6916009)(316002)(83380400001)(38100700002)(54906003)(6506007)(26005)(53546011)(33964004)(186003)(6512007)(21480400003)(235185007)(36756003)(33656002)(5660300002)(15650500001)(2906002)(30864003)(2616005)(45980500001)(72826004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TC9IT0p5cndGMDR0MmFiT2p3L0lZa1c5WThrb2JTWUl2bkRwTlUxbzBBdnlE?=
 =?utf-8?B?MWZ4ckQvclBLN1FYN1R1aVgxRmZEcEJNblVrWXpJR2VKbDRuNEtnMDNCQUMr?=
 =?utf-8?B?bjZGVlJRMUZJaEZrQ28rN0VQR2NLU1EraTJaelBYbFIvOW9kekdEM1JhMHlm?=
 =?utf-8?B?QXNsbTR6R1RuSUNSYlVBS2lRNHppVjk2d2JSbXV4UWpQdStNYTVaTXZyYzJU?=
 =?utf-8?B?My9KVHk5OW5zRmMrQWVXNkJYaGNjZDlhMTBQWmVUMC94VUpPSitCTDlYK0Rq?=
 =?utf-8?B?SkZIUTBKYmNVRTJNNisvT2tLbWlnQTRtWUhnc1NadzBUTk93aXV4VEh3NTZH?=
 =?utf-8?B?SllqWTZ5ckxQQTYvczk5SURYRmFjRDZENVJvQ2Z3anAvNkZsSjJTVE8zQ01D?=
 =?utf-8?B?T1lVaEFxZGdXRG9GeVV3NXBUK2pIT2xGcE8wSGpqR0pYckdTZDFlQWphZkhO?=
 =?utf-8?B?Sm5XTE11ZHlNL0JTb3pmL0RXUnBMeEVub3Q2bElsdHdrTi9maXdDSFY4MGw0?=
 =?utf-8?B?Q1RaVXNPVm1sUkdlOUZDQllGRnovS3JtcGsrLzNXajBEczBoZWdzOUZvdzlP?=
 =?utf-8?B?cUtQTnhQOXRyaFNEMmp3cU1lcXh3SWN3K0w2eFBGdlArQ3JVVFI3aUxxTFk3?=
 =?utf-8?B?ektLb1VaM2I0U09KRFlGcDhRdEFmZ0Z4YWpjSldQcmp3TlZMSW9WODZsWjZi?=
 =?utf-8?B?OSt0NTNqN2hrNXZHYTJvRk1ydy9Jb3F2Q0l6WDVKRmJBSzJneWFxQ0xGSFE2?=
 =?utf-8?B?VUlJcC9nSmV0SnZvbU9Od0dwSjU2Vmt0VXVlLzV0eUFwMHFDZDE5cW9OeWY2?=
 =?utf-8?B?QzA2eEJKVU9LYi9SUTNZNEpMK2hKUWU2a3VOaG5xK0VybWJXUGFrN0RtMkZm?=
 =?utf-8?B?aS9JRVpkd3cvQjlpUndyZ0x5NThXaXVKTDdpR0FSN2FVb3NGZGM4bjR3ZnRl?=
 =?utf-8?B?MHhmWnorN0p0RGl2WGdsQ1BpWWg3ZlJ6bWFkaGIwTytnT05ZZDB6SmVJNUc1?=
 =?utf-8?B?d1FGdXZHc29SSC8wTGFJSjV0d2w1STRMdVFWTzJYcWt3VTZnSzd4RnJ1cmp6?=
 =?utf-8?B?VXAxVVlVV3JZZTZwTTN6cVA0cDNtM3JaZGdmVTROaHdSQW1IY3BtTVl4U3Bv?=
 =?utf-8?B?cFA4c20wOU1xRnhoRGdKZ0VVVnJQVWRldmFoZkE1K3IrTXJORHlDV1JFRXdB?=
 =?utf-8?B?VHZlTVVUQzYrTVI4WFgzU2h4YUxUbGd4L3lHdU5NMW10VE1CWDJCVGx3ZjVh?=
 =?utf-8?B?SjV5ZWVJNnhHWER0dG1LN3JvaWN5OHl4bU1wVUM3d1dhKzYzNGJaMWVXc1Nn?=
 =?utf-8?B?cFRPUEg4ZVVpSjRVemVRVkpIY3FkbFZHdXovNXFyMENoQ0ZMSFAra1RPSUh3?=
 =?utf-8?B?NkxEbnVPbmFodmt5OEdyL0ozVnZXUTdqVXJrS0JQbXRWOXdzeWlqN0tJWnY5?=
 =?utf-8?B?cXU5LytocjlDZHlpZXhHN1VOSWtJRmN4bXRDUFZCWXFRanVtU1dCUFo5b2Iw?=
 =?utf-8?B?eTlONFQ2SFpOOGtVVjNYcFQzMlptQ1JycmJtQ1V6ZHFpRGhBa2hlaldQVnls?=
 =?utf-8?B?dkRMNk1TZ0JiTGJ3Qkx0blI2WWhRQjJ1bnA2ZVp0cFJ5dWJ5RWdJSnBvMzBI?=
 =?utf-8?B?Z0FrLzhCckRYZngvcU94TFVib09DeTZHN202OVdMS3JTS1dBSzNOOVk2V0hZ?=
 =?utf-8?B?bDQ1eE1VS3NyVEZNbll5KzZpa2NWclZscFM0ZE82U0w5N2Z4YU5Eb2ZEKzhN?=
 =?utf-8?B?d2Z6ZXoyQ3orWjZ0Q0FWZ2pqdTBsT253QlMxckd6VnJIYnZ4eHhoWjZyVzVR?=
 =?utf-8?B?L2plRXdGbVN6Vk02V0lGVmhyaCt0ckc3dHVFSCtKWHVFYm42OVpTOFVDTjRM?=
 =?utf-8?B?VERwNkhQNlhlR0s3OTkvblBrQUh1OWl6SGFpOFV4T0pselg5b21yVXFRQUxX?=
 =?utf-8?B?WDFSMXhjSEtQb1FsSDZvUnZvUzlaT2U0S0tqN3FFSGtVRFkxdmZxN3NuS1Vm?=
 =?utf-8?B?SlJGRHpUMkF5MjJPNk1maWNiNm1DRzJGRzdPZW1OdWpGVlFaZU5pZnl6MUE2?=
 =?utf-8?B?aXNvaHcrK1pYcm5PR2wzVkVsL0UxQmRxdVIwd293Nk1YUWJTWWVJOVhFZDh0?=
 =?utf-8?B?WFErM2p6dS9jbFgxdE82MmNWRFhrZXY3VDNzVTVSKzNyU3pRRWNiUUdabHZa?=
 =?utf-8?B?RDRXRU5VMk0rUzc2S0VnMzVyNXZPRFdpNFJ0cDhiVzdaSy83T21hbzdJaGt0?=
 =?utf-8?B?NmNxdkhQaGdJakpQMEd0OVhCWDM2SUF5Z2ZrU3ViUlVlek5pYmFrWndMZGp5?=
 =?utf-8?B?M3hBOTN6dnpHSlp1T1pHKzVCeENtcVdIeHNVdGgxQ2hueGdJL0hRUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41ba1d17-acfb-4ad2-49cb-08da4fa0ac60
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB5744.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 14:01:13.3261
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jepgQy/oEpRsKCWQZIJUno+6dgvMq/9Q5fYIroFiKc2vk9381qB1qhEGHouqKA41
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3199
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=_MailMate_9B1CEB9B-AE92-4814-B080-AAE217B6F75A_=
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 15 Jun 2022, at 12:15, Xianting Tian wrote:

> =E5=9C=A8 2022/6/15 =E4=B8=8B=E5=8D=889:55, Zi Yan =E5=86=99=E9=81=93:
>> On 15 Jun 2022, at 2:47, Xianting Tian wrote:
>>
>>> =E5=9C=A8 2022/6/14 =E4=B8=8A=E5=8D=888:14, Zi Yan =E5=86=99=E9=81=93=
:
>>>> On 13 Jun 2022, at 19:47, Guo Ren wrote:
>>>>
>>>>> On Tue, Jun 14, 2022 at 3:49 AM Zi Yan <ziy@nvidia.com> wrote:
>>>>>> On 13 Jun 2022, at 12:32, Guo Ren wrote:
>>>>>>
>>>>>>> On Mon, Jun 13, 2022 at 11:23 PM Zi Yan <ziy@nvidia.com> wrote:
>>>>>>>> Hi Xianting,
>>>>>>>>
>>>>>>>> Thanks for your patch.
>>>>>>>>
>>>>>>>> On 13 Jun 2022, at 9:10, Xianting Tian wrote:
>>>>>>>>
>>>>>>>>> Commit 787af64d05cd ("mm: page_alloc: validate buddy before che=
ck its migratetype.")
>>>>>>>>> added buddy check code. But unfortunately, this fix isn't backp=
orted to
>>>>>>>>> linux-5.17.y and the former stable branches. The reason is it a=
dded wrong
>>>>>>>>> fixes message:
>>>>>>>>>        Fixes: 1dd214b8f21c ("mm: page_alloc: avoid merging non-=
fallbackable
>>>>>>>>>                            pageblocks with others")
>>>>>>>> No, the Fixes tag is right. The commit above does need to valida=
te buddy.
>>>>>>> I think Xianting is right. The =E2=80=9CFixes:" tag is not accura=
te and the
>>>>>>> page_is_buddy() is necessary here.
>>>>>>>
>>>>>>> This patch could be applied to the early version of the stable tr=
ee
>>>>>>> (eg: Linux-5.10.y, not the master tree)
>>>>>> This is quite misleading. Commit 787af64d05cd applies does not mea=
n it is
>>>>>> intended to fix the preexisting bug. Also it does not apply cleanl=
y
>>>>>> to commit d9dddbf55667, there is a clear indentation mismatch. At =
best,
>>>>>> you can say the way of 787af64d05cd fixing 1dd214b8f21c also fixes=
 d9dddbf55667.
>>>>>> There is no way you can apply 787af64d05cd to earlier trees and ca=
ll it a day.
>>>>>>
>>>>>> You can mention 787af64d05cd that it fixes a bug in 1dd214b8f21c a=
nd there is
>>>>>> a similar bug in d9dddbf55667 that can be fixed in a similar way t=
oo. Saying
>>>>>> the fixes message is wrong just misleads people, making them think=
 there is
>>>>>> no bug in 1dd214b8f21c. We need to be clear about this.
>>>>> First, d9dddbf55667 is earlier than 1dd214b8f21c in Linus tree. The=

>>>>> origin fixes could cover the Linux-5.0.y tree if they give the
>>>>> accurate commit number and that is the cause we want to point out.
>>>> Yes, I got that d9dddbf55667 is earlier and commit 787af64d05cd fixe=
s
>>>> the issue introduced by d9dddbf55667. But my point is that 787af64d0=
5cd
>>>> is not intended to fix d9dddbf55667 and saying it has a wrong fixes
>>>> message is misleading. This is the point I want to make.
>>>>
>>>>> Second, if the patch is for d9dddbf55667 then it could cover any tr=
ee
>>>>> in the stable repo. Actually, we only know Linux-5.10.y has the
>>>>> problem.
>>>> But it is not and does not apply to d9dddbf55667 cleanly.
>>>>
>>>>> Maybe, Gregkh could help to direct us on how to deal with the issue=
:
>>>>> (Fixup a bug which only belongs to the former stable branch.)
>>>>>
>>>> I think you just need to send this patch without saying =E2=80=9Ccom=
mit
>>>> 787af64d05cd fixes message is wrong=E2=80=9D would be a good start. =
You also
>>>> need extra fix to mm/page_isolation.c for kernels between 5.15 and 5=
=2E17
>>>> (inclusive). So there will need to be two patches:
>>>>
>>>> 1) your patch to stable tree prior to 5.15 and
>>>>
>>>> 2) your patch with an additional mm/page_isolation.c fix to stable t=
ree
>>>> between 5.15 and 5.17.
>>>>
>>>>>> Also, you will need to fix the mm/page_isolation.c code too to mak=
e this patch
>>>>>> complete, unless you can show that PFN=3D0x1000 is never going to =
be encountered
>>>>>> in the mm/page_isolation.c code I mentioned below.
>>>>> No, we needn't fix mm/page_isolation.c in linux-5.10.y, because it =
had
>>>>> pfn_valid_within(buddy_pfn) check after __find_buddy_pfn() to preve=
nt
>>>>> buddy_pfn=3D0.
>>>>> The root cause comes from __find_buddy_pfn():
>>>>> return page_pfn ^ (1 << order);
>>>> Right. But pfn_valid_within() was removed since 5.15. So your fix is=

>>>> required for kernels between 5.15 and 5.17 (inclusive).
>>>>
>>>>> When page_pfn is the same as the order size, it will return the
>>>>> previous buddy not the next. That is the only exception for this
>>>>> algorithm, right?
>>>>>
>>>>>
>>>>>
>>>>>
>>>>> In fact, the bug is a very long time to reproduce and is not easy t=
o
>>>>> debug, so we want to contribute it to the community to prevent othe=
r
>>>>> guys from wasting time. Although there is no new patch at all.
>>>> Thanks for your reporting and sending out the patch. I really
>>>> appreciate it. We definitely need your inputs. Throughout the email
>>>> thread, I am trying to help you clarify the bug and how to fix it
>>>> properly:
>>>>
>>>> 1. The commit 787af64d05cd does not apply cleanly to commits
>>>> d9dddbf55667, meaning you cannot just cherry-pick that commit to
>>>> fix the issue. That is why we need your patch to fix the issue.
>>>> And saying it has a wrong fixes message in this patch=E2=80=99s git =
log is
>>>> misleading.
>>>>
>>>> 2. For kernels between 5.15 and 5.17 (inclusive), an additional fix
>>>> to mm/page_isolation.c is also needed, since pfn_valid_within() was
>>>> removed since 5.15 and the issue can appear during page isolation.
>>>>
>>>> 3. For kernels before 5.15, this patch will apply.
>>> Zi Yan, Guo Ren,
>>>
>>> I think we still need some imporvemnt for MASTER branch, as we discus=
sed above, we will get an illegal buddy page if buddy_pfn is 0,
>>>
>>> within page_is_buddy(), it still use the illegal buddy page to do the=
 check. I think in most of cases, page_is_buddy() can return false,=C2=A0=
 but it still may return true with very low probablity.
>> Can you elaborate more on this? What kind of page can lead to page_is_=
buddy()
>> returning true? You said it is buddy_pfn is 0, but if the page is rese=
rved,
>> if (!page_is_guard(buddy) && !PageBuddy(buddy)) should return false.
>> Maybe show us the dump_page() that offending page.
>>
>> Thanks.
>
> Let=E2=80=98s take the issue we met on RISC-V arch for example,
>
> pfn_base is 512 as we reserved 2M RAM for opensbi, mem_map's value is 0=
xffffffe07e205000, which is the page address of PFN 512.
>
> __find_buddy_pfn() returned 0 for PFN 0x2000 with order 0xd.
> We know PFN 0 is not a valid pfn for buddy system, because 512 is the f=
irst PFN for buddy system.
>
> Then it use below code to get buddy page with buddy_pfn 0:
> buddy =3D page + (buddy_pfn - pfn);
> So buddy page address is:
> 0xffffffe07e1fe000 =3D (struct page*)0xffffffe07e26e000 + (0 - 0x2000)
>
> we can know this buddy page's address is less than mem_map(0xffffffe07e=
1fe000 < 0xffffffe07e205000),
> actually 0xffffffe07e1fe000 is not a valid page's address. If we use 0x=
ffffffe07e1fe000
> as the page's address to extract the value of a member in 'struct page'=
, we may get an uncertain value.
> That's why I say page_is_buddy() may return true with very low probabli=
ty.
>
> So I think we need to add the code the verify buddy_pfn in the first pl=
ace:
> 	pfn_valid(buddy_pfn)
>

+DavidH on how memory section works.

This 2MB RAM reservation does not sound right to me. How does it work in =
sparsemem?
RISC-V has SECTION_SIZE_BITS=3D27, i.e., 128MB a section. All pages withi=
n
a section should have their corresponding struct page (mem_map). So in th=
is case,
the first 2MB pages should have mem_map and can be marked as PageReserved=
=2E As a
result, page_is_buddy() will return false.

For flatmem, IIRC, the valid addresses should be aligned to MAX_ORDER_NR_=
PAGES.
This means first 4MB (assuming MAX_ORDER is 11 on RISC-V) should not be o=
n
buddy allocator and hence this issue does not happen in the first place.
But correct me if I am wrong.



>>> I think we need to add some code to verify buddy_pfn in the first pla=
ce.
>>>
>>> Could you give some suggestions for this idea?
>>>
>>>>>>>>> Actually, this issue is involved by commit:
>>>>>>>>>        commit d9dddbf55667 ("mm/page_alloc: prevent merging bet=
ween isolated and other pageblocks")
>>>>>>>>>
>>>>>>>>> For RISC-V arch, the first 2M is reserved for sbi, so the start=
 PFN is 512,
>>>>>>>>> but it got buddy PFN 0 for PFN 0x2000:
>>>>>>>>>        0 =3D 0x2000 ^ (1 << 12)
>>>>>>>>> With the illegal buddy PFN 0, it got an illegal buddy page, whi=
ch caused
>>>>>>>>> crash in __get_pfnblock_flags_mask().
>>>>>>>> It seems that the RISC-V arch reveals a similar bug from d9dddbf=
55667.
>>>>>>>> Basically, this bug will only happen when PFN=3D0x2000 is mergin=
g up and
>>>>>>>> there are some isolated pageblocks.
>>>>>>> Not PFN=3D0x2000, it's PFN=3D0x1000, I guess.
>>>>>>>
>>>>>>> RISC-V's first 2MB RAM could reserve for opensbi, so it would hav=
e
>>>>>>> riscv_pfn_base=3D512 and mem_map began with 512th PFN when
>>>>>>> CONFIG_FLATMEM=3Dy.
>>>>>>> (Also, csky has the same issue: a non-zero pfn_base in some scena=
rios.)
>>>>>>>
>>>>>>> But __find_buddy_pfn algorithm thinks the start address is 0, it =
could
>>>>>>> get 0 pfn or less than the pfn_base value. We need another check =
to
>>>>>>> prevent that.
>>>>>>>
>>>>>>>> BTW, what does first reserved 2MB imply? All 4KB pages from firs=
t 2MB are
>>>>>>>> set to PageReserved?
>>>>>>>>
>>>>>>>>> With the patch, it can avoid the calling of get_pageblock_migra=
tetype() if
>>>>>>>>> it isn't buddy page.
>>>>>>>> You might miss the __find_buddy_pfn() caller in unset_migratetyp=
e_isolate()
>>>>>>>> from mm/page_isolation.c, if you are talking about linux-5.17.y =
and former
>>>>>>>> version. There, page_is_buddy() is also not called and is_migrat=
e_isolate_page()
>>>>>>>> is called, which calls get_pageblock_migratetype() too.
>>>>>>>>
>>>>>>>>> Fixes: d9dddbf55667 ("mm/page_alloc: prevent merging between is=
olated and other pageblocks")
>>>>>>>>> Cc: stable@vger.kernel.org
>>>>>>>>> Reported-by: zjb194813@alibaba-inc.com
>>>>>>>>> Reported-by: tianhu.hh@alibaba-inc.com
>>>>>>>>> Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
>>>>>>>>> ---
>>>>>>>>>    mm/page_alloc.c | 3 +++
>>>>>>>>>    1 file changed, 3 insertions(+)
>>>>>>>>>
>>>>>>>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>>>>>>>> index b1caa1c6c887..5b423caa68fd 100644
>>>>>>>>> --- a/mm/page_alloc.c
>>>>>>>>> +++ b/mm/page_alloc.c
>>>>>>>>> @@ -1129,6 +1129,9 @@ static inline void __free_one_page(struct=
 page *page,
>>>>>>>>>
>>>>>>>>>                         buddy_pfn =3D __find_buddy_pfn(pfn, ord=
er);
>>>>>>>>>                         buddy =3D page + (buddy_pfn - pfn);
>>>>>>>>> +
>>>>>>>>> +                     if (!page_is_buddy(page, buddy, order))
>>>>>>>>> +                             goto done_merging;
>>>>>>>>>                         buddy_mt =3D get_pageblock_migratetype(=
buddy);
>>>>>>>>>
>>>>>>>>>                         if (migratetype !=3D buddy_mt
>>>>>>>>> --
>>>>>>>>> 2.17.1
>>>>>>>> --
>>>>>>>> Best Regards,
>>>>>>>> Yan, Zi
>>>>>>>
>>>>>>> --
>>>>>>> Best Regards
>>>>>>>    Guo Ren
>>>>>>>
>>>>>>> ML: https://lore.kernel.org/linux-csky/
>>>>>> --
>>>>>> Best Regards,
>>>>>> Yan, Zi
>>>>>
>>>>> -- =

>>>>> Best Regards
>>>>>    Guo Ren
>>>>>
>>>>> ML: https://lore.kernel.org/linux-csky/
>>>> --
>>>> Best Regards,
>>>> Yan, Zi
>> --
>> Best Regards,
>> Yan, Zi


--
Best Regards,
Yan, Zi

--=_MailMate_9B1CEB9B-AE92-4814-B080-AAE217B6F75A_=
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJDBAEBCgAtFiEE6rR4j8RuQ2XmaZol4n+egRQHKFQFAmKrN6YPHHppeUBudmlk
aWEuY29tAAoJEOJ/noEUByhUgvgQAIcS7rCeLic2iXtr5veHSsYma80JbSimYVk1
0KhyAr4BTaSk0Px5mHjQIK/nIYoy3NKOAbIv7gXnfnFBax2mJUumAPqqc+ZeCvlY
epSGzY5Khl+4cBFsjMZrJ2WDLY97+CTntn6G2U/rJa2cZaZ2s0Ecut9CGPlmZOsc
qAYTyLi8tbR+aylaSFgBq8WzZogcqiiKyO+wUVbm+3UL7IYINtNcdgY1a+jNQX0+
80itMNTmCiCcPmC7BeYFrEpYlpU1i+kdavr54vdrLxm2jPR9xSnhvoCYniRzkXxz
UPYnl9BtVZLbDNFiw/Dy7CrpFS/7dEm9BCMP6Xl+2GNP2QwIEkMXaIVVd3KtQzEs
L6zOg/7VU/2AkhdClPu1sSE6mWzBYThD7P/GBvB7R7Xd8yE7xchNIUGOAf3YnH8F
civHSjbuwkxW6AYUAOorE1+xdhsRQv5uazq6Lrg4b4rfPthReaontLR95+3kYC7p
Cgm6YwiXC6jH0mBel/wJ/cFDeKr3/lJEVtu8x8EXXhbTQ1pnL19t8V6QCgm/aMoN
hRs5JdNf/Q696H2F9TVsV+GBf/BrgBoqnnuAxYfVye30OvKxHuoUpJc1Lu3hVPkv
toTxGyDqbynsN3PQpPkqN1cxzFBYMAIL5d1SvrgFnYAD2KBWg/nBHecvzbOHhySh
YTFLnx0R
=O/vv
-----END PGP SIGNATURE-----

--=_MailMate_9B1CEB9B-AE92-4814-B080-AAE217B6F75A_=--
