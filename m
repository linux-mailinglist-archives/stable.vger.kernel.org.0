Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79BCA3A4E28
	for <lists+stable@lfdr.de>; Sat, 12 Jun 2021 12:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbhFLKTL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Jun 2021 06:19:11 -0400
Received: from mail-bn8nam12on2066.outbound.protection.outlook.com ([40.107.237.66]:5857
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230095AbhFLKTL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 12 Jun 2021 06:19:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bVqQIhjmymX6/nqIEt7giWiq++WJcpQwruFBJ8dpX3Bboli62i0hX6LPVXY3gglf+/77Mwc9Iv+vTIp4LKTUcz0+GblNLfYVn/S2CJ4EUKYbZNK9d9Gxiz6DkoVKiSY+bAix68SnpcssQzSr/Hz/PCpBfp+53788Z3SmmgngYYHDlLJ6YdgMssQmUY1h9366q+tFUBb9+WB0zy2GBjqYFL5CL3pIyl1291x0JH1sg+sUoG6Jm1Pzn82G+D/WXkD3Tri8LvIfG3dTvfLAQh7I1q7KGSz88XtdFqQkYAd/S+tZ+lKUAJvUkFc/BcymXKYCGHY1R73mTXsIjEgPfoPujw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jqPEEBq7V/+EcQiJZ3iKARMgCLsPgz69U1+xg7SH9nw=;
 b=dfI8DMJ8OERe1Wk0FzSWiW4iQf1N6yJwG3yqtfH7MEmYCRcLTggblgVPl00zV5EutRK1y8d6ledk67Uq85g5p+xtCNIKI7uqBK4hZPSIBoBRLOOyM5SzYFsM0yCUGdi2Ex5QrqB8YclfeAi+WfKJRjIXFVNykotk6Rb44MT2LqvWzzHZU2Sw38eAhprvvx9wk9iM9mMpXKdo04a/ZPU+R02L6XwOJQ98GGEN9SarH5igO7APJY33K7LtR32ywJYuz+FawSKsaD+zeoP1zFa4awZFkNADpvYTuXCd7+CqZTEbYSvvRfP1RonbzA7x6Hxlr7XEE60EDTJq72MfHPe3Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kvack.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jqPEEBq7V/+EcQiJZ3iKARMgCLsPgz69U1+xg7SH9nw=;
 b=sGagCNB9sAI4S1OKovmb9aHjksIMSMuDbkjBKy8qNBSV1hCLa3GseM5s41hO6D8yEIT2STWINatEmsNJqwcvXAzIJXFfcQP1YR/Lp/9YOZBcuyvgYdMVmIc4OqifrIjkGbGp22FAptzbuBNEZbnjNq08Ff3Mf4+yNeF7/teewsdvak03VSQjuLWyEkrfUyAkEXThEsnRENtn3pwZbxFsj/q9J4VnPMmubp2cT2M7t05Fbi5BtNpyjgsIq+BreVpnSwr4i/NCfUMRx3NPrwZjh0gjlOWHf3mM9inf6kSa1GKDPpSAXM4iLd1N+00Dz0WRquiCoeQTDlTWppnLjkPS6g==
Received: from CO2PR04CA0007.namprd04.prod.outlook.com (2603:10b6:102:1::17)
 by BYAPR12MB2997.namprd12.prod.outlook.com (2603:10b6:a03:db::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.25; Sat, 12 Jun
 2021 10:17:08 +0000
Received: from CO1NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:102:1:cafe::8c) by CO2PR04CA0007.outlook.office365.com
 (2603:10b6:102:1::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend
 Transport; Sat, 12 Jun 2021 10:17:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT059.mail.protection.outlook.com (10.13.174.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4219.21 via Frontend Transport; Sat, 12 Jun 2021 10:17:08 +0000
Received: from dhcp-10-2-48-181.owa-only.scl-ca.nvidia.com (172.20.187.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sat, 12 Jun 2021 10:17:06 +0000
Subject: Re: [PATCH resend] mm/gup: fix try_grab_compound_head() race with
 split_huge_page()
To:     Jann Horn <jannh@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC:     Linux-MM <linux-mm@kvack.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Jan Kara <jack@suse.cz>, stable <stable@vger.kernel.org>
References: <20210611161545.998858-1-jannh@google.com>
 <20210611153624.65badf761078f86f76365ab9@linux-foundation.org>
 <CAG48ez3mjsf41Z2vCjmkuBaHe9XgoXbWDGvM4OJdUjqiCQbN4A@mail.gmail.com>
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <9041f85d-515d-576d-21a9-6f10b6e1279e@nvidia.com>
Date:   Sat, 12 Jun 2021 00:17:05 -1000
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAG48ez3mjsf41Z2vCjmkuBaHe9XgoXbWDGvM4OJdUjqiCQbN4A@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f3603c15-1a72-4468-0d06-08d92d8b3c3b
X-MS-TrafficTypeDiagnostic: BYAPR12MB2997:
X-Microsoft-Antispam-PRVS: <BYAPR12MB2997EBCE5AD1CE9A01F6A951A8339@BYAPR12MB2997.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WwxcSrkp156heWdGsWkbrLUPobkeKPi9c+nzf5UZOhMwZwqcHT1cTS3UI7FGIFafiMj9n4RqWiNc2OeUsDT3ZQEZnbZhiX1/t91ZNAUwZ2Pztm852Yepl7fGM6FlgjqfFRJHzQ+Y0XD1kDyyXYaGYZoGUvgkiPjbg3q2hr5G2y8Mzk/FloBcRujr+ThrHJ/iUhZSI7NVoKuaYIRJJgW7ukDJTzMHFNa7A4+xBNwbfieCq/NOSuHQajxvU8FAp3h22SP5k+Cj1dS26D5W3yxmUsdZOM6PjeeT5wRXq297JQwK2vM8uAkfotrCvX+68hOHZhD04AdNRjNtsgLBUYcHvMSVTTAIbqQi2HhcsPjcPqQgCLGaVp9zaeDg0rx6ANhHmjEuct8F50ZqvitM2iNhK0Fb/BhY/RYAhFW39AOyn6MmL7QusSt2Qx8kJPQnnp4UQOZqwKOl0C82fTYe9IC8d0qSLBNWCjo67Oo9CLdHmBPjon81RELQAX1WrR2AvO8DYKxUotQpBZzdPsadFH5OzCXyLmOuFq7hW6hNQp5D5tvTWXS6d8FywdnQWz1iuVJfEdxDGYcyYY9VtoWJQ2DZFImDTZvNC24sJU6ACYtn6AcC4vNn+sOV58Z0txUFDX1EGMzjiNbbt/fHQPqQvPoUVEXVO9TkdnL+7rxaSxLi1YgopCqwoCI7Rl7PCyk8HEnhQBWxhf3i+2vY1UmbzRWZAA==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(376002)(39860400002)(46966006)(36840700001)(186003)(336012)(82310400003)(7636003)(31686004)(82740400003)(356005)(36860700001)(2906002)(110136005)(36756003)(53546011)(8676002)(54906003)(4326008)(31696002)(86362001)(7696005)(83380400001)(316002)(36906005)(47076005)(70586007)(16526019)(26005)(70206006)(8936002)(2616005)(426003)(5660300002)(478600001)(14583001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2021 10:17:08.2823
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f3603c15-1a72-4468-0d06-08d92d8b3c3b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2997
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/11/21 3:49 PM, Jann Horn wrote:
> On Sat, Jun 12, 2021 at 12:36 AM Andrew Morton
> <akpm@linux-foundation.org> wrote:
>> On Fri, 11 Jun 2021 18:15:45 +0200 Jann Horn <jannh@google.com> wrote:
>>> +/* Equivalent to calling put_page() @refs times. */
>>> +static void put_page_refs(struct page *page, int refs)
>>> +{
>>> +     VM_BUG_ON_PAGE(page_ref_count(page) < refs, page);
>>
>> I don't think there's a need to nuke the whole kernel in this case.
>> Can we warn then simply leak the page?  That way we have a much better
>> chance of getting a good bug report.
> 
> Ah, yeah, I guess that makes sense. I had just copied this over from
> put_compound_head(), and figured it was fine to keep it as-is, but I
> guess changing it would be reasonable. I'm not quite sure what the
> best way to do that would be though.
> 
> I guess the check should go away in !DEBUG_VM builds?
> 
> Should I just explicitly put the check in an ifdef block? Like so:
> 
> #ifdef CONFIG_DEBUG_VM
> if (VM_WARN_ON_ONCE_PAGE(...))
>    return;
> #endif
> 
> Or, since inline ifdeffery looks ugly, get rid of the explicit ifdef,

Agreed: VM_WARN_ON_ONCE_PAGE(), at least at the API level, seems like
the best thing to use here. However, as you point out below, it needs a
little something first.

> and change the !DEBUG_VM definition of VM_WARN_ON_ONCE_PAGE() as
> follows so that the branch is compiled away?
> 
> #define VM_WARN_ON_ONCE_PAGE(cond, page)  (BUILD_BUG_ON_INVALID(cond), false)
> 
> That would look kinda neat, but it would be different from the
> behavior of WARN_ON(), which still returns the original condition even
> in !BUG builds, so that could be confusing...
> 

The VM_WARN_ON_ONCE_PAGE() is not implemented exactly right
in the !CONFIG_DEBUG_VM case. IMHO it should follow the WARN*()
behavior, and return the original condition and keep going
in that case.

Then you could use it directly here.


thanks,

-- 
John Hubbard
NVIDIA
