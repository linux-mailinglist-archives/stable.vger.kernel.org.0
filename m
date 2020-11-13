Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7B3B2B1B27
	for <lists+stable@lfdr.de>; Fri, 13 Nov 2020 13:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbgKMM3N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Nov 2020 07:29:13 -0500
Received: from mail-eopbgr80095.outbound.protection.outlook.com ([40.107.8.95]:14241
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726406AbgKMM3N (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Nov 2020 07:29:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ldxyC4/LKWibRrPY5/bCPyu2geXIZPwJ9EkUv74bTL0uNuI6H5KzzYh54wiIN9yHHVQD3zQeeBHcoK31H+wHMvgaN8enKncrWkpVb6Kx/BURnerR6+yqfdX/ARbiQhm7EqyZxNx58bt1QBQYwM/EXBFXoxbLgIkeCXTKQgazL3FhtLIZn6LxZdSYWMPM7dG1mXFiU/dAqjCB9RPmf3A0De9ZqHXQEmib+EduGTn1mgZW/Tn5PrfWI0171DuLld/mLAZ9AuZbkIksLZ61QjvxDfN3Ksf+w+G/Ewfiiu9Q1VM+kjqBU03XIrQS2oPKyTK2GWVLI0ZAg7iSyZTrYXu7Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pmrRFKisAZVXXhU4ztW74huX4wee0zHe/OE8V53nN2w=;
 b=WonNYPh1/Yb1k4aJYfCY7T95Cf5TCd0TMmhIbUReSODYyvnt5luekkA+m3GS6USWgamMltO9LTePI9ShYF7ch3j+tFzkn4efRY6toT6Is4P9U9K8MCFn6a9ie5A4g7PHgK7GJT+K4GUWOpUp0IilHANG9FgOY2WHHl6+v/9fFmPQ9U9rVzy9Lo+TBR4FikQrS1HC96c68Fd7cHicaqGjDNqf45YZjjmnmzh+Wg/64lY7j40C1WOqstzMmnBp9Y9dTe4YhyyyISjs1dKdqFradzigHj4LNp3UCLp37G1QXYuBYZ9x8wT6Lm04kbAEPfyK7lNkexHkQM4Jbv3ZcZ5VOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pmrRFKisAZVXXhU4ztW74huX4wee0zHe/OE8V53nN2w=;
 b=xQCzNcoU63dKY0+bYyzarLuoQLtxYmEjdn57rFIm40lZmQpMo3caGyE8HI3W04LFhp/zTzckugMCGmICsLAw2w1ALBD/iY2ZJ+bJ7Ps5gYpmCEi3skzt0GGCwu80dpKiTOQpdRAraMWCgUSCr/OR4w7JcDQQ4+HXRUY2ipBrXoc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nokia.com;
Received: from AM0PR07MB4531.eurprd07.prod.outlook.com (2603:10a6:208:6e::15)
 by AM0PR0702MB3667.eurprd07.prod.outlook.com (2603:10a6:208:25::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.21; Fri, 13 Nov
 2020 12:29:09 +0000
Received: from AM0PR07MB4531.eurprd07.prod.outlook.com
 ([fe80::d527:e75b:546c:a85b]) by AM0PR07MB4531.eurprd07.prod.outlook.com
 ([fe80::d527:e75b:546c:a85b%6]) with mapi id 15.20.3564.021; Fri, 13 Nov 2020
 12:29:09 +0000
Subject: Re: [PATCH] MIPS: reserve the memblock right after the kernel
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Serge Semin <fancer.lancer@gmail.com>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips@vger.kernel.org, Paul Burton <paulburton@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20201106141001.57637-1-alexander.sverdlin@nokia.com>
 <20201107094028.GA4918@alpha.franken.de>
 <1d6a424e-944e-7f21-1f30-989fb61018a8@nokia.com>
 <20201110095503.GA10357@alpha.franken.de>
 <c435b3df-4e82-7c10-366a-5a3d1543c73f@nokia.com>
 <20201111145240.lok3q5g3pgcvknqr@mobilestation>
 <4625868b-f845-2f03-c3f2-fc3ff1ccf63d@flygoat.com>
From:   Alexander Sverdlin <alexander.sverdlin@nokia.com>
Message-ID: <9d8c55a2-4c8b-8cb0-0c3d-004554e14ef3@nokia.com>
Date:   Fri, 13 Nov 2020 13:29:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <4625868b-f845-2f03-c3f2-fc3ff1ccf63d@flygoat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [131.228.32.167]
X-ClientProxiedBy: AM0PR10CA0045.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::25) To AM0PR07MB4531.eurprd07.prod.outlook.com
 (2603:10a6:208:6e::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ulegcpsvhp1.emea.nsn-net.net (131.228.32.167) by AM0PR10CA0045.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Fri, 13 Nov 2020 12:29:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b09f0c70-1948-4cee-f90e-08d887cfb843
X-MS-TrafficTypeDiagnostic: AM0PR0702MB3667:
X-Microsoft-Antispam-PRVS: <AM0PR0702MB3667FBECA5DC931CD7D9874488E60@AM0PR0702MB3667.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FcRTsJca6yC2mV8j6+JQ3KJ0GFrNIy/wx+B2GOYwig2QPOH/uHJk5NL0cPvtFGWuOxoFnZy941LswbkryMieFKgsRcVc5FuB3PRtfP7sEa0qkocTvMSBzoD5rsmLa2WAzY5imnaYb+SyJahAicvmnDdh3LH0FyH1oWA+P0uBdHMEUQdIjnC3wd0vNvrWyP5d0UIgnFsZ3KxmQkQ9rV1Jb5gi/QxfX0aMJaN8U50nqs8VsP5SnzIRdunUsPM9vhmSdxOKtYmHilKDsWRuxQiruu4Bo76wCqQSsTz4ZTPSrm3j0KzQoRz575xdzzdqb/+MOuisny9jUFibxKAg02Esppzl51kCYgZZELkt4WOVzYTBKUkHSuSXLezzNDoWxRwk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR07MB4531.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(376002)(136003)(39860400002)(6506007)(54906003)(316002)(6512007)(66476007)(86362001)(53546011)(956004)(478600001)(8676002)(2616005)(31696002)(66556008)(8936002)(5660300002)(36756003)(186003)(66946007)(52116002)(16526019)(31686004)(4744005)(83380400001)(26005)(44832011)(4326008)(6486002)(2906002)(110136005)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 29Y23o7v5cq5C1ZDvwustUtdGv/F6GUbPQ03oQBUg+ULek0IoUL7vcaurFrYPgIZ2D1dz2foZ9Er4t47rfY3d85aZz5JqxokJ+RIl0cDnizbl0KusCBbxLu1z8n56nayNsekRIRYVvgPwbiwwM6A3xnzcLeUhPTgBWRIahBKROkRxCpGMuc93c5TCI3m1iblveYODNCAVAuTXpoUgA3n9+UxPVYInhgqEkqOM68MycwtWmAd8wA4VVlNh+hx0dfW9YvXjcbeCLmt9F7O22iJ7DJF/dX0Ynr4vHt81bSEz650pZ6Q7gIwn8u9O5BClU5Yqn69pp9waR/yKrw8Cx3BNRyJwyv+hN3dOh3qoXkoYGaEv2hfs/XsN4+Yt9iuyTVRWI2PD6a01z6RzPgFkuyNOc2up50RWofiUP+lQNS2vVbuDa6HzdlywRfSZaom7b14mXsgCsiYdO0DIXafc65mBdSDrb6NwzewSpxbbyO+iYHTTS4cc/buN5u3LTDy8qd6VrT3mJGlB5jIRzgXyrZj15T1HY+FQWGVvWouXFZfpPKMeue2Z5dblgqEjSG0qYjXZlJz0JeqJMMHIb3TlJbZAmpk+E4U030JYXdrKVfvL4Ffcwn8gci/VbexVu67bm8JQZdf1fWeFCNvwpUMtNhnNy8E8y2CIk6Cn6H90eO7IJZxoDYzTFc3LwuUXYn8iH/LSW376A4dkkIUie8XJtd6Mw6bsUpNRK4Y3+OIvPsyNZ2xYZiFRKyAYSahmHRnR3C3ShqraE8EStulcCFj5oiqaxtCghvAnaI0Yz+XYPB1/U0jhKp6etRO8Wj9v8rGz+NSMxlKPgU2xO7nG46jMEvmHh3QzvUFuXtvJ0G5zHGd1o4UmF/e2RIUuS7zJqdAm9xiwcO3+JH/eEFy3NuFr6brMw==
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b09f0c70-1948-4cee-f90e-08d887cfb843
X-MS-Exchange-CrossTenant-AuthSource: AM0PR07MB4531.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2020 12:29:09.3660
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BFzkAgmGalK0EGGy0E6Tfzm3yE9tZmGBAE2AM76FRyuWiQwq91fQwaYqq880+DUNAflX5DIG46N9PLUvoxeHHnUKb2anDeeAI3EFypF87C4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0702MB3667
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi!

On 13/11/2020 03:30, Jiaxun Yang wrote:
>> 2) The check_kernel_sections_mem() method can be removed. But it
>> should be done carefully. We at least need to try to find all the
>> platforms, which rely on its functionality.
> It have been more than 10 years since introducing this this check, but
> I believe there must be a reason at the time.

It doesn't look like 10 years to me :)

commit a94e4f24ec836c8984f839594bad7454184975b1
Author: Jiaxun Yang <jiaxun.yang@flygoat.com>
Date:   Mon Aug 19 22:23:13 2019 +0800

    MIPS: init: Drop boot_mem_map

at least not so long in public, that's why we only noticed recently, that
is breaks Octeon platform.

-- 
Best regards,
Alexander Sverdlin.
