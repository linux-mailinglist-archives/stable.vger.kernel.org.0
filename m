Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E38B769126B
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 22:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjBIVGu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 16:06:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbjBIVGt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 16:06:49 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2106.outbound.protection.outlook.com [40.107.223.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 419D51BF4;
        Thu,  9 Feb 2023 13:06:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fDdhJMylNflkzmn2VmXi2RlO7cyxN9anBjm4byud1NK1hfUJWhXQAnR6YJb4+5Pw+ZLZo/uD2PvkwjSNqxnsApmQmJhsOGvblIb9MhJTrw2ciGITCACbVVU3/nbV3BPP+YocFMPtVzL06AHjIEw5RtXu9Lq9b2Pm6BwV5AF9v2IuHkqvNxCaSAT9KluKou7TRq+YMCF6Jk4DZMmnrDUeY3xGEWWL/u4M+s0NknVN7SRd+Tb4lKnuSbjqiDAKZgBqkj/wwOOCF2AXl6fR1QnppKzHIFRxFh55l3Ub1JI7gfrJx2tGrcXNh6XoZ8sDmK690ZfLZKk7xzBgSGXWxgOhCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bLZUgIgv4YHLcah/BCUp9Skf8wMnCwDIRhSgkPaedH0=;
 b=cCBnky+gSNe8eFfizHTzpGlT1g8IPbMBh1vPKtPu+meo7coxlxaOYjsqvSzr8+vegJF/D9QfWxpuvMVf9tU1D2Mk1QPvKNNEpeVnTrpNuFABiC9x4sIfFOEfaA3pBsYxQrZWNj2lEBggexMDXhzG5cbJiUnZnSo2+k6/WfvLSXpdVDWBIco5YNkSMlJBn5fGMzWn/HQGJakBQ7dEaF6u55Xj0G+z7TebSeHnax3SiP9HgfCescqjQYZF91ro4xvDok9MWiu5iAAQGkuBvE/1Wt5DoUU1i1fUIzrKD7Oprqvb9tJk6U5pJztQPj+zjnStcgy0MvBgwJImbfgcb+cttg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bLZUgIgv4YHLcah/BCUp9Skf8wMnCwDIRhSgkPaedH0=;
 b=GuvlfTDZcOVp0j20fmgrB+u9fsz8IG6U5bMTF2W8rpJrDmyygHtgUm+UxnyBc0xEAl3EMBvB+cciLc7MPMh2N8LRpY03BsJCdkEtMhTw+tIxpLhJU2MhMcW1j+CDyVH5dseyN5HQsaUbP9bjAcU1vZnv6SkQMUGrWpX/MwFUvx8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ0PR01MB7432.prod.exchangelabs.com (2603:10b6:a03:3d3::16) by
 SJ2PR01MB8227.prod.exchangelabs.com (2603:10b6:a03:549::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.36; Thu, 9 Feb 2023 21:06:41 +0000
Received: from SJ0PR01MB7432.prod.exchangelabs.com
 ([fe80::5208:e5ea:6ab3:19b5]) by SJ0PR01MB7432.prod.exchangelabs.com
 ([fe80::5208:e5ea:6ab3:19b5%9]) with mapi id 15.20.6086.017; Thu, 9 Feb 2023
 21:06:41 +0000
Date:   Thu, 9 Feb 2023 13:06:37 -0800
From:   Darren Hart <darren@os.amperecomputing.com>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Justin He <Justin.He@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Alexandru Elisei <alexandru.elisei@gmail.com>, nd <nd@arm.com>,
        Nathan Chancellor <nathan@kernel.org>
Subject: Re: [PATCH v2] arm64: efi: Force the use of SetVirtualAddressMap()
 on eMAG and Altra Max machines
Message-ID: <Y+VgXbVHf0BC3vO6@fedora>
References: <2ab9645789707f31fd37c49435e476d4b5c38a0a.1675901828.git.darren@os.amperecomputing.com>
 <DBBPR08MB4538C586B721C8209B03AEEEF7D99@DBBPR08MB4538.eurprd08.prod.outlook.com>
 <CAMj1kXG8TY9eKJxtSWYPCu_8qs7W3FWwDSZ+teuwhHb1BHUf7g@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXG8TY9eKJxtSWYPCu_8qs7W3FWwDSZ+teuwhHb1BHUf7g@mail.gmail.com>
X-ClientProxiedBy: CH0PR03CA0278.namprd03.prod.outlook.com
 (2603:10b6:610:e6::13) To SJ0PR01MB7432.prod.exchangelabs.com
 (2603:10b6:a03:3d3::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR01MB7432:EE_|SJ2PR01MB8227:EE_
X-MS-Office365-Filtering-Correlation-Id: 8de6c758-17ab-4c6a-8c1f-08db0ae18a49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jQMU0QmmESzTt8j2SzlySeShCtaWlaQRfI0rlGbAYsG9iwGfdqypy7n+4ptvomi0LJitLgucyb1EPJvYD/jBPfENa95L54TaLNkkZFxpg5ukvtLaVP6pQLx5HupojTGl4BOzpbMJhagdJW5wMQyjsHtSYQ/jdFkjcgKNW+kdiYqJfzMLrLCG5p09IqDfWqrrvejwrlS35RNEpyIHD3IYuVjL3zvYR7YvJqo+USqY9U5JMOehFPHXChdlLi72ys8XWfI31aLTW5hl92yRogDK/d6CDN6qfbxy4UwFyNjddSA4jt2jzWbXYacG4G9Iufe9vhhbtdcbWheB33VQ5t49iHMQ5zLhVDAba3ENLCtADMSzf4zMlQDvrw50lz3GFRUhhTwoIZQu+q976tp/kAdoknx45QZCvJUm2ZVzZDkyBtfbFdNIaEAs9AZvIRva4aFC8vgxrHCcqP53Xlo5tc7iVnhqiKrJ/b9/mBDNWLxlaY7Bnwv7Cdokeeob9q0FF4HnNcShOyngfbba9/ndxA+uXBUc/LXWuD4To6u3UaRMmkfEzZwqimWbxGf+JZIlGRV4EFsDYXar6b/9Lz0mvC32QMwI/P34GedPPYQOupicScJ3nt8Wi9hFjoQo5Ieo4CnFxPZXvTQ4VnlGFCC4XjbEkZsliJp5rLFnOm7JUTGidyAkIHUyhhNbI2pbzwBMOU/rIsmyTV4PKUJW0C7XTTUQ+nIo+4ocsDoecwglVHEj00E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR01MB7432.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(136003)(366004)(346002)(396003)(39850400004)(376002)(451199018)(83380400001)(66476007)(66946007)(54906003)(8676002)(316002)(66556008)(6916009)(5660300002)(8936002)(41300700001)(4326008)(6666004)(478600001)(6512007)(9686003)(6506007)(53546011)(26005)(6486002)(52116002)(186003)(86362001)(33716001)(38100700002)(2906002)(38350700002)(66899018)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?w33cgzoibh/d7m3uU27oAxlFVNCR3Z51RXdbM/dxjJXwiDhb99hjr1aaK8OL?=
 =?us-ascii?Q?YYKJuw8+K5KYN2WUf/z8B6KlJTU6bonCus7wqktt1JvwwiHP8RzyjLhZhmzp?=
 =?us-ascii?Q?ZAB1qlhlW7ZLw1q/T9Ye5gX0rR8TZ/zmC6LF9jdTQR4tnRkQU24KaPJuGJ7p?=
 =?us-ascii?Q?mlnGTDha+TVy4XeQXzgVI8cKz7CCUu+mADRd/vmM7VNmzYAr7/lkZplvE/kF?=
 =?us-ascii?Q?LAWEyLxpqACVsTJHofC/DDeZBMnC+P4N0Vfqb7sfk6BbtVxK1KPwl/RD8cOs?=
 =?us-ascii?Q?MgsnlVBSE2dwgI5WaVs2WsQpEB6jekho2p3eBjLEZqpQ/tS31fo3QvkXPVNq?=
 =?us-ascii?Q?2lApv/Hm5XqlNmqEKDeh24XaeVfOL9QIAYgJSUll51V/ZNBq/Peb/iEHj1qg?=
 =?us-ascii?Q?Dy0qphP/sZeHZyehnZhA95h17bqW0jEJOHHOGYwZLhmuIDCYtI3yrByxMFQh?=
 =?us-ascii?Q?KQzu0DQGQSpgqU+HXO0SoMwnADYF2Su6MrWQpUjlPkU57m7L+KTzFhHmlUlN?=
 =?us-ascii?Q?qklBLF1JsNxADzG4s9URFUagEL2ozXQ/5WP9I9aIsD2S5tW56D2pxu3bEdS2?=
 =?us-ascii?Q?FrKd5ZDwKWGLwnRz4rGGCp6Nkmubd+2lTRXRmGnDopVbJefxVZ9dFNBzXAsw?=
 =?us-ascii?Q?gOccV083lY49VOzlsE1wLvD0TjecQjFt9shysyesx/h18lMGeQHhEi8vafLh?=
 =?us-ascii?Q?rs0JKyqufJxWR4+/H4PODmfmQiaG5HPWfMqeJJtqgXe5Dh7SPsddioUeSJcT?=
 =?us-ascii?Q?zLBrudNl+fAxQppjvWGkz2tk0MA8GHX5TgILd1pdkJJJ5ZWAimi4vQhyjXsy?=
 =?us-ascii?Q?RwtsAf2qrmWLLlXROuUzRx5N9qO+tt4a1w2+NKiY+4VBbHHhfS4dwpnQaWBv?=
 =?us-ascii?Q?jhZRD7VObtKw/16pJ306Hd3RU5JsdKx6iTXRS/YByfjsod0JHrf/PCjVsE1d?=
 =?us-ascii?Q?dEOtZ/gKm2BfSDU6dAcNdLUiyf2p/MsiPS5JnFF4nqUu0rvPlnDhvcqn5hVJ?=
 =?us-ascii?Q?WxyUJQ8YTDrczZhIcEmPPZhBaxPGXYw6fbCkEhaTpDsDf1OGDyIR57HewmIg?=
 =?us-ascii?Q?MxIOxFebGrjg1PbFhOWUB2iBG+gCGdh7Ji7k+04KHAvFoml+1HhAtm8bunDM?=
 =?us-ascii?Q?YFpWMG/i3Kll+YVdlpkDDcILDMh8grCnw4RmAbxj5+RWsjYV7Xpoa5HREzBS?=
 =?us-ascii?Q?eRWbI9Rs4WKZV9DBtGo14kdglsj332Am0Ac2rP2+ATN3AqCZedB+wAOVDm1l?=
 =?us-ascii?Q?6RXDNOIy1Ibx1QlAOsz2d8FuYw6HwLekc3wCMVjHpuH12Uo/nL4g34jOgsR8?=
 =?us-ascii?Q?fD2T9MyOAcBfi8qYJKBC893wzP3B9gsJndjBdltmOfjcEqyoTu6NboFHVmuU?=
 =?us-ascii?Q?UA0nd5D2K6nFds/+sPZQY5R+OWfRcwRVGYftvpAKmRzReiS1YXxzGWCTjGRV?=
 =?us-ascii?Q?gRglYnUz7add/EIhMBw98rWdRS87bcLW+vBSSms0Wp+v+EqfsrjTosmuZ/L6?=
 =?us-ascii?Q?c7XASdYYAfappMyoDQDhBAF5Q/zI5eR9BkTLmk8J9bysu//fRnZLQtgqpmvc?=
 =?us-ascii?Q?2HcdY5PxgPubdrJjNjdd+xiQeo1WrT1Q7y6JeaWoVxdY+pO7GkkX8NCJP3Cc?=
 =?us-ascii?Q?DbS7M5XTYXHlLKxunaQL8x8=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8de6c758-17ab-4c6a-8c1f-08db0ae18a49
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR01MB7432.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 21:06:40.9551
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1X/uejmW5ux7zCx1N/fOwklM+R65cf+uUhcaa63kJ7Twr8KsXECGSzOuQCQTeMe8/p/Akmol+6FlqVY7AGQXXGXSlY8ehiqL2cJr1iIqALiohfBiG4+B4+ep7xOBUi6R
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR01MB8227
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 09, 2023 at 04:30:57PM +0100, Ard Biesheuvel wrote:
> (cc Nathan, another happy Ampere customer)
> 
> On Thu, 9 Feb 2023 at 05:26, Justin He <Justin.He@arm.com> wrote:
> >
> >
> >
> > > -----Original Message-----
> > > From: Darren Hart <darren@os.amperecomputing.com>
> > > Sent: Thursday, February 9, 2023 8:28 AM
> > > To: LKML <linux-kernel@vger.kernel.org>
> > > Cc: stable@vger.kernel.org; linux-efi@vger.kernel.org; Alexandru Elisei
> > > <alexandru.elisei@gmail.com>; Justin He <Justin.He@arm.com>; Huacai Chen
> > > <chenhuacai@kernel.org>; Jason A. Donenfeld <Jason@zx2c4.com>; Ard
> > > Biesheuvel <ardb@kernel.org>
> > > Subject: [PATCH v2] arm64: efi: Force the use of SetVirtualAddressMap() on
> > > eMAG and Altra Max machines
> > >
> > > Commit 550b33cfd445 ("arm64: efi: Force the use of SetVirtualAddressMap()
> > > on Altra machines") identifies the Altra family via the family field in the type#1
> > > SMBIOS record. eMAG and Altra Max machines are similarly affected but not
> > > detected with the strict strcmp test.
> > >
> > > The type1_family smbios string is not an entirely reliable means of identifying
> > > systems with this issue as OEMs can, and do, use their own strings for these
> > > fields. However, until we have a better solution, capture the bulk of these
> > > systems by adding strcmp matching for "eMAG"
> > > and "Altra Max".
> > >
> > > Fixes: 550b33cfd445 ("arm64: efi: Force the use of SetVirtualAddressMap() on
> > > Altra machines")
> > > Cc: <stable@vger.kernel.org> # 6.1.x
> > > Cc: <linux-efi@vger.kernel.org>
> > > Cc: Alexandru Elisei <alexandru.elisei@gmail.com>
> > > Cc: Justin He <Justin.He@arm.com>
> > > Cc: Huacai Chen <chenhuacai@kernel.org>
> > > Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
> > > Cc: Ard Biesheuvel <ardb@kernel.org>
> > > Signed-off-by: Darren Hart <darren@os.amperecomputing.com>
> > Tested-by: justin.he@arm.com
> > > ---
> > > V1 -> V2: include eMAG
> > >
> > >  drivers/firmware/efi/libstub/arm64.c | 9 ++++++---
> > >  1 file changed, 6 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/drivers/firmware/efi/libstub/arm64.c
> > > b/drivers/firmware/efi/libstub/arm64.c
> > > index ff2d18c42ee7..4501652e11ab 100644
> > > --- a/drivers/firmware/efi/libstub/arm64.c
> > > +++ b/drivers/firmware/efi/libstub/arm64.c
> > > @@ -19,10 +19,13 @@ static bool system_needs_vamap(void)
> > >       const u8 *type1_family = efi_get_smbios_string(1, family);
> > >
> > >       /*
> > > -      * Ampere Altra machines crash in SetTime() if SetVirtualAddressMap()
> > > -      * has not been called prior.
> > > +      * Ampere eMAG, Altra, and Altra Max machines crash in SetTime() if
> > > +      * SetVirtualAddressMap() has not been called prior.
> > >        */
> > > -     if (!type1_family || strcmp(type1_family, "Altra"))
> > > +     if (!type1_family || (
> > > +         strcmp(type1_family, "eMAG") &&
> > > +         strcmp(type1_family, "Altra") &&
> > > +         strcmp(type1_family, "Altra Max")))
> > In terms of resolving the boot hang issue, it looks good to me. And I've verified the
> > "eMAG" part check.
> > So please feel free to add:
> > Tested-by: Justin He <justin.he@arm.com>
> >
> 
> Thanks. I've queued this up now.
> 
> > But I have some other concerns:
> > 1. On an Altra server, the type1_family returns "Server". I don't know whether it
> > is a smbios or server firmware bug.
> 
> This is not really a bug. OEMs are free to put whatever they want into
> those fields, although that is a great example of a sloppy vendor that
> just puts random junk in there.
> 

We could use the type1 "product name" and have a unique identifier, but that
doesn't scale well either. Ampere partners with many OEMs, and we should expect
this to increase in time.

> We could plumb in the type 4 smbios record too, and check the version
> for *Altra* - however, it would be nice to get an idea of how many
> more we will end up needing to handle here.

If we don't get this fixed in firmware, I think we have two kernel side
maintainable options:

1) Depend on the type4 string for the SoCs with impacted EDK2 firmware. This is
suboptimal as OEMs should be able to update the firmware they ship and control
how the kernel interacts with their platform. This effectively removes that
option in order to avoid the individual listing of "product name".

2) Revert the earlier commit changing the default to not calling
SetVirtualAddressMap(). Obviously undesirable for the reasons that patch went
in, and it affects all arm64 platforms. The only argument here is it used to
work and now it doesn't.

> Also, is anyone looking to get this fixed? There is Altra code in the
> public EDK2 repo, but it is very hard to get someone to care about
> these things, and fix their firmware.

Yes, this is a conversation I'm having internally with the firmware teams, and
the preferred approach provided it can be effectively rolled out to eventually
capture all Altra* and future platforms.

Thanks,

-- 
Darren Hart
Ampere Computing / OS and Kernel
