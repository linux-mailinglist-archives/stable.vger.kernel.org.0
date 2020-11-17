Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1F8A2B5BF2
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 10:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727402AbgKQJlx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 04:41:53 -0500
Received: from mail-eopbgr10119.outbound.protection.outlook.com ([40.107.1.119]:42912
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727218AbgKQJlw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 04:41:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BYlBg+XbUyMLGVcbm+yBlgqCFWk+S2DbRbKzc4eGR5kum/6pVnOp+vgg7XSBofnyki3kgTZZjRMX0z5djeKXMRNLU0cRP4z++fYTA2wQ763L9aFAz8VRsOrqvm31K91+Ir2rRbAaiJstwB5DQXWLApHNdfS46C81oP0UdvT401i11vTlknQ+I/W5cxoUTPTLYPtkZW8Y4EHGtCkFRVMKKnOrITwIM/ghVENmNgQi/sfICXV6SlHwijsZqCtoBgVWvoT8dOTWIQSC3FGL6oy/Cn1/EwgrUE4cjAXJEdXypON9IgwQKM3O4N1S1P0uu53XVYRiTeMILshwSf8JdGoWKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1RreXzbGPQ4JKBG2M/8g7I78ZTL1xWtJujzF05GANiw=;
 b=XSotGpnqr+CkQ/5iBHhEc/m6QTfYaULLVAiF9ejeQbvwe5JJQK7wcmIpp2Q6SsIoBg+d13whCi8Y0gupzWMMFc2cOEKYQcVugs0za1SM+qA9HmVKsZoN5Eu/ne8a8gT6fy5WbwDgdImDtGDfg2gYa+mdmS3291v0lRqzL96dfUlqqOABlDghZJP8LNNJU9vPzXZpA+Nu6iUcNp45pv3KWf2yTiC1RnRdeH98n+e9qB69CJUAvbDjA2KQulMcH7vo5UiaJLU3yApnbIUhwl6ZZ/GauHN1gsbb1tJbKOJitEZNHymZ3sC/Udtvf59Ceqk45DXWu5amy9Je1HHloYNCQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1RreXzbGPQ4JKBG2M/8g7I78ZTL1xWtJujzF05GANiw=;
 b=thzfCLTPI7CNaHjpuhJcEHzmskzpGeAEI7K3mNCKjIILWq0mobybXmfZooIv8LgIZaR9uK5Zo5Yq8Yr2OFcoHwLD4j2WJ1784N6Wy0yusjLgkRFdG7/6CBrB4GhtWtmQHiyWOSlNEfcREr1AIWTRYOv1N+n2oVfYZAAIBZ9x84E=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nokia.com;
Received: from AM0PR07MB4531.eurprd07.prod.outlook.com (2603:10a6:208:6e::15)
 by AM0PR0702MB3825.eurprd07.prod.outlook.com (2603:10a6:208:23::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.12; Tue, 17 Nov
 2020 09:41:48 +0000
Received: from AM0PR07MB4531.eurprd07.prod.outlook.com
 ([fe80::d527:e75b:546c:a85b]) by AM0PR07MB4531.eurprd07.prod.outlook.com
 ([fe80::d527:e75b:546c:a85b%6]) with mapi id 15.20.3564.021; Tue, 17 Nov 2020
 09:41:48 +0000
Subject: Re: [PATCH] MIPS: reserve the memblock right after the kernel
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
 <13fff200-660a-27b8-6507-82124eee51c5@nokia.com>
 <20201116223146.cmb6myelohnlbw7y@mobilestation>
From:   Alexander Sverdlin <alexander.sverdlin@nokia.com>
Message-ID: <e1c594d7-d746-d0ce-2c55-fa3169f9bef1@nokia.com>
Date:   Tue, 17 Nov 2020 10:41:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <20201116223146.cmb6myelohnlbw7y@mobilestation>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [131.228.32.167]
X-ClientProxiedBy: AM0PR04CA0055.eurprd04.prod.outlook.com
 (2603:10a6:208:1::32) To AM0PR07MB4531.eurprd07.prod.outlook.com
 (2603:10a6:208:6e::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ulegcpsvhp1.emea.nsn-net.net (131.228.32.167) by AM0PR04CA0055.eurprd04.prod.outlook.com (2603:10a6:208:1::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28 via Frontend Transport; Tue, 17 Nov 2020 09:41:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6436f188-4dbc-4889-d650-08d88add00bc
X-MS-TrafficTypeDiagnostic: AM0PR0702MB3825:
X-Microsoft-Antispam-PRVS: <AM0PR0702MB3825EE77D046228077A5146988E20@AM0PR0702MB3825.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3W6Ba/+L6D1Rtj3KXuw4xPV/bDMBpS+m39GZsmeRdBssh5gPI0dsqQD//Zk1FH1FTiXpPV619dY3buWTz6T+9SLPWjTk3+CeIYUOuMw7qJakP9uMSzojsbYorLAcT3rDSOvARUyZgNH1ThAVK14qLG9mFXJrOClzhztcuRILxky2HN/J5bAX01W3khyvBtGruI22QiN4Kp3KZqK2mzl5E+ckMXbcZW6B5fovtzBbav0QkEen+VfrTY/R5Ix2jYaOgUZnF476yq+fLIENIrGqVZkkMBIh1Uz/jK0XNSvze1h1oMGUyKUnVYNaLMYQ02Zawr45SuSK9yl7gahLt2+/UGngabmLcTbJN6cUWZex7Lfn7RA+FPqmG4awyGDc9Sv9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR07MB4531.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(396003)(39860400002)(346002)(136003)(31686004)(186003)(956004)(2906002)(16526019)(31696002)(26005)(6916009)(36756003)(4744005)(44832011)(6486002)(52116002)(6506007)(54906003)(53546011)(2616005)(4326008)(5660300002)(478600001)(83380400001)(86362001)(316002)(6512007)(66556008)(6666004)(8936002)(66946007)(66476007)(8676002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: kgD/twuoJBtDwTKoyD0GtXNAJwrMwKC/IzG38t28Bax5UB+AbUov+vtF77W8SSr6xyX4GVDwlVv0jIul+Vo4QxPgd1GIZcAOPNGrMisSnzs4ff4RRzJpg3og5uz0Ij2uwz5MoLALVV/QG2iVqzSw5bgbHxPVJJU8BkNy4Jkf3HobhjjF76hTFrG4KyDRGREg61w7ahnyELeiALjT8udCyZ4RwVSZN+2uB8o6mrWlSCUfi1JENbBurJ3GFa9xoInjKVLpFr1dCibe5t2er9PEIOnlGa7UJmnewccmWUXuS/SppQ7w5Xl01QQVFlObq7sQO2oVnlwg2UpY73/u7Bq4pIdaMW4Mxb6zDczfqRf+4LyRVEHszUl+IVjNZZK/SbhpvixPsNAS2nE4xBetnoeV+7L5qYJW4gM4MCHN8q5NKpIgE72jDR0SYecjxmx9I9Ar0PTOOygFTJ3TGFud/Lha9X97y2yILMnueLLhITcikB/0yVaj5W1rUrT99A8ivFb+ah7sBn9EiD8HhABLNLmZhfNyhjdejrUfaVLz0Ef4Rf5kRQVmGCFIgLzsnI+e31ZVPImpLRXWCP4Q1TH83eNh3dzLVDbI4N4GJ/9w5Ybr2F5v6YtieCVBt8CN6ENaeb/HjgyMmLVoFLzgUEJ5+TOfF7jkOhoEMtnzVUq6fj9D2an4Zuzyy29xCaTElAqJZebzB248rXh7mA9ixY3Kjf7wBJD1uirN2O1Guwrg+jtSnmKBzGBWE1trz3+YzKgxWouHqW8K2l9jjAPmfTWJhN+o09ugRKBzv1YSb/omjFHAGOGZrgWiRu8x24E8hHE2X+EuF/P/K0Gg3VmR0M0NR+EDsnJxI4NV7w1YJ9laFIOvGh1wJJpuDusP68TLemLJ/3Plpl622IGfDiaeXue1qWUyfg==
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6436f188-4dbc-4889-d650-08d88add00bc
X-MS-Exchange-CrossTenant-AuthSource: AM0PR07MB4531.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2020 09:41:47.9243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 15+FDjStrDtGpgsT3UeMq1OWhkEGOVeKA9AJvdHCShML2D7U3XpjFHCg3at/amrmIkIL46UjIQI8ylnni3G7yMUbjYhW6LOEXxlT2xTfDcQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0702MB3825
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Serge,

On 16/11/2020 23:31, Serge Semin wrote:
>> As completely unrelated optimization I can remove the same memblock_add() of the
>> kernel sections from the Octeon platform code. 
> Why not as long as it will work. AFAICS the octeon platform code does
> some kernel start address adjustment while the generic MIPS code
> doesn't. Are you sure using the generic version for octeon won't cause
> any problem?

as I interpret this adjustment, this is open-coded virt_to_phys.
In my tests both code blocks reserve the same memory (well, generic code claims the rest of the last page,
and I'm going to fix this).

-- 
Best regards,
Alexander Sverdlin.
