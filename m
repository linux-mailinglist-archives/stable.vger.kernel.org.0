Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 197254EDF37
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 18:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240372AbiCaQ74 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 12:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240369AbiCaQ7z (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 12:59:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA1222325DB;
        Thu, 31 Mar 2022 09:58:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55EAB60E07;
        Thu, 31 Mar 2022 16:58:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90DF7C340ED;
        Thu, 31 Mar 2022 16:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648745886;
        bh=qtxA2NrqK7Exzf7HC/ksSd8ei66uPYi3MMMoC8zkUoY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KsAWDahHmpxJIyCJvBq9W0j556uYj9F8vaXF1+3BfNZfCQxlHkc9VIcCELmkb1D+E
         0L0RtzDBqgcvw0n7dClO9+7JCuRMUKbFafLUtcffHiY2VdMUc8KaGGjxcPRc9ZHFzI
         MuPOCH2nFpOCKdTyd7jV57WUW8TUMfe070InAjQ0x85S6nIihxvVgna1a2pSsX0kBV
         m2bdPhSkUnRyhy+YT/LkLR9E77i9RZAMaLt+P4qkA3iIUdLvfUn3oi4zC+UaaWxKPR
         fNMk7PkAaLz3mVqtTbRKv8VGDfpUe4BGMMZkWoF9+SaHk7DrmEbsoX6qFKzbMy5xro
         fMc4ZpCYVnNLA==
Date:   Thu, 31 Mar 2022 12:58:05 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Stephen Brennan <stephen.s.brennan@oracle.com>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        linux@roeck-us.net
Subject: Re: [PATCH AUTOSEL 5.17 31/66] printk: Add panic_in_progress helper
Message-ID: <YkXdnZqCIOsctwUI@sashalap>
References: <20220330114646.1669334-1-sashal@kernel.org>
 <20220330114646.1669334-31-sashal@kernel.org>
 <YkRELPuydJ5Fn3It@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YkRELPuydJ5Fn3It@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 30, 2022 at 01:51:08PM +0200, Greg KH wrote:
>On Wed, Mar 30, 2022 at 07:46:10AM -0400, Sasha Levin wrote:
>> From: Stephen Brennan <stephen.s.brennan@oracle.com>
>>
>> [ Upstream commit 77498617857f68496b360081dde1a492d40c28b2 ]
>>
>> This will be used help avoid deadlocks during panics. Although it would
>> be better to include this in linux/panic.h, it would require that header
>> to include linux/atomic.h as well. On some architectures, this results
>> in a circular dependency as well. So instead add the helper directly to
>> printk.c.
>>
>> Suggested-by: Petr Mladek <pmladek@suse.com>
>> Signed-off-by: Stephen Brennan <stephen.s.brennan@oracle.com>
>> Reviewed-by: Petr Mladek <pmladek@suse.com>
>> Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
>> Signed-off-by: Petr Mladek <pmladek@suse.com>
>> Link: https://lore.kernel.org/r/20220202171821.179394-2-stephen.s.brennan@oracle.com
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  kernel/printk/printk.c | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
>> index 82abfaf3c2aa..0f8918f5f22a 100644
>> --- a/kernel/printk/printk.c
>> +++ b/kernel/printk/printk.c
>> @@ -257,6 +257,11 @@ static void __up_console_sem(unsigned long ip)
>>  }
>>  #define up_console_sem() __up_console_sem(_RET_IP_)
>>
>> +static bool panic_in_progress(void)
>> +{
>> +	return unlikely(atomic_read(&panic_cpu) != PANIC_CPU_INVALID);
>> +}
>> +
>>  /*
>>   * This is used for debugging the mess that is the VT code by
>>   * keeping track if we have the console semaphore held. It's
>> --
>> 2.34.1
>>
>
>All 4 of the printk patches should not need to be backported to stable
>kernels, thanks.  Please drop them all.

I'll drop them, thanks.

-- 
Thanks,
Sasha
