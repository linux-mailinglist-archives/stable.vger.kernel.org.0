Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C504148B1F
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 16:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387448AbgAXPST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 10:18:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:34942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389354AbgAXPSR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 10:18:17 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35F4020709;
        Fri, 24 Jan 2020 15:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579879096;
        bh=B9JE+2kE+jyANeB9dKWwkQO3t234T8vFOOsqZseP6bE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=y4e8ABobiLOumUqsMVVQaYxpcsvvRpXRpX9kS/Kto+fdldidAVN3jbB5DBWX5BVLD
         qXhXbu5Xg/PsRks6Kpzfxed9Qux0K4y6X9qrJKZad2yDWaQMvnM2VVw1cZMy/gaYtj
         idSTr+Xyt/ls83qPORYJIRcbq7DRvJ2Pzdbl7txI=
Date:   Fri, 24 Jan 2020 10:18:15 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH 5.4 007/102] libbpf: Fix call relocation offset
 calculation bug
Message-ID: <20200124151815.GH1706@sasha-vm>
References: <20200124092806.004582306@linuxfoundation.org>
 <20200124092807.172946256@linuxfoundation.org>
 <CA+G9fYupGFyHCjikJqwiW5Y6_G+vqnn07Fgx50+=u2OKrrNyog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CA+G9fYupGFyHCjikJqwiW5Y6_G+vqnn07Fgx50+=u2OKrrNyog@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 24, 2020 at 07:13:27PM +0530, Naresh Kamboju wrote:
><trim>
>> Fixes: 48cca7e44f9f ("libbpf: add support for bpf_call")
>> Reported-by: Alexei Starovoitov <ast@kernel.org>
>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>> Acked-by: Yonghong Song <yhs@fb.com>
>> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
>> Link: https://lore.kernel.org/bpf/20191119224447.3781271-1-andriin@fb.com
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>
>> ---
>>  tools/lib/bpf/libbpf.c                             |    8 ++++++--
>>  tools/testing/selftests/bpf/progs/test_btf_haskv.c |    4 ++--
>>  tools/testing/selftests/bpf/progs/test_btf_newkv.c |    4 ++--
>>  tools/testing/selftests/bpf/progs/test_btf_nokv.c  |    4 ++--
>>  4 files changed, 12 insertions(+), 8 deletions(-)
>>
>> --- a/tools/lib/bpf/libbpf.c
>> +++ b/tools/lib/bpf/libbpf.c
>> @@ -1791,9 +1791,13 @@ bpf_program__collect_reloc(struct bpf_pr
>>                                 pr_warning("incorrect bpf_call opcode\n");
>>                                 return -LIBBPF_ERRNO__RELOC;
>>                         }
>> +                       if (sym.st_value % 8) {
>> +                               pr_warn("bad call relo offset: %lu\n", sym.st_value);
>
>Perf build failed on stable-rc 5.4 branch for arm, arm64, x86_64 and i386.
>
>libbpf.c: In function 'bpf_program__collect_reloc':
>libbpf.c:1795:5: error: implicit declaration of function 'pr_warn';
>did you mean 'pr_warning'? [-Werror=implicit-function-declaration]
>     pr_warn("bad call relo offset: %lu\n", sym.st_value);
>     ^~~~~~~
>     pr_warning
>libbpf.c:1795:5: error: nested extern declaration of 'pr_warn'
>[-Werror=nested-externs]
>Makefile:653: arch/arm64/Makefile: No such file or directory
>cc1: all warnings being treated as errors
>
>build links,
>https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-5.4/DISTRO=lkft,MACHINE=hikey,label=docker-lkft/69/consoleText
>https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-5.4/DISTRO=lkft,MACHINE=intel-corei7-64,label=docker-lkft/69/consoleText

Oh, I realized I'm not testing libbpf. I'll drop this patch for now.

-- 
Thanks,
Sasha
