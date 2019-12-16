Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8122F120F51
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 17:24:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbfLPQYW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 11:24:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:40724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbfLPQYV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 11:24:21 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90C9A20726;
        Mon, 16 Dec 2019 16:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576513460;
        bh=xDh2YDLUTml/a1VTrsg8vTE3WzPQfNuS8erA20GMNyE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xids2YQoUKSOQrMNJM3nXGL7hQUe6ZRKwWpTZp2XJENFgMlXHrMjGTn8MCMljY7/1
         PcMurUQaIDPrIQTLZQ1jBM6I6hXRH5d//HvObhDU4NKmF3WskeCUWxhq0Nq69N/WrC
         na625G+TuPFTvNA2AlKNZAdB453bKLnjqadYoQHw=
Date:   Mon, 16 Dec 2019 11:24:19 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] s390/smp,vdso: fix ASCE handling" failed
 to apply to 4.19-stable tree
Message-ID: <20191216162419.GG17708@sasha-vm>
References: <157650182321140@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <157650182321140@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 16, 2019 at 02:10:23PM +0100, gregkh@linuxfoundation.org wrote:
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
>From a2308c11ecbc3471ebb7435ee8075815b1502ef0 Mon Sep 17 00:00:00 2001
>From: Heiko Carstens <heiko.carstens@de.ibm.com>
>Date: Mon, 18 Nov 2019 13:09:52 +0100
>Subject: [PATCH] s390/smp,vdso: fix ASCE handling
>
>When a secondary CPU is brought up it must initialize its control
>registers. CPU A which triggers that a secondary CPU B is brought up
>stores its control register contents into the lowcore of new CPU B,
>which then loads these values on startup.
>
>This is problematic in various ways: the control register which
>contains the home space ASCE will correctly contain the kernel ASCE;
>however control registers for primary and secondary ASCEs are
>initialized with whatever values were present in CPU A.
>
>Typically:
>- the primary ASCE will contain the user process ASCE of the process
>  that triggered onlining of CPU B.
>- the secondary ASCE will contain the percpu VDSO ASCE of CPU A.
>
>Due to lazy ASCE handling we may also end up with other combinations.
>
>When then CPU B switches to a different process (!= idle) it will
>fixup the primary ASCE. However the problem is that the (wrong) ASCE
>from CPU A was loaded into control register 1: as soon as an ASCE is
>attached (aka loaded) a CPU is free to generate TLB entries using that
>address space.
>Even though it is very unlikey that CPU B will actually generate such
>entries, this could result in TLB entries of the address space of the
>process that ran on CPU A. These entries shouldn't exist at all and
>could cause problems later on.
>
>Furthermore the secondary ASCE of CPU B will not be updated correctly.
>This means that processes may see wrong results or even crash if they
>access VDSO data on CPU B. The correct VDSO ASCE will eventually be
>loaded on return to user space as soon as the kernel executed a call
>to strnlen_user or an atomic futex operation on CPU B.
>
>Fix both issues by intializing the to be loaded control register
>contents with the correct ASCEs and also enforce (re-)loading of the
>ASCEs upon first context switch and return to user space.
>
>Fixes: 0aaba41b58bc ("s390: remove all code using the access register mode")
>Cc: stable@vger.kernel.org # v4.15+
>Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
>Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>

Adjusted context for missing ce3dc447493f ("s390: add support for
virtually mapped kernel stacks") in 4.19 and queued up.

-- 
Thanks,
Sasha
