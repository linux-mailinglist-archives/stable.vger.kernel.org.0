Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D575D11496F
	for <lists+stable@lfdr.de>; Thu,  5 Dec 2019 23:41:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726154AbfLEWlJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 17:41:09 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:11915 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726034AbfLEWlJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Dec 2019 17:41:09 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5de987880000>; Thu, 05 Dec 2019 14:41:12 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 05 Dec 2019 14:41:08 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 05 Dec 2019 14:41:08 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 5 Dec
 2019 22:41:08 +0000
Received: from [10.110.48.28] (10.124.1.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 5 Dec 2019
 22:41:07 +0000
Subject: Re: [v3 PATCH] mm: move_pages: return valid node id in status if the
 page is already on the target node
To:     Qian Cai <cai@lca.pw>, Yang Shi <yang.shi@linux.alibaba.com>
CC:     <fabecassis@nvidia.com>, <mhocko@suse.com>, <cl@linux.com>,
        <vbabka@suse.cz>, <mgorman@techsingularity.net>,
        <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <ff202f9f-4124-7e63-a5fb-ebeb2a263632@linux.alibaba.com>
 <D04891DC-0EE8-4EA0-8541-97E4AB4DED3C@lca.pw>
X-Nvconfidentiality: public
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <bd3f2ee5-9cbd-ed4f-9863-8859866da810@nvidia.com>
Date:   Thu, 5 Dec 2019 14:41:07 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <D04891DC-0EE8-4EA0-8541-97E4AB4DED3C@lca.pw>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1575585672; bh=DdLhKtrMa5vIsFwQ0R0OlkICohD9TGNnd+PliV+HLsE=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=XVxQotaVe0OdH9i/+bIQtirIG+UW0JqL2uNgRvn8RhdUbRIdMF4XHqdXoDO93EpMO
         2tYHAdQqIJZA/HS01RTK5KeGnwMqbxAUw66qwVCeTAEMkTS6ZrhUbUkCBFvDr4T36g
         N/xIKfHgMoqv7ky2epSffEE9wGDlUi8CxNTW9GdUiWSW2U+Y127rr1t+2BIu8rbme5
         ExIvkfgaYKRvOyGzWE0IPQEPQSJHwJ0j3xTfEgBI6lubhMkbO59hpYDoDIP5VdE33k
         5rmmEP8Xcq+/VIH/yoBH5E4sfbBv3Jk6+OfMsj8f0nCRXdf9PRfYip8bw2zADwSr8t
         jLdvUrp6PGSSA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/5/19 2:23 PM, Qian Cai wrote:
>> On Dec 5, 2019, at 5:09 PM, Yang Shi <yang.shi@linux.alibaba.com> wrote:
>>
>> As I said the status return value issue is a regression, but the -ENOENT issue has been there since the syscall was introduced (The visual inspection shows so I didn't actually run test against 2.6.x kernel, but it returns 0 for >= 3.10 at least). It does need further clarification (doc problem or code problem).
> 
> The question is why we should care about this change of behavior. It is arguably you are even trying to fix an ambiguous part of the manpage, but instead leave a more obviously one still broken. It is really difficult to understand the logical here.
> 

Please recall how this started: it was due to a report from a real end user, who was 
seeing a real problem. After a few emails, it was clear that there's not a good
work around available for cases like this:

* User space calls move_pages(), gets 0 (success) returned, and based on that,
proceeds to iterate through the status array.

* The status array remains untouched by the move_pages() call, so confusion and
wrong behavior ensues.

After some further discussion, we decided that the current behavior really is 
incorrect, and that it needs fixing in the kernel. Which this patch does.

>>
>> Michal also noticed several inconsistencies when he was reworking move_pages(), and I agree with him that we'd better not touch them without a clear usecase.
> 
> It could argue that there is no use case to restore the behavior either.
> 

So far, there are no reports from the field, and that's probably the key
difference between these two situations.

Hope that clears up the reasoning for you. I might add that, were you to study
all the emails in these threads, and the code and the man page, you would
probably agree with the conclusions above. You might disagree with the underlying
philosophies (such as "user space is really important and we fix it if it
breaks", etc), but that's a different conversation.


thanks,
-- 
John Hubbard
NVIDIA

