Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76EAE4D38C1
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 19:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233329AbiCIS1j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 13:27:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231344AbiCIS1i (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 13:27:38 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2093.outbound.protection.outlook.com [40.107.93.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 204E1201;
        Wed,  9 Mar 2022 10:26:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GoWXvBq+GhSzXznh3aZmQHvat7RbFwwIKAEmAdKUpaNO/IPHzzCBE66Ugzk76UjVZkjLyxP65B5wgE9MLW092NJCJa8QXRumd4k3kgwX5l84bxEgZyQYI+IP7tP/Y47mASY2hG/eO46/+FGZV2/xo8lmw+TNjfK9TCS4MjxpKknFPnHtTlC2jq87if11S5i19uQkOe1CEyb6oSekIkGzuA6+wem3APqearfxUnAAe4a3gek7eFy71k+SA95fT5XFaQ1afQgqeQ/apzSAb6xAzO3iQ+7JNh6MjGhyzI6t/lYRn+49uygO2nI2zZV9GyIGPuDP16S6u9iTaUW/AD3OyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lHY1UGfN7E2FQx07buHJ0q+8CLWN3UO8YeUbfzaPSXI=;
 b=OikK/yJkYR15CV4DXLHjvVEtZ36XeTJNeGCA6mr38in5r9jeAsIMwfSAsiYOcfzaGz4tQW54xT0zRtZGSzus2IB7Ket4bNHvOq0ZMQ3hG1P/CUYNtkKuD/l+W3QbNtl84+L/wZI4oQAApGPAM9sNMECFZ1q+QglZQI09BR+USMELxCnNgDfAGiUXWO1ijegCfqeUZRBHzb4vOphwzdWsKdDZsQ81BQd7JUTQC+EEgBiNU0TaeK/K+h87MpgBr/DMfxXo8TKYfXdPoxPV7XrOqfxb1Nj3i4nxJaldAcxliZCW4rNzBhEG/6osVAh9V4p6ePlirvnHooKKGOCzmuXZvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lHY1UGfN7E2FQx07buHJ0q+8CLWN3UO8YeUbfzaPSXI=;
 b=Vnp+dUZVxxSj1Ipyo4IodVqSaxNygWIJg64ZcxcEAQlOE6onN3SAE4EBuamIh3ft3IrqCuUOF3JTX0aA34x+itFEA9x99i4nzBqmx3r/qlfn/i7nEijKLo9aAWrDHHekyc3gPFcHg7ZIS5ZvWZ0UFIikUnJgiOpGhHAkOk0DYYA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SA0PR01MB6329.prod.exchangelabs.com (2603:10b6:806:ee::12) by
 BN7PR01MB3668.prod.exchangelabs.com (2603:10b6:406:8e::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.15; Wed, 9 Mar 2022 18:26:25 +0000
Received: from SA0PR01MB6329.prod.exchangelabs.com
 ([fe80::f56a:e18f:b6c4:ddb5]) by SA0PR01MB6329.prod.exchangelabs.com
 ([fe80::f56a:e18f:b6c4:ddb5%7]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 18:26:25 +0000
Date:   Wed, 9 Mar 2022 10:26:24 -0800
From:   Darren Hart <darren@os.amperecomputing.com>
To:     Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc:     Vincent Guittot <vincent.guittot@linaro.org>,
        Will Deacon <will@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Arm <linux-arm-kernel@lists.infradead.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Barry Song <song.bao.hua@hisilicon.com>,
        Valentin Schneider <Valentin.Schneider@arm.com>,
        "D . Scott Phillips" <scott@os.amperecomputing.com>,
        Ilkka Koskinen <ilkka@os.amperecomputing.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] topology: make core_mask include at least
 cluster_siblings
Message-ID: <YijxUAuufpBKLtwy@fedora>
References: <f1deaeabfd31fdf512ff6502f38186ef842c2b1f.1646413117.git.darren@os.amperecomputing.com>
 <20220308103012.GA31267@willie-the-truck>
 <CAKfTPtDe+i0fwV10m2sX2xkJGBrO8B+RQogDDij8ioJAT5+wAw@mail.gmail.com>
 <e91bcc83-37c8-dcca-e088-8b3fcd737b2c@arm.com>
 <YieXQD7uG0+R5QBq@fedora>
 <7ac47c67-0b5e-5caa-20bb-a0100a0cb78f@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ac47c67-0b5e-5caa-20bb-a0100a0cb78f@arm.com>
X-ClientProxiedBy: MWHPR1401CA0017.namprd14.prod.outlook.com
 (2603:10b6:301:4b::27) To SA0PR01MB6329.prod.exchangelabs.com
 (2603:10b6:806:ee::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b17e001f-7f8e-47c3-6947-08da01fa51de
X-MS-TrafficTypeDiagnostic: BN7PR01MB3668:EE_
X-Microsoft-Antispam-PRVS: <BN7PR01MB36688743BDE149CDD93BBD35F70A9@BN7PR01MB3668.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N19SjbDVxr6Pky34uTokcB2QxLuM91bu2Aus4IM4b2FsOmUZh+IqGtIsyPIjlqrO+1zAjVmWjtdFJAMKAdwXO8rVvo5KR4Eny7ElXZQWquiBkocNxHhAvW7B1RnRCm1OXcc28qSQuS2KUG+nZeET8iogWbo152BoT4P79J6FtSveuNHjJhMdMe1iY/NVdeWUd9LGJS+yP2GA6achgdip8iTvl0zRpCpmyJroveoyMSjmI8HJwHTM9xf8W+BbBqBfY6uzQqCMRwz0W5zy9eZ85PALiidRj5DbkJLnV+sWinDwD8yAtyBT6b/Pb2XmERfFnR73DImbCaZZ7NLbq7+3kTFGQfDuNWh4LyymJCwgcE5VyhUgNXsis6w8qC3b74a2+mNAr/vm6hJt7BG1saXtp3CjwZbmO+Wd9pFx/MvhLk+7hIxafIOHKoA5Esa+miIkoEHUEPAC+fs7DcTYZGnSE7k1yangqtEGxt0hZ77wXVN1TVaU41xFu34N+0Lg2KcclY7pCqbXLBD5SyzAzzflBhH7RGVTw50K2mxjBPd+PUhwnMzDqZu4m63Mhc0D+5HeCz4ipPZkx3F852PR0aGm8C05mUFjp+NL5TbYelIRw/I9tr28HiXLufVpA/e0lgKd4FrpAa3Jk//c7+BsZ/79nsnen+97qs/THUCEMCiEZqpNaGjQ2MxHKaSMvMtBOWpe9tR/V7UWKu154r8mkBwT7A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR01MB6329.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(5660300002)(6486002)(9686003)(6512007)(7416002)(38100700002)(54906003)(6916009)(316002)(6506007)(4326008)(66556008)(8676002)(86362001)(53546011)(52116002)(66476007)(66946007)(38350700002)(8936002)(508600001)(26005)(186003)(33716001)(2906002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ii00PHgD5KeuvAnllR/oX53nLohcXtG/L0PNhyXbGfTbATAoVKUxtwMTwPjA?=
 =?us-ascii?Q?jUKbpI9+J0EvwfUcbYRRXDUpPGIu2KsWBbienkBI9gtq4tgL+kw7AHUGzm2L?=
 =?us-ascii?Q?RFYZQL8qLvGasPLQ6FPwu2u4jtUuRkwDqz7rfh6LBdzXag3GG144y50fQ7UR?=
 =?us-ascii?Q?X0u0ZHowK6G/OYQw6QpFJ+nzYdNDhfdSxerpy91PGfRx7OTKiaMmCXv8M6Zg?=
 =?us-ascii?Q?Uj/3kLClwvzLWn/bJFgyx2cE0UES1bBJYBZyYGo3b33WSgH47C4U1iwAIo4x?=
 =?us-ascii?Q?WzVugmZKsiD39YflP4NuNfIzypgEyJJvov8V4roKueewuaMg3vFRcjXtZHh+?=
 =?us-ascii?Q?V5+NNwfbmbBrCL8KA+ZgebW2S8ExwwsB5duXB4F0k88QfuPAVaPx41aQNOe9?=
 =?us-ascii?Q?rfhWsMtSBFiu6hByIPBpxNAfd5ooM6J0JcDGXV1XP0i3gCiZr6j+tdeWIER3?=
 =?us-ascii?Q?GYKW6E/lzTY+COHOy/aOwgaSCfsWMw0M9noTzJSzLpiQ+x1i/Bv77iOtZK/q?=
 =?us-ascii?Q?JWzgbf57fkiHQE5i4pgEtNPMhKEW7l2qy3TiU0UHd6HKypO+KrrEN+cyCppi?=
 =?us-ascii?Q?A+wtHRpU7yEpbte124uzm+q3Hpe/XAmWPFM3oAMLV7MuDnWNBzuM6uTiBXKd?=
 =?us-ascii?Q?sC9VjD0iHnSUmUtpxXYs8MDo9ctTp8UP1i1VUELVrRy27+HhcgFiyIDLaaS4?=
 =?us-ascii?Q?NunxnPCwvAjfSq1XTs7TJvlzUQj1fl+zadtONoaGbqM6OslrmdSLVIpdjoUu?=
 =?us-ascii?Q?tb44BZKdUlEoZgHM65QpHXphnoE9+/uYmFvGuRsKl0NnLzsP9/0lWJoYWRw5?=
 =?us-ascii?Q?8YSKee6exkEJjdR+ESLMTnzlFbba7hVSQPSKY3kmM+1ASnzHEi1o4pv8s9pl?=
 =?us-ascii?Q?cc5cGeivVMPwiqhrDMYJFs84qwunnBPNJdsYA8D6sU1LxnfrHRQAzOMKJ0Ky?=
 =?us-ascii?Q?eDnNrPK++TodMoR5A/+6j/g6UdmQ+gNga1kzMeXcsmlmvHm31swCwHPIB5Ax?=
 =?us-ascii?Q?52/uzTVwoIhqbOp5Sv91UOIPftY3zHvH3ewcxEPhwqiV/JBhZy8Aq2QQtcm2?=
 =?us-ascii?Q?ToAlGllCyNm9zEwv5SPXqhIGAtVhs8xF5ItOU2xq47iZBBtxYok//OSiGXaa?=
 =?us-ascii?Q?z8P72QENkblHQ5jVC/rhK0LnffLBLDRhnss9B1doaYnUSON1UtesJpy1zJ2y?=
 =?us-ascii?Q?H5RP4tHiOz+W0WfvOadMQs3V/lVLuQvAPhpNJYPU7j9x0WUfqm/IsRgRr676?=
 =?us-ascii?Q?Q8J+1qwFFHNNtlQEsbUjgfhytYBWaYVfPb6YfMwyBXG66FQfOPS9Rk4XORES?=
 =?us-ascii?Q?2W7qSbu15KkfUiZktYWB5aPLG/C1LPXgb7/1wMXnq5z8u9PYcHvAbi1U2iZX?=
 =?us-ascii?Q?jDUBkHeQ0WoKSGU83iq6DtJK2uLALDnGGPrugsNDOPkkM4NUBpuvNSLrAn43?=
 =?us-ascii?Q?s3FPqiPu3k+JDZP6Q7lmTtM6vGWnQ+AMP3rbbWWQ9CT8Trf3R+AAcNs8iAjc?=
 =?us-ascii?Q?ueEvT+CO6JwpZwmxx7q93hiPeMLKGm0MW1g07UkJESx0ZLp3pbQ3bWEOX20+?=
 =?us-ascii?Q?Yzm38tOuSDaUiFdzwfpRDgcLfmc+l6xwVTUhROh8erNiQNHLWfRQ0vS1NgbJ?=
 =?us-ascii?Q?zcgyP6ekP8NzcU4gT3S+H4j7oRyxP4/R2xqjXkZ4qD8wzhtJhUCkVsPwBPPT?=
 =?us-ascii?Q?yCi9OjPVc4I3jJPBFivz675GCKs6BbKw4RR68JR0SOEZ95K8mvWMKfV/DptC?=
 =?us-ascii?Q?yXStrU2erw=3D=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b17e001f-7f8e-47c3-6947-08da01fa51de
X-MS-Exchange-CrossTenant-AuthSource: SA0PR01MB6329.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 18:26:25.6008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /62cxblx3YjfQfLOf5eRp0jnkHUaRJG65FEpup6HxBye5l2B6Tqm2ltjCAEFhlWYWS+Yu+kwp4Jtpz38QXX70NrC99wFqdchuN1nKEItxOkr2Bul8e22PRlvIwTy0T07
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR01MB3668
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 09, 2022 at 01:50:07PM +0100, Dietmar Eggemann wrote:
> On 08/03/2022 18:49, Darren Hart wrote:
> > On Tue, Mar 08, 2022 at 05:03:07PM +0100, Dietmar Eggemann wrote:
> >> On 08/03/2022 12:04, Vincent Guittot wrote:
> >>> On Tue, 8 Mar 2022 at 11:30, Will Deacon <will@kernel.org> wrote:
> 
> [...]
> 
> >> IMHO, if core_mask weight is 1, MC will be removed/degenerated anyway.
> >>
> >> This is what I get on my Ampere Altra (I guess I don't have the ACPI
> >> changes which would let to a CLS sched domain):
> >>
> >> # cat /sys/kernel/debug/sched/domains/cpu0/domain*/name
> >> DIE
> >> NUMA
> >> root@oss-altra01:~# zcat /proc/config.gz | grep SCHED_CLUSTER
> >> CONFIG_SCHED_CLUSTER=y
> > 
> > I'd like to follow up on this. Would you share your dmidecode BIOS
> > Information section?
> 
> # dmidecode -t 0
> # dmidecode 3.2
> Getting SMBIOS data from sysfs.
> SMBIOS 3.2.0 present.
> 
> Handle 0x0000, DMI type 0, 26 bytes
> BIOS Information
> 	Vendor: Ampere(TM)
> 	Version: 0.9.20200724
> 	Release Date: 2020/07/24
> 	ROM Size: 7680 kB
> 	Characteristics:
> 		PCI is supported
> 		BIOS is upgradeable
> 		Boot from CD is supported
> 		Selectable boot is supported
> 		ACPI is supported
> 		UEFI is supported
> 	BIOS Revision: 5.15
> 	Firmware Revision: 0.6
> 

Thank you, I'm following internally and will get with you.

> > Which kernel version?
> 
> v5.17-rc5
> 
> [...]
> 
> >>> I would not say that I'm happy because this solution skews the core
> >>> cpu mask in order to abuse the scheduler so that it will remove a
> >>> wrong but useless level when it will build its domains.
> >>> But this works so as long as the maintainer are happy, I'm fine
> > 
> > I did explore the other options and they added considerably more
> > complexity without much benefit in my view. I prefer this option which
> > maintains the cpu_topology as described by the platform, and maps it
> > into something that suits the current scheduler abstraction. I agree
> > there is more work to be done here and intend to continue with it.
> > 
> >> I do not have any better idea than this tweak here either in case the
> >> platform can't provide a cleaner setup.
> > 
> > I'd argue The platform is describing itself accurately in ACPI PPTT
> > terms. The topology doesn't fit nicely within the kernel abstractions
> > today. This is an area where I hope to continue to improve things going
> > forward.
> 
> I see. And I assume lying about SCU/LLC boundaries in ACPI is not an
> option since it messes up /sys/devices/system/cpu/cpu0/cache/index*/.
> 
> [...]

I'm not aware of a way to accurately describe the SCU topology in the PPTT, and
the risk we run with lying about LLC topology is that lie has to be comprehended
by all OSes and not conflict with other lies people may ask for. In general, I
think it is preferable and more maintainable to describe the topology as
accurately and honestly as we can within the existing platform mechanisms (PPTT,
HMAT, etc) and work on the higher level abstractions to accommodate a broader
set of topologies as they emerge (as well as working to more fully describe the
topology with new platform level mechanisms as needed).

As I mentioned, I intend to continue looking in to how to improve the current
abstractions. For now, it sounds like we have agreement that this patch can be
merged to address the BUG?

Thanks all,

-- 
Darren Hart
Ampere Computing / OS and Kernel
