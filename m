Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11A7A68FB63
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 00:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbjBHXo5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Feb 2023 18:44:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbjBHXoz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Feb 2023 18:44:55 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2123.outbound.protection.outlook.com [40.107.100.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 459C21E5CA;
        Wed,  8 Feb 2023 15:44:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mnAPKu9Z0BMgXUl3rXAVvJIjmoUtvvHkRB0MdvCncdTPHKsF19NHuy0mQUWYdoyeerwWEbmmHLkS4UPESr4HNriOMmk5jkOW+y4m7pN2qY6MZr3zC7ydHDQTb6LJRwOityEL5o6eELX+dAINrNYfQ0g1U9A+dHXXOc7jcY9iAOcHs/nLq/cXX2HmkNvCvnC3BrLVPoGV/SWoVBLGMmho+QlBB+S7CRWUcZi0VoSICsGPR3spxNUlh2LcMe5Rqdb4+TE11Z0rT/qRJdH9dItBgy6ICWPoIITnY0RLAurpVHWdM8uTiCxXbNguwIahv9MU+Foj2FQDMpk6y0vvX7GatA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XyoeKnczE1KJ0nkRCWHx6n6mCDsYJ4qEP90Q9VM5UZs=;
 b=G4mPWiD7Zusm3ik0EWiewdtb69uLkOoQO+NPZxHySXW1dai2mUYy2pyfGTVdwTWx5Xjtju0me5H7DeONMk+yR1zljjHTbW/GhNbcUhYgSRf23Belzr5AQjEysGNCkxkc2QREqZskoDrs3dpQtc6nO70F0lqFHKBrG+2ektToGtRzmLc1ueFmj5zxPS6HiG1DC42PIBpk0BdtUP1/eeREfcOfveM1CXyFRbzvIiDg3tjtUyGrlUtDTeCkXGA9gBjMHCHTWaUixVsoVl1VD9FB61dFsyEN26v66yZ1MQlk9ECu511ukWtVigy8Qb0eqlEwpAZad7SHdwWRJiy1147czQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XyoeKnczE1KJ0nkRCWHx6n6mCDsYJ4qEP90Q9VM5UZs=;
 b=EJAGPXx5ln7/ZCK/0apmRVRk6r/pRqqu8gQf5JChasmd/cLdGh5432JvrnciAwbq1Xcys68Up//7RvebmTFWqfpR5joPG7lXhHA43tKWCC/WwWibKo997nUKoh8NFysdQIsRdkjptWNsXcH0UPm+OqqekPyqLuxDpuCN2Zq8cW4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ0PR01MB7432.prod.exchangelabs.com (2603:10b6:a03:3d3::16) by
 BN6PR01MB3249.prod.exchangelabs.com (2603:10b6:404:d9::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.32; Wed, 8 Feb 2023 23:43:50 +0000
Received: from SJ0PR01MB7432.prod.exchangelabs.com
 ([fe80::5208:e5ea:6ab3:19b5]) by SJ0PR01MB7432.prod.exchangelabs.com
 ([fe80::5208:e5ea:6ab3:19b5%9]) with mapi id 15.20.6086.017; Wed, 8 Feb 2023
 23:43:50 +0000
Date:   Wed, 8 Feb 2023 15:43:48 -0800
From:   Darren Hart <darren@os.amperecomputing.com>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        linux-efi@vger.kernel.org,
        Alexandru Elisei <alexandru.elisei@gmail.com>
Subject: Re: [PATCH] arm64: efi: Force the use of SetVirtualAddressMap() on
 Altra Max machines
Message-ID: <Y+QztBs1uHnTRyyu@fedora>
References: <a968c446bde75bf019580366854349bf94e6c961.1675897882.git.darren@os.amperecomputing.com>
 <CAMj1kXF2Bi_iyjzUK2zie_pt6Vnm4QwvarHicJoRzUiX7nU0Kw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXF2Bi_iyjzUK2zie_pt6Vnm4QwvarHicJoRzUiX7nU0Kw@mail.gmail.com>
X-ClientProxiedBy: SJ0PR05CA0069.namprd05.prod.outlook.com
 (2603:10b6:a03:332::14) To SJ0PR01MB7432.prod.exchangelabs.com
 (2603:10b6:a03:3d3::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR01MB7432:EE_|BN6PR01MB3249:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c85db96-2e58-4fbc-b8f2-08db0a2e5435
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4VRrKTqISrvgrYiisG0BvgqZE+oF4gn9+RVGNHN19Kff5xmhmFiz5GOtI8m2uhltVnY77ts4MrfV9wRA/k1sWqJwTcdKHJxARCUF1baGjLIT1qE23oZcoSNsWp+Y3tgv8wkMuX7yluBv/VEc+DHI5IIPF9IAVr9zHMOMogTnQzyfwK40yp41IbIScOz+/f1Cq6LBYfxSA1w9zZ/Z3cia4oXEzfrURIW82x7q+sjDFGl0yo2HquMxeVOam+iap1MJu0mJOaPCOAF7v2WYRvzQSHLlHhoTAa5grY1PSZ/Pudt7JNpeYfBMG4L+bqEfdUMRKQPTU7lkDJjeyps2SAcdTmQHxYPXz+a4DlhLbQXEUdikY5xlnx0aM7uhi/sU3hccwLUpcIUBfKFu8lHSQVaJoZ2G4EBGLzgjOACTJJgXJO0QGbFYv23lol6aw3uODyhQfZ5AgUqzrXZj3Guhjd5L+bCkbQcnlEFnGLsT7UuI8+xdQc/DGZc8wNi4LjMyyWmTF7RHk99azHTC8flAvVw2wO00QAAA6klNYzQupyhLv8yOQ20JP7RtjfUiSPgQ4L7iwWC6ZNRS9MoKxFyYLA5k7eu5eBDdPyWypg+hEEye1iUh6s5AuicWPxs1DVAdct9J4IykGEAG2aF/K8EKUQLAlUMQtBrtJ4YUBXlQfL7DscMV4ofdM81pLaasadeSPaUmskLlxm/KVBXfkeNBhyoDJD2m7OgNdAew4tJvA9tuFov+TVc9NujYuGx3CFAEJI+B
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR01MB7432.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(136003)(39850400004)(366004)(346002)(376002)(396003)(451199018)(478600001)(6486002)(966005)(41300700001)(33716001)(83380400001)(86362001)(8936002)(2906002)(38350700002)(38100700002)(66946007)(6916009)(66476007)(8676002)(66556008)(4326008)(6506007)(186003)(6512007)(26005)(9686003)(5660300002)(54906003)(316002)(52116002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ACg+8SjvNoTUC98LnVN8p1kKpseVNgCs6w13I9QrHCLm/08zQJWoTdXEo6R+?=
 =?us-ascii?Q?MM4XAQgqyQV01Qq/EWGFtQJpcUuL3srmyWCiX2huc0FiJIuphi2Vc2Dh875c?=
 =?us-ascii?Q?04vElJ4buAOd5ldGjVPUuftIIKkdwhZ8kdmkkVaTq4Q8LfCVmWHe5/ive7KO?=
 =?us-ascii?Q?zhS+xawN7P6PmpZfEW0rApM88B01pOAaPvRylLbBZuQy1ST/R1klIMIFNMm+?=
 =?us-ascii?Q?hAFjE84ObaE6J2IoyyrqILNtLIF/j/3PXc4cYeisB3kWhA8vny/O37vxmc40?=
 =?us-ascii?Q?HPBXTCtoPBtbaSxoVMesZWeVoQIk2KM2lszbcGwc0EKak7+Sgug8kpExWGdx?=
 =?us-ascii?Q?EtNR5PQdGSZDpsWlk0PxT9vXdEpgxRlULB54LlYNeGKxEikHp4tnVrUvsjbU?=
 =?us-ascii?Q?tqrw47eRcmvCx40oe/Upjp6NLc4FlWziR9Txxx2GrlTmJ3QsIHbwtii+XDfu?=
 =?us-ascii?Q?vzykwv4aQHJt5XzYmR5If2B+btkOm3j3oCF+BRPNfRWrtPblx0G44kBnIBxm?=
 =?us-ascii?Q?ZSdLhy9HWO+C5wlezjaa/hP6ZvebLgVntAQE3ZpoLNqxkQNeCPRgRED3OyXq?=
 =?us-ascii?Q?ONDXe5hGR32D3FC6uprbyHpr4JdKeeSyxbWYNK9fJwxgY0MGDcDTd5LfpHCX?=
 =?us-ascii?Q?JUdQq0k+ij99J+PUSOHjTUWBWyfKSDb2condJ3ottDAhPFJ09BgRIBJb/oBL?=
 =?us-ascii?Q?+GgzO8HpkqTLF8h6TOmBaUKPwLW3zMu1b+Tz2bIl5NtV/Hp3BewuUuyK/oV0?=
 =?us-ascii?Q?A0Ahl3GvRGgZvnf8TXn4MSAp8D4gXURC+2552VSwjHAdBp1l5UHGCGs91Fwx?=
 =?us-ascii?Q?ZZuFy7bgDVHYsnXOOF/NlidmUBBJBUF1kfUIQaoFC5EyDmowUK62CsJ6zlsS?=
 =?us-ascii?Q?J0KKrIEOSgHglS9kMZ+4rHzMJpf5kkgZpEaCKoFqe/7MV21qphkhgma8hQtd?=
 =?us-ascii?Q?qwU4NWcF+MHpQGEuXWNC2jPEjiR5UNks0AH9keVXo2y/V5Q5wM1/TVHZD1Nx?=
 =?us-ascii?Q?4rqUuk77RNpsk1DEsiPSM5q0LUbnikjEcLpv7EUvLyx/a9r2UAx//DxhADDm?=
 =?us-ascii?Q?erTRhuPRRl5MrFcKz7ay1LHWWnFnJ8Woeun4udEQGa1COs486GfmanJxlqGP?=
 =?us-ascii?Q?KA6nJJqCGXpfbuzTPY3wTShjMPjTLpfoYYbwc6xFszwXnjD3JoW61ls16bVM?=
 =?us-ascii?Q?hgUyhdL/4o6oYuZte7JUcM4euQ5vpXF7a1CELKWbLwvsgEI68kApUqCRBM0k?=
 =?us-ascii?Q?/2dta2UYWc7d1618peLGPP6+URI19NuQxG/Ln/11Dpj6BiRrs6kJUlmEowF8?=
 =?us-ascii?Q?IsfuGddIqdWoZ9a/V80RCJMgkySgsE/k6W+2of1P5hUFIe+HYoqg/SsZ/tA7?=
 =?us-ascii?Q?vgv6m1mOQyC1nbrTTg/e9tRyx8yPI/PTO1A754DidMMB6kuvUnV0T8tvwfjL?=
 =?us-ascii?Q?tJZ05h9mD85KVbDikrp+irf9uLq68o2pV3RjPfBAMkxuQbgF+1oumy3Dqdtl?=
 =?us-ascii?Q?d2eHtllmZg+R6w1h9WvFUP5EV2cYZVotp7OR3b2pzTk6NNZu1YRbRBV2FAQR?=
 =?us-ascii?Q?VZOvZLau1SPRbXf0U4uRKStWEvHEBzsnnzfGhx7yLO8BRASgUPTALYISt7V3?=
 =?us-ascii?Q?P+Q0zK0O6qc9sWwmHsK0pT0=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c85db96-2e58-4fbc-b8f2-08db0a2e5435
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR01MB7432.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 23:43:50.2219
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /Qz0ODgKRTWviQBkKmwMTPl/cxsQTnszX0BSoZHyCzZAe6yzWG71n5x2yX/neJ9p4nCSB21lEJ6ONHJCiBzlp/iYNZhusEtpkFDfJBqA6JIJOEOSNPWulACfCFpZCXjC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR01MB3249
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 09, 2023 at 12:16:46AM +0100, Ard Biesheuvel wrote:
> Hello Darren,
> 
> On Thu, 9 Feb 2023 at 00:14, Darren Hart <darren@os.amperecomputing.com> wrote:
> >
> > Commit 550b33cfd445 ("arm64: efi: Force the use of SetVirtualAddressMap()
> > on Altra machines") identifies the Altra family via the family field in
> > the type#1 SMBIOS record. Altra Max machines are similarly affected but
> > not detected with the strict strcmp test.
> >
> > Rather than risk greedy matching with strncmp, add a second test for
> > Altra Max. Do not refactor to handle multiple tests as these should be
> > the only two needed.
> >
> 
> Famous last words ...

Indeed, I nearly included that myself...

> 
> Unfortunately, I just had a report the other day that 'eMAG' and
> 'Server' (!) are also being used.
> 
> https://lore.kernel.org/all/20230131040355.3116-1-justin.he@arm.com/
> 

OK, so in order to workaround this in the kernel, we need a better way to match.
Unfortunately, this is specific to the oem platform, and the oem controls those
strings.

Thanks for the pointer, will go mull this over and see if I can come up with
something better.

In the meantime, would you consider matching on:
Altra
Altra Max
eMAG

to capture the bulk of the systems until we have a better solution?

Thanks,

Darren

> 
> > Fixes: 550b33cfd445 ("arm64: efi: Force the use of SetVirtualAddressMap() on Altra machines")
> > Cc: <stable@vger.kernel.org> # 6.1.x
> > Cc: <linux-efi@vger.kernel.org>
> > Cc: Alexandru Elisei <alexandru.elisei@gmail.com>
> > Cc: Ard Biesheuvel <ardb@kernel.org>
> > Signed-off-by: Darren Hart <darren@os.amperecomputing.com>
> > ---
> >  drivers/firmware/efi/libstub/arm64.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/firmware/efi/libstub/arm64.c b/drivers/firmware/efi/libstub/arm64.c
> > index ff2d18c42ee7..97f4423059c7 100644
> > --- a/drivers/firmware/efi/libstub/arm64.c
> > +++ b/drivers/firmware/efi/libstub/arm64.c
> > @@ -19,10 +19,10 @@ static bool system_needs_vamap(void)
> >         const u8 *type1_family = efi_get_smbios_string(1, family);
> >
> >         /*
> > -        * Ampere Altra machines crash in SetTime() if SetVirtualAddressMap()
> > -        * has not been called prior.
> > +        * Ampere Altra and Altra Max machines crash in SetTime() if
> > +        * SetVirtualAddressMap() has not been called prior.
> >          */
> > -       if (!type1_family || strcmp(type1_family, "Altra"))
> > +       if (!type1_family || (strcmp(type1_family, "Altra") && strcmp(type1_family, "Altra Max")))
> >                 return false;
> >
> >         efi_warn("Working around broken SetVirtualAddressMap()\n");
> > --
> > 2.34.3
> >

-- 
Darren Hart
Ampere Computing / OS and Kernel
