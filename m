Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 751E5D0443
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 01:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729495AbfJHXk1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 19:40:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:46152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726822AbfJHXk1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Oct 2019 19:40:27 -0400
Received: from localhost (unknown [131.107.159.163])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7BEA21721;
        Tue,  8 Oct 2019 23:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570578026;
        bh=hJeYw5xAsubnuUYuENZmbA/IWW++YDtUqL/jJ8ENM0c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mhhXn0mt9MOEUZB7M/oakQkyOu1O/nD9lXJIqWjRhUR7CWwhmBJtyHYknnyMHywwp
         1aZR/JyT5U4UthKqlYowIhoFUGxxMbnnmt/sebG5T6VUR8w5so2snQqQOHPOFJBA2I
         MlHa4n43paseCytfLahAd8K78KxcymRvS96AA19U=
Date:   Tue, 8 Oct 2019 19:40:26 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     jolsa@kernel.org, acme@redhat.com,
        alexander.shishkin@linux.intel.com, mpetlan@redhat.com,
        namhyung@kernel.org, peterz@infradead.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] perf tools: Fix segfault in
 cpu_cache_level__read()" failed to apply to 4.19-stable tree
Message-ID: <20191008234026.GM1396@sasha-vm>
References: <1570555231157141@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1570555231157141@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 08, 2019 at 07:20:31PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.19-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 0216234c2eed1367a318daeb9f4a97d8217412a0 Mon Sep 17 00:00:00 2001
>From: Jiri Olsa <jolsa@kernel.org>
>Date: Thu, 12 Sep 2019 12:52:35 +0200
>Subject: [PATCH] perf tools: Fix segfault in cpu_cache_level__read()
>
>We release wrong pointer on error path in cpu_cache_level__read
>function, leading to segfault:
>
>  (gdb) r record ls
>  Starting program: /root/perf/tools/perf/perf record ls
>  ...
>  [ perf record: Woken up 1 times to write data ]
>  double free or corruption (out)
>
>  Thread 1 "perf" received signal SIGABRT, Aborted.
>  0x00007ffff7463798 in raise () from /lib64/power9/libc.so.6
>  (gdb) bt
>  #0  0x00007ffff7463798 in raise () from /lib64/power9/libc.so.6
>  #1  0x00007ffff7443bac in abort () from /lib64/power9/libc.so.6
>  #2  0x00007ffff74af8bc in __libc_message () from /lib64/power9/libc.so.6
>  #3  0x00007ffff74b92b8 in malloc_printerr () from /lib64/power9/libc.so.6
>  #4  0x00007ffff74bb874 in _int_free () from /lib64/power9/libc.so.6
>  #5  0x0000000010271260 in __zfree (ptr=0x7fffffffa0b0) at ../../lib/zalloc..
>  #6  0x0000000010139340 in cpu_cache_level__read (cache=0x7fffffffa090, cac..
>  #7  0x0000000010143c90 in build_caches (cntp=0x7fffffffa118, size=<optimiz..
>  ...
>
>Releasing the proper pointer.
>
>Fixes: 720e98b5faf1 ("perf tools: Add perf data cache feature")
>Signed-off-by: Jiri Olsa <jolsa@kernel.org>
>Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
>Cc: Michael Petlan <mpetlan@redhat.com>
>Cc: Namhyung Kim <namhyung@kernel.org>
>Cc: Peter Zijlstra <peterz@infradead.org>
>Cc: stable@vger.kernel.org: # v4.6+
>Link: http://lore.kernel.org/lkml/20190912105235.10689-1-jolsa@kernel.org
>Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

Conflicts due to d8f9da240495b ("perf tools: Use zfree() where
applicable"). Fixed up and queued for 4.9+.

-- 
Thanks,
Sasha
