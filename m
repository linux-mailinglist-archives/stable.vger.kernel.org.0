Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4D77D5C7A
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 09:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730255AbfJNH27 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 14 Oct 2019 03:28:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41750 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728811AbfJNH27 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Oct 2019 03:28:59 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5F246308FC4D;
        Mon, 14 Oct 2019 07:28:59 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 53F025DA2C;
        Mon, 14 Oct 2019 07:28:59 +0000 (UTC)
Received: from zmail17.collab.prod.int.phx2.redhat.com (zmail17.collab.prod.int.phx2.redhat.com [10.5.83.19])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2BE654EA6E;
        Mon, 14 Oct 2019 07:28:59 +0000 (UTC)
Date:   Mon, 14 Oct 2019 03:28:59 -0400 (EDT)
From:   Jan Stancek <jstancek@redhat.com>
To:     CKI Project <cki-project@redhat.com>, andreyknvl@google.com,
        LTP List <ltp@lists.linux.it>
Cc:     Linux Stable maillist <stable@vger.kernel.org>,
        Memory Management <mm-qe@redhat.com>
Message-ID: <805988176.6044584.1571038139105.JavaMail.zimbra@redhat.com>
In-Reply-To: <cki.B4A567748F.PFM8G4WKXI@redhat.com>
References: <cki.B4A567748F.PFM8G4WKXI@redhat.com>
Subject: =?utf-8?Q?Re:_=E2=9D=8C_FAIL:_Test_report_for_kernel_?=
 =?utf-8?Q?5.4.0-rc2-d6c2c23.cki_(stable-next)?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.43.17.163, 10.4.195.7]
Thread-Topic: =?utf-8?B?4p2MIEZBSUw6?= Test report for kernel 5.4.0-rc2-d6c2c23.cki (stable-next)
Thread-Index: I1iuqhveSXTk+4892N8PIoGCTDH8iQ==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Mon, 14 Oct 2019 07:28:59 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



----- Original Message -----
> 
> Hello,
> 
> We ran automated tests on a recent commit from this kernel tree:
> 
>        Kernel repo:
>        git://git.kernel.org/pub/scm/linux/kernel/git/sashal/linux-stable.git
>             Commit: d6c2c23a29f4 - Merge branch 'stable-next' of
>             ssh://chubbybox:/home/sasha/data/next into stable-next
> 
> The results of these automated tests are provided below.
> 
>     Overall result: FAILED (see details below)
>              Merge: OK
>            Compile: OK
>              Tests: FAILED
> 
> All kernel binaries, config files, and logs are available for download here:
> 
>   https://artifacts.cki-project.org/pipelines/223563
> 
> One or more kernel tests failed:
> 
>     aarch64:
>       ❌ LTP: openposix test suite
> 

Test [1] is passing value close to LONG_MAX, which on arm64 is now treated as tagged userspace ptr:
  057d3389108e ("mm: untag user pointers passed to memory syscalls")

And now seems to hit overflow check after sign extension (EINVAL).
Test should probably find different way to choose invalid pointer.

[1] https://github.com/linux-test-project/ltp/blob/master/testcases/open_posix_testsuite/conformance/interfaces/mlock/8-1.c
