Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA54B3F797F
	for <lists+stable@lfdr.de>; Wed, 25 Aug 2021 17:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241524AbhHYP4E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Aug 2021 11:56:04 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:38759 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240720AbhHYP4D (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Aug 2021 11:56:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1629906916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XkfJv/GeVwwE6dWBrnp6jjh2P1l9bZu1T9viqqgowe4=;
        b=lUB9ryZEFlj4Zq/n8SExa6x3F9sq3RFPlz4peCfRI+Gc23OmMwolaJVq2irkviDlyXUiSP
        1oBXR9V3W9UcNhePmzPzNe54U71/Ny8ouHoEuYQ1NUuCbHcXvr28fc3o1atIKsArZ9h5zH
        YNO2MTgJihFTDoHzNzjF3cMD9ERuBFg=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2054.outbound.protection.outlook.com [104.47.13.54]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-23-DzIgqtZRNSmknGwLHWqmTQ-1; Wed, 25 Aug 2021 17:55:14 +0200
X-MC-Unique: DzIgqtZRNSmknGwLHWqmTQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FAB5lwI9JDwOdzRr5OGTEJD+wV6RkiJi8kfpqrdLXNoE8oG0HqeDnokOnpNEH5aUnNnF8UKyi/DSRaexfjhF6riwAYJYWf3rSCvl8kgpuHN7GV3pAlfQqIC/3XKh7/BVx88KmjD1uO+XsxogwdNS+gxpJcWnPdGEX/BU0DrEH49orEQVMRp7uDoGtxaLrzpqLody1jQNy/8Sgr1RnHKkavVM+HSbwcrKOKVt3KG3nBMktUyDxYekT+aiIunj3QBO8nRyfRUfaINFewZWqamZ1EZiF7ZSUBI3uXkBd7P7onXWfvAwYACFfzx6QWBz8LF6sngnKSWe1n/3A46fgodY+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yjWPYN1k146GH/igWGyIID2OvfkJxkVgl42F2FVeuG0=;
 b=F4yegEqIAS0P3I/NBSD6bfNia+JGG8HgSW85rZhOQ9GApzHx1ijZrVENVJaTcJ7hUTAe1pTLZBSeNaloibxyDisf1AVmxumSiUcLZ/GrWFCCGk0cN2MIr1wIjfkdWsTXFFos/mFL0f/JgIv/rJiSmjx25TqZSS6qz8Xs0+pmRRD7cxbzykxvEjn92drTzXRjjzRAHabLCPki79uvZBUOf7gRydgqLrJw57FjYL6FcD0ajBFlzf0+QOVoPRph4vsYeBDTz7s4/1d1gayv9DX/opIyv7+gSChP/rpgsbRN/d+rhrWt+RYY4N8MuaLI0EsJ4ZFvKEOj47VlAgF1bBIKyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR04MB5600.eurprd04.prod.outlook.com (2603:10a6:803:e7::16)
 by VE1PR04MB6671.eurprd04.prod.outlook.com (2603:10a6:803:11f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17; Wed, 25 Aug
 2021 15:55:12 +0000
Received: from VI1PR04MB5600.eurprd04.prod.outlook.com
 ([fe80::4d37:ec64:4e90:b16b]) by VI1PR04MB5600.eurprd04.prod.outlook.com
 ([fe80::4d37:ec64:4e90:b16b%7]) with mapi id 15.20.4457.017; Wed, 25 Aug 2021
 15:55:12 +0000
Subject: Re: Kernel panic in __pci_enable_msix_range on Xen PV with PCI
 passthrough
To:     =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?= 
        <marmarek@invisiblethingslab.com>
CC:     linux-pci@vger.kernel.org, stable@vger.kernel.org,
        regressions@lists.kernel.dev,
        xen-devel <xen-devel@lists.xenproject.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>
References: <YSZgkQY1B+WNH50r@mail-itl>
 <3e72345b-d0e1-7856-de51-e74714474724@suse.com> <YSZmFMeVeO4Bupn+@mail-itl>
From:   Jan Beulich <jbeulich@suse.com>
Message-ID: <24d47a06-a887-05e5-0e3f-ed3cdd19490b@suse.com>
Date:   Wed, 25 Aug 2021 17:55:09 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <YSZmFMeVeO4Bupn+@mail-itl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: PR0P264CA0281.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1::29) To VI1PR04MB5600.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.156.60.236] (37.24.206.209) by PR0P264CA0281.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Wed, 25 Aug 2021 15:55:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0511ef5f-2876-442a-83d6-08d967e0b8e2
X-MS-TrafficTypeDiagnostic: VE1PR04MB6671:
X-Microsoft-Antispam-PRVS: <VE1PR04MB667173BC64C9D2E348B465F8B3C69@VE1PR04MB6671.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LPAxPTHrk9/zO8LrD3ADqOGtVeXmtLZilTFfG47wYeDsGabT2IQF7QRjWvcZD8B9UgIraYHJiX8vR3fIGBLC7skqriao0LVv2NZCNtfiilS8MxrFlIbHSrpMMDrc0jM2L2Ot5GL/lnLQRkYK/N2lYtCpTzwpAERiAzmCXRltZ/E2C3+8w3IJrxRXsunSYVAFKqrwrFxpEJbpjWZSXP/tDgr0knk1074t1Cxd2p3LvIknfNO0TAaD/8dfgs5QTQfZxWB3anS/3lA2M38txEhQoQvUXo3cEDK7Q9kPDe1fHiphQUDR3cKsFIHnU/aPdbiN7ZjhwNCeYLAChYsIGbf2glRfxfxx0OG9PYf8G0UMid1Mju8ztWX8fUTRFfX7W3HzsP7huTe6PdHyUIBIAuz2TtFSP/StUIM0DNZDEtnZM9ygfy2egGsXwIdACdlosG4ACLjK+ix2JPLdjFQ/FmNkb9LBITq+onaWDgPMbkCeasiobJR6miYI0IyNSCDNYH5zrT2MZ5JsKqhb0px0u/xbAzwu8D6MOigjGCrvbUTaBhRz99ms6MwdQUEL1tSsdQat1a+mF8EgLRxS6fRV0aViKcZ9Zcl8XcqxD0pEHgjUcqrmAcQ6qditvtLf/NpLPtxK5LmfwK094g10DYhu+e1s6I+Z2dVou420EEMy3FbsJWlaHPrslehEGdDg3uuicGx7KXqFWdjVKcE4vWU9XT1sCMGII+dbsIbnlFGowTbXghk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5600.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(39850400004)(366004)(136003)(66946007)(478600001)(36756003)(8936002)(66476007)(66574015)(66556008)(6486002)(5660300002)(53546011)(16576012)(8676002)(54906003)(6916009)(38100700002)(2906002)(4326008)(31686004)(86362001)(316002)(31696002)(83380400001)(26005)(956004)(2616005)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vXVjrDPX2k+goA+ZVznHWEXmnO1wmo83/aBA3MCY6IFQizJlLFItT1Xc5tOI?=
 =?us-ascii?Q?+nExplzFqllnq1ZiIPCe7WOCEDFRgLIDQqHqNHY/Ik2ZYbWbAegmltOglHJJ?=
 =?us-ascii?Q?YaJC7t3vP7VaxpL8mJVu/0ofKjhouK5GG/u/Z/rHhfukQ5W42x4WlFoxLxns?=
 =?us-ascii?Q?H8zsgXAMb46gBMfbB+UZUBG8CV+AotVFY3qJ9W2gux0k8c9xOh0wJtWiX12m?=
 =?us-ascii?Q?+fAwklFgnPnGZDvmzYumcVserHfyIglB3q6SC9eFqpCVck0Q2R9fjlkkgVRn?=
 =?us-ascii?Q?pe9OTUfcAEp6ndM6Nb82uRGiUvlWnu878CIxj/1gzmQSa7qrgfXIle7trwAq?=
 =?us-ascii?Q?dAlOpoFC7rNQ5qa4tFXOZtuHsZjipH3p4Th7pLvT6Z0+pGWwIJtrCrP9r0/K?=
 =?us-ascii?Q?Q/XBmBZf0pTLdMVW6F/1UFJyqruVB0VJ06efBr6cwfx2JBs78rP5cAjQP8nS?=
 =?us-ascii?Q?HwmG2urIYIo0B8NSboX1YSRjXrYSyKnIcQP3yzobSrFYBmP/w8U//5IliXUc?=
 =?us-ascii?Q?xGLZOe65QsKmUDNVrAchB9qxmfea3ZgbAnaBptl7Zrh6CGyqUEBMwD+vWd7D?=
 =?us-ascii?Q?i7JhQv9v8aSqHl8I4yhZIItw7qqgwIkFFDlorLewCVfyjaihP20gpqG4TG3g?=
 =?us-ascii?Q?xGTZR1j3+hbta+6rxmaRgtlq8FszAGR/Zciu7IOjWKcGC//CIoKhmJ8lKLPj?=
 =?us-ascii?Q?pDH1D9SEt1bCBsYCflpZynrak3AT+gz5U+4dxnDSjXwr+3v/5JPpb5dVgtTz?=
 =?us-ascii?Q?s19MMBCgz+o7vx3kwEZexDH1Yyg6W5CSiQXxw4f9eFrpFDVNQNzVHxhy48pt?=
 =?us-ascii?Q?kIgU92lwsxK66TJEnC83893aYrCc6k9wLHGCPlBSNPz3Rro4TIUug2AYwTdT?=
 =?us-ascii?Q?acT3QOHlhb5eip6VJBNTdkbGgpQRca/6lbKV4R/Cj1tOmkEXdmNtZ3o1eoH4?=
 =?us-ascii?Q?bf6KF2sYFmTq54A/e+jua8qtDZ9f7kp2E2cU1FofJfXwFQOw/4KsTL+qxAwd?=
 =?us-ascii?Q?APqnT4+/uiN0eQtaxNoretxILkxaMd9trAuugeM4qqGvuF6WUUFZHSWMmJEU?=
 =?us-ascii?Q?zUArTG+QuwE/ATjTel3rKcUMktUB0VNcHrEJqDH2iNWm8J9YNwk32E2585Bb?=
 =?us-ascii?Q?PL60FcEIZDOZ2miKa/sN4wYANOBti/5SW/7aKkzif2cfFmQUuCfHmLYN+VmJ?=
 =?us-ascii?Q?TMoL1wbw4l5T9m+EfVDPavi74p4NnHAs+8LiCLFKkM5SPSco1JJlZh++gyL3?=
 =?us-ascii?Q?uxB6JoapPVpvnOyUSwGUGKuh+TUflrZwxFsBzTwE2v/iHvSagySGzQhyCTL2?=
 =?us-ascii?Q?y0JRXg7uJO7YzKwWB20C7sps?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0511ef5f-2876-442a-83d6-08d967e0b8e2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5600.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2021 15:55:12.2663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /BiBAtUVk0S9sjsZ6T6tgOAGKRlXCqpA9q/E6wp0UoMz5XISUt/MOg/LsGVR4reWe5xapik2hAXsBu6wk+vE8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6671
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 25.08.2021 17:47, Marek Marczykowski-G=C3=B3recki wrote:
> On Wed, Aug 25, 2021 at 05:33:54PM +0200, Jan Beulich wrote:
>> On 25.08.2021 17:24, Marek Marczykowski-G=C3=B3recki wrote:
>>> On recent kernel I get kernel panic when starting a Xen PV domain with
>>> PCI devices assigned. This happens on 5.10.60 (worked on .54) and
>>> 5.4.142 (worked on .136):=20
>>>
>>> [   13.683009] pcifront pci-0: claiming resource 0000:00:00.0/0
>>> [   13.683042] pcifront pci-0: claiming resource 0000:00:00.0/1
>>> [   13.683049] pcifront pci-0: claiming resource 0000:00:00.0/2
>>> [   13.683055] pcifront pci-0: claiming resource 0000:00:00.0/3
>>> [   13.683061] pcifront pci-0: claiming resource 0000:00:00.0/6
>>> [   14.036142] e1000e: Intel(R) PRO/1000 Network Driver
>>> [   14.036179] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
>>> [   14.036982] e1000e 0000:00:00.0: Xen PCI mapped GSI11 to IRQ13
>>> [   14.044561] e1000e 0000:00:00.0: Interrupt Throttling Rate (ints/sec=
) set to dynamic conservative mode
>>> [   14.045188] BUG: unable to handle page fault for address: ffffc90040=
69100c
>>> [   14.045197] #PF: supervisor write access in kernel mode
>>> [   14.045202] #PF: error_code(0x0003) - permissions violation
>>> [   14.045211] PGD 18f1c067 P4D 18f1c067 PUD 4dbd067 PMD 4fba067 PTE 80=
100000febd4075
>>
>> I'm curious what lives at physical address FEBD4000.=20
>=20
> This is a third BAR of this device, related to MSI-X:
>=20
> 00:04.0 Ethernet controller: Intel Corporation 82574L Gigabit Network Con=
nection
>         Subsystem: Intel Corporation Device 0000
>         Physical Slot: 4
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParEr=
r- Stepping- SERR+ FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
>         Interrupt: pin A routed to IRQ 11
>         Region 0: Memory at feb80000 (32-bit, non-prefetchable) [size=3D1=
28K]
>         Region 1: Memory at feba0000 (32-bit, non-prefetchable) [size=3D1=
28K]
>         Region 2: I/O ports at c080 [size=3D32]
>         Region 3: Memory at febd4000 (32-bit, non-prefetchable) [size=3D1=
6K]
>         Expansion ROM at feb40000 [disabled] [size=3D256K]
>         Capabilities: [c8] Power Management version 2
>                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,=
D2-,D3hot-,D3cold-)
>                 Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME=
-
>         Capabilities: [d0] MSI: Enable- Count=3D1/1 Maskable- 64bit+
>                 Address: 0000000000000000  Data: 0000
>         Capabilities: [e0] Express (v1) Endpoint, MSI 00
>                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <6=
4ns, L1 <1us
>                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset- S=
lotPowerLimit 0.000W
>                 DevCtl: CorrErr- NonFatalErr- FatalErr- UnsupReq-
>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>                         MaxPayload 128 bytes, MaxReadReq 128 bytes
>                 DevSta: CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr-=
 TransPend-
>                 LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s, Exit =
Latency L0s <64ns
>                         ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp-
>                 LnkCtl: ASPM Disabled; RCB 64 bytes, Disabled- CommClk-
>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                 LnkSta: Speed 2.5GT/s (ok), Width x1 (ok)
>                         TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
>         Capabilities: [a0] MSI-X: Enable- Count=3D5 Masked-
>                 Vector table: BAR=3D3 offset=3D00000000
>                 PBA: BAR=3D3 offset=3D00002000
>         Kernel driver in use: pciback
>         Kernel modules: e1000e
>=20
>> The maximum verbosity
>> hypervisor log may also have a hint as to why this is a read-only PTE.
>=20
> I'll try, if that still makes sense.

I think the above data clarifies it already.

>>> [   14.045227] Oops: 0003 [#1] SMP NOPTI
>>> [   14.045234] CPU: 0 PID: 234 Comm: kworker/0:2 Tainted: G        W   =
      5.14.0-rc7-1.fc32.qubes.x86_64 #15
>>> [   14.045245] Workqueue: events work_for_cpu_fn
>>> [   14.045259] RIP: e030:__pci_enable_msix_range.part.0+0x26b/0x5f0
>>> [   14.045271] Code: 2f 96 ff 48 89 44 24 28 48 89 c7 48 85 c0 0f 84 f6=
 01 00 00 45 0f b7 f6 48 8d 40 0c ba 01 00 00 00 49 c1 e6 04 4a 8d 4c 37 1c=
 <89> 10 48 83 c0 10 48 39 c1 75 f5 41 0f b6 44 24 6a 84 c0 0f 84 48
>>> [   14.045284] RSP: e02b:ffffc9004018bd50 EFLAGS: 00010212
>>> [   14.045290] RAX: ffffc9004069100c RBX: ffff88800ed412f8 RCX: ffffc90=
04069105c
>>> [   14.045296] RDX: 0000000000000001 RSI: 00000000000febd4 RDI: ffffc90=
040691000
>>> [   14.045302] RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000=
0febd404f
>>> [   14.045308] R10: 0000000000007ff0 R11: ffff88800ee8ae40 R12: ffff888=
00ed41000
>>> [   14.045313] R13: 0000000000000000 R14: 0000000000000040 R15: 0000000=
0feba0000
>>> [   14.045393] FS:  0000000000000000(0000) GS:ffff888018400000(0000) kn=
lGS:0000000000000000
>>> [   14.045401] CS:  e030 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [   14.045407] CR2: ffff8000007f5ea0 CR3: 0000000012f6a000 CR4: 0000000=
000000660
>>> [   14.045420] Call Trace:
>>> [   14.045431]  e1000e_set_interrupt_capability+0xbf/0xd0 [e1000e]
>>> [   14.045479]  e1000_probe+0x41f/0xdb0 [e1000e]
>>
>> Otoh, from this it's pretty clear it's not a device Xen may have found
>> a need to access for its own purposes. If aforementioned address covers
>> (or is adjacent to) the MSI-X table of a device drive by this driver,
>> then it would also be helpful to know how many MSI-X entries the device
>> reports its table can have.
>=20
> See above.
>=20
> Does PCI passthrough for on PV support MSI-X at all?

It is supposed to work. The treatment by generic code shouldn't be overly
different from how MSI-X works for Dom0 (Xen specific code of course
differs).

> If so, I guess the issue is the kernel trying to write directly, instead
> of via some hypercall, right?

Indeed. Or to be precise - the kernel isn't supposed to be "writing" this
at all. It is supposed to make hypercalls which may result in such writes.
Such "mask everything" functionality imo is the job of the hypervisor
anyway when talking about PV environments; HVM is a different thing here.

Jan

