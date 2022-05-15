Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7027C527676
	for <lists+stable@lfdr.de>; Sun, 15 May 2022 10:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234405AbiEOI5Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 May 2022 04:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233797AbiEOI5Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 May 2022 04:57:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE7406274;
        Sun, 15 May 2022 01:57:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 882CA60EC3;
        Sun, 15 May 2022 08:57:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89667C385B8;
        Sun, 15 May 2022 08:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652605042;
        bh=VxFX7xx56JZzOHMNORrQI6bWg6BbNTRrh7GpU1e75ew=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=g/CZJvOU1p1ZrPXYrVQvy1DW6PuSKfsNt6Hx9SxbNQA3J2ffj1FQqyBsZOnvjHtAc
         yR9a1B18F8UujVdntyEYxjkx5KlnHFeXp9hcudsx+pqZG7tnFFs29u5o1k7urIEZlI
         lo4PfqtaJvVvziEDvfugt44I1pd8H9nymDOLW3oJ+ov37LNufRFT94ZDa2mu0/n3aq
         r3w+bt1E++P01OcXiIjagYV8Z8q879qGmu9NbeOv5Bbnwn2k249Wv55TVUAa3J3H8p
         WrIqcv7othwhF8lkpO9nqKORo4YDU2nXXnKPSQNGqDcwNOLXV7Ega173ZAXiFXk4Gu
         2bGbvqKrUl7gQ==
Message-ID: <6b316ed0-c5af-0157-b04a-4aea1c0b9143@kernel.org>
Date:   Sun, 15 May 2022 16:57:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v2] f2fs: fix to do sanity check for inline inode
Content-Language: en-US
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     jaegeuk@kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ming Yan <yanming@tju.edu.cn>, Chao Yu <chao.yu@oppo.com>
References: <20220514080102.2246-1-chao@kernel.org>
 <Yn+dLtxsy6LwVIBQ@debian.me>
From:   Chao Yu <chao@kernel.org>
In-Reply-To: <Yn+dLtxsy6LwVIBQ@debian.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022/5/14 20:14, Bagas Sanjaya wrote:
> On Sat, May 14, 2022 at 04:01:02PM +0800, Chao Yu wrote:
>> As Yanming reported in bugzilla:
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=215895
>>
>> I have encountered a bug in F2FS file system in kernel v5.17.
>>
>> The kernel message is shown below:
>>
>> kernel BUG at fs/inode.c:611!
>> Call Trace:
>>   evict+0x282/0x4e0
>>   __dentry_kill+0x2b2/0x4d0
>>   dput+0x2dd/0x720
>>   do_renameat2+0x596/0x970
>>   __x64_sys_rename+0x78/0x90
>>   do_syscall_64+0x3b/0x90
>>
>> The root cause is: fuzzed inode has both inline_data flag and encrypted
>> flag, so after it was deleted by rename(), during f2fs_evict_inode(),
>> it will cause inline data conversion due to flags confilction, then
>> page cache will be polluted and trigger panic in clear_inode().
>>
>> This patch tries to fix the issue by do more sanity checks for inline
>> data inode in sanity_check_inode().
>>
>> Cc: stable@vger.kernel.org
>> Reported-by: Ming Yan <yanming@tju.edu.cn>
>> Signed-off-by: Chao Yu <chao.yu@oppo.com>
> 
> Hi Chao,
> 
> I think the patch message can be reworked , like below:

Hi Bagas,

Thanks a lot for your cleanup. :)

> 
> Yanming reported a kernel bug in Bugzilla kernel, which can be reproduced.
> The bug message is:

I will keep the link for backtrace.

> 
> kernel BUG at fs/inode.c:611!
> Call Trace:
>   evict+0x282/0x4e0
>   __dentry_kill+0x2b2/0x4d0
>   dput+0x2dd/0x720
>   do_renameat2+0x596/0x970
>   __x64_sys_rename+0x78/0x90
>   do_syscall_64+0x3b/0x90
> 
> The bug is due to fuzzed inode has both inline_data and encrypted flags.
> During f2fs_evict_inode(), after the inode was deleted by rename(), it

I prefer "during f2fs_evict_inode(), as inode was deleted by rename()"

> will cause inline data conversion due to conflicting flags. The page
> cache will be polluted and the panic will be triggered in clear_inode().
> 
> Try fixing the bug by doing more sanity checks for inline data inode in
> sanity_check_inode().

Let me revise in v3.

Thanks,

> 
> Thanks.
> 
