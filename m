Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3CC923C3E7
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 05:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725999AbgHEDPW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Aug 2020 23:15:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbgHEDPW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Aug 2020 23:15:22 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC24C06174A
        for <stable@vger.kernel.org>; Tue,  4 Aug 2020 20:15:22 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id g19so11902260plq.0
        for <stable@vger.kernel.org>; Tue, 04 Aug 2020 20:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20150623.gappssmtp.com; s=20150623;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=VtIghFUUQN5mDIDgH3ibaPqJHhjrfIMsBIz4Kx+N5Ow=;
        b=zJXG3v/hVCrB+1rVcOQ6m9Yd0dtr2TN4bTZWw8Zu1q5/MQWvJ4DwFqCrIcfwGunIEp
         ucW/z3YH4km9BvKmyUXePzMMjY7EgMsbXoWGeRueG7leIua6KOTit+hv0QLyEhY007Io
         VFcoElqsSZkts2Evqn94Us0FFofeU+X0vJyPc7J0K6u/ma9K7E8rE/8v+A/bT9fWF7C5
         CHjKNqngi+xZAVGpkMVDUHIU87S50gkaXEb+OqkdzNnc1y4y440Tu0/ccW5d6CfKfys5
         Ptma1t87IloKNk5AuPTCYukFVebK9gKUXA2Z7jT6z4luMlaFrOVkl2LR9GCbaEbpi9yi
         yAlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=VtIghFUUQN5mDIDgH3ibaPqJHhjrfIMsBIz4Kx+N5Ow=;
        b=CaApOtJNP3V23nyrvzeIkz5ahFQiezgI43AzbDdGX10xH2d3E3YStWUiY85P7QESvy
         k3lcPDK0vhTZJWXJUGVNA9eQgbmHHMmbRqAN0KYoYdze3ThDKKgYVrpryibjhuzylsk0
         tx+OlSWRTldop+s1gsSB8MzOjEr8IsiBp/yMSnooVBVjBJSpgBB+5Kt1CC8LLs3+wikp
         0bD/Ghd15rmhtHk0C1JXrAJgtbLcDCvL2CSjvNuVMmh2V+5IDcPODsxD8xaCulWVBlbQ
         lWunTXMpNMYKgqmYKUi3xkb3//c03gL/OVAQgPcUbqyr2lyVuaohx+LSsI1eY3gwPcKm
         Yr9g==
X-Gm-Message-State: AOAM5326dtyEnSAs74YK2Kzikb/yOt1rVeACt+ncFceoXnm+oKYV2Jvz
        XSzVC4y8Ce4gYMMVmcK+XSO51g==
X-Google-Smtp-Source: ABdhPJwACgfukRamo/zUHdUPi8KTwWhQHcSlNJgrqdqyEldAO2Q5ZM3XH0cxBgJ2eb195FpT47V41Q==
X-Received: by 2002:a17:90a:25a9:: with SMTP id k38mr1178872pje.103.1596597321290;
        Tue, 04 Aug 2020 20:15:21 -0700 (PDT)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id il10sm816178pjb.54.2020.08.04.20.15.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2020 20:15:20 -0700 (PDT)
Date:   Tue, 04 Aug 2020 20:15:20 -0700 (PDT)
X-Google-Original-Date: Tue, 04 Aug 2020 20:15:19 PDT (-0700)
Subject:     Re: [PATCH 1/2] riscv: ptrace: Use the correct API for `fcsr' access
In-Reply-To: <20200805024807.GM1236603@ZenIV.linux.org.uk>
CC:     macro@wdc.com, linux-riscv@lists.infradead.org,
        Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     viro@zeniv.linux.org.uk
Message-ID: <mhng-2d0483dd-411b-4e2b-aae1-b8bb52417d29@palmerdabbelt-glaptop1>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 04 Aug 2020 19:48:07 PDT (-0700), viro@zeniv.linux.org.uk wrote:
> On Tue, Aug 04, 2020 at 07:20:05PM -0700, Palmer Dabbelt wrote:
>> On Tue, 04 Aug 2020 19:07:45 PDT (-0700), viro@zeniv.linux.org.uk wrote:
>> > On Tue, Aug 04, 2020 at 07:01:01PM -0700, Palmer Dabbelt wrote:
>> >
>> > > > We currently have @start_pos fixed at 0 across all calls, which works as
>> > > > a result of the implementation, in particular because we have no padding
>> > > > between the FP general registers and the FP control and status register,
>> > > > but appears not to have been the intent of the API and is not what other
>> > > > ports do, requiring one to study the copy handlers to understand what is
>> > > > going on here.
>> >
>> > start_pos *is* fixed at 0 and it's going to go away, along with the
>> > sodding user_regset_copyout() very shortly.  ->get() is simply a bad API.
>> > See vfs.git#work.regset for replacement.  And ->put() is also going to be
>> > taken out and shot (next cycle, most likely).
>>
>> I'm not sure I understand what you're saying, but given that branch replaces
>> all of this I guess it's best to just do nothing on our end here?
>
> It doesn't replace ->put() (for now); it _does_ replace ->get() and AFAICS the
> replacement is much saner:
>
> static int riscv_fpr_get(struct task_struct *target,
>                          const struct user_regset *regset,
>                          struct membuf to)
> {
> 	struct __riscv_d_ext_state *fstate = &target->thread.fstate;
>
> 	membuf_write(&to, fstate, offsetof(struct __riscv_d_ext_state, fcsr));
> 	membuf_store(&to, fstate->fcsr);
> 	return membuf_zero(&to, 4);     // explicitly pad
> }
>
> user_regset_copyout() calling conventions are atrocious and so are those of
> regset ->get().  The best thing to do with both is to take them out of their
> misery and be done with that.  Do you see any problems with riscv gdbserver
> on current linux-next?  If not, I'd rather see that "API" simply go away...
> If there are problems, I would very much prefer fixes on top of what's done
> in that branch.

I guess my confusion was about "start_pos *is* fixed at 0": it certainly is
zero in the code right now, but when poking around while review the patch I
didn't see any reason that must be so.  Admittedly all I did was read the
prototype and function, so maybe I'm just missing something.  That said, if
it's all going away anyway then I don't really care either way.

As far as I can tell the patch set in question (the RISC-V one) doesn't change
any functionality.  I don't actually use GDB, but I haven't seen any issues
reported in a few years so if there is one I've missed it.

I did this ptrace stuff many years ago (IIRC it was actually my first RISC-V
Linux patch), and all I really remember is that it seemed way more complicated
than it needed to be.  I'm happy to just drop our patch set, as yours looks way
cleaner to me and if you're already planning on fixing put() then it doesn't
seem worth the churn.
