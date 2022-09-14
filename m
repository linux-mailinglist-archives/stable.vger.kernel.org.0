Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF495B9098
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 00:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbiINWrc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 18:47:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbiINWra (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 18:47:30 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2057.outbound.protection.outlook.com [40.107.220.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFBE052477;
        Wed, 14 Sep 2022 15:47:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CBtHyXwGY9buYfWRmp25XIjfNOeDQ0+KbOYAf4556RLqgZy6tPX8liwrPUaVVhDjbQywpYavyZOtvhDL488CA6hoTR3Fn57NDncQMmBCU9RGJLa6vG0tKoz30SKMudtS9A41FXlaxyn4G5DHNY83zjG6nqApjd05NX0tbPzgl5wrgfRdX7JvHT9xcF887+XqNmTE7xG+/p1tuO7VbwzChd8xeiRSu7lOuPJBatrm72SjSPjBblVafJqsP2LwQLIzRcOM6hnyUQKHKSddCRMRP6kbTvbl7scYkwAkfKZy8FwhXwpGc4FJjRAiCEoixeVH4/GLqQG4HuL6MwzHPXMCWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T1Z17oH30YZIqkLi55aRCdIMbRIUBM3HwoFr+KwEdk4=;
 b=m/Vb+Y0A2gd7hiyh3NMk+lqFv2Da2DlOA2zSFs6v82suTSGtyz6MGMAxB1TRDalGsKTnLRPMJBS9DB//BWiDAqhu2sQYk4TMz+6W4XkajOdOUMOQU1nGYZLGFx8EB6IqoMedBLkyVqEwTG/R339lGP1FUjL7KCV3f7Symcp5ZCdV/21gH6QqOefcVJ0XOIy6gKmuQTz/+s76ASSzmR040ol1RvjZOfYu89xFhFZqkIhf99D7Q6ehW3wDvX55tyf72j/QojGhukrCG/EY+zHXZI8FEjwf21YLshSKZcDsVpqFUU2QcLAOpmUtBHdwZJ6B26levvRwQBVxZU7hWDiWWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T1Z17oH30YZIqkLi55aRCdIMbRIUBM3HwoFr+KwEdk4=;
 b=cmNfeOoF/h4Uk8wQfy2Z+9aRzZdTLdPNj6tIod0/4Qx6iFIVoHaPePlR3PLHyF05h/zMLFvkYEemZTf/pwEWnNzkb332fPUa9NUP/K6U+VF1ShgTimC3bnPnRJqotoJnc00lcpUD1I9R2kriON7NnSV/eh6VUmYgO4ADZtZiuOsuS5xBrD7g44ow73UmCSKUA19H8coaoQpgEfYIV03sdKstZMJG491hxlAZOFUPwM9Icg1mJQodaN66Ab2SohnPN4XYW7khLeXaUvLNjDfhAHpIw3dQ+gqzYj317L84UERQoH6crHBDewTE644cHMxZsWqaetcpvX+El5xlFrYe8w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB5744.namprd12.prod.outlook.com (2603:10b6:8:73::18) by
 BL1PR12MB5239.namprd12.prod.outlook.com (2603:10b6:208:315::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.23; Wed, 14 Sep
 2022 22:47:28 +0000
Received: from DS7PR12MB5744.namprd12.prod.outlook.com
 ([fe80::94df:bc2b:6294:8cc6]) by DS7PR12MB5744.namprd12.prod.outlook.com
 ([fe80::94df:bc2b:6294:8cc6%6]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 22:47:28 +0000
From:   Zi Yan <ziy@nvidia.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Doug Berger <opendmb@gmail.com>, linux-mm@kvack.org,
        David Hildenbrand <david@redhat.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/page_isolation: fix isolate_single_pageblock()
 isolation behavior
Date:   Wed, 14 Sep 2022 18:47:26 -0400
X-Mailer: MailMate (1.14r5916)
Message-ID: <04AD3C98-5BD5-47CB-8B26-945D03BAD9E5@nvidia.com>
In-Reply-To: <20220914154225.e3f8ad4b076236c75705b0f9@linux-foundation.org>
References: <20220914023913.1855924-1-zi.yan@sent.com>
 <20220914154225.e3f8ad4b076236c75705b0f9@linux-foundation.org>
Content-Type: multipart/signed;
 boundary="=_MailMate_48CBD3F5-ECD9-44E2-A294-23F37B607F8B_=";
 micalg=pgp-sha512; protocol="application/pgp-signature"
X-ClientProxiedBy: MN2PR05CA0012.namprd05.prod.outlook.com
 (2603:10b6:208:c0::25) To DS7PR12MB5744.namprd12.prod.outlook.com
 (2603:10b6:8:73::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB5744:EE_|BL1PR12MB5239:EE_
X-MS-Office365-Filtering-Correlation-Id: 90281b8e-653a-450a-2a1a-08da96a319cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SQBnIftHpF3A3gEEBgqsQhCuwa/iX/zpoHdLq+SsfWgMG2xoXqVhDuUVVxofOHesHZnATdJvwCKUQF9RRvZ7g5+FKZvSPby4ZIAc0F1eIV99Rcf1ejUQW7rKjkXXGpTthVu7fpqhJ01KiFsMFoR7yIMgHIu4p2XFBbDH8T0HZCbgNzvhOEsWgqNVERIa5y/36mVU9YKLiqAACNcCgKNmP1PDw6m0K0sjHurkViW9FHGnl20A8L1PiFKD0YUlPKtpQs9Kc5iyTD5mTCvNBZWrHIvdjkjH/SGjR2NHV6JwCVoblbjh24El8Xd0jdH3QWqmmT8V41T/e1aenTvh8h6cvrjZiIgDtBuFFSp1uAk2cy51uVpBZiL6D10uY1DrjwbZdNNTbecM2lDjfrI+a0wUiv3MRogSUSCHj/bRT70HnS53PDm4SUPV2Qkfab38oUy1bykhcNn19jGrfUF03mvpdiOEga0bSkgBIxAD4i2A3Ftb1W+YRYj1PiXYXdgrH/bvUTpsFIPNaFd0ffQz8psWUO9ZyEqAYul7IFssLS7mhD6jj+XB8AeNhksRDPt64ZeDz83bbx3XhAm/GS/fjF98kubljkBRAX3EthxW5TUwTkTnxtKnOJoHfjmIzd2XoO9tiweZFWMgmWM2+55JBOvoOpeELHNdJZwjGCjvAgTtMzAATAdd9zHuvamlXJtD38ZUg4X8+K7dMBwYncoFjvRWNyzG+R31tFqOsVN3fOmJRuSs1JMUxN8YJIfrXSvdPYaipysvNLo1LY1rgfP5hgOpo+xHUsEGBdal/ovtbWtq6ycYiJ1C4M3Y6Gr4clrbGsCteNIkGzrGMoMH89eROIBV9bH5Y2JaYxmgou0geKQd0/M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB5744.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(346002)(376002)(396003)(366004)(451199015)(36756003)(33656002)(86362001)(38100700002)(53546011)(6506007)(235185007)(2906002)(478600001)(966005)(41300700001)(186003)(26005)(6512007)(2616005)(6486002)(83380400001)(66946007)(5660300002)(8676002)(4326008)(316002)(66476007)(8936002)(66556008)(54906003)(6916009)(72826004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5Q4NSTrXidHE1l9JE/xd6BhYqnaDtJaJtsO53cGXux6GJxkcnjyr9bAtyJaM?=
 =?us-ascii?Q?c1xZtiCVqsv5DMhPFLh48BbzT4JlG+W93GbvdjHLym7hdoaM2VtgbaYiYhN5?=
 =?us-ascii?Q?3eMcAbHsi7ieiMNhe9XZ7Us4sll+MN7LO9PPNn6cWQf+BumfxTVPACUfLQj2?=
 =?us-ascii?Q?fdU04CoZg3WHvt1IZ13tHAWgsQTpNDp2j43YvGfAhhsiyHN19g52qj7JoHZM?=
 =?us-ascii?Q?uJIrkdYjXFx2RL5YLZnOyEVwHe13OJ0K6W27EgZFzfRcp9GTAiuwU2gE9VVn?=
 =?us-ascii?Q?2HUHnjIRVxUf1IuOcdSbrMq5nN3uA/1q6s877R6RG0hCZjxmhHtoIOgbmDDs?=
 =?us-ascii?Q?MbzwvE8bVmtEnuh7pkGiDfreQheiFZ7qLSsARoLAawy6B2imBhQX7ev/gSFI?=
 =?us-ascii?Q?Av7GUTOHMCVQFRdpzx63RmUkL2HM6k3TPpU2ibcGJt1/Qcg4L83V17iuGU/j?=
 =?us-ascii?Q?9zecJwtqegdyJwp6Kqecr3GpC+ElelQwHFIky1mmagrBFtGwhcrI8Z3dJ3aN?=
 =?us-ascii?Q?cUMou3/w0/byBvlFXB1v4XtKSKbL3JZwHDU49lBMLmCJZj7wdY3sETPbSIn9?=
 =?us-ascii?Q?wwMtNfEKx4YiFE/HjZSsRXe3CHY9clAU5wiXaETuIMqoOW4PHmm6E2NVRLqy?=
 =?us-ascii?Q?/MO0rH4xsS+tGF/rf6Ki8kIY2qytq8NA+t0bTcijPAW86RL5kZ7TgTI1BHFO?=
 =?us-ascii?Q?yzyR0eCNIBLpEiilKLHYI2nxQRIRkTiwr19AjaKXg6MCzAuqC4X62edSHf1m?=
 =?us-ascii?Q?aXC7MS0HFKQ/nSufUqa5PqRki+kLqC4nurgw1/NywyC2xKOV8iOms6lQ0gI7?=
 =?us-ascii?Q?3IHq2hC7LUmLvYilr6097uj22Jocjxa2NL17O4jrOGsioCybzibUrv4ig6n2?=
 =?us-ascii?Q?Zdu+Of3T0BR981E4NnZ7GF+yEqsbrdpLyonOJhkl9xbb8leeM7Gcp9dS9YCT?=
 =?us-ascii?Q?GGS7TbqtqCzTeE8kNkcdxYpvymfpsQtZZGI807epCF+OVyYa7tIlgstx8uTv?=
 =?us-ascii?Q?4noD69/Hk5QCtzgFo8eBFF88/6rIO0TblL+/MJiekMaahBXiZsK+xP1G+FvV?=
 =?us-ascii?Q?/xNa6kXQmvXHn2rSeksr2GKWoSPNbxaJSE4IJtiJ7DokFeIHTBtfmL2YtdwV?=
 =?us-ascii?Q?u+LXftlxBC80dT1DltuzcltyowS50PqFLZacQBEaYGhpIudApisQLGNm06Mi?=
 =?us-ascii?Q?itkDAAsUvK1qr87D20MdUAMD3kZ7RyoSc62qTGejArttToaSI9WQRMJJmCKu?=
 =?us-ascii?Q?kixI9GyBbFJ6wgbGW7quNtKPf9sDS5mqpj/qg86LeW3Qi8Ca6Z8PzMkiTUZg?=
 =?us-ascii?Q?XjVGxkD3TDVUadbgR0Pt9xZBeBXQYy4BTbybiBi4EBWvEUj2Xyb3kLBhGrdK?=
 =?us-ascii?Q?Vz6KwXDr5cpPs+v0lw4I5yd3Cp5v0+LZgepTiVxNdRT4cHJUWNGcDA7xLSZe?=
 =?us-ascii?Q?16pzcPcyfOwM6CEJ0Iotj3A2SC50aGc96MzozzrkToYRKT3UQOudC7epruFe?=
 =?us-ascii?Q?XS8uGwHqWWRJDU6Pu+ES66waUwkGmjea4U/wCHROR9Y7E+DGARH0+7JYUBXW?=
 =?us-ascii?Q?MgVZAsL02NgVcuTTVX2AFSf4dtNvy5MC8VUyojPA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90281b8e-653a-450a-2a1a-08da96a319cf
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB5744.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 22:47:28.4439
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i6LPTU8jLQZaRSCkQylsF/zGY5q445Cy45VAs6Tl3SCEjSR4VDcvE8lkodmorToa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5239
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=_MailMate_48CBD3F5-ECD9-44E2-A294-23F37B607F8B_=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On 14 Sep 2022, at 18:42, Andrew Morton wrote:

> On Tue, 13 Sep 2022 22:39:13 -0400 Zi Yan <zi.yan@sent.com> wrote:
>
>> set_migratetype_isolate() does not allow isolating MIGRATE_CMA pageblo=
cks
>> unless it is used for CMA allocation. isolate_single_pageblock() did n=
ot
>> have the same behavior when it is used together with
>> set_migratetype_isolate() in start_isolate_page_range(). This allows
>> alloc_contig_range() with migratetype other than MIGRATE_CMA, like
>> MIGRATE_MOVABLE (used by alloc_contig_pages()), to isolate first and l=
ast
>> pageblock but fail the rest. The failure leads to changing migratetype=

>> of the first and last pageblock to MIGRATE_MOVABLE from MIGRATE_CMA,
>> corrupting the CMA region. This can happen during gigantic page
>> allocations.
>
> How does this bug manifest itself as far as the user is concerned?

Like Doug said here: https://lore.kernel.org/linux-mm/a3363a52-883b-dcd1-=
b77f-f2bb378d6f2d@gmail.com/T/#u,
for gigantic page allocations, the user would notice no difference, since=

the allocation on CMA region will fail as well as it did before. But
it might hurt the performance of device drivers that use CMA, since
CMA region size decreases.


>
>> Fix it by passing migratetype into isolate_single_pageblock(), so that=

>> set_migratetype_isolate() used by isolate_single_pageblock() will prev=
ent
>> the isolation happening.


--
Best Regards,
Yan, Zi

--=_MailMate_48CBD3F5-ECD9-44E2-A294-23F37B607F8B_=
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename=signature.asc
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQJDBAEBCgAtFiEE6rR4j8RuQ2XmaZol4n+egRQHKFQFAmMiWf4PHHppeUBudmlk
aWEuY29tAAoJEOJ/noEUByhUSIIP/A5ykvtrYGUtcSQqhmUw80SccKZTg200z4eB
cOLh4F1AeWky55IBlgaBATjKTxZoRXOI5h4lQtOiMgswuFaxB0kbEj1AbumwMn0t
zb2tVlvDFPiILbDt3tpF7pZ73iNI9SJ1TS9aJFOEmXgVQBk8PwrRYZ0VQ4d1Cz3C
vTYId8bs6ff4CVXoBhvKSHTfyX2s1ZGutTfj6xaKJwn4vuhrTFg2p1LNc55f/J/3
DoKkEhNAtsWTq1jsWTL7JoNsri0Nq/FfMBpiA3Zwsl2Vrme0f43H5QXwZttx26MG
Oq+s7NUOfZvM23MUDJC+qO736VDGn8XSMrDk6jb59lNQQqL0tDbEQsD9H5uP91FA
QKFGlBxNBdUhDtNK6GKnpFYYAr1ru/7GlOTfa2YjkGO1WLM6NK8cOum/xlkfu+pK
HnAEW6vkwp1umcRvlQ9hoeJmBrEH+uMAyRVR+7F/LCnxtJFPIpfQwQIZM20lzmAG
BVJ2Mw57CEc5Bac3CyYcWn8UEhpyxLn/Be9lAz1gAEGlUh7o/leUfCXA4aiWae88
RxlHofo1gxtAVu5lJOX3PSKY6I71Gajn1FU+CFkHAR7G1uKh2sMthGSbqhbP6EiD
Y/FTlnY1WYcJ+eHmkE/h7qT5xxjmTdGscPtSHTdqWDu/s6X7SdY9m4ZEx8vnvGRm
Gl7qtilu
=XoYE
-----END PGP SIGNATURE-----

--=_MailMate_48CBD3F5-ECD9-44E2-A294-23F37B607F8B_=--
