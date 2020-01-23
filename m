Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D484E1463F3
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 09:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbgAWIzC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 23 Jan 2020 03:55:02 -0500
Received: from mail.fireflyinternet.com ([109.228.58.192]:51628 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726061AbgAWIzB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jan 2020 03:55:01 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 19978801-1500050 
        for multiple; Thu, 23 Jan 2020 08:54:48 +0000
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To:     Andrew Morton <akpm@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org
From:   Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <20200123084632.GA435419@kroah.com>
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
References: <20200123084632.GA435419@kroah.com>
Message-ID: <157976968555.18920.13404367012873725550@skylake-alporthouse-com>
User-Agent: alot/0.6
Subject: Re: Linux 4.19.98
Date:   Thu, 23 Jan 2020 08:54:45 +0000
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Greg KH (2020-01-23 08:46:32)
> I'm announcing the release of the 4.19.98 kernel.

commit 3e6b472f474accf757e107919f8ee42e7315ac0d
Author: Waiman Long <longman@redhat.com>
Date:   Wed Nov 14 09:55:40 2018 -0800

    efi: Fix debugobjects warning on 'efi_rts_work'

    [ Upstream commit ef1491e791308317bb9851a0ad380c4a68b58d54 ]

    The following commit:

      9dbbedaa6171 ("efi: Make efi_rts_work accessible to efi page fault handler")

    converted 'efi_rts_work' from an auto variable to a global variable.
    However, when submitting the work, INIT_WORK_ONSTACK() was still used,
    causing the following complaint from debugobjects:

      ODEBUG: object 00000000ed27b500 is NOT on stack 00000000c7d38760, but annotated.

    Change the macro to just INIT_WORK() to eliminate the warning.

    Signed-off-by: Waiman Long <longman@redhat.com>
    Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
    Acked-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Cc: Peter Zijlstra <peterz@infradead.org>
    Cc: Thomas Gleixner <tglx@linutronix.de>
    Cc: linux-efi@vger.kernel.org
    Fixes: 9dbbedaa6171 ("efi: Make efi_rts_work accessible to efi page fault handler")
    Link: http://lkml.kernel.org/r/20181114175544.12860-2-ard.biesheuvel@linaro.org
    Signed-off-by: Ingo Molnar <mingo@kernel.org>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

was incorrectly applied to v4.19.41 and causes lockdep complaints for
the onstack efi_rts_work being initialised by INIT_WORK().
-Chris
