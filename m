Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17D83134D19
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 21:23:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbgAHUXb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 15:23:31 -0500
Received: from mail-mw2nam10on2087.outbound.protection.outlook.com ([40.107.94.87]:1281
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725881AbgAHUXa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Jan 2020 15:23:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZtfuGoXpNGFQCzla6d41RvdnXte6oEBu7XKam5VqKa1BvhllhBWbH7GMmkzHb4OtQVKkUNieroz0LSHaiIzBVV6X9Oq/NUu4ewUmvJFn4mDKTvSwX/MNntBR5uu+c986UlbfSvqGnm8mUJKBEkaOOMB8VQYRqCcyQxMz6GcbR7xFVviL4Mr7TYjWDN2TgXqm65Dj/yUEYxRpUwEzxtPdm65PNBH68/Q5JkcfaHztz8EF64SLpj7qpCbwLTY0rAYRmT7iuQDK5YdX8pIgkq0aGaLwjKhY8gX62eu8PtfQXRAmRgdOQHUhb6Oa0+SA7tNH7purSwtwdAjLSPgsuNDqFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9LDRqAYmrb6YtYfNNe3jSO7o6EVgEE8oUpJVmqEfT04=;
 b=DKqYBFdtBP2eVaOi7zZFWEWVMKPvfzseC1OQJuYZI+86kNhFHGlC00hErBVuyOgBy+U90govkKcSh+KbtvG+jiXLbcPG4sl/TsKmMgkJ7h9It0q55pQdjPWVqS92LTA6NWk0puiuSkVKRKjS3msR4YAIXkvwnNfj9eGT1NR4MpmSNIkYvfC/BH2+gyKO+uPKt0jn7cqqdQ/celY3vCVWDZeoIhU3AvGgUCBx/Lx02bhPe5f4iz4ViYML5ewo7Z4jUFNyT8bv/bLtIpe2q5qlGaixMpn/a9GqXyjXK8MgKs7mGq75SjA6vx4E0HXqXT0c5fg+BSZNROuIMe/Dt9QIsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9LDRqAYmrb6YtYfNNe3jSO7o6EVgEE8oUpJVmqEfT04=;
 b=WrillX3lMezolfdl5Gzm1McUXZkEDDjuMCCg6FuT4YSMfOcVSDuEtWjk7pyd71DMdLsXgLGDnxIUMe8U4LaOfgsZ81fNoa8NstslKrUWoDv1o273ZmuYWRwdrm46GzFdkDTNGshMpoe/CrkCZdS9nq/Lbi7plK4Es5oTzNe10b4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=kim.phillips@amd.com; 
Received: from SN6PR12MB2845.namprd12.prod.outlook.com (52.135.106.33) by
 SN6PR12MB2781.namprd12.prod.outlook.com (52.135.99.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Wed, 8 Jan 2020 20:23:26 +0000
Received: from SN6PR12MB2845.namprd12.prod.outlook.com
 ([fe80::48af:8c71:edee:5bc]) by SN6PR12MB2845.namprd12.prod.outlook.com
 ([fe80::48af:8c71:edee:5bc%7]) with mapi id 15.20.2602.017; Wed, 8 Jan 2020
 20:23:26 +0000
Subject: Re: [PATCH internal v2] perf/x86/amd: Add missing L2 misses event
 spec to AMD Family 17h's event map
To:     Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     stable@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?UTF-8?Q?Martin_Li=c5=a1ka?= <mliska@suse.cz>,
        Namhyung Kim <namhyung@kernel.org>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86-ml <x86@kernel.org>,
        linux-kernel@vger.kernel.org, Babu Moger <babu.moger@amd.com>
References: <20200108193455.29834-1-kim.phillips@amd.com>
From:   Kim Phillips <kim.phillips@amd.com>
Message-ID: <03e5fd9e-5662-c4a5-5792-c64146225dc8@amd.com>
Date:   Wed, 8 Jan 2020 14:23:25 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
In-Reply-To: <20200108193455.29834-1-kim.phillips@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0401CA0027.namprd04.prod.outlook.com
 (2603:10b6:803:2a::13) To SN6PR12MB2845.namprd12.prod.outlook.com
 (2603:10b6:805:75::33)
MIME-Version: 1.0
Received: from [10.236.136.247] (165.204.77.1) by SN4PR0401CA0027.namprd04.prod.outlook.com (2603:10b6:803:2a::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.9 via Frontend Transport; Wed, 8 Jan 2020 20:23:26 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 02f3b658-7fd2-4d94-8537-08d794789e1a
X-MS-TrafficTypeDiagnostic: SN6PR12MB2781:|SN6PR12MB2781:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB278116499EC0C66AAEE0DADA873E0@SN6PR12MB2781.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 02760F0D1C
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(199004)(189003)(44832011)(31696002)(2616005)(5660300002)(558084003)(26005)(66556008)(66476007)(66946007)(956004)(53546011)(52116002)(86362001)(16526019)(54906003)(81166006)(81156014)(16576012)(110136005)(4326008)(31686004)(8936002)(2906002)(8676002)(6486002)(186003)(36756003)(498600001)(7416002);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR12MB2781;H:SN6PR12MB2845.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fj/I6yKhad3l0Irnhyo3mdQ4oVqhsDtwdApXlUjLROK1/+nTNy7OQApFqIpJ3HL7NN6tO1VIiZINFUwqE8p1yK+EhLAq7adn2E4GKfvHWfFKwH+ecxBLtf8Gt2ZJT+QMqi9FBQkCag7qEQIAqB+7XcCtXGY5OKEejbGaMyd9LmJl4xxelz9lDM0UhL7bNLexLrQBxBFM+xI/tVJW0QImwL4fCX/vRor0irDdqhAYleWOG6ZyAgiN7oUSkRqAj3ur6alFzIaBiXe8PcXZVDArstVbEGSfT2nZX3WkquVi1HNU4z4T8hCsKzT5Ri26Bdx5cabYQ0U7D5dpVrGjWAqvhOVPDRQPerU4sDf639nNgPIlRP9KDEjFHOtEAav3yMuB5BZozy3SRFU1Il/3ZQruZcyG154NlA0Stdr9CHL4fA+9KVz98JCD5qE2TKGIlE1Y
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02f3b658-7fd2-4d94-8537-08d794789e1a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2020 20:23:26.7078
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YX5ElSg6qCFI90TXaGkjNJzAx+ihjuLdy42rvjyeeGtmf2jhywO6tmmDG25e35VFLMluGc9a0DahmXVLdBwfuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2781
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/8/20 1:34 PM, Kim Phillips wrote:
> Commit 3fe3331bb285 ("perf/x86/amd: Add event map for AMD Family 17h"),

Hi, I neglected to remove the "internal v2" from the $SUBJECT.

This is not an internal patch, it is intended to be an upstream submission.

Please consider applying it.

Thanks,

Kim
