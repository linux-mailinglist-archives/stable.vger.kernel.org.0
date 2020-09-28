Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFF6A27B7F6
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 01:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbgI1XUc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 19:20:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:42848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726379AbgI1XUc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Sep 2020 19:20:32 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F62721D7F;
        Mon, 28 Sep 2020 22:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601330488;
        bh=MZv602zAH+mldtKaHV8n2x/vl5hO6z6CgNiDtNb/co4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=10JFGv45YDJTrlFEV6WQiTAi/TskPMzQj6c6xbeq9coOe6pfxGYK0il/SvxLwNFVy
         ilsp7OakST5z753hMgoeauIJjW/hdokg8folEDFOfyRy6IK6iooE4J7OMx5EhT2IH7
         vAD/K7NxbXL/8L1GL3xPWfzt2zHTf9nv6NuiV0QU=
Date:   Mon, 28 Sep 2020 18:01:27 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux- stable <stable@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        open list <linux-kernel@vger.kernel.org>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        clang-built-linux@googlegroups.com, Jiri Olsa <jolsa@kernel.org>,
        Leo Yan <leo.yan@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        lkft-triage@lists.linaro.org
Subject: Re: [PATCH AUTOSEL 4.14 112/127] perf parse-events: Fix incorrect
 conversion of 'if () free()' to 'zfree()'
Message-ID: <20200928220127.GE2219727@sasha-vm>
References: <20200918021220.2066485-1-sashal@kernel.org>
 <20200918021220.2066485-112-sashal@kernel.org>
 <CA+G9fYteKZxdLVtQzXyh36hhaj6W5e17U_emsXwZdjPoeyj+OQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CA+G9fYteKZxdLVtQzXyh36hhaj6W5e17U_emsXwZdjPoeyj+OQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 29, 2020 at 01:24:32AM +0530, Naresh Kamboju wrote:
>On Fri, 18 Sep 2020 at 08:00, Sasha Levin <sashal@kernel.org> wrote:
>>
>> From: Arnaldo Carvalho de Melo <acme@redhat.com>
>>
>> [ Upstream commit 7fcdccd4237724931d9773d1e3039bfe053a6f52 ]
>>
>> When applying a patch by Ian I incorrectly converted to zfree() an
>> expression that involved testing some other struct member, not the one
>> being freed, which lead to bugs reproduceable by:
>>
>>   $ perf stat -e i/bs,tsc,L2/o sleep 1
>>   WARNING: multiple event parsing errors
>>   Segmentation fault (core dumped)
>>   $
>>
>> Fix it by restoring the test for pos->free_str before freeing
>> pos->val.str, but continue using zfree(&pos->val.str) to set that member
>> to NULL after freeing it.
>>
>> Reported-by: Ian Rogers <irogers@google.com>
>> Fixes: e8dfb81838b1 ("perf parse-events: Fix memory leaks found on parse_events")
>> Cc: Adrian Hunter <adrian.hunter@intel.com>
>> Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
>> Cc: Andi Kleen <ak@linux.intel.com>
>> Cc: clang-built-linux@googlegroups.com
>> Cc: Jiri Olsa <jolsa@kernel.org>
>> Cc: Leo Yan <leo.yan@linaro.org>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: Namhyung Kim <namhyung@kernel.org>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Stephane Eranian <eranian@google.com>
>> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>stable rc 4.14 perf build broken.

Dropped, thanks!

-- 
Thanks,
Sasha
