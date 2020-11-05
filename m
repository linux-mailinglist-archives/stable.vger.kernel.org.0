Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85E482A7F27
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 13:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730519AbgKEM4R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 07:56:17 -0500
Received: from mx2.suse.de ([195.135.220.15]:40244 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730044AbgKEM4Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Nov 2020 07:56:16 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DB79AABAE;
        Thu,  5 Nov 2020 12:56:15 +0000 (UTC)
Date:   Thu, 5 Nov 2020 13:57:01 +0100
From:   Cyril Hrubis <chrubis@suse.cz>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux- stable <stable@vger.kernel.org>,
        LTP List <ltp@lists.linux.it>, lkft-triage@lists.linaro.org,
        Li Wang <liwang@redhat.com>, Jan Stancek <jstancek@redhat.com>
Subject: Re: [stable-rc 4.14] shmctl04.c:115: TFAIL: SHM_INFO haven't
 returned a valid index: SUCCESS (0)
Message-ID: <20201105125701.GD10395@yuki.lan>
References: <CA+G9fYu4RdH7zdd5MU=E-o+azMRx-EqR-7VYuJCUastKRd0KCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYu4RdH7zdd5MU=E-o+azMRx-EqR-7VYuJCUastKRd0KCA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi!
> LTP syscalls test shmctl04 test modified in latest LTP release 20200930
> and this test reported as fail. so reporting to LTP mailing list.
> Failed on stable-rc 4.14, 4.9 and 4.4 branches but
> passed on stable-rc 4.19, 5.4 and 5.9 branches for arm64, arm, x86_64 and i386.
> 
> shmctl04.c:115: TFAIL: SHM_INFO haven't returned a valid index: SUCCESS (0)
> shmctl04.c:131: TFAIL: Counted used = 0, used_ids = 1
> shmctl04.c:72: TPASS: used_ids = 1
> shmctl04.c:79: TPASS: shm_rss = 0
> shmctl04.c:86: TPASS: shm_swp = 0
> shmctl04.c:93: TPASS: shm_tot = 1

Looks like SHM_STAT_ANY was added to kernel 4.17, that would explain why
shmctl() with SHM_STATA_ANY returns -1 on 4.14 and older but in that
case errno should be EINVAL and not set to zero.

-- 
Cyril Hrubis
chrubis@suse.cz
