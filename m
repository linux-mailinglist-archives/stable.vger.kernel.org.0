Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C03F11479A
	for <lists+stable@lfdr.de>; Thu,  5 Dec 2019 20:27:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729240AbfLET1m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 14:27:42 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:42511 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726028AbfLET1m (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Dec 2019 14:27:42 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07487;MF=yang.shi@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0Tk3hI4V_1575574049;
Received: from US-143344MP.local(mailfrom:yang.shi@linux.alibaba.com fp:SMTPD_---0Tk3hI4V_1575574049)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 06 Dec 2019 03:27:33 +0800
Subject: Re: [v3 PATCH] mm: move_pages: return valid node id in status if the
 page is already on the target node
To:     Qian Cai <cai@lca.pw>
Cc:     fabecassis@nvidia.com, jhubbard@nvidia.com, mhocko@suse.com,
        cl@linux.com, vbabka@suse.cz, mgorman@techsingularity.net,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <1575572053-128363-1-git-send-email-yang.shi@linux.alibaba.com>
 <0E1D1C04-5892-438F-9191-F23CBE1A6DC5@lca.pw>
From:   Yang Shi <yang.shi@linux.alibaba.com>
Message-ID: <d96e3849-5fd4-26c0-31cf-02523085ed37@linux.alibaba.com>
Date:   Thu, 5 Dec 2019 11:27:27 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:52.0)
 Gecko/20100101 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <0E1D1C04-5892-438F-9191-F23CBE1A6DC5@lca.pw>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/5/19 11:19 AM, Qian Cai wrote:
>
>> On Dec 5, 2019, at 1:54 PM, Yang Shi <yang.shi@linux.alibaba.com> wrote:
>>
>> This is because the status is not set if the page is already on the
>> target node, but move_pages() should return valid status as long as it
>> succeeds.  The valid status may be errno or node id.
>>
>> We can't simply initialize status array to zero since the pages may be
>> not on node 0.  Fix it by updating status with node id which the page is
>> already on.
> This does not look correct either.
>
> “ENOENT
> No pages were found that require moving. All pages are either already on the target node, not present, had an invalid address or could not be moved because they were mapped by multiple processes.”
>
> move_pages() should return -ENOENT instead.

Yes, we noticed this too. I had a note in v1 and v2 patch, but I forgot 
paste in v3, says:

John noticed another return value inconsistency between the 
implementation and the manpage. The manpage says it should return 
-ENOENT if the page is already on the target node, but it doesn't. It 
looks the original code didn't return -ENOENT either, I'm not sure if 
this is a document issue or not. Anyway this is another issue, once we 
confirm it we can fix it later.

And, Michal also commented to the note:

I do not remember all the details but my recollection is that there were 
several inconsistencies present before I touched the code and I've 
decided to not touch them without a clear usecase.

