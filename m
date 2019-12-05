Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A63461149CF
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 00:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbfLEXYH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 18:24:07 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:4072 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725926AbfLEXYH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Dec 2019 18:24:07 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5de991920001>; Thu, 05 Dec 2019 15:24:02 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 05 Dec 2019 15:24:06 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 05 Dec 2019 15:24:06 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 5 Dec
 2019 23:24:06 +0000
Received: from [10.110.48.28] (10.124.1.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 5 Dec 2019
 23:24:06 +0000
Subject: Re: [v3 PATCH] mm: move_pages: return valid node id in status if the
 page is already on the target node
To:     Qian Cai <cai@lca.pw>
CC:     Yang Shi <yang.shi@linux.alibaba.com>, <fabecassis@nvidia.com>,
        <mhocko@suse.com>, <cl@linux.com>, <vbabka@suse.cz>,
        <mgorman@techsingularity.net>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
References: <bd3f2ee5-9cbd-ed4f-9863-8859866da810@nvidia.com>
 <4C589824-CA40-41A3-8F2B-C2AA2A924510@lca.pw>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <a7f354b7-d2f9-71c0-7311-97255933b9a2@nvidia.com>
Date:   Thu, 5 Dec 2019 15:24:05 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <4C589824-CA40-41A3-8F2B-C2AA2A924510@lca.pw>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1575588242; bh=Ab8rY4ay+5Y5dcV8urGXOfE2qIJ9aPxsk4hQ7HgMonA=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=MPqzdlHwcfwR0Ie02pSlatkIvc5TpipiNn58lbnSWReZxeutyVajGB4ZD+2Ghb+PO
         nwk96+jLLfwS6r+vdWBXymIq8m+PV+9gid8+g0ia0I3cnyt3Du48FE9P6SJOi1p94o
         gX/xeOlvFl6VKcBeQAO7rkSyAd7KNM8nW7JlL7jOvWUYgYKRse8LCqg2v96wXRMTkc
         VlAn8dbvQqyV7xQ1JDc1+UcLkLc9t4mivgRHgHKe1gdiA5fTDO0xcLdFnfvJDD+hQU
         uGQsbkbpyaV4MkTQZ0YdRJY1pSBDjJCNs4IsyQwqFkQ1YS5t1q7+MIZSflL5h8AZFG
         ETB+/yoeXgRdA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/5/19 3:16 PM, Qian Cai wrote:
> 
> 
>> On Dec 5, 2019, at 5:41 PM, John Hubbard <jhubbard@nvidia.com> wrote:
>>
>> Please recall how this started: it was due to a report from a real end user, who was 
>> seeing a real problem. After a few emails, it was clear that there's not a good
>> work around available for cases like this:
>>
>> * User space calls move_pages(), gets 0 (success) returned, and based on that,
>> proceeds to iterate through the status array.
>>
>> * The status array remains untouched by the move_pages() call, so confusion and
>> wrong behavior ensues.
>>
>> After some further discussion, we decided that the current behavior really is 
>> incorrect, and that it needs fixing in the kernel. Which this patch does.
> 
> Well, that test code itself  does not really tell any real world use case.  Also, thanks to the discussion, it brought to me it is more obvious and critical  that the return code is wrong according to the spec. Then, if that part is taking care of, it would kill two-bird with one stone because there is no need to return status array anymore. Make sense?
> 

Let's check in the fix that is clearly correct and non-controversial, in one
patch. Then another patch can be created for the other case. This allows forward
progress and quick resolution of the user's bug report, while still dealing
with all the problems.

If you try to fix too many problems in one patch (and remember, sometimes ">1"
is too many), then things bog down. It's always a judgment call, but what's 
unfolding here is quite consistent with the usual judgment calls in this area.

I don't think anyone is saying, "don't work on the second problem", it's just
that it's less urgent, due to no reports from the field. If you are passionate
about fixing the second problem (and are ready and willing to handle the fallout
from user space, if it occurs), then I'd encourage you to look into it.

It could turn out to be one of those "cannot change this because user space expectations
have baked and hardened, and changes would break user space" situations, just to
warn you in advance, though.

thanks,
-- 
John Hubbard
NVIDIA
