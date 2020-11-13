Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFD232B1B7A
	for <lists+stable@lfdr.de>; Fri, 13 Nov 2020 13:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgKMM4u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Nov 2020 07:56:50 -0500
Received: from mail-vi1eur05on2137.outbound.protection.outlook.com ([40.107.21.137]:56992
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726160AbgKMM4t (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Nov 2020 07:56:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=btMovLxS/siZ6jhnEqRHoAwYQI8uGKAseKOfuOtOcOW5d3vIG+xWcm18DHmSh0kfhqWvYqTfDqwj06acmg9/jhLvgbtWGPQrirQwsQBXZh/MCc2Ls8rokTLoRJ+gywCtwL67nmQx6v8onTaGfAVzuZDDYypMlVffnF2VJzDQPPgbrsdPbPgb+XVmnNZ5IFuFkzT0AFKiUzimAwKEdsOXPsYR3IyhjAwVHarSFjJzVkdsFId1ybVpxfMD1gNUOo/dMjNjTPc+FtEmy1HwTX2Gy17U0XW8YmQwuszFQovpnouscgClI+o+Am9raE9MmJERfWWeLkR4ljzl680+8p7DBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P3WaX0FHF5NWqCvTa8sgq21fGljUJOm+jaF57Gk6UK8=;
 b=TJwAvfDx4krmU9PXjN8LOrQqSWItc3Qu5benPttLy3GLY1DegBWdTouRzv7pUNgwWGUDLfSwzJhdT5/sSz8CmLVzsFdGh5xlQeusx6HITHXf3xtALPXW40tPp9TJSUPlMOetL2KLqXu8DB5dBYYOIaqz1lGvdLQF6Uwh1GQWPJsQtQIS0TJGoWa9Tk4t2Mhi7Tg2sCwVPyF/yqeqkVqT0w9mFRFRJ72TQSG1J1XPc6wiD5/qtJMt/HpqNa104qELdDHadvEvhyY1xnpsPpwm6HzD42cf8REHGMcUrZMNxKqsFYFRKPxn0JgFIV5qnrkHDfz5suHpcm89YKsFoCfhtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P3WaX0FHF5NWqCvTa8sgq21fGljUJOm+jaF57Gk6UK8=;
 b=ev41EF1kqc+WZ5A8xp8nNBkKJXOwGXRwcfS06Z0trm/X/kfW4+WdePPGJ/V1KTQ15ee8CNhVBIIET0WDJ5BTu2ciBVQ1STq1+0XoX9SwYO5mH7s6QP9tTrR40o9899DvwtMM93vQwYyhaAAzyE925y3LqPf1cEtCztc6S1NjPeI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nokia.com;
Received: from AM0PR07MB4531.eurprd07.prod.outlook.com (2603:10a6:208:6e::15)
 by AM0PR07MB6148.eurprd07.prod.outlook.com (2603:10a6:208:11d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.21; Fri, 13 Nov
 2020 12:56:45 +0000
Received: from AM0PR07MB4531.eurprd07.prod.outlook.com
 ([fe80::d527:e75b:546c:a85b]) by AM0PR07MB4531.eurprd07.prod.outlook.com
 ([fe80::d527:e75b:546c:a85b%6]) with mapi id 15.20.3564.021; Fri, 13 Nov 2020
 12:56:45 +0000
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
Message-ID: <1973ec3a-82a8-2c4a-20d6-45bc7465120b@nokia.com>
Date:   Fri, 13 Nov 2020 13:56:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <4625868b-f845-2f03-c3f2-fc3ff1ccf63d@flygoat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [131.228.32.167]
X-ClientProxiedBy: AM3PR05CA0115.eurprd05.prod.outlook.com
 (2603:10a6:207:2::17) To AM0PR07MB4531.eurprd07.prod.outlook.com
 (2603:10a6:208:6e::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ulegcpsvhp1.emea.nsn-net.net (131.228.32.167) by AM3PR05CA0115.eurprd05.prod.outlook.com (2603:10a6:207:2::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Fri, 13 Nov 2020 12:56:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 20ece6cd-03aa-4594-6f15-08d887d3936f
X-MS-TrafficTypeDiagnostic: AM0PR07MB6148:
X-Microsoft-Antispam-PRVS: <AM0PR07MB61482DC362524FF48981AF0D88E60@AM0PR07MB6148.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6lLgCzmUZe0JXz0qs90axKxipjsrqACkGwQF5nWW3hIj/bLko4JyFvVPmsgLOOKh4AXnLoEMFCuW0x2v80R90H+yyEGh238yxuXfJiC97sfKuQB8nHHNc7axq/L9OwGKeoMbS9KKFHh4LMPHRrKtFK0ot8lDzGsw9qmazrn3uFo/wVXfS32ytCyTCRAIsGDFGEzW03SwC3GRRMVWQUOYONBIbSKNWTBHwc9hCh+jNUs7J8f4HdKtF1HTDahxlNRNeClCNCT6qvrUzNB6VcU1ssMPiuk0bKzK2oguj5sckPtbDOLok+/1uiLd3Ac6qS2mbn5+mMtQMTUX231mtltjjUW63C6jCaljBxSECswvu3cSBLk6eu5uNwaO04eHATp9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR07MB4531.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(136003)(376002)(366004)(186003)(36756003)(4744005)(44832011)(8676002)(478600001)(26005)(2616005)(31696002)(52116002)(53546011)(66946007)(66556008)(86362001)(956004)(54906003)(5660300002)(316002)(16526019)(2906002)(6512007)(6506007)(6486002)(31686004)(110136005)(8936002)(4326008)(66476007)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: KEp3G4o/BHt2GyBXKSeDQd96K9wSpZjVXizxV6eNVbbLowmhizfgYfiAL2Q8jTyK41YHtXv7vZkDw3b/zlXYNOASiIjO27Ay1zWPFF1Lrdrwzq+QcGbyxpkuXItbWSCDV8hSb/uHtRoTv2UceC82qR10qv7AaG//gGHxzp0a42ul3dfS+Y/vNFLRz7eEkFVT9oa5kox+84gZAlViesVb2HY3THU9So4CCA+9Lsk+gaIneHYyq3Wr7oRoUK7tc5JbSPZwW2qSnqIVf+ufdHXKFzkrSQShWVm2VCTdq+uMi5zWiLVngR4iLnj2A1AeTwXqxiwaJRXZ7H+v8R2jkO85fNTI8JDbnT6lNVvZ5vJ48NIq+rqTx4zUhrbyoGTDsv5GzaY8MEBauUwwoL+CIXGaZt8xupSU5o8DaI6ZRluDtGlGT9IFkJcejFmKYbPfK5cbg9BBRFgseGZ7sUrs1+hk2sSn9BfUnYw0Ka8PqE92DFsTcl6ERCiyRjEvQczbg6m3vkIvHRJVYpfNtZCLh6FBiVShpUhgjhPWIBPXraxOnEQnsoT/O4VwbJbwt+B2wTn3oZjH9gki3rBtL+D4PaZUF+pOACqubiLB+fF0i7URezCY6M8F78KTJsGv3+7SasRQEFts1agUrFPPfBgzzaxk6qSPulNo6s2FpL+T6apZWemvcC0j8+/vW8o0CX0iryx6b6LevyF3iPKCAOL/UIWkJ3OXfp08QFmgBKBKOvDRv9KQrZyvgGn2MdD01B+T2YqKAme0IPbhRBIVingkecjMexEGA5Wo1c8H51IYs28L18heiuJR+AcUdq3xZb5ta/rF4QMlrclzXODF3C+k9PA7Yg8EPZfn1+8upoMa+necBPhAwTygNvaCLraVNZQInBBxcIqtuf1b4LK8Kt6sVkbvrg==
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20ece6cd-03aa-4594-6f15-08d887d3936f
X-MS-Exchange-CrossTenant-AuthSource: AM0PR07MB4531.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2020 12:56:45.5585
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RaWXzYDfRp8v8C7YWV91tMMUpZvn45oCavUoQLIBy+hTKTnoGzY4nio3Xwkw//gIK+QiqQ/XaDwFxQJYiECmwuM7sPqwYP79I+0lrnvYB8A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR07MB6148
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jiaxun,

On 13/11/2020 03:30, Jiaxun Yang wrote:
>> 2) The check_kernel_sections_mem() method can be removed. But it
>> should be done carefully. We at least need to try to find all the
>> platforms, which rely on its functionality.
> It have been more than 10 years since introducing this this check, but
> I believe there must be a reason at the time.

could you maybe share the reason you've submitted it with us?

> Also currently we have some unmaintained platform and it's impossible
> to test on them for us.

Do you at least know the list of platforms this patch is required for?

-- 
Best regards,
Alexander Sverdlin.
