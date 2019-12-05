Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6764C114909
	for <lists+stable@lfdr.de>; Thu,  5 Dec 2019 23:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729417AbfLEWJO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 17:09:14 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:42641 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729154AbfLEWJO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Dec 2019 17:09:14 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07486;MF=yang.shi@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0Tk4-uwA_1575583745;
Received: from US-143344MP.local(mailfrom:yang.shi@linux.alibaba.com fp:SMTPD_---0Tk4-uwA_1575583745)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 06 Dec 2019 06:09:09 +0800
Subject: Re: [v3 PATCH] mm: move_pages: return valid node id in status if the
 page is already on the target node
To:     Qian Cai <cai@lca.pw>
Cc:     fabecassis@nvidia.com, jhubbard@nvidia.com, mhocko@suse.com,
        cl@linux.com, vbabka@suse.cz, mgorman@techsingularity.net,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <d96e3849-5fd4-26c0-31cf-02523085ed37@linux.alibaba.com>
 <A5A53ED8-D17C-4BCD-9832-93DB0D9302A0@lca.pw>
From:   Yang Shi <yang.shi@linux.alibaba.com>
Message-ID: <ff202f9f-4124-7e63-a5fb-ebeb2a263632@linux.alibaba.com>
Date:   Thu, 5 Dec 2019 14:09:04 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:52.0)
 Gecko/20100101 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <A5A53ED8-D17C-4BCD-9832-93DB0D9302A0@lca.pw>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/5/19 11:34 AM, Qian Cai wrote:
>
>> On Dec 5, 2019, at 2:27 PM, Yang Shi <yang.shi@linux.alibaba.com> wrote:
>>
>> John noticed another return value inconsistency between the implementation and the manpage. The manpage says it should return -ENOENT if the page is already on the target node, but it doesn't. It looks the original code didn't return -ENOENT either, I'm not sure if this is a document issue or not. Anyway this is another issue, once we confirm it we can fix it later.
> No, I think it is important to figure out this in the first place. Otherwise, it is pointless to touch this piece of code over and over again, i.e., this is not another issue but the core of this problem on hand.

As I said the status return value issue is a regression, but the -ENOENT 
issue has been there since the syscall was introduced (The visual 
inspection shows so I didn't actually run test against 2.6.x kernel, but 
it returns 0 for >= 3.10 at least). It does need further clarification 
(doc problem or code problem).

Michal also noticed several inconsistencies when he was reworking 
move_pages(), and I agree with him that we'd better not touch them 
without a clear usecase.
