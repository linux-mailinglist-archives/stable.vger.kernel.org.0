Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0A4F1318C7
	for <lists+stable@lfdr.de>; Mon,  6 Jan 2020 20:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbgAFTbK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jan 2020 14:31:10 -0500
Received: from albireo.enyo.de ([37.24.231.21]:50288 "EHLO albireo.enyo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726695AbgAFTbK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Jan 2020 14:31:10 -0500
Received: from [172.17.203.2] (helo=deneb.enyo.de)
        by albireo.enyo.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1ioY5g-0003eK-3x; Mon, 06 Jan 2020 19:31:04 +0000
Received: from fw by deneb.enyo.de with local (Exim 4.92)
        (envelope-from <fw@deneb.enyo.de>)
        id 1ioY4k-0004zc-C2; Mon, 06 Jan 2020 20:30:06 +0100
From:   Florian Weimer <fw@deneb.enyo.de>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        paulmck <paulmck@linux.ibm.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>,
        linux-api <linux-api@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Neel Natu <neelnatu@google.com>
Subject: Re: [PATCH for 5.5 1/2] rseq: Fix: Clarify rseq.h UAPI rseq_cs memory reclaim requirements
References: <20191220201207.17389-1-mathieu.desnoyers@efficios.com>
        <87imman36g.fsf@mid.deneb.enyo.de>
        <173832695.14381.1576875253374.JavaMail.zimbra@efficios.com>
        <875zian2a2.fsf@mid.deneb.enyo.de>
        <669061171.14506.1576876500152.JavaMail.zimbra@efficios.com>
        <1025393027.850.1578337717165.JavaMail.zimbra@efficios.com>
Date:   Mon, 06 Jan 2020 20:30:06 +0100
In-Reply-To: <1025393027.850.1578337717165.JavaMail.zimbra@efficios.com>
        (Mathieu Desnoyers's message of "Mon, 6 Jan 2020 14:08:37 -0500
        (EST)")
Message-ID: <87a7709ydd.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* Mathieu Desnoyers:

> Just to clarify: should the discussion here prevent the UAPI
> documentation change from being merged into the Linux kernel ? Our
> discussion seems to be related to integration of rseq into glibc,
> rather than the kernel UAPI per se.

I still think that clearing rseq_cs upon exit from the function that
contains the sequence is good practice, and the UAPI header should
mention that.

For glibc, if I recall correctly, we decided against doing anything in
dlclose to deal with this issue (remapping new code in an existing
rseq area) because it would need updating all threads, not just the
thread calling dlclose.  That's why we're punting this to
applications and why I think the UAPI header should mention this.
