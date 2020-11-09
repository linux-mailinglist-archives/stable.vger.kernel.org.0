Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5823C2AB618
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 12:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729782AbgKILIM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 06:08:12 -0500
Received: from mail-db8eur05on2101.outbound.protection.outlook.com ([40.107.20.101]:15425
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729812AbgKILIJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 06:08:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BOFUL40UomkH2gBiDQ2BOayTKkF9OyCTWW4YCOQTAA3rhKdfUdJmenSPwW87vo2hnKohiNyRLVSc6IVJH+/X3iTvdumq+Ys+M3VBDN8NbbNF9yBo1lSgTZNavknv+mFVBfRNlG2oKaslwwjh9OdqOFdvZu5tVE3x0RSGfaXLzeuoFGby9YWyN+F35QheRE0esi2kctECkBtAMRuImYsMj+p6XR2YgVavLgA+UYFhKuhFa/ZAy6JLVUfgW+r2/coIr7HKT0PbrWAuNbVdes15YrUjA0H9a/eaOK+3hjkiMQkp+h9i0ovBs4VYmEBqgFlhFpHO61nRl7zoRospko17RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UaFvSpialcL94jFqE0HtOKmPJviQGVC6NK/Ql221lrs=;
 b=gE9ufJlzWO1ap3rXtX9plGjVr+nhVm1fFaOOyEHa+NSjaCuLdbckkggsyPqL3aj766M76R5YE5zTgtaXmxLHbi8hyWYmkVVMIPWCdfR58RVE3KKSgvnygd662bctg9rtpArb1OM0JfQIEVruAzD/7pTzPUAAjLN60FIQgbDDK1k+NKma11O/z+7eqatG/WwABWt2LZJjkF4/1dLR+ilHORYA4SlEesMKR/Z3t3y2RO4n08LdkzLNl0FgTCDjOvKP5C5kMT6XGf9TGMiss0WSmHHnY9SweHxSkcczBVE0W3psQUr1ueJD6ZUiXfpGbXjL0l2tM1z/PZKRE3/u5Eq11w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UaFvSpialcL94jFqE0HtOKmPJviQGVC6NK/Ql221lrs=;
 b=xZP116hDQZr71JcGV0YlSoSNeSsK11O4PHM9uzYZSuTg9PgOkNtK1IxT7GAQUyJ/T00AKdi8tZH5dJ+fn6dpH/u/CpP7atmwEoZNGCgkjUzpHmGPrxgCL4XEMViNikx9XE8kjBBaggW9QhbUAy8bA32HGPqqgFKCPiw/XqIY2Vk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nokia.com;
Received: from AM0PR07MB4531.eurprd07.prod.outlook.com (2603:10a6:208:6e::15)
 by AM8PR07MB7393.eurprd07.prod.outlook.com (2603:10a6:20b:246::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.14; Mon, 9 Nov
 2020 11:08:05 +0000
Received: from AM0PR07MB4531.eurprd07.prod.outlook.com
 ([fe80::d527:e75b:546c:a85b]) by AM0PR07MB4531.eurprd07.prod.outlook.com
 ([fe80::d527:e75b:546c:a85b%6]) with mapi id 15.20.3564.021; Mon, 9 Nov 2020
 11:08:05 +0000
Subject: Re: [PATCH] MIPS: reserve the memblock right after the kernel
From:   Alexander Sverdlin <alexander.sverdlin@nokia.com>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>, linux-mips@vger.kernel.org,
        Paul Burton <paulburton@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20201106141001.57637-1-alexander.sverdlin@nokia.com>
 <20201107094028.GA4918@alpha.franken.de>
 <1d6a424e-944e-7f21-1f30-989fb61018a8@nokia.com>
Message-ID: <27310707-78d5-0f96-7048-749db4959a07@nokia.com>
Date:   Mon, 9 Nov 2020 12:08:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <1d6a424e-944e-7f21-1f30-989fb61018a8@nokia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [131.228.32.167]
X-ClientProxiedBy: AM9P191CA0026.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::31) To AM0PR07MB4531.eurprd07.prod.outlook.com
 (2603:10a6:208:6e::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ulegcpsvhp1.emea.nsn-net.net (131.228.32.167) by AM9P191CA0026.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:21c::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Mon, 9 Nov 2020 11:08:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e92e3848-edb2-4217-b076-08d8849fbb9c
X-MS-TrafficTypeDiagnostic: AM8PR07MB7393:
X-Microsoft-Antispam-PRVS: <AM8PR07MB7393F831A1083DA6738DE26088EA0@AM8PR07MB7393.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0B19l6SF4fH8QY/6OuYDpvOpo0kkiPfQLiiYMIEe1aY9kUvRYiY7SOS7UYlNXSxLjtiLSMb7fGvlz5LyHEnpSqm1DMvlfcm13toEap4VbuFcrVjQrtkFJgxFnE5afMpzPqcq9JrHoZwchspe1vLdLmm4clCmhTPiKyp5UnWpqTXqVimetcVXXhEARz6d85OeBv7McvnLnlHbHBF+adFpVODJ8DtAbYtTxRA9DYGMJSRV9oeOzwDmhG0n0zzeZ0NISkcUfBJYNCwOtB+nShQM6Z+ekXWOKd7E9VYxxuIJTMumzlbCsYFOmpKaVjDR7DEkHCSrH+Vw1iQZ2Y2+MQPbNpmvg3LBVHK+Y/1mAqZTUxgUSEkjI/ioRp04ZbIKg6O/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR07MB4531.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(376002)(366004)(346002)(136003)(5660300002)(83380400001)(6486002)(31696002)(66476007)(8676002)(54906003)(478600001)(53546011)(6506007)(26005)(44832011)(956004)(2616005)(52116002)(316002)(31686004)(86362001)(16526019)(186003)(8936002)(6512007)(4326008)(2906002)(6916009)(66556008)(66946007)(36756003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: XlGUxJ/wrzmtGFN8/tXIIUFvHAuPjUotGpmIzv85UXO/DyXI1SAiqveFcbo0KGZYMfPccuQT0B+QOpJdlyMGXZwdsnAR0hws3BqI3lcHiE/sNLHICgXPJ/ulbC0QEFfvhnFQOTNddktfzQitDpZG9mvGqLfY/jPvNNN+2Vf/42yWu1yPVBmLgLR6HWDg3E9BazcuACuOfVyMHphhFsYq7BlMkB6hm+aaT+Tvy/h61yZLK2yxHZvwzeJx+PgSojLs/V999YxS72j16T//XZP+Jj19BSvkKUtFXjB87LTfBDK9urYUsZA+DQ6NTCR3AQVFh/ERYzq14gJHsSVmyY56W031pJ4i+Sqv6XcpP2/Hu1woeMxklRSfZYV9ybyjjjAV8cdXPC6qXoSH3TYubfvlquxUK1fW0aQnI3BPHaQaO/syX3MGIQmDt87J51/WvEiMISFVZ+Bb8B/kh6OCmrSfhq2x3Il34sIajFyTJ4ephagaRoCT6ZLU1QViiGiQj+46Z0S3dLdzaEHkP3EkdlrXRQZDn/8LrEnXSx2Td8jnAG4zbgM3Q6QdjRO+ejnE+Iv5Iay3fY7EHIFpEg56bCdZBNX1nQuNy0jFKeDFf+4YvkLAfDfgqK05qLUfuctB2kyIQfB/gRjDRh9e/nlvH+ayEEnVP4P+D4gnq1o1PqxCFArbDIfhcPKnRvgjipb3+jLIbYCwaRsjr7PmXwVMHbWSU7bdNW+B5Sjv77z7PNC1yhQyT7vAwtrxu3fVmBRjNf+VUQ5T7CRfC2Nzv8dPrN2B+SsttXwZVSi8qHYEdCNfSGXj97ERUIGMlEoEJutxQRELMV6zHGzMVvNzLtQstObOd4g98PepEyvWuSYJF6abPmZUrGjD7frdLGgyM6EQsmyCtiReorl8rPUSSjkPfF9CQQ==
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e92e3848-edb2-4217-b076-08d8849fbb9c
X-MS-Exchange-CrossTenant-AuthSource: AM0PR07MB4531.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 11:08:05.6617
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y/ubUEsn15/0kc2pqBE3DUGkfJ2DphkEJWQPSHFFx0LSDLChrLgkgUD04vtJLwYvPXX9crkJuLrQ8qRgs13baDOK5AdUo9TPl4rF6w/BZ1w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR07MB7393
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Thomas,

On 09/11/2020 11:34, Alexander Sverdlin wrote:
>>> Linux doesn't own the memory immediately after the kernel image. On Octeon
>>> bootloader places a shared structure right close after the kernel _end,
>>> refer to "struct cvmx_bootinfo *octeon_bootinfo" in cavium-octeon/setup.c.
>>>
>>> If check_kernel_sections_mem() rounds the PFNs up, first memblock_alloc()
>>> inside early_init_dt_alloc_memory_arch() <= device_tree_init() returns
>>> memory block overlapping with the above octeon_bootinfo structure, which
>>> is being overwritten afterwards.
>> as this special for Octeon how about added the memblock_reserve
>> in octen specific code ?
> while the shared structure which is being corrupted is indeed Octeon-specific,
> the wrong assumption that the memory right after the kernel can be allocated by memblock
> allocator and re-used somewhere in Linux is in MIPS-generic check_kernel_sections_mem().
> 
> I personally will be fine with repairing Octeon only as I don't have other MIPS
> targets to care about, but maybe someone else in the MIPS community will find
> this fix useful...

another reason for not putting that to Octeon platform code was the fact, that one
would need to put the knowledge about wrong assumption of ARCH (MIPS) code into
different code area of Octeon platform.
If at some point in time check_kernel_sections_mem() will be altered/fixed, nobody
will understand why Octeon still has this workaround.

-- 
Best regards,
Alexander Sverdlin.
