Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEDD91778D3
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 15:28:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727719AbgCCO2B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 09:28:01 -0500
Received: from mail-eopbgr80113.outbound.protection.outlook.com ([40.107.8.113]:5376
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727369AbgCCO2B (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 09:28:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VJmPLIj0bmcI6xcNK73QjAeNMqVi1zv7WQ/vQ2Ol5b2erwPWwB7MXNmIl4Wx67e7JMqiUFWJdKHmP9INS1sVN7nb2Cvy/Mm5Tu8jrAPEMKl225h+q577G4juUqlfJwZXlqwO55WVA9dxst5Ny7MHKCxn+hijcZjXIPg+qzgGMB/XE1U5TgJ+h6s7eX0192ZIQCmFHzIvZkk/0kcwqGT5zgUnPkzxM59DYe36wKHOqtFyFUuHpSxWscy27EqHQQPeF+Ct2zL1oOS4D02bJ+cqiayvxFmQbxQrFt270of8ey94ZZZ+ovmVSaLvg5zUDFTpKQ77nHOcTiSs1onQgGG0AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Gsl9LHSNbJAVENyBOjM96BfzCIaSu9kdmOa/WHUJD4=;
 b=kQ+2qgqg9IPVePXdyaTov0R5qEAgRN/UFBKlpJk5wcHjeipU4R3agsDE4c/r09NdeN06gLPnurGWambrPHTkYyACC6+NjI0N7sZBgjVo3XR7guYXSYNEI6FTITXUfTDv61Hq+2FS8ckIUmSUiiUGif6aRSOJ0fkzl5iFpsAWilP58RqBRUnxp9dcGVFLO15nWavuF9YHHs+ZABplX1FBM5iHpEVbdRAoNMEnivcM4FFK6Gp3aKSDTjdIi+nXhdYS3vcjWdnDV/xYUtX9fb5Sw4BNl/nnLMS8du8UzB/14/5d8a9IkarIWx0Ql0hLG2h+XcvdN1eNaFTxey/nC2AKkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Gsl9LHSNbJAVENyBOjM96BfzCIaSu9kdmOa/WHUJD4=;
 b=FsuX/uFanGvm8FBhO/r2KRERBXP8fv0T6sCWsBGf6K9J5+fYUnf1SGqMRtNUWsHMe8DfYewFOzIHhWqsKLE1+xcpMrK5iF+062x4iYrpRfCbmihZkwo8ZRbex8rTW/MVkeugV7HXCq8q1yNnZaUNf56K/KP6RafY/d/Pshr9tnE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=alexander.sverdlin@nokia.com; 
Received: from VI1PR07MB5040.eurprd07.prod.outlook.com (20.177.203.20) by
 VI1PR07MB6126.eurprd07.prod.outlook.com (20.178.121.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.9; Tue, 3 Mar 2020 14:27:57 +0000
Received: from VI1PR07MB5040.eurprd07.prod.outlook.com
 ([fe80::f5f9:e89:3fef:2ffd]) by VI1PR07MB5040.eurprd07.prod.outlook.com
 ([fe80::f5f9:e89:3fef:2ffd%7]) with mapi id 15.20.2793.009; Tue, 3 Mar 2020
 14:27:57 +0000
Subject: Re: [PATCH] mtd: spi-nor: Fixup page size and map selection for
 S25FS-S
To:     John Garry <john.garry@huawei.com>,
        "chenxiang (M)" <chenxiang66@hisilicon.com>,
        linux-mtd@lists.infradead.org
Cc:     Tudor Ambarus <tudor.ambarus@microchip.com>,
        Richard Weinberger <richard@nod.at>, stable@vger.kernel.org,
        Marek Vasut <marek.vasut@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Boris Brezillon <bbrezillon@kernel.org>
References: <20200227123657.26030-1-alexander.sverdlin@nokia.com>
 <18cdef63-75e3-97c3-2a22-4969d4997af9@hisilicon.com>
 <60b272c1-ab6a-7a7a-6f56-03d7c7daf8bc@nokia.com>
 <43ae2554-06c8-59f9-153e-094a326166c2@huawei.com>
From:   Alexander Sverdlin <alexander.sverdlin@nokia.com>
Message-ID: <5d6f3062-677f-3d0d-b0d7-7c97c658ed89@nokia.com>
Date:   Tue, 3 Mar 2020 15:27:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
In-Reply-To: <43ae2554-06c8-59f9-153e-094a326166c2@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: HE1P192CA0004.EURP192.PROD.OUTLOOK.COM (2603:10a6:3:fe::14)
 To VI1PR07MB5040.eurprd07.prod.outlook.com (2603:10a6:803:9c::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ulegcpsvhp1.emea.nsn-net.net (131.228.32.167) by HE1P192CA0004.EURP192.PROD.OUTLOOK.COM (2603:10a6:3:fe::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14 via Frontend Transport; Tue, 3 Mar 2020 14:27:54 +0000
X-Originating-IP: [131.228.32.167]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a4470b2f-c068-4656-de86-08d7bf7f1151
X-MS-TrafficTypeDiagnostic: VI1PR07MB6126:
X-Microsoft-Antispam-PRVS: <VI1PR07MB6126F3ED2E4539FA5570AFA488E40@VI1PR07MB6126.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 03319F6FEF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(376002)(346002)(39860400002)(396003)(366004)(189003)(199004)(6512007)(8936002)(31696002)(81156014)(5660300002)(7416002)(81166006)(66476007)(6486002)(8676002)(86362001)(4326008)(66946007)(66556008)(52116002)(6506007)(53546011)(26005)(36756003)(316002)(54906003)(31686004)(6666004)(956004)(16526019)(966005)(110136005)(44832011)(2906002)(2616005)(478600001)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR07MB6126;H:VI1PR07MB5040.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: nokia.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RnmVXC9MaLyq6x/ukpe3//GsU5/6UVCu6s/MfffUe61ogf6KteUe+2Y9sJlLuWbfjYKZHVu/PCoucYiZQHX9SEibIUbEAr15jwkZHs/xYQbfd3i66RdDNGri4PDf6N8cilPndiJTNSCZ1/WZPX+yKvnLRBKnF9Ls2SmbXepROPgrQTgC9JLPE+9P6odw/tZkQtOeC4FjsMwRDjcb831uL2Yp8R+/yr5Nb2IYJ9lE6J4sbF0fvq/XcvWKr1eCObUFidK3ZcuU9/PvqtwSQRgL9nPEaxcPY32KJIHuAlGHOsPydK6bXCIPZgwZ+rsMWmktFpGGYvz0rr38pWF4+XgxNcJ7G5ssTBVGqxTmoEPJM8v6DAxVBqxNiNRE931h6WMcDNg93CyfQ+h2qEeRfFjEcM3dvI7UjQbKNqUjMDXOLwQ/BZQlFky0P7XL4ofYyGhdfKuZ12rrWnYU270/eXlctPC6Kl+yj15RVVZNuV7m/+IVB6yntzte/poTmPJ4et1I0snjcmQKuk0V8dqf1rP7GA==
X-MS-Exchange-AntiSpam-MessageData: 6upneDgBywY1C3ZiuGvpnyZVN4NlynacA22Q3qTXFjaglhAnqbc65wtqr0K8QEMrHn5uaKj87T5k2UDIIxT7O0Mqd5XT/khsUUOitRmVLldAEnKytrYqrHYNFeweiLynpf/WHFh34lpwjYetARPLuw==
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4470b2f-c068-4656-de86-08d7bf7f1151
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2020 14:27:57.2322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o8oU7rsfwQ61D0VobIScOsb5x5g/BjtBJEF84xNaCOtz9F/0tx1hQkKyjyrhh4cNnnyh8jMr3tUMm93oRVQH+g0DL1oEO/FVtb7sc43qqXs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR07MB6126
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi John,

On 02/03/2020 19:25, John Garry wrote:
>>>> -    { "s25fl129p1", INFO(0x012018, 0x4d01,  64 * 1024, 256, SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR) },
>>>> +    { "s25fl129p1", INFO(0x012018, 0x4d01,  64 * 1024, 256, SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR)
>>>> +            .fixups = &s25fs_s_fixups, },
>>>
>>> It seems SFDP is not supported on s25fl129p (you can check it on https://www.cypress.com/file/400586/download), so is it necessary to add this for this type flash?
>>
>> Yes, all of the above is necessary to repair S25FS128S, which supports SFDP and lands
>> in the above table entry.
> 
> So do you know how we can tell if the part is s25fl129p1 or S25FS128S? Is it based on family id? For the part of my board, it has the same id according to "s25fl129p1" entry in the spi-nor driver, yet the SFDP signature is not present (signature reads as 0x4d182001 vs expected 0x50444653). I printed the family id, and it is 81h, which seems to align with S25FS (which should support SFDP). Confused.
> 
> What's more, the spi-nor probe is failing for this part since I enabled quad spi. So I am interested to know if there is some differences between these part families for that.

I'd say, one can distinguish them by the fact one does support SFDP and another doesn't.
Is it really necessary to distinguish them?

-- 
Best regards,
Alexander Sverdlin.
