Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B55BD46DFFC
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 02:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241704AbhLIBKE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 20:10:04 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:54860 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233885AbhLIBKD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Dec 2021 20:10:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B017BCE2328;
        Thu,  9 Dec 2021 01:06:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82EC7C341C6;
        Thu,  9 Dec 2021 01:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639011987;
        bh=LRtnTEDYfrH3rK4h5Xti2Q/SJ/ia/P40Z5mMsuaLecc=;
        h=From:To:Cc:Subject:Date:From;
        b=tAyn6VMi9zUQnetySyJzmo/KHh8F/880ResUCN7DV067TWer+mTRXZwHly6c7MNRK
         pYYr743kEfwjG8uz88lr+PVR9iyf4AbASRSzGXhi+RqhfAZ/bnTYRT+EtuVQlJmUWa
         vVt1iK1kOiuVU3us2fM3nJOOKPdRQSRiio3UzIyHyVTttKGuRcCpbSMYZJRh83XQDA
         f8aXOtdl6xQN02CuRRSwBCapVmcTAcra70NawOJZpN+94PlrBOMdzSH/ftYRvALflV
         WgxIHAsGZ6UtoROEPPFS8HN2SXD5Rof0VVpWCgDtBhaGisSAkZRqYq9Ea/K6+A31kF
         CWRUX4DKaQbmQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>
Cc:     linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ramji Jiyani <ramjiyani@google.com>,
        Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Martijn Coenen <maco@android.com>, stable@vger.kernel.org
Subject: [PATCH v3 0/5] aio: fix use-after-free and missing wakeups
Date:   Wed,  8 Dec 2021 17:04:50 -0800
Message-Id: <20211209010455.42744-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This series fixes two bugs in aio poll, and one issue with POLLFREE more
broadly.  This is intended to replace
"[PATCH v5] aio: Add support for the POLLFREE"
(https://lore.kernel.org/r/20211027011834.2497484-1-ramjiyani@google.com)
which has some bugs.

Careful review is appreciated; the aio poll code is very hard to work
with, and it doesn't appear to have many tests.  I've verified that it
passes the libaio test suite, which provides some coverage of poll.

Note, it looks like io_uring has the same bugs as aio poll.  I haven't
tried to fix io_uring.

This series applies to v5.16-rc4.

Changed v2 => v3:
  - Fixed a few commit messages and comments.
  - Mention that libaio test suite still passes.

Changed v1 => v2:
  - Added wake_up_pollfree().
  - Various fixes to the aio poll fixes.
  - Improved some comments in aio poll.

Eric Biggers (5):
  wait: add wake_up_pollfree()
  binder: use wake_up_pollfree()
  signalfd: use wake_up_pollfree()
  aio: keep poll requests on waitqueue until completed
  aio: fix use-after-free due to missing POLLFREE handling

 drivers/android/binder.c        |  21 ++--
 fs/aio.c                        | 184 ++++++++++++++++++++++++++------
 fs/signalfd.c                   |  12 +--
 include/linux/wait.h            |  26 +++++
 include/uapi/asm-generic/poll.h |   2 +-
 kernel/sched/wait.c             |   7 ++
 6 files changed, 195 insertions(+), 57 deletions(-)

-- 
2.34.1

