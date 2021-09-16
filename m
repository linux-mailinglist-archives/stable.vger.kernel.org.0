Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 884F740ED6C
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 00:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241119AbhIPWkE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 18:40:04 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:50664 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231521AbhIPWkD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Sep 2021 18:40:03 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1631831921;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PsTwjeDxSlQlFP4KCCxKbdSN7ofxhqMzyKM26GDMRW8=;
        b=AoeDZljOHB9PCNMj8dgWpMYNPmHShah6zKFHPSHP8Ez/3Szk3/pYio984hw3fW0Wgc8ggC
        TxBtLmGUDJJyVAPGfapJKCvLKCEOF7Fwp+qGMU5C8OCIrDws212QBkBCrQXXV+DAr6/82l
        VRCiv5LbUnTfU8SW6iPQh3Gscq422CBM8PDaMnDZjOwy7JLFUpetYk/j/dag3kkCsrzU2O
        p4NSO8l9xGJGgvLhr3EEik6WPiQWFVLMTocaSh0LwXeErA2yLZAspn/PUCUqPFCSt2ye81
        23qxECV8x7cnwS1VG8EdGQcBTb1K2/iZ3P9NE2vsordzbG/EAW7g1mvbJoExjA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1631831921;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PsTwjeDxSlQlFP4KCCxKbdSN7ofxhqMzyKM26GDMRW8=;
        b=CecphcR1xepvXa2c4tQ05VcI36Kkz/zZuC6Ye3i+gPdrLHjYkWKLGrVx1k7wJl/kjnhBGG
        uIDM0k/njD5F3MCA==
To:     Arnd Bergmann <arnd@kernel.org>,
        OPENSOURCE Lukas Hannen 
        <lukas.hannen@opensource.tttech-industrial.com>
Cc:     "EMC: linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>
Subject: Re: [PATCH 5.14 298/334] time: Handle negative seconds correctly in
 timespec64_to_ns()
In-Reply-To: <CAK8P3a0Cnr7LjWmXqSbhnc_jyjseCCztxLv8+v5ojhLXJ+_MyQ@mail.gmail.com>
References: <20210913131113.390368911@linuxfoundation.org>
 <20210913131123.500712780@linuxfoundation.org>
 <CAK8P3a0z5jE=Z3Ps5bFTCFT7CHZR1JQ8VhdntDJAfsUxSPCcEw@mail.gmail.com>
 <AM0PR01MB5410E0963A0AF9A525509DB2EEDC9@AM0PR01MB5410.eurprd01.prod.exchangelabs.com>
 <CAK8P3a0Cnr7LjWmXqSbhnc_jyjseCCztxLv8+v5ojhLXJ+_MyQ@mail.gmail.com>
Date:   Fri, 17 Sep 2021 00:38:41 +0200
Message-ID: <871r5o9mdq.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 16 2021 at 22:57, Arnd Bergmann wrote:
> On Thu, Sep 16, 2021 at 6:50 PM OPENSOURCE Lukas Hannen
> <lukas.hannen@opensource.tttech-industrial.com> wrote:
> I did stumble over one small detail:
>
>         if (ts->tv_sec <= KTIME_SEC_MIN)
>                 return KTIME_MIN;
>
> I think this is not entirely correct for the case of tv_sec==KTIME_SEC_MIN
> with a nonzero tv_nsec, as we now round down to the full second. Not sure
> if that's worth changing, as we also round up for any value between
> KTIME_SEC_MAX*NSEC_PER_SEC and KTIME_MAX, or between
> KTIME_MIN and KTIME_SEC_MIN*NSEC_PER_SEC.
> In practice I guess we care very little about the last nanosecond in the corner
> cases.

It's completely irrelevant whether the result is off by one second
related to the 292 years limit.

Thanks,

        tglx
