Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CFAE6D9766
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 14:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237928AbjDFMzW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 08:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237514AbjDFMzV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 08:55:21 -0400
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 469694C21;
        Thu,  6 Apr 2023 05:55:19 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=rongwei.wang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VfTAMRc_1680785713;
Received: from 30.221.129.255(mailfrom:rongwei.wang@linux.alibaba.com fp:SMTPD_---0VfTAMRc_1680785713)
          by smtp.aliyun-inc.com;
          Thu, 06 Apr 2023 20:55:14 +0800
Message-ID: <a37f0f71-2ea0-857a-6e87-376d95d207a9@linux.alibaba.com>
Date:   Thu, 6 Apr 2023 20:55:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.1
Subject: Re: [PATCH v2] mm/swap: fix swap_info_struct race between swapoff and
 get_swap_pages()
Content-Language: en-US
To:     Aaron Lu <aaron.lu@intel.com>
Cc:     akpm@linux-foundation.org, bagasdotme@gmail.com,
        willy@infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20230401221920.57986-1-rongwei.wang@linux.alibaba.com>
 <20230404154716.23058-1-rongwei.wang@linux.alibaba.com>
 <6dad8c2f-b896-3cc0-26c1-37f5fff406bd@linux.alibaba.com>
 <20230406121245.GA376058@ziqianlu-desk2>
From:   Rongwei Wang <rongwei.wang@linux.alibaba.com>
In-Reply-To: <20230406121245.GA376058@ziqianlu-desk2>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.2 required=5.0 tests=ENV_AND_HDR_SPF_MATCH,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Oh, sorry, I miss this email just now, that because of I'm also replying 
your previous email.

On 2023/4/6 20:12, Aaron Lu wrote:
> On Wed, Apr 05, 2023 at 12:08:47AM +0800, Rongwei Wang wrote:
>> Hello
>>
>> I have fix up some stuff base on Patch v1. And in order to help all readers
>> and reviewers to
>>
>> reproduce this bug, share a reproducer here:
> I reproduced this problem under a VM this way:
>
> $ sudo ./stress-ng --swap 1
> // on another terminal
> $ for i in `seq 8`; do ./swap & done
> Looks simpler than yours :-)
Cool, indeed become simpler.
> (Didn't realize you have posted your reproducer here since I'm not CCed
> and just found it after invented mine)
> Then the warning message normally appear within a few seconds.
>
> Here is the code for the above swap prog:
>
> #include <stdio.h>
> #include <stddef.h>
> #include <sys/mman.h>
>
> #define SIZE 0x100000
>
> int main(void)
> {
>          int i, ret;
>          void *p;
>
>          p = mmap(NULL, SIZE, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANON, -1, 0);
>          if (p == MAP_FAILED) {
>                  perror("mmap");
>                  return -1;
>          }
>
>          ret = 0;
>          while (1) {
>                  for (i = 0; i < SIZE; i += 0x1000)
>                          ((char *)p)[i] = 1;
>                  ret = madvise(p, SIZE, MADV_PAGEOUT);
>                  if (ret != 0) {
>                          perror("madvise");
>                          break;
>                  }
>          }
>
>          return ret;
> }
>
> Unfortunately, this test prog did not work on kernels before v5.4 because
> MADV_PAGEOUT is introduced in v5.4. I tested on v5.4 and the problem is
> also there.

Maybe that is this bug can not be found since now. And we found this is 
triggered by stress-ng-swap and stress-ng-madvise (PAGEOUT) firstly. It 
seems this is that reason.

It seems MADV_COLD is also introduced together with MADV_PAGEOUT. I have 
no idea and have to depend on you.:-)

>
> Haven't found a way to trigger swap with swap device come and go on
> kernels before v5.4; tried putting the test prog in a memcg with memory
> limit but then the prog is easily killed due to nowhere to swap out.
>
Personally, I do not intend to continuing searching for the method to 
reproduce before v5.4. Of course, if you have idea, I can try.


Thanks:-)

