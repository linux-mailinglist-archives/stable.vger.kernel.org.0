Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FAFD1B9A08
	for <lists+stable@lfdr.de>; Mon, 27 Apr 2020 10:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbgD0IYJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Apr 2020 04:24:09 -0400
Received: from mail-db8eur05on2138.outbound.protection.outlook.com ([40.107.20.138]:59192
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726003AbgD0IYJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Apr 2020 04:24:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f/06yLxEZcmM71BU1nVuMHIJP1GpO+XdnQnjPq0n4RFv/DfYsRA6Ol7u40tOaBFNexWxKin3hv0QWIXGUl+J4syBz2pz5Jm6vo5BdJwHQGQGq2WSp5k5RYwegGn0WPZF99Mh4KLEO7oDA6vFCgXc39mYLNCHpXeOmsfvnbCf3I9j9ktWqUX1XPgnjEWoy+4OjUrq+Ws9YtXl1zxrJV7zA5PAoIeErbtdkEZxIHU4CwAUYaDmOrGw3eWa02jPq6oJqhJyefeZHIDMWLeP8WoM0woeyI8eybJJCe3NzCoS0DdNGsxOE0+ySMXcnyVB5PojADK9FUfzKSCnp7LJtQ6Ngw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6vOb7AW/9DP3XDYWgf/LVunpti15W1UmmDmVWxICE0k=;
 b=fDM04MWVjUpClWAeRDiU7sLrCT6Le2lwnBHUYkpZIrpa4Nw32bcxEfwZ21ndnKav2LpkVd8VB6HsN1hXxr7zQrji9aiBAlxysSeLzqkyCzrHSbQGhbA9hvBPS9/ombss4o2Uh/7gjARz4bYG6bt90T7RJ8oUWMIhYdnsbw+Ekc8OsCWg/HPCQm0gJJKJ79PPPwPS/xdsSz/10/ffBNANMlIzTr9b0VM/m7lxDiJevrvwdWY31NfifDExsvOC5omk13/y5wjwoxXUxLsTf6AJddU/Mqsb9rhSMgfB+TNOhVZI///G4SsySqUgAHQIjrqwYTejDnXcA0ugCWiWBxPWIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6vOb7AW/9DP3XDYWgf/LVunpti15W1UmmDmVWxICE0k=;
 b=U+z71E6ZUBxx7UT6m1iz23CsjchhipFsJcFCw+D5i+wp0kz1Xjr8+fnpTIC6eqIn8WtKRsVhGkV2HGHC4s38vwiRoH2F3LP4Z5S1CB2nb0MosAUMzqdImFGJ8JIdKmJvdpkTKDi3UJ0pbWz0Ip76A/cwwixBDZ1soohvvBuBV5s=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=alexander.sverdlin@nokia.com; 
Received: from AM0PR07MB3937.eurprd07.prod.outlook.com (2603:10a6:208:4c::20)
 by AM0PR07MB5441.eurprd07.prod.outlook.com (2603:10a6:208:10b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.14; Mon, 27 Apr
 2020 08:24:05 +0000
Received: from AM0PR07MB3937.eurprd07.prod.outlook.com
 ([fe80::6958:35d6:fc84:49db]) by AM0PR07MB3937.eurprd07.prod.outlook.com
 ([fe80::6958:35d6:fc84:49db%7]) with mapi id 15.20.2958.014; Mon, 27 Apr 2020
 08:24:05 +0000
Subject: Re: [PATCH] mtd: spi-nor: Fixup page size and map selection for
 S25FS-S
To:     Tudor.Ambarus@microchip.com
Cc:     linux-mtd@lists.infradead.org, john.garry@huawei.com,
        marek.vasut@gmail.com, dwmw2@infradead.org,
        computersforpeace@gmail.com, bbrezillon@kernel.org, richard@nod.at,
        stable@vger.kernel.org
References: <20200227123657.26030-1-alexander.sverdlin@nokia.com>
 <2670775.TqFIqkCU4V@192.168.0.120>
From:   Alexander Sverdlin <alexander.sverdlin@nokia.com>
Message-ID: <97ac42d6-29b5-c5a6-a32d-2214f5f5b047@nokia.com>
Date:   Mon, 27 Apr 2020 10:23:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
In-Reply-To: <2670775.TqFIqkCU4V@192.168.0.120>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HE1PR0701CA0078.eurprd07.prod.outlook.com
 (2603:10a6:3:64::22) To AM0PR07MB3937.eurprd07.prod.outlook.com
 (2603:10a6:208:4c::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ulegcpsvhp1.emea.nsn-net.net (131.228.32.167) by HE1PR0701CA0078.eurprd07.prod.outlook.com (2603:10a6:3:64::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.12 via Frontend Transport; Mon, 27 Apr 2020 08:23:54 +0000
X-Originating-IP: [131.228.32.167]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d350c7af-ccab-41cb-990c-08d7ea845929
X-MS-TrafficTypeDiagnostic: AM0PR07MB5441:
X-Microsoft-Antispam-PRVS: <AM0PR07MB54417D3B17BAC41B1B92E88A88AF0@AM0PR07MB5441.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 0386B406AA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR07MB3937.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(366004)(136003)(346002)(39860400002)(5660300002)(2906002)(66556008)(66946007)(478600001)(316002)(6486002)(66476007)(6512007)(2616005)(956004)(44832011)(6916009)(31686004)(186003)(6506007)(52116002)(81156014)(16526019)(8676002)(36756003)(86362001)(26005)(8936002)(6666004)(31696002)(4326008)(53546011);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: nokia.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /QfAUXMRzMDmaK75GiT3u1K/WwwOaDdQ3dwt6AUc0f+e2L7kBNa/cafwcvsLu0cOFNobqrrGkfX7c30GxtRdxJ2zJnb8xGwSPYm/8PmcH0S14/pyapE5UjIHcnsaDWMYC78FH3GKIy2qtFmQeclWQ6JIn0pOYZPLtydS++H2IANKqd9WkJvgOFGM4ku6fwElq6XRCv/RfMhj5l6JnvB7UBKS481ZhDLBwasoFFL2p84epFrzXTzwkXZ2Bq7TfGsBLentGNDEYrisTN8yHOEJBj3os4IGwFELbWnHNV/Xt2GiHHn/u4onoNfA7ONsOgEOY8WyN53DbW40oG5R+pR7AKH8dKnpSxiecS0Y9ETLj4NCX2ZBJebzo4Di0cuSYQdEwcOrcVWzYI6a0lMDxPcQ9W4Ce8wglNHf10wQ8oSTVPyXcekp7wwX3yej4hMVYB3t
X-MS-Exchange-AntiSpam-MessageData: atpQi/SOcuNz0LgsC/Mlkd3ZIvaI/lsZii/ESbXxLELEC4rAAblqdiCFoB6rGWPp9iomO4pSBgpu0+DoblZ7aa23w6UeilFz/NIXuIPjyYOLy7zC7OzrSlEv45w0oVdIJGStVkwlsT8LTRtIOUWfV0VbIvS/MqHeB4bnvpfQMhYXqxt/Z54lAQtjuJeh/yieK4y3EkwZqAXE/xI3yk6s13y+u/4br61TcfFCDpvGwLzgcwLm+FUftZagUeX60gAdABOuaVXnyYdaRTEULAMLfRNy+qXAikt94bUsT5wY8F7p/8cPqyubv+osNuy5x8F5kXZyjlWGGXLws+qskwq18Sfjw4fYvAxxypL/E7DjOurDs9SAQ3peGf4AMS7mwUZCdgOYtez9xdL1CjVORnpsOGMdfF3n+xaIsJw/8hwJTzcvnXEQWe3t3cpU/j1PCim76kDtaFNHXA34fxD9UiHbWuMnlX4eIkrdeR+wb9RtNDjxRc8p7G/9sn2nW6cNkO/8hRntzHOR5v6X2+ARAfjvPQVnmFloR/M4OSkt9gnZYh+CnhfPGa21efz2x/GtsCG/Idjavhm/WiSInNj3or7rd6Y5jJ6bp6SPBQRF3frVWDbuKqw2LBw8RUw/ICeKsyGozeRq4TrW4N+5y5dLe93uycUD/mrRfj/9nCCjmEXggVB5mN0UHbldMd7yfcZE048QxHprkYoK7LL4mZ58E9lAD2anT9tzKuqGU9b4/QqQLX7Fx0RvvgPswDw4PLyUnwZVmALFbWZzPsChmh6tnLckLQ2ODhTsTxyjQt6vcbyLGSA=
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d350c7af-ccab-41cb-990c-08d7ea845929
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2020 08:24:05.0464
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Etkrh4LijtPOH8E226aYmQ+ujr+zN59MobvRqHuMIbswHd0ekM0pJnj3CduFDXSfPdZwc/ClXydsq8oaS4KoKw0hDAYHitPjZDruGn3Ysok=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR07MB5441
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi!

On 26/04/2020 17:40, Tudor.Ambarus@microchip.com wrote:
> On Thursday, February 27, 2020 2:36:57 PM EEST Alexander A Sverdlin wrote:
>> Spansion S25FS-S family has an issue in Basic Flash Parameter Table:
> 
> But you modify the s25fl256s0 entry. We have to fix the flash identification 
> first. How about the patch from below?
> 
> 
> Author: Tudor Ambarus <tudor.ambarus@microchip.com>
> Date:   Sun Apr 26 18:33:33 2020 +0300
> 
>     mtd: spi-nor: spansion: Differentiate between s25fl256s and s25fs256s
>     
>     s25fs256s was identified as s25fl256s. Differentiate between them by
>     the Family ID using the INFO6 macro.
>     
>     Fixes: c4b3eacc1dfe ("spi-nor: Recover from Spansion/Cypress errors")

The patch itself looks fine to me except the "Fixes:" tag above, which has
a potential for improvement. The mentioned commit is not related to FL-FS
aliasing.

>     Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
> 
> diff --git a/drivers/mtd/spi-nor/spansion.c b/drivers/mtd/spi-nor/spansion.c
> index ea72f0e5be73..8ea30491cdd7 100644
> --- a/drivers/mtd/spi-nor/spansion.c
> +++ b/drivers/mtd/spi-nor/spansion.c
> @@ -25,15 +25,21 @@ static const struct flash_info spansion_parts[] = {
>         { "s25fs128s1", INFO6(0x012018, 0x4d0181,  64 * 1024, 256,
>                               SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ |
>                               USE_CLSR) },
> -       { "s25fl256s0", INFO(0x010219, 0x4d00, 256 * 1024, 128,
> -                            SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ |
> -                            USE_CLSR) },
> -       { "s25fl256s1", INFO(0x010219, 0x4d01,  64 * 1024, 512,
> -                            SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ |
> -                            USE_CLSR) },
> +       { "s25fl256s0", INFO6(0x010219, 0x4d0080, 256 * 1024, 128,
> +                             SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ |
> +                             USE_CLSR) },
> +       { "s25fl256s1", INFO6(0x010219, 0x4d0180, 64 * 1024, 512,
> +                             SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ |
> +                             USE_CLSR) },
>         { "s25fl512s",  INFO6(0x010220, 0x4d0080, 256 * 1024, 256,
>                               SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ |
>                               SPI_NOR_HAS_LOCK | USE_CLSR) },
> +       { "s25fs256s0", INFO6(0x010219, 0x4d0081, 256 * 1024, 128,
> +                             SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ |
> +                             USE_CLSR) },
> +       { "s25fs256s1", INFO6(0x010219, 0x4d0181, 64 * 1024, 512,
> +                             SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ |
> +                             USE_CLSR) },
>         { "s25fs512s",  INFO6(0x010220, 0x4d0081, 256 * 1024, 256,
>                               SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ |
>                               USE_CLSR) },
> 
> 
> 

-- 
Best regards,
Alexander Sverdlin.
