Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 338753D1DC6
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 07:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbhGVFNG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 01:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbhGVFNF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Jul 2021 01:13:05 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C61DC061575
        for <stable@vger.kernel.org>; Wed, 21 Jul 2021 22:53:41 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id a17-20020a17090abe11b0290173ce472b8aso2727553pjs.2
        for <stable@vger.kernel.org>; Wed, 21 Jul 2021 22:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=28owLvv+vL6tVtuvmnfHr7+qgTSNqBXGBIr+3Xh6M9I=;
        b=hpbQp607GEFF9BCuVfEbDnBl6wt+QGW+IpFzORDnEq6cmOEC3dka+R5HSzK07WOoTN
         UsWZ1gJQGUo9muaSIl3PVyy+mYkPB+BWkp7DntatitzmvMxcR3je7f0avV6Db4ND6xFm
         9dBHri4GY2RS6qRoy2pgleiJgnn2O2oW5/nxLEr07DIZjiszDijILxRJKh6+uBRJtbVg
         M7aDC6ykEPFUQ/SnhrnikWg0yz2y2c80GVmd91tqhsh25jusi/Q4UE5CJCyXGRX2c3/4
         1wlXUiDx8PscIshdELj+35VYcbXbl5YU68Esmx7mcs60tZXSEhcWH5dbKux8ixpQkdVO
         Aj1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=28owLvv+vL6tVtuvmnfHr7+qgTSNqBXGBIr+3Xh6M9I=;
        b=syN7byS//B2HiZNcwufhJrW13o93i1ucTcaV7OnynqDj5PTWVTngTtfMFFvYVWoYVw
         Dk7Kzn/OxCxjEeMbZjwL6z81OQkoH38q4AEryVdQm/j9bJRv7NaTdrfWlq2g+ftHo5Fa
         XWN6xZyqMJUc9nSdlN/4IAV7gMXMN+HkTOzz8VluH4b002D6AlMQyW/FegjQiMs3EMqJ
         ikzgzLdczKkNBIWAvYBgQxurLIb/foCgvnzjB4fIb3rAdMcnCpuXQ47mcxbRB9HTvw65
         Tv+Cn9p9Pj4PEca4USPvzUmmWAhY6PGIk3zu/Glm45zjHLiyp8Fpljghdl5s2R5CgN3c
         Kx9A==
X-Gm-Message-State: AOAM530qfGSyuOOF+0JlSBarL3db1iaPpL3wzMTspt9aJJq1wLjYtdHm
        4ruDnYhTfSr0Li8u7sasLP1hOw==
X-Google-Smtp-Source: ABdhPJwg4kNrjPL5wglKUZNAdm57nuCLNRhTw7Jq2LqJ9dqrvFwcFcEnvN1fCwH5tuB07Uvu4TvIhw==
X-Received: by 2002:a17:90b:4ac9:: with SMTP id mh9mr7595414pjb.226.1626933220572;
        Wed, 21 Jul 2021 22:53:40 -0700 (PDT)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id z15sm32360128pgc.13.2021.07.21.22.53.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 22:53:40 -0700 (PDT)
Date:   Wed, 21 Jul 2021 22:53:40 -0700 (PDT)
X-Google-Original-Date: Wed, 21 Jul 2021 22:23:26 PDT (-0700)
Subject:     Re: [PATCH] riscv: Fix 32-bit RISC-V boot failure
In-Reply-To: <CAEUhbmVO_dV86LJLz3S4PFu9oFp4_5HWSkKLwqc-ZkQK=yYZfw@mail.gmail.com>
CC:     wangkefeng.wang@huawei.com, Atish Patra <Atish.Patra@wdc.com>,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
        stable@vger.kernel.org
From:   Palmer Dabbelt <palmerdabbelt@google.com>
To:     bmeng.cn@gmail.com, Greg KH <gregkh@linuxfoundation.org>
Message-ID: <mhng-4e9664d5-a766-40d3-8757-230788677472@palmerdabbelt-glaptop>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 15 Jul 2021 19:14:20 PDT (-0700), bmeng.cn@gmail.com wrote:
> On Thu, Jul 8, 2021 at 9:29 PM Bin Meng <bmeng.cn@gmail.com> wrote:
>>
>> Hi Palmer,
>>
>> On Thu, Jul 1, 2021 at 10:20 AM Bin Meng <bmeng.cn@gmail.com> wrote:
>> >
>> > On Thu, Jul 1, 2021 at 10:08 AM Kefeng Wang <wangkefeng.wang@huawei.com> wrote:
>> > >
>> > >
>> > > On 2021/6/30 19:58, Bin Meng wrote:
>> > > > On Mon, Jun 28, 2021 at 11:21 AM Bin Meng <bmeng.cn@gmail.com> wrote:
>> > > >> On Mon, Jun 28, 2021 at 10:28 AM Kefeng Wang <wangkefeng.wang@huawei.com> wrote:
>> > > >>>
>> > > >>> On 2021/6/28 9:15, Bin Meng wrote:
>> > > >>>> On Mon, Jun 28, 2021 at 8:53 AM Kefeng Wang <wangkefeng.wang@huawei.com> wrote:
>> > > >>>>> Hi， sorry for the mistake，the bug is fixed by
>> > > >>>>>
>> > > >>>>> https://lore.kernel.org/linux-riscv/20210602085517.127481-2-wangkefeng.wang@huawei.com/
>> > > >>>> What are we on the patch you mentioned?
>> > > >>>>
>> > > >>>> I don't see it applied in the linux/master.
>> > > >>>>
>> > > >>>> Also there should be a "Fixes" tag and stable@vger.kernel.org cc'ed
>> > > >>>> because 32-bit is broken since v5.12.
>> > > >>> https://kernel.googlesource.com/pub/scm/linux/kernel/git/riscv/linux/+/c9811e379b211c67ba29fb09d6f644dd44cfcff2
>> > > >>>
>> > > >>> it's on Palmer' riscv-next.
>> > > >> Not sure riscv-next is for which release? This is a regression and
>> > > >> should be on 5.13.
>> > > >>
>> > > >>> Hi Palmer, should I resend or could you help me to add the fixes tag?
>> > > > Your patch mixed 2 things (fix plus one feature) together, so it is
>> > > > not proper to back port your patch.
>> > >
>> > > "mem=" will change the range of memblock, so the fix part must be included.
>> > >
>> >
>> > Yes, so you can rebase the "mem=" changes on top of my patch.
>> >
>> > The practice is that we should not mix 2 things in one patch. I can
>> > imagine that you wanted to add "mem=" to RISC-V and suddenly found the
>> > existing logic was broken, so you sent one patch to do both.
>> >
>> > >
>> > > >
>> > > > Here is my 2 cents:
>> > > >
>> > > > 1. Drop your patch from riscv-next
>> > > > 2. Apply my patch as it is a simple fix to previous commit. This
>> > > > allows stable kernel to cherry-pick the fix to v5.12 and v5.13.
>> > > > 3. Rebase your patch against mine, and resend v2
>> > > >
>> > > > Let me know if this makes sense.
>> > >
>> > > It is not a big problem for me, but I have no right abourt riscv-next,
>> > >
>> > > let's wait Palmer's advise.
>> > >
>> >
>> > Sure. Palmer, let me know your thoughts.
>>
>> Ping?
>
> Ping?

Sorry, I missed this one.  It looks like the patch that adds mem= and 
fixes the bug has already been merged, so I'm not really quite sure what 
the right thing to do is here: we don't really want the mem= code on 
stable, but we do want the fix.  I went ahead and did

commit 444818b599189fd8b6c814da542ff8cfc9fe67d4 (HEAD -> fixes, palmer/fixes)
gpg: Signature made Wed 21 Jul 2021 10:21:05 PM PDT
gpg:                using RSA key 2B3C3747446843B24A943A7A2E1319F35FBB1889
gpg:                issuer "palmer@dabbelt.com"
gpg: Good signature from "Palmer Dabbelt <palmer@dabbelt.com>" [ultimate]
gpg:                 aka "Palmer Dabbelt <palmerdabbelt@google.com>" [ultimate]
Merge: e73f0f0ee754 d0e4dae74470
Author: Palmer Dabbelt <palmerdabbelt@google.com>
Date:   Wed Jul 21 22:18:58 2021 -0700

    Merge remote-tracking branch 'riscv/riscv-fix-32bit' into fixes

    This contains a single fix for 32-bit boot.  It happens this was already
    fixed by c9811e379b21 ("riscv: Add mem kernel parameter support"), but
    the bug existed before that feature addition so I've applied the patch
    earlier and then merged it in (which results in a conflict, which is
    fixed via not changing the resulting tree).

    * riscv/riscv-fix-32bit:
      riscv: Fix 32-bit RISC-V boot failure

as that"s the best I could come up with -- then the fix will land on 
master, which should cause it to get pulled onto stable.

Greg: is there a better way to make something like this get to stable?
