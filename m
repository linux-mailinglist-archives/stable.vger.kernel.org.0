Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60D9023D07C
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 21:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728257AbgHETtF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 15:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728343AbgHETsw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Aug 2020 15:48:52 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9696EC06174A
        for <stable@vger.kernel.org>; Wed,  5 Aug 2020 12:48:52 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id d188so17386888pfd.2
        for <stable@vger.kernel.org>; Wed, 05 Aug 2020 12:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20150623.gappssmtp.com; s=20150623;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=L17CWK1m3SliQ1EsOYU/bGzhjK9+vwZDDuk1FmFiO2U=;
        b=1pykeJF3J6nCADZe+oNtNIXQbcs+6ezxghmqOsh5fLU98/DwcNnv6LNoX+V1+UugAi
         jbyJ8S2TBOozl6G1DzMZCxynY3o6i+DGfRl/10ug/Rn+wOeWxyon8mc4qCiNfAcSOlaX
         Q1HDUu/1/pzCfyrajnzKkwAgyJeEag+JYZyhXLp5kmPoCJVhcp06Lw+lUiLi3NvQWbh4
         DG7P2QZ5iwlFIXFcJf3lYuWJzqqkVt3SAFOCFWWRU+dvO/DS/jWqvpCT48AGYfs2XRGS
         II4pH/3/UBYQglTe1cGiwkxrDjQCtBpGnFjwHqTV0iO7m94pOe11X7M/NWYeGUYJjqyr
         FznA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=L17CWK1m3SliQ1EsOYU/bGzhjK9+vwZDDuk1FmFiO2U=;
        b=qmbkOUePw647iS0Bi6KFGXcxOtKeVa4xiqVsZtvGnx17gPXSrl0LuKRvHnrobBJ5KB
         6YocjUvvU186lCkUDGJrcw5J23B9CuZrE7jE6O/HZDpV9Ea8BIluKmUZySdtF0uTnnj7
         qoPoa6je6Tu9UROMqOHvHhdpQ6rWWehjOoJaASl1Lc8jowXyNJPm6ZB25DADoTbTK12I
         0+8ne5IrJWEvs4RHWfco87YLzLL8z2HOW7rxyd7iuLCNpDfKtSO2U7LglKMD2z1dIlI7
         ay1UBWmKAmcvoUNTAkN1MJLd0ZqV3Cp9C9lzj7JY6aaGOI9W8th57E+fA/5OnunQqIwn
         Wbew==
X-Gm-Message-State: AOAM532lWJV1in4bJHT0qUcClFTtFQSIt/ixfgLaslcnQFAAKzh5KuVu
        8NM4jMzv4w+x2zyZdffRZW820g==
X-Google-Smtp-Source: ABdhPJwLhRMrPJuYQBuTk34kbj1gU4nZ+/dxUu//j3YIMASMw5+RvnfEU2fU01veDmWaS+MvgWUtCQ==
X-Received: by 2002:a63:e00c:: with SMTP id e12mr4364217pgh.413.1596656931925;
        Wed, 05 Aug 2020 12:48:51 -0700 (PDT)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id z189sm4627140pfb.178.2020.08.05.12.48.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 12:48:51 -0700 (PDT)
Date:   Wed, 05 Aug 2020 12:48:51 -0700 (PDT)
X-Google-Original-Date: Wed, 05 Aug 2020 12:48:49 PDT (-0700)
Subject:     Re: [PATCH 1/2] riscv: ptrace: Use the correct API for `fcsr' access
In-Reply-To: <alpine.LFD.2.21.2008051117180.24175@redsun52.ssa.fujisawa.hgst.com>
CC:     viro@zeniv.linux.org.uk, linux-riscv@lists.infradead.org,
        Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     macro@wdc.com
Message-ID: <mhng-6e42b0e6-1f3b-41a3-a023-4145fb4d8980@palmerdabbelt-glaptop1>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 05 Aug 2020 03:25:11 PDT (-0700), macro@wdc.com wrote:
> On Wed, 5 Aug 2020, Al Viro wrote:
>
>> > I'm not sure I understand what you're saying, but given that branch replaces
>> > all of this I guess it's best to just do nothing on our end here?
>>
>> It doesn't replace ->put() (for now); it _does_ replace ->get() and AFAICS the
>> replacement is much saner:
>>
>> static int riscv_fpr_get(struct task_struct *target,
>>                          const struct user_regset *regset,
>>                          struct membuf to)
>> {
>> 	struct __riscv_d_ext_state *fstate = &target->thread.fstate;
>>
>> 	membuf_write(&to, fstate, offsetof(struct __riscv_d_ext_state, fcsr));
>> 	membuf_store(&to, fstate->fcsr);
>> 	return membuf_zero(&to, 4);     // explicitly pad
>> }
>
>  I'm glad to see the old interface go, it was cumbersome.
>
>> user_regset_copyout() calling conventions are atrocious and so are those of
>> regset ->get().  The best thing to do with both is to take them out of their
>> misery and be done with that.  Do you see any problems with riscv gdbserver
>> on current linux-next?  If not, I'd rather see that "API" simply go away...
>> If there are problems, I would very much prefer fixes on top of what's done
>> in that branch.
>
>  I can push linux-next through regression-testing with RISC-V gdbserver
> and/or native GDB if that would help.  This is also used with core dumps,
> but honestly I don't know what state RISC-V support is in in the BFD/GDB's
> core dump interpreter, as people tend to forget about the core dump
> feature nowadays.

IIRC Andrew does GDB test suite runs sometimes natively on Linux as part of
general GDB maintiance and we don't see major issues, but I'm pretty checked
out of GDB development these days so he would know better than I do.  It's
always great to have someone test stuff, though -- and I doubt he's testing
linux-next.  It's been on my TODO list for a long time now to put together
tip-of-tree testing for the various projects but I've never gotten around to
doing it.

Oddly enough, despite not really using GDB I have used it for core dumps -- I
was writing a tool to convert commit logs to coredumps with the GDB reverse
debugging annotations, but I never got around to finishing it.
