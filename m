Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE2F2B1B9A
	for <lists+stable@lfdr.de>; Fri, 13 Nov 2020 14:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgKMNJT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Nov 2020 08:09:19 -0500
Received: from mail-eopbgr50128.outbound.protection.outlook.com ([40.107.5.128]:3813
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726267AbgKMNJQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Nov 2020 08:09:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oAlDV59dmYIikt1bHlixf3nyVAmBldV2tUZSUymJcREhTwmpDCBdjMTBpgOuhiLaaPJHC47E+4S6QTuMQ/jltlWptGrZ1fE0mcGveaoCFaxosDHctzj/5na9jGrc69R/2Mm9nT0MDVmhM093k6LJ2Te5D+FU9j5zfAcNKbjeEiRl9/L1qsHfPnWcGrrrGkrSUreTtJsJCVCyrr4lcI7jWWO2UMvuKAMvAKt7o0vMM0FjzpJVVzq3aFC/7nfLID7/xxlGLx7HgYrIPFCyNfjZ6lItTSIx0UeIEAeuN+G5ZVTTb+h3oYIRK16aYDgTk0IaLcSGcNcu7g8K0akH5OYPtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pOJlMXaOdlJ2JzZtUH/4rHWWJ9uNJV4xSIBToTRaxAo=;
 b=igLRjRdxXYlx7Che2LclGMFc4LueD3EDqUMSHCJzeWGu4rwkVNjD18uRRYZO8TIthDZx13KzuKPWPIuavCQJwE6Y2ATtO1DNz46/l46uc0bDEqQmT0eZzqguGcehnqp11Os4EFO7uwu0eRLlnslg/jyNKDx8gxwhOaHCuCesQ337XOpG2id1gPAa5EYi0mdv2VbBKHtR7jbbYknFAXePZJOs4em84kgq7oxvj4sAbSnBS+D7cNtAkK5w5ONCCoxsopsDaj1O83h5tKG3qg7qcOfJUT100NH/wH6prUOajqi/VmD8VKlKj7DkJWL2t2xNYNlIkJRZ+bXu8QSia1yNLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pOJlMXaOdlJ2JzZtUH/4rHWWJ9uNJV4xSIBToTRaxAo=;
 b=bQ6v9fPMZIPnUzYqXSZIEmpVWHsLtO6y50RcjCq65hVUKQyxKV7j6I7dS4ZBaIuBKS8KNjQi1ocfI9kd1wYZFtvzPZVkD9/kiiMr12yE/mgCyHT+8icsRcQPo7UTkWiWwLgLf61cFEPmDCMbi7FqP+d273NfBoUx4j43XHoMqPA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nokia.com;
Received: from AM0PR07MB4531.eurprd07.prod.outlook.com (2603:10a6:208:6e::15)
 by AM9PR07MB7188.eurprd07.prod.outlook.com (2603:10a6:20b:2d0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.13; Fri, 13 Nov
 2020 13:09:12 +0000
Received: from AM0PR07MB4531.eurprd07.prod.outlook.com
 ([fe80::d527:e75b:546c:a85b]) by AM0PR07MB4531.eurprd07.prod.outlook.com
 ([fe80::d527:e75b:546c:a85b%6]) with mapi id 15.20.3564.021; Fri, 13 Nov 2020
 13:09:12 +0000
Subject: Re: [PATCH] MIPS: reserve the memblock right after the kernel
From:   Alexander Sverdlin <alexander.sverdlin@nokia.com>
To:     Serge Semin <fancer.lancer@gmail.com>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        linux-mips@vger.kernel.org, Paul Burton <paulburton@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20201106141001.57637-1-alexander.sverdlin@nokia.com>
 <20201107094028.GA4918@alpha.franken.de>
 <1d6a424e-944e-7f21-1f30-989fb61018a8@nokia.com>
 <20201110095503.GA10357@alpha.franken.de>
 <c435b3df-4e82-7c10-366a-5a3d1543c73f@nokia.com>
 <20201111145240.lok3q5g3pgcvknqr@mobilestation>
 <4c58b551-b07f-d217-c683-615f7b54ea30@nokia.com>
Message-ID: <13fff200-660a-27b8-6507-82124eee51c5@nokia.com>
Date:   Fri, 13 Nov 2020 14:09:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <4c58b551-b07f-d217-c683-615f7b54ea30@nokia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [131.228.32.167]
X-ClientProxiedBy: AM0PR02CA0009.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::22) To AM0PR07MB4531.eurprd07.prod.outlook.com
 (2603:10a6:208:6e::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ulegcpsvhp1.emea.nsn-net.net (131.228.32.167) by AM0PR02CA0009.eurprd02.prod.outlook.com (2603:10a6:208:3e::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25 via Frontend Transport; Fri, 13 Nov 2020 13:09:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3a97cd96-f382-4931-fe0d-08d887d55097
X-MS-TrafficTypeDiagnostic: AM9PR07MB7188:
X-Microsoft-Antispam-PRVS: <AM9PR07MB7188868D9F543281A9AF1CA188E60@AM9PR07MB7188.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jNUI4AuRglP5Oi9WC2o5itdtlVP0P2tVTck/O5v+hndia1Rg5h6evxbRkMfSzX4NBiHfun0tAhl1b4FVY6OPpLea9M09fVs6GxiEWvUXdqyFme27B2+kBl2JG+mHJiyBkohsoJtjJxqVG98WfIXylzXfXhkqWp61fgtMMNqa0p79QvIZrE1RXgUFTYo6NaDwKX2z0YRb0PAQnAm8O8oZQ3wCRv/s7vr1TvTX1By6hVwbN2hge9KcWdo6wefs7eXySy7dBC4/hhAfIaHuvwj2dWvLVyoPER0PSkvpEe283XlzGOjFHfCdhbhT1o2VmnwfeoBkjWocGn9gCFJ4OPuXWS8OKgvjBCG/I0x6jlxtKHqDkO2lSHaZUZq9e5c8uMMy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR07MB4531.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(376002)(136003)(346002)(956004)(66476007)(66556008)(186003)(31686004)(31696002)(36756003)(478600001)(16526019)(66946007)(8936002)(54906003)(8676002)(2616005)(6486002)(6512007)(83380400001)(26005)(5660300002)(2906002)(4326008)(6916009)(86362001)(316002)(6506007)(44832011)(53546011)(52116002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: eTHhsHSW5ig9uuH+ayR6rmKsDF7Ezc7WmgqH3tx6SzwKpb+DLJZ256RU3CVZuCzE+sSFfW02J1tCcxDnrG7e52tkPc/qD4nGWl1i3JtWr2F5v1DsgNHAMSXmhc9M7LoZ5z85wUJAAbqDRGH3qkSmciIqt5xrX/rvjIFi+/z1ph93FoHTunugxFsXwbDtbW2Rl57PYrgY7/otG0YB/3xmA/EwuTkdiuAGAPawAS67R4cSuySCFbRJFYwJF9fKWGY1TQiXUrHtQowjEuXnNyNemM6aGNT0/rb9qJO/6fHh2V5IKDOPRXRn2bXhuqZCKLq4Rr1vFC8H0WS57z2X29mQG15wXM8RWaG0Q4ZLtbJzSTIbEQ4p7gm78eRIdy6lckOD+3Jx3TaM+3djxjK2K0K5AJIuUzORt61FRLMk/dULtiKq7rVHb9BRvsdFYoSQD+NSst7tGkUeRCMgFh7hhGThcOiFLqUNXUewxg9Thzlt0X6ZUVggChoqkHhYE5WfbrYHPCytC3nu//X39/HVw6GN1yx1CSLFXBJ3ySyUlgKcYyPJ7DjL7bvBLTN8wvj40W6/7NFxFty7dd38hHSceOJ6tGY9rDwdbUGAx119Id/Tx8jUOUTUwN0pbCtSyePsT2aXz4YjqvFRxh0RI5W5QxMDh84i/EDklQmNiiA07g8O63//Cog9spSCOpXRjerXW4c3Si0zbxNAXYvz+EvufxE+SMu26iaslfumyc6TmlMjGV98BeXD9pPtUqIlh4lEAgLX1fU+/Lh2LkGMUU7JkqbP+vbaqk5lMN+0dEep1RLvwMMd/+HQvaCpY9qOOXhBWsOVpU0OfEjkr5FMo9LpTz/OhXXEvlhz1MTwuwCh6BTV9QLiRbOXrEWv0erGCBSA9MmjOP7Qin5p7xl671gi5tyjUg==
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a97cd96-f382-4931-fe0d-08d887d55097
X-MS-Exchange-CrossTenant-AuthSource: AM0PR07MB4531.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2020 13:09:12.4239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rk+yEjmhqi2cMUxoQGTkj3HB5DCAFFfjLUE/DWcWBEggewBQT9O1wcMzvoJkgleUSHwLVQ0faeiteOhiY/C3e5YRLylCSmaC4DPrm6ThqzQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR07MB7188
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Serge, Thomas,

On 13/11/2020 10:17, Alexander Sverdlin wrote:
>> So IMHO what could be the best conclusion in the framework of this patch:
>> 1) As Thomas said any platform-specific reservation should be done in the
>> platform-specific code. That means if octeon needs some memory behind
>> the kernel being reserved, then it should be done for example in
>> prom_init().
>> 2) The check_kernel_sections_mem() method can be removed. But it
>> should be done carefully. We at least need to try to find all the
>> platforms, which rely on its functionality.
> Thanks for looking into this! I agree with your analysis, I'll try to rework,
> removing check_kernel_sections_mem().

but now, after grepping inside arch/mips, I found that only Octeon does memblock_add()
of the area between _text and _and explicitly.

Therefore, maybe many other platforms indeed rely on check_kernel_sections_mem()?
Maybe the proper way would be really to remote the PFN_UP()/PFN_DOWN() from
check_kernel_sections_mem(), which is not necessary after commit b10d6bca8720
("arch, drivers: replace for_each_membock() with for_each_mem_range()")
which fixed the resource_init()?

As completely unrelated optimization I can remove the same memblock_add() of the
kernel sections from the Octeon platform code. 

-- 
Best regards,
Alexander Sverdlin.
