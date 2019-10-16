Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A01C0D940D
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 16:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405059AbfJPOiT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 10:38:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58348 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404542AbfJPOiT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 10:38:19 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 50D43821CB;
        Wed, 16 Oct 2019 14:38:19 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 043CC60C5E;
        Wed, 16 Oct 2019 14:38:19 +0000 (UTC)
Received: from zmail17.collab.prod.int.phx2.redhat.com (zmail17.collab.prod.int.phx2.redhat.com [10.5.83.19])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id CF21418037CD;
        Wed, 16 Oct 2019 14:38:18 +0000 (UTC)
Date:   Wed, 16 Oct 2019 10:38:18 -0400 (EDT)
From:   Jan Stancek <jstancek@redhat.com>
To:     Will Deacon <will@kernel.org>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        CKI Project <cki-project@redhat.com>,
        LTP List <ltp@lists.linux.it>,
        Linux Stable maillist <stable@vger.kernel.org>,
        Memory Management <mm-qe@redhat.com>,
        Szabolcs Nagy <szabolcs.nagy@arm.com>,
        Dave P Martin <Dave.Martin@arm.com>
Message-ID: <2041772384.6478556.1571236698606.JavaMail.zimbra@redhat.com>
In-Reply-To: <20191016042933.bemrrurjbghuiw73@willie-the-truck>
References: <cki.B4A567748F.PFM8G4WKXI@redhat.com> <805988176.6044584.1571038139105.JavaMail.zimbra@redhat.com> <CAAeHK+zxFWvCOgTYrMuD-oHJAFMn5DVYmQ6-RvU8NrapSz01mQ@mail.gmail.com> <20191014162651.GF19200@arrakis.emea.arm.com> <20191014213332.mmq7narumxtkqumt@willie-the-truck> <20191015152651.GG13874@arrakis.emea.arm.com> <20191015161453.lllrp2gfwa5evd46@willie-the-truck> <20191016042933.bemrrurjbghuiw73@willie-the-truck>
Subject: =?utf-8?Q?Re:_=E2=9D=8C_FAIL:_Test_report_for_kernel_?=
 =?utf-8?Q?5.4.0-rc2-d6c2c23.cki_(stable-next)?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.17.163, 10.4.195.23]
Thread-Topic: =?utf-8?B?4p2MIEZBSUw6?= Test report for kernel 5.4.0-rc2-d6c2c23.cki (stable-next)
Thread-Index: dPYP1FfVK1Nl7HrHWInfr5hBTz9+Cg==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Wed, 16 Oct 2019 14:38:19 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


----- Original Message -----
> 
> From 517d979e84191ae9997c9513a88a5b798af6912f Mon Sep 17 00:00:00 2001
> From: Will Deacon <will@kernel.org>
> Date: Tue, 15 Oct 2019 21:04:18 -0700
> Subject: [PATCH] arm64: tags: Preserve tags for addresses translated via
> TTBR1
> 
> Sign-extending TTBR1 addresses when converting to an untagged address
> breaks the documented POSIX semantics for mlock() in some obscure error
> cases where we end up returning -EINVAL instead of -ENOMEM as a direct
> result of rewriting the upper address bits.
> 
> Rework the untagged_addr() macro to preserve the upper address bits for
> TTBR1 addresses and only clear the tag bits for user addresses. This
> matches the behaviour of the 'clear_address_tag' assembly macro, so
> rename that and align the implementations at the same time so that they
> use the same instruction sequences for the tag manipulation.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Link:
> https://lore.kernel.org/stable/20191014162651.GF19200@arrakis.emea.arm.com/
> Reported-by: Jan Stancek <jstancek@redhat.com>
> Signed-off-by: Will Deacon <will@kernel.org>

No regressions observed with LTP syscalls/sched/mm/commands and open_posix_testsuite.

Tested-by: Jan Stancek <jstancek@redhat.com>
