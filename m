Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD1802AD3CF
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 11:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbgKJKax (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 05:30:53 -0500
Received: from mail-eopbgr10139.outbound.protection.outlook.com ([40.107.1.139]:40385
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726690AbgKJKax (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Nov 2020 05:30:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B16f5G//vKC7hhc9ZOQk+obRlsO7QfzZPmVX5yFAQJjJ8JNy5l2WefhG4gB54GT9Bs/soAQGVqx0SvERJrBJS2OMhdYF0Wd3BqkAOp1trkRGMMuIzk6UIrWUgTQ7DOnKHMyuGuosBTqxR+NWIFFCl7zBtrqJcuLFfcGb6KIES3rBzKwsK7dLE+w4bhd3KKU7qiFCc5q+3+5b8VOeb0jhyR7+NAEEv3ctyoQ/vdzxRXPu3ifYBxwD8y+jCIq/HEEhcI8ufOZDWFwCEUoRZhBsW4QRAPJHAYdW20DuxZV0f/elh1b0JhfmMDrm1xuLBRCJtDt5lhkOqUJ946XwkLme9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TV4R7XflGxnu7hzXQe9xiwN6gBdgYgA8u4CDLHGNy0U=;
 b=GRyQvLfuVx5vB9KPSL+0Y1THmrPheHt/hz+nrz4h3jwOaklWYkrN7wURilPUhQ4cGDTJTb0Z3k8F+NaPRuIHy6dq4wpZ29sNz3szyBv1ySAey+AR0OvKOuPtudL0IietYHr2WhKV4GVoxymeBnPXbpT5M8zgJc4nLymWEPZZ0b+EumgoFW7WN3jEb2A+v4S79w6pWugWHpoMcH0E3Q8OVtLjd28k5ZAnsfcMhZfgnHqr6RIa13Dp+jsre5UsfsA4fq6yDqC19z4xD4sr3LIw511+aHeRuZOVsjx3wmTqWkKPTmB461kx13r+M7+FKpSRdv/i3SQipj0klCy/2suhzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TV4R7XflGxnu7hzXQe9xiwN6gBdgYgA8u4CDLHGNy0U=;
 b=PufXMx+5GRnq18Kn/0ZYK4F/q8mqbLwNB/o+TPscUl/MqQ0DbwoFbiLYTIPHpIivijJBSJcDt1WovtQTsO99qfajJxEcOot1Es3tbA9kwVSIg2hrJVVKrEj7GYS+Q+gfB1KFbF6pY55ENLs9nVKwxB02s7WFl5i3XfpLnEfSd/Q=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nokia.com;
Received: from AM0PR07MB4531.eurprd07.prod.outlook.com (2603:10a6:208:6e::15)
 by AM9PR07MB7331.eurprd07.prod.outlook.com (2603:10a6:20b:2c1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.14; Tue, 10 Nov
 2020 10:30:46 +0000
Received: from AM0PR07MB4531.eurprd07.prod.outlook.com
 ([fe80::d527:e75b:546c:a85b]) by AM0PR07MB4531.eurprd07.prod.outlook.com
 ([fe80::d527:e75b:546c:a85b%6]) with mapi id 15.20.3564.021; Tue, 10 Nov 2020
 10:30:46 +0000
Subject: Re: [PATCH] MIPS: reserve the memblock right after the kernel
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>, linux-mips@vger.kernel.org,
        Paul Burton <paulburton@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20201106141001.57637-1-alexander.sverdlin@nokia.com>
 <20201107094028.GA4918@alpha.franken.de>
 <1d6a424e-944e-7f21-1f30-989fb61018a8@nokia.com>
 <20201110095503.GA10357@alpha.franken.de>
From:   Alexander Sverdlin <alexander.sverdlin@nokia.com>
Message-ID: <c435b3df-4e82-7c10-366a-5a3d1543c73f@nokia.com>
Date:   Tue, 10 Nov 2020 11:29:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <20201110095503.GA10357@alpha.franken.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [131.228.32.167]
X-ClientProxiedBy: AM8P192CA0006.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::11) To AM0PR07MB4531.eurprd07.prod.outlook.com
 (2603:10a6:208:6e::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ulegcpsvhp1.emea.nsn-net.net (131.228.32.167) by AM8P192CA0006.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21b::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Tue, 10 Nov 2020 10:29:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c0a1726e-66db-450f-023d-08d885638f2c
X-MS-TrafficTypeDiagnostic: AM9PR07MB7331:
X-Microsoft-Antispam-PRVS: <AM9PR07MB7331B460D94A5E86C5BECAA888E90@AM9PR07MB7331.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tfIhtpiiDRC/d72PK/Z9CTF8Zajp6Y3ukHYjFAZf6ESsA9XACR0cvL6UCkjI/o4O4uR8/brhKHrJ2rwPBfgYPGXz8URt1K1VjlSg9eK26iAp13973kMsBpua7ZNDjJqUD6T67k+8DJRTwfpsdO5Jl07t9gaK25lJzZJVWDfuCW3ucUKsoS75SJmcgrcrx7SLI/FvaKZpBr4PfxurDgpUk6T/dvscKnxp9bcRDqXRcjqLb+w7UshzJurfUh9xbvtzCN4fpF9OFkJ3LlEmc3ewCdJ6LctKnwPIPmG0cAnPYx5HRzy0YHXgUAc0/5fHC8T2OUnqoZ1BazWTVoYI6iomOT516KRmTKtysjSFhxCQ78r6cwn9Yp0BCORvJfBQsa8Q
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR07MB4531.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(39860400002)(346002)(136003)(376002)(4326008)(2906002)(86362001)(2616005)(6486002)(31696002)(956004)(66946007)(66476007)(31686004)(44832011)(83380400001)(6512007)(52116002)(6916009)(54906003)(16526019)(478600001)(8676002)(36756003)(66556008)(316002)(186003)(6506007)(53546011)(26005)(5660300002)(8936002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: K1zsaJemikhFuklT3C48ZVmW8NqolWPmjzFWrkdv0dg1+J51UXX7eMYLixDlkIr8F7elMqwT7+D0WrTfOtKlkpdj2u99sTq93o495y0+tlHYskHs3mqO18dZjl7CqsmHMzdaNoVOodZAYKYdtKX3hb5sN0DUXhhXvdajCTejbAoq2zs/s5th57WBxpLl/WXwPUJVqb/WgOZATjKLqPxYkKrnJ5c84OwsFF864pUwxZrWNDNLfAcKlfn3Dcnt1oLf7C8wkvpOVSnHrrBtutnfWUJdgqAIf30vRbzzsLKslZPFB8ib0qlzIoOIRSSaE/GXGiqCOMZttuYHccvM7HKufYDJVS4u3wHosDxsHenlALJ28qLsNnEX6gOtrUh4+9kaRIz2MYnTM1ZxoQ3SpH027JRDlxeGgNulHCh+/0qZSjBPNX2HOGOXsemRS9mfEGHbo+UKHM4r8G9WUCKoTzinBdWUdEtUe5NNLIo4Q+LPlkBSNc10B4s9RFWEKPn9bPYW4d/ZaFn6+1ML13BE70TdTG2rJ6ZKCH52hTHXc0c6fSm4Vt7QejuorGo9RxaovoqbVCXfOr6G7EJ0Uii77gjb2V/YcW3TtKgHIvv8f/Qg+GSFgOvoYJpmcKXo9cesg01xu4Qj7fX/38Iw8NM8ra2hz4VAoUZY7HmIEp3nql0h5Ixh9b31bmAq0gjjmixopyWeJcd/4kLs8jmSOXObVIsxFIXgNI8kQ7f3f1KWCEIF2Y3GXNYZBrvc/aTnhZbUqP+474Lj2Pxe4q0lO0LMwNXDZee2LraX66SaTVIIS60OQls2gGwveiSulNPgaMWWg724ew9fNZcT1CUB2V81U7tDEw1usMdfG2BQzppIUeBKM5yKJFU6OnuP9C5lQDT756ofuh2k1ba7twMBIldbqV9RVA==
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0a1726e-66db-450f-023d-08d885638f2c
X-MS-Exchange-CrossTenant-AuthSource: AM0PR07MB4531.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2020 10:29:52.4515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mxb2rDnRshTe/RoMX1u1H9Exdh9b8rVbvkWbHJJIaMKZHGd60dQ7kZ669/sWmvElD2Euj3V20MUVAo4wrv1fjyDegT9cbwEyDcgRMreAnXM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR07MB7331
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Thomas,

On 10/11/2020 10:55, Thomas Bogendoerfer wrote:
>>>> Linux doesn't own the memory immediately after the kernel image. On Octeon
>>>> bootloader places a shared structure right close after the kernel _end,
>>>> refer to "struct cvmx_bootinfo *octeon_bootinfo" in cavium-octeon/setup.c.
>>>>
>>>> If check_kernel_sections_mem() rounds the PFNs up, first memblock_alloc()
>>>> inside early_init_dt_alloc_memory_arch() <= device_tree_init() returns
>>>> memory block overlapping with the above octeon_bootinfo structure, which
>>>> is being overwritten afterwards.
>>> as this special for Octeon how about added the memblock_reserve
>>> in octen specific code ?
>> while the shared structure which is being corrupted is indeed Octeon-specific,
>> the wrong assumption that the memory right after the kernel can be allocated by memblock
>> allocator and re-used somewhere in Linux is in MIPS-generic check_kernel_sections_mem().
> ok, I see your point. IMHO this whole check_kernel_sections_mem() should
> be removed. IMHO memory adding should only be done my memory detection code.
> 
> Could you send a patch, which removes check_kernel_section_mem completly ?

this will expose one issue:
platforms usually do it in a sane way, like it was done last 15 years, namely
add kernel image without non-complete pages on the boundaries.
This will lead to the situation, that request_resource() will fail at least
for .bss section of the kernel and it will not be properly displayed under
/proc/iomem (and probably same problem will appear, which initially motivated
the creation of check_kernel_section_mem()).

As I understood, the issue is that memblock API operates internally on the
page granularity (at least there are many ROUND_DOWN() inside for the size
or upper boundary), so for request_resource() to success one has to claim
the rest of the .bss last page. And with current memblock API
memblock_reserve() must appear somewhere, being this ARCH or platform code.

-- 
Best regards,
Alexander Sverdlin.
