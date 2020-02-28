Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22D84173146
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 07:46:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbgB1GqS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Feb 2020 01:46:18 -0500
Received: from mail-eopbgr80108.outbound.protection.outlook.com ([40.107.8.108]:45732
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726785AbgB1GqR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Feb 2020 01:46:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D5f4b38SKBV1KU6ucy/E4h6FQKd61IuTAlaAeD/CJE20Jimoqgne4soVEP71Y2WNlo5gSFBJ69egXknJhG5xbflakN+GB1cpE1KrSF0P2SmhQ1VfZqEtzKas++mg/jMMSElnilwlvctqMJX2imwK9NL9+Ylhv1zwx4Kex6yiScdzlaHqjSgbtwNjiIK7+tf+NC39xRNr5rOZanaUTEFzQzwV8FT90+lcCCbVYe+9KWrNKWaODvvLfhGvqSsCRa1YTt8EkvBZSCs1J0JOsb73QDFfrL3ZZcOCVGndTeZSDmDoxTKJfQXqaxaWSZfVEWMt6hyXptwvkabktU5rKw9XLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EV9Axk5gqWSfJp/klgutHTSYhdHwZnK5WYbv0YHcanc=;
 b=gEoL8mCepyydbmyGV39m2cYTdqB38+O6HBrUsZGzUIwe2/EIje7SdN7WgAbbW1LTZWy/jyL07O6BQfsB9ndViP4rrudOt8sz3VM12TRtcyR2qRgtqCff5Mn9CZpdV0MRA9oc6zDbzl7987D8aMiF7X5/QiIwYAmvPf/LO0N5vXZV1R+3D8rakuFplORNIjorQSfvIPR6mXR09ONtAUyKHKDZCjxKSzEiStfgI/cqFXHXDUqDrEyWepRplos4aHa2TBH10I2JZAAYdrBqsByjodgg1oSFz7E9t/bvzlyI55wZwjm9HTAxSrBouVD33pmAujgySc1LaJgVZLARUs1ilQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EV9Axk5gqWSfJp/klgutHTSYhdHwZnK5WYbv0YHcanc=;
 b=tKEdVUpfvJynLiml0KHepRFMw+6Y7crR/3brslAU5CToDL6zV1Z32gEbpG0T6kABtQX5zM1zvnCl8x++Q+QvATF0p+kYVRkf3jpoADcjN2u/CWEY82+RSgql21+Y/KPkvK2XUQ5PEq4tTlLxOvdUZEp1K1XZJtXJyyPKz/rPxt4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=alexander.sverdlin@nokia.com; 
Received: from VI1PR07MB5040.eurprd07.prod.outlook.com (20.177.203.20) by
 VI1PR07MB4912.eurprd07.prod.outlook.com (20.177.200.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.9; Fri, 28 Feb 2020 06:46:14 +0000
Received: from VI1PR07MB5040.eurprd07.prod.outlook.com
 ([fe80::f5f9:e89:3fef:2ffd]) by VI1PR07MB5040.eurprd07.prod.outlook.com
 ([fe80::f5f9:e89:3fef:2ffd%7]) with mapi id 15.20.2772.012; Fri, 28 Feb 2020
 06:46:14 +0000
Subject: Re: [PATCH] mtd: spi-nor: Fixup page size and map selection for
 S25FS-S
To:     "chenxiang (M)" <chenxiang66@hisilicon.com>,
        linux-mtd@lists.infradead.org
Cc:     Tudor Ambarus <tudor.ambarus@microchip.com>,
        Richard Weinberger <richard@nod.at>,
        John Garry <john.garry@huawei.com>, stable@vger.kernel.org,
        Marek Vasut <marek.vasut@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Boris Brezillon <bbrezillon@kernel.org>
References: <20200227123657.26030-1-alexander.sverdlin@nokia.com>
 <18cdef63-75e3-97c3-2a22-4969d4997af9@hisilicon.com>
From:   Alexander Sverdlin <alexander.sverdlin@nokia.com>
Message-ID: <60b272c1-ab6a-7a7a-6f56-03d7c7daf8bc@nokia.com>
Date:   Fri, 28 Feb 2020 07:45:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
In-Reply-To: <18cdef63-75e3-97c3-2a22-4969d4997af9@hisilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: HE1PR09CA0046.eurprd09.prod.outlook.com
 (2603:10a6:7:3c::14) To VI1PR07MB5040.eurprd07.prod.outlook.com
 (2603:10a6:803:9c::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ulegcpsvhp1.emea.nsn-net.net (131.228.32.167) by HE1PR09CA0046.eurprd09.prod.outlook.com (2603:10a6:7:3c::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14 via Frontend Transport; Fri, 28 Feb 2020 06:46:09 +0000
X-Originating-IP: [131.228.32.167]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7aefbff8-cc4a-491f-66b7-08d7bc19e7cd
X-MS-TrafficTypeDiagnostic: VI1PR07MB4912:
X-Microsoft-Antispam-PRVS: <VI1PR07MB49120E1FD34453C4C1D24DE288E80@VI1PR07MB4912.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0327618309
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(376002)(346002)(396003)(39860400002)(136003)(189003)(199004)(6486002)(8676002)(81166006)(8936002)(52116002)(966005)(956004)(6666004)(26005)(44832011)(81156014)(5660300002)(6512007)(53546011)(36756003)(2616005)(7416002)(16526019)(6506007)(66476007)(66556008)(66946007)(54906003)(31696002)(2906002)(478600001)(186003)(86362001)(4326008)(316002)(31686004);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR07MB4912;H:VI1PR07MB5040.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: nokia.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SmXJA+P715+++PuEjnPUEEwpzB3dWrlr6RuCdDHT/nBiPBewGc7IH3o3rO58YFvWE1PClLkPUUSpAwPxpJHjrMCE/AEwlj8iz++qvnc6BMez1c7ymRjcdHq5kzds+LD/CuOzzoswdcxtYQkCP+ZPdQx2numR4sCMXY8EM9ItJOLEGtCclL/vSp3r52Rz+K18QS9nqnhXT7mk7nka/EqEKeedsRin2swyI9N+aUNaEeKlUQ9eZ5J957RtJwSBmZWHQSPHZegaum3u51xy9xw+yarLDVDP3MCPBpUNaFNG+8wJwhshZKSNS96TyVWMHS2G6ilGY4SYFGL5LlDVXR5P6yAehgfX70XnKIRQZL9So9HTQ98+PFpKN6dzlD07dfYxAzWmH/QgKfQD7CIS/J3orn+97584hOo5l5k6hs/WRpeuw/G7zelcSSei8R1AB46u8FUk3vfZd+dDfoSqaHukXFtVuil0QPD4ivWkxK2b8WLlw+GsufRc351gDgG8+0gZn2EwsDGEHchvGgm/7JOGvw==
X-MS-Exchange-AntiSpam-MessageData: 0O57UeFA3OCtjRo/0xGYZTfVrB97KQdfg/SM8CvY5ADMQY+zTIUR71uzgGD2fD1LrbcGXl5hnGfdb5B3o0wVU8myvBMWFszgnh2V+PM9YBg88Mwek/VuCFfy17nYeLGjL4UekTRQkE/YOJkyLIrufg==
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7aefbff8-cc4a-491f-66b7-08d7bc19e7cd
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2020 06:46:14.6716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /QSE5EJynjEsHOUKZvOJh7F5m1HA8pL461JujW1CozU7sxUEsEmWIgDpUbUs3qXkF3dUjBrfFv6y947UaH0xU4q8x2jAA9RwcIe3Qs53EAA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR07MB4912
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi!

On 28/02/2020 04:01, chenxiang (M) wrote:
>> JESD216 allows "variable address length" and "variable latency" in
>> Configuration Detection Command Descriptors, in other words "as-is".
>> And they are still unset during Sector Map Parameter Table parsing,
>> which led to "map_id" determined erroneously as 0 for, e.g. S25FS128S.

[...]

>> @@ -2570,7 +2687,8 @@ static const struct flash_info spi_nor_ids[] = {
>>       { "s25sl12800", INFO(0x012018, 0x0300, 256 * 1024,  64, 0) },
>>       { "s25sl12801", INFO(0x012018, 0x0301,  64 * 1024, 256, 0) },
>>       { "s25fl129p0", INFO(0x012018, 0x4d00, 256 * 1024,  64, SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR) },
>> -    { "s25fl129p1", INFO(0x012018, 0x4d01,  64 * 1024, 256, SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR) },
>> +    { "s25fl129p1", INFO(0x012018, 0x4d01,  64 * 1024, 256, SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR)
>> +            .fixups = &s25fs_s_fixups, },
> 
> It seems SFDP is not supported on s25fl129p (you can check it on https://www.cypress.com/file/400586/download), so is it necessary to add this for this type flash?

Yes, all of the above is necessary to repair S25FS128S, which supports SFDP and lands
in the above table entry.

-- 
Best regards,
Alexander Sverdlin.
