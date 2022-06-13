Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06106549FAD
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 22:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344741AbiFMUop (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 16:44:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351293AbiFMUnu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 16:43:50 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2042.outbound.protection.outlook.com [40.107.244.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 880CF2E68C;
        Mon, 13 Jun 2022 12:49:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AtDEW5MmWIGw+gloGY0Tw0Q2BoKDlY3CXuhG/DZe4hwj1lm8h6FK79OOyjQriAbdRxpr+yjwIGSFKKKjLLnxtwd+oU1lwIGWMQrWv87aB8idaMjloD0L5XbSjbWSwVbJzcNnlGAuxxhSc9/dWaHzUpMb3TOp6rqyQwofZmxI7uV8P8wQ0Rw73cME2J5/5gU/JoioMOgB5g/jc6qn4bEF1tbA9x3DyntHEbYQanGCT+1PcGYL3HePThG/WSlxj+VkralRR4jub/UHZ/k4ykde7krCFOwgMOl0dRp+VYe3gqNMiqMFEd6f7SNaQGbJIe6zB7IBm0P/fssnui8UG58lkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WeI4Qb9Dqr5C91GVUAWLGi4LXwA2W66gqW/d0UmgyaU=;
 b=kTfoVRdXURMse8Vre/BGj4YMdYY26kSTJYJRNzXgm6+mjtu3J/9ImocPb0smiwsovRm35erTwxuleLtFBOg7jc8WOZSvdkg87Jux2acM8j27ewiHqsO7j/Yqsz+ZgjTW0Q4X2KJ7gRhmIE26yUHdz81UShLQU81GjGHnfvciZ5PqchNBUYmMdehwNx3BDic5uPmIXaXnCDZzFjPNLsakUmp3Wr7FZfHm7IBNhYDWQvlrUn4v4fpn77fuLwL7JspUlJPXxEqpNmyHWcpFvh34b4i6fg90uFL0alncU1zKvAwTtX9AuybHNt7LDixDXgyyoDiHJRI8mMfqV+F763cl1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WeI4Qb9Dqr5C91GVUAWLGi4LXwA2W66gqW/d0UmgyaU=;
 b=Z88vBs/Sz/sMCjEt9k25S9JNV4PfaCq1FO+/QPzia/z51rCHAG1AQOomhXFRt/nO144CJsxbpbfvGOdDIdX+21QbilQDkRy5F2qXudKxtNlMDhJU9qA3wWbuOin7Q/g8435Yi2jiNmNMN4bFv8FUFfax2IxLWZ4wvr3MDwHgrJjz9qdT4mt0pXQyN2i88zLDPIsXI9lqlU8VyMvYM+E3oO2Ll7oU35A7G9hj1Eq0t3Shxr0qXf3JBpZZ5NYckyRtZI/OjPH/n+nF1u8AKlyhwADUf3pBAHGiNgWmSMoB8Ujhv1Xqo1PuWfaJGnS/FDU+ixyHbkDD7xzXf8EaT825RQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB5744.namprd12.prod.outlook.com (2603:10b6:8:73::18) by
 MN2PR12MB3821.namprd12.prod.outlook.com (2603:10b6:208:16f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.12; Mon, 13 Jun
 2022 19:49:41 +0000
Received: from DS7PR12MB5744.namprd12.prod.outlook.com
 ([fe80::2030:d898:6e2f:3471]) by DS7PR12MB5744.namprd12.prod.outlook.com
 ([fe80::2030:d898:6e2f:3471%7]) with mapi id 15.20.5332.017; Mon, 13 Jun 2022
 19:49:41 +0000
From:   Zi Yan <ziy@nvidia.com>
To:     Guo Ren <guoren@kernel.org>
Cc:     Xianting Tian <xianting.tian@linux.alibaba.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, huanyi.xj@alibaba-inc.com,
        zjb194813@alibaba-inc.com, tianhu.hh@alibaba-inc.com,
        Hanjun Guo <guohanjun@huawei.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Laura Abbott <labbott@redhat.com>
Subject: Re: [RESEND PATCH] mm: page_alloc: validate buddy before check the
 migratetype
Date:   Mon, 13 Jun 2022 15:49:38 -0400
X-Mailer: MailMate (1.14r5898)
Message-ID: <D667F530-E286-4E75-B7CE-63E120E440C8@nvidia.com>
In-Reply-To: <CAJF2gTQGXAubtas4wAzrg298dGQJntu38X48V2OzcK8xZ_vPJg@mail.gmail.com>
References: <20220613131046.3009889-1-xianting.tian@linux.alibaba.com>
 <0262A4FB-5A9B-47D3-8F1A-995509F56279@nvidia.com>
 <CAJF2gTQGXAubtas4wAzrg298dGQJntu38X48V2OzcK8xZ_vPJg@mail.gmail.com>
Content-Type: multipart/signed;
 boundary="=_MailMate_8CA5950B-8B8A-40E2-9ED1-3D2209BFC5BB_=";
 micalg=pgp-sha512; protocol="application/pgp-signature"
X-ClientProxiedBy: BL0PR02CA0038.namprd02.prod.outlook.com
 (2603:10b6:207:3d::15) To DS7PR12MB5744.namprd12.prod.outlook.com
 (2603:10b6:8:73::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c9c2ab0-b74f-4e91-96a5-08da4d75db0f
X-MS-TrafficTypeDiagnostic: MN2PR12MB3821:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB38210AD8913F7BDEAACE32DAC2AB9@MN2PR12MB3821.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yaDMs1ELs2gx81STHnvNV7XnrA6098Vs/ne5PRMC80H4Y28N+u2hR1sijS0rMzQ1sz0FzASweDgxKXhQz8IzdC4N2leJKLr762WqtBsU+28Twgi8ziH2kDPaxI+jylDCM7+N5uVdrrVPz2bBgQ+QcbJe4U9GDeRBEmqouZPUh4PYLScICVgtX9kGUjWGH5/mZ0IB9FyYaZgbWAOJ1HCmzq778FT1v4XvJfGagD2ReDM7tlHREUmC+iyEhA3wNk6ao6Iq5Kb63xkeiyy3yhZEYuAC77+jlvGbr1EhxFy/bUoj8r6ls01uEybnTeMKShUOnRefh/spATVasiLuRT7gCJWbW5lbCXlMXaX6Hr/+uewFqnu0xJnim6g/LWc1zZ+zoMTji/5vPCeGQl6fdSRho0mC1Af79neIJKpaJMJE+TJsHEKQ6VAKXiKOoCpmN19MyScxYouDJYuI+fugnMhCzHa1WZXAmTf9Dzj88NhT2ZcNkSI/iUo4+e+kdbRhmAu0X/lPDuPUpQptxyJ9iV7ub79bkSQSWXlckEIwdsnMPd8N206BQk4jDWhiSw+Yy/d8zxLryjBYyTgkMYgUpQt0ouqxOuGX9fk3HeX60vxzRwWxPDZk047ogMAwrFeGOJjTPENIBxqWDBS1ySb9emwtyxu3RgJN+ed5vllkh/2uvVrAXtFahhuNwF+O/dQN5a4ZNHQGj7mRf7evBybAJwD3pkl+dD+q4CAj15HJPl3FDZw/MV39YGIJD06OAxtNQPFFqFWHgkhQkAv9FklvyU2ErOIo44JZjfe0NsYn7O6tFZe3aBt0Jkx+xCYco5Id5ROR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB5744.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(8676002)(4326008)(66946007)(66476007)(66556008)(8936002)(2616005)(235185007)(86362001)(54906003)(508600001)(5660300002)(6486002)(966005)(53546011)(36756003)(33964004)(7416002)(6916009)(6506007)(2906002)(33656002)(26005)(186003)(21480400003)(83380400001)(6512007)(316002)(38100700002)(15650500001)(6666004)(72826004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cGZXbG9tMHNRcHFrMjVPM0loM1RLY1RsLzViTE9PU2hLTlpSSC9Vc2tMUktS?=
 =?utf-8?B?QmRiejh1YnJrc0luVG9LdC9TVzl2TkZGZ3RVQ29MNDg4RXFTa3BvL252empi?=
 =?utf-8?B?N0FSeFNxTHpJbUVwcHgzOHp2aHJUZlJMVnluNnJqSU9IYUVIOU9KSUtmUGQz?=
 =?utf-8?B?VHJQTk4yeUJjZkp5aEdhUnZURXZwSnE2WnBwMi84WnRsamdqaGtidGlaN1Ur?=
 =?utf-8?B?VU43UXpiNlZMYUMyRW9PaG03SUJFVlM5OWlVWkJncWNKTFQ4YmNod2hvYjZN?=
 =?utf-8?B?RzgrQTBKRnFBN3h1R2VidTZIUVNoY2c3WUQ3K1FEV1BMTCtLeTZmUjlUdEhF?=
 =?utf-8?B?ZFVSNFg0cnBJdS9xRjVpUyt5TEdmeDhJaUJHYkIzTHZoUGg4ZVpuV3NYM1NQ?=
 =?utf-8?B?S1YrVE5qUTRmTVJ4bHNGWkFJUmhsKzMyLzhtMlVna1E3S2E0V3orQXhnZldv?=
 =?utf-8?B?ZDJ3QU0rbXFlVGZ2U3F6akt4VjFwRTJJUmlPUEN4UTdBYTU5dDBKY2MwTUdi?=
 =?utf-8?B?RGVpZ0RjOWtHN1VpVmdlOUQwb2QyWnNETTZabVpUR04zVVZObEtDTlRGOHll?=
 =?utf-8?B?QStXcUpSWGR4Z0xQL1J2QTNIaXZLUlNrMFhObW92U2JMRGdYWXRDdEVxcjJW?=
 =?utf-8?B?YlZoSnRXTUlJVktNWTVkN2JUTGpBNXY0ZUR2a3NVUVRDTHc3elJLV05NR0JJ?=
 =?utf-8?B?ay9qRWxaVUNaSDFPT3NhM094dUwxTnNQdUQ1eHZaOW8xYlQ5TGhkcTVSdWM3?=
 =?utf-8?B?a3pobjdmRlhTNHloV1VmR3hSOHpOV09NcVhma0V0THZZNnFlbXNrUUFWakJq?=
 =?utf-8?B?d1NBQnJBUmNWMWZna3VDM1NUcHd3UTdKT1MzM25DMnRFNmJUYktNTzJXM0FV?=
 =?utf-8?B?ZnVyVys3QytpemptZTlyclJHbVdWS1BTa0ZYb3dSc2Rxb2pVaFZCNUYwTmdL?=
 =?utf-8?B?dThjTkE3ZUw2Slppc3hYTmNDTm5XSWtWT3BrSGlTMVZxU1FJTks0VzFHdU9I?=
 =?utf-8?B?ZXEyRjhzd0VQUDBDOUJLSXJibU5QNVRKTC9sM05SVGFDYXVKUmgzRU5mTTUw?=
 =?utf-8?B?YkNDam5qWkRFSUpEaExNYUQ3SE5rWHdib0ZGT1gwUzBqT1dWWkRTSnBWUlRT?=
 =?utf-8?B?Y3hwc0crWHNkSXU2cHhJblhyNEJ6QytWTm9qZENVanVKOXU3NGlRazF2MnVS?=
 =?utf-8?B?eHlxdmxtTktHRGsvNFFyaG9iaDhsZE9vVXNRQmRIRlR4NVVZSlU1bDIyY3g5?=
 =?utf-8?B?d1NRTDNOaUlKKzd6Q0t6OGk5NjJBSXl0OFNmVkFwMDZPY0dTaldWT0FnblFX?=
 =?utf-8?B?UTEyUmwzQmNubUpmQllERkR0bi9ZOXhSTXRlTmFOU1lmd09xWnZIcExYVlFM?=
 =?utf-8?B?ODQ1UGFDMmlVQlRFU0p5OTZFcUZVRDRJK2tYVGpoa2JQbERSUjdvVVhKRzlj?=
 =?utf-8?B?Uks2RTJiM3hQbXpTQUl5cjkwTHZYRGxqLzlFQjkxZEx1VjVEZ2hCMm4xZ0hh?=
 =?utf-8?B?WDFQa3UrTnpYZCtmR2JBKzlFbDF2aTg5QnY0UVZKUC9GNldRK0xoWTVVRmJj?=
 =?utf-8?B?bjl1RDBOV1V4eFdVZUpoWkNIaU9aQksyeTRHNTloM2Vwc2VYZE1BRnFHU3JD?=
 =?utf-8?B?T2lGMDRobEZYeUJPakdueFE5TmVFL1hDL3RGVWFFS2NXYisxcHQ2M0xFU0JN?=
 =?utf-8?B?alF6QkxSOENqeDBoNzFWTHhOdW1QRWNZdU9ET3lkQ2VBN3VpTy9MUUxKdTNT?=
 =?utf-8?B?eDZJRVY1dTRwVVAvNmhKR0NES2w2czBML3EyV2JPVmswdGFsOThyOUpNWDF3?=
 =?utf-8?B?WDRRTTdnOUdJUkVoR3llVDYvMVZZd0VZeHlsZkZaU3JBNVhmWFhucVUvcmVN?=
 =?utf-8?B?ZGR0ODNIWlE5SmNTMXlualppUTl2anZwUGJ0eWFydUtIWEtpbWliU0RDM1FQ?=
 =?utf-8?B?bDdvZkUyZXArOW1YYkkyV1J2alMwVGorVWhLRFpnMVJtS2VTSEIvL3VCbExl?=
 =?utf-8?B?OXdxVllGb201cmpRV2xDakNsNHkreHA2bTB0L1lhZnlkcVpmVWVjWnFxMFEz?=
 =?utf-8?B?ckJLZ25UNVdwZFdFZWNrTG8rVUdZLzNIZHhMQzQ3elFWMzdZZTU2My96VDBy?=
 =?utf-8?B?QU5kU3Z1WjQyaVJMQTEvczdVSU1aeEhQVWJrbTJMNlg0Y3ppNTE3VGFxRlFr?=
 =?utf-8?B?V0U5NUhJQ2VreFgxaGcxRE1hZFU4NGh5dmQreWdqQ0xsSFhYcnREVCtSR0s2?=
 =?utf-8?B?YzV1cGh3dllHSHBqZlBBV1FLV2dkOER0VmN5NUV3VWRmdFVJRjJObXV1UXFH?=
 =?utf-8?B?dnN3TzVJYjUvT0kyK05OcUwxaitYcnFHdGo2MDZFUWxVdnBuRGUwUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c9c2ab0-b74f-4e91-96a5-08da4d75db0f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB5744.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2022 19:49:40.9340
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hm61HQ/D5sZ3CFJedcmJjKKYOxCjNLkri1ndFhSbpy+zatQ6cCAwx6GZHIm05TYx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3821
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=_MailMate_8CA5950B-8B8A-40E2-9ED1-3D2209BFC5BB_=
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 13 Jun 2022, at 12:32, Guo Ren wrote:

> On Mon, Jun 13, 2022 at 11:23 PM Zi Yan <ziy@nvidia.com> wrote:
>>
>> Hi Xianting,
>>
>> Thanks for your patch.
>>
>> On 13 Jun 2022, at 9:10, Xianting Tian wrote:
>>
>>> Commit 787af64d05cd ("mm: page_alloc: validate buddy before check its=
 migratetype.")
>>> added buddy check code. But unfortunately, this fix isn't backported =
to
>>> linux-5.17.y and the former stable branches. The reason is it added w=
rong
>>> fixes message:
>>>      Fixes: 1dd214b8f21c ("mm: page_alloc: avoid merging non-fallback=
able
>>>                          pageblocks with others")
>>
>> No, the Fixes tag is right. The commit above does need to validate bud=
dy.
> I think Xianting is right. The =E2=80=9CFixes:" tag is not accurate and=
 the
> page_is_buddy() is necessary here.
>
> This patch could be applied to the early version of the stable tree
> (eg: Linux-5.10.y, not the master tree)

This is quite misleading. Commit 787af64d05cd applies does not mean it is=

intended to fix the preexisting bug. Also it does not apply cleanly
to commit d9dddbf55667, there is a clear indentation mismatch. At best,
you can say the way of 787af64d05cd fixing 1dd214b8f21c also fixes d9dddb=
f55667.
There is no way you can apply 787af64d05cd to earlier trees and call it a=
 day.

You can mention 787af64d05cd that it fixes a bug in 1dd214b8f21c and ther=
e is
a similar bug in d9dddbf55667 that can be fixed in a similar way too. Say=
ing
the fixes message is wrong just misleads people, making them think there =
is
no bug in 1dd214b8f21c. We need to be clear about this.

Also, you will need to fix the mm/page_isolation.c code too to make this =
patch
complete, unless you can show that PFN=3D0x1000 is never going to be enco=
untered
in the mm/page_isolation.c code I mentioned below.

>
>>
>>> Actually, this issue is involved by commit:
>>>      commit d9dddbf55667 ("mm/page_alloc: prevent merging between iso=
lated and other pageblocks")
>>>
>>> For RISC-V arch, the first 2M is reserved for sbi, so the start PFN i=
s 512,
>>> but it got buddy PFN 0 for PFN 0x2000:
>>>      0 =3D 0x2000 ^ (1 << 12)
>>> With the illegal buddy PFN 0, it got an illegal buddy page, which cau=
sed
>>> crash in __get_pfnblock_flags_mask().
>>
>> It seems that the RISC-V arch reveals a similar bug from d9dddbf55667.=

>> Basically, this bug will only happen when PFN=3D0x2000 is merging up a=
nd
>> there are some isolated pageblocks.
> Not PFN=3D0x2000, it's PFN=3D0x1000, I guess.
>
> RISC-V's first 2MB RAM could reserve for opensbi, so it would have
> riscv_pfn_base=3D512 and mem_map began with 512th PFN when
> CONFIG_FLATMEM=3Dy.
> (Also, csky has the same issue: a non-zero pfn_base in some scenarios.)=

>
> But __find_buddy_pfn algorithm thinks the start address is 0, it could
> get 0 pfn or less than the pfn_base value. We need another check to
> prevent that.
>
>>
>> BTW, what does first reserved 2MB imply? All 4KB pages from first 2MB =
are
>> set to PageReserved?
>>
>>>
>>> With the patch, it can avoid the calling of get_pageblock_migratetype=
() if
>>> it isn't buddy page.
>>
>> You might miss the __find_buddy_pfn() caller in unset_migratetype_isol=
ate()
>> from mm/page_isolation.c, if you are talking about linux-5.17.y and fo=
rmer
>> version. There, page_is_buddy() is also not called and is_migrate_isol=
ate_page()
>> is called, which calls get_pageblock_migratetype() too.
>>
>>>
>>> Fixes: d9dddbf55667 ("mm/page_alloc: prevent merging between isolated=
 and other pageblocks")
>>> Cc: stable@vger.kernel.org
>>> Reported-by: zjb194813@alibaba-inc.com
>>> Reported-by: tianhu.hh@alibaba-inc.com
>>> Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
>>> ---
>>>  mm/page_alloc.c | 3 +++
>>>  1 file changed, 3 insertions(+)
>>>
>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>> index b1caa1c6c887..5b423caa68fd 100644
>>> --- a/mm/page_alloc.c
>>> +++ b/mm/page_alloc.c
>>> @@ -1129,6 +1129,9 @@ static inline void __free_one_page(struct page =
*page,
>>>
>>>                       buddy_pfn =3D __find_buddy_pfn(pfn, order);
>>>                       buddy =3D page + (buddy_pfn - pfn);
>>> +
>>> +                     if (!page_is_buddy(page, buddy, order))
>>> +                             goto done_merging;
>>>                       buddy_mt =3D get_pageblock_migratetype(buddy);
>>>
>>>                       if (migratetype !=3D buddy_mt
>>> --
>>> 2.17.1
>>
>> --
>> Best Regards,
>> Yan, Zi
>
>
>
> -- =

> Best Regards
>  Guo Ren
>
> ML: https://lore.kernel.org/linux-csky/

--
Best Regards,
Yan, Zi

--=_MailMate_8CA5950B-8B8A-40E2-9ED1-3D2209BFC5BB_=
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJDBAEBCgAtFiEE6rR4j8RuQ2XmaZol4n+egRQHKFQFAmKnlNIPHHppeUBudmlk
aWEuY29tAAoJEOJ/noEUByhUQ2EP/1NmadZ9tPSW/UsTe/q1cwy5pWUX9vD0snmh
UmcYBnGn95EjTXF5vaHumACth9yHDhMGJzK0xX76+4+RFioRDCZqrOB4TqN9WmXX
z8iWhOHeTIoPtw66NnoPnMhgZ9pSgPeim1Us4cKquuBwgvs3xIsXkluiGLNNqOVj
F8Xn50zl6JB8uSFWH5b9Tb4PoRkU7yxXBmptId98X6oF2YcCVxkCUW2YxLk1UR0/
WbLetuDp6KRvsPlLK7kTK/p1cHFp3y0sbiYVtV05bMjRzrZdBXtFMwsS9msKrNG1
FzbTAGW3L/G97zYDgN52MTHKs8LYo7FxvC656VV/Y7zVu6sTs1KNRqqkX+1HwF2x
s7gmiDRFYfv60pTvfx8/HM9IdTDCREiGn8igVxxIe0nRwBg8to8vVS1Bm9gI65w7
b7OM4ekIQNYTUMjepOCTGxGU26+fENAebEzOpyNeBsKBwIZzzwKlxUFLPAIli9nq
s1iYb7b4TUAh2oJHDdS5Kjuh6cyQi1qZYw1NTafoF1eFEefwpS7k+EUoalOg0FlC
9OCTLLBjzvFt4wxRiRXQ/7IJGQNhc+0MTadnhMcux0tm8qUuWwNSS+oqY4fYGLgx
HOUxDtJVCl4HS+YMXSRNIy87HAI0UA+jnme/zxQ3JfxRP8ehXIfYGbNDSUtX2Ah5
0tC7FN+D
=cgWF
-----END PGP SIGNATURE-----

--=_MailMate_8CA5950B-8B8A-40E2-9ED1-3D2209BFC5BB_=--
