Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 318A93C5A48
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 13:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238238AbhGLJp2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 05:45:28 -0400
Received: from mail-mw2nam08on2066.outbound.protection.outlook.com ([40.107.101.66]:22048
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238202AbhGLJpU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 05:45:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=koXoLTpRLXGdAzYygo0naF6d0LUs7aYwK+UcTtLVtzyw3A6SJFW0J7+zMfq7rmB8uLcA9D2UTejVNHytUOTqlSUZfzk86d6CPu0B/LhfmDMMaa4V+uTcqnkCUbhvxyDt5IEFZesGtC+7KP45DvpvLonJYZ+L/TI9atjmOIqBljVyrvCcp0+J+6Z4/QnF8U+CO4887XucliCbJmYKSYLBroWVKqkUlUriP6BSCnEIHkdjnGrkdx/ABkEJkyVWyEiz3NigX/8DThGpnZIZ5u0az+vqDRmXM2MwNcXVPmNaorH+g1Q/KRR7Z49yCHvSXrRV7hMfnFE8tJ5kzc9cnmaqUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K5HpRHa1p5oYVfHTWB6AIWJUAH2X6cUhSXRsfkjHQnk=;
 b=ATX5gdbrdi78E5lDlOxMM6J/5mfs8g1h1Poa1E224QdwM6E4DJw3I1A0KeQaoEYQGu6Z4kSN9ms3PWgx0/TgO3LIlTA1sed1KNapUaH4iQax1FXkhlIE8N9KyyOTY9NBLY6RkJ1bbdJHSmeN5I6Iu5CexNIM4j5V96iHny9irDBSC40HKDLY1bOHPgeqyLCGmjgMTkXFv52/N9OJgKo0bJKZECKxwi+te/QGZg1i45zZEqEBta8in+E0flPhblPuyA9w1hKbsM3rMLxxYJWUSjhSWdWVGey9PR0/5VDnPe1nF0R+bO9LGGumH8TtiibhUuv92kaBXhRm2lSQIBTWBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K5HpRHa1p5oYVfHTWB6AIWJUAH2X6cUhSXRsfkjHQnk=;
 b=N4zxZns/TizYa5NcMJ4u1Q0RdfLnV+4dYtdU153cirZxX9dZaN8J2YXQBefRqT4DT5U1Q/VjaSfU4+/zXoqyknfIeeWUfF1n/oarHmZVBNWBkjf05iL+QJwLhHAvfNHVI3OlyXJTpYbD5tCchWRWl7+lQAGa9BoUpZJsG6HOdIU/iIWimmLpNUMMOLuJmX2FJS9cx1pUiYemkVU2BAFz1l7wF2ad2EEyRj+fq171pGXJbXuNml/Z5HhBWkbycumC0+Kus97XKG//js6LUo2u2sikyC3vLKsqt+BwVqOvf2LplwNvG3DQlRGlEZJLm2QT9WMqb8o63JLmzaGBH7kZEw==
Received: from MW4PR04CA0155.namprd04.prod.outlook.com (2603:10b6:303:85::10)
 by CY4PR12MB1176.namprd12.prod.outlook.com (2603:10b6:903:38::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.24; Mon, 12 Jul
 2021 09:42:30 +0000
Received: from CO1NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:85:cafe::6f) by MW4PR04CA0155.outlook.office365.com
 (2603:10b6:303:85::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21 via Frontend
 Transport; Mon, 12 Jul 2021 09:42:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; linux-foundation.org; dkim=none (message not
 signed) header.d=none;linux-foundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT051.mail.protection.outlook.com (10.13.174.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4308.20 via Frontend Transport; Mon, 12 Jul 2021 09:42:30 +0000
Received: from [10.21.180.219] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 12 Jul
 2021 09:42:26 +0000
Subject: Re: [PATCH 5.10 000/593] 5.10.50-rc1 review
To:     Pavel Machek <pavel@denx.de>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
References: <20210712060843.180606720@linuxfoundation.org>
 <dfcae9165b814757b9853c28cc11e820@HQMAIL111.nvidia.com>
 <20210712093526.GA23916@duo.ucw.cz>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <028eb5b4-c0bb-d4a6-5e06-ad508cebd0cf@nvidia.com>
Date:   Mon, 12 Jul 2021 10:42:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210712093526.GA23916@duo.ucw.cz>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0445e2dd-c6c4-480b-8ff6-08d945195e1d
X-MS-TrafficTypeDiagnostic: CY4PR12MB1176:
X-Microsoft-Antispam-PRVS: <CY4PR12MB117639E63826236E8E53EAD2D9159@CY4PR12MB1176.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7WGLO2JpYSTWhnEgOrjZ7xbu2k3nqn8gPozqL6qQ7o97Oe1pw69cA0hLRCbF4Yc7bOoFUEF7uMZP0Ak9gAgIt9j8u8Bg9HpHXucKp5vY/YAqzd6H0TVnoL0tmk1bUfLUv3k4G1Q+MdGnBnpYDUTrhanMzxuWg1uxFMHj0f4hQjnLYEdAddZVJwgwLQmxZSfkKh5din8zOIIlz6pYgV4muenQ9cqOV3JM/DsDcEbzuOjjfg7t2xBN6IZ3r4lRVz/rGT5xj1m5eh1MwaI8W2rLkxL3hJB9KWJfjb5S6Vu0NdYtrhfZ4zTIY3APWNMe9q/a25qTm4SWnq4whTTX2mjP6eC3Gw/A8dPzW9tazvuFbWrJYmTGFBVvrDKV0DVZvUVMDSmw3sTAvfWaQDv0KJe11tNZmr+33xo9GE3yGDoVHSkN2bbWew6Y65SC2enpbH7tEUxtyctXMSHpJOq5RZtVP0MmONmlekkVZYUz1d3aPZhhGW6NK4l1YRlsg3K9Z67WxWhNNxv+uLVztqb+NiB6BRb2a9cv9V1f8r1eIGpIwiyjaPDQ6ItjUxtzTLSr3RS+NZJPEesfIcy9A3cQHg7fbXaDGbsGIvnFNGt8XFdzzccxFbuLpSRm6xDFseN01xiduDfsnDSLLIvZWzf9X7AjHZaFhoxVe3flqn0TrZhYs3PHBgQaptjqit6f+w/R70CSJEjpTDrLc3UFN50z8XMLa+BX3K6lvohKK7bnvtL9Aoq/6yAD+6jAmGrmUUvlK6qcZnYsyhc+Wb+2O/O7YttJPQ==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(376002)(39860400002)(46966006)(36840700001)(186003)(16526019)(53546011)(8936002)(54906003)(83380400001)(7636003)(36906005)(70586007)(86362001)(356005)(70206006)(16576012)(316002)(31696002)(26005)(2906002)(6666004)(31686004)(36756003)(6916009)(82740400003)(5660300002)(4326008)(47076005)(82310400003)(34020700004)(4744005)(336012)(7416002)(36860700001)(478600001)(2616005)(8676002)(426003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2021 09:42:30.3781
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0445e2dd-c6c4-480b-8ff6-08d945195e1d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1176
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 12/07/2021 10:35, Pavel Machek wrote:
> Hi!
> 
> (2000 lines trimmed)
> 
>>>  tools/testing/selftests/vm/protection_keys.c       |  12 +-
>>>  638 files changed, 5205 insertions(+), 2782 deletions(-)
> 
>> All tests passing for Tegra ...
>>
>> Test results for stable-v5.10:
>>     10 builds:	10 pass, 0 fail
>>     28 boots:	28 pass, 0 fail
>>     70 tests:	70 pass, 0 fail
>>
>> Linux version:	5.10.50-rc1-g3e2628c73ba0
>> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>>                 tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
>>                 tegra20-ventana, tegra210-p2371-2180,
>>                 tegra210-p3450-0000, tegra30-cardhu-a04
>>
>> Tested-by: Jon Hunter <jonathanh@nvidia.com>
> 
> Thanks for testing... but could we get you to snip the parts of email
> not important for the reply?

Yes I have noticed that too! The script we have use to trim that, so I
need to see why it no longer is. I have recently made some modifications
and so clearly have broken that. Anyway, I will get that fixed.

Jon

-- 
nvpublic
