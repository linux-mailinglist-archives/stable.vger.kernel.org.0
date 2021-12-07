Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B18B446B83B
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 10:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234623AbhLGKCr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 05:02:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234560AbhLGKCo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 05:02:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 823DBC061574;
        Tue,  7 Dec 2021 01:59:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42D42B81670;
        Tue,  7 Dec 2021 09:59:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E0EAC341C3;
        Tue,  7 Dec 2021 09:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638871151;
        bh=nI2+Q38ri2O+YEgxm0ZrR4t9h83EzE6SPPoA5QvZf5k=;
        h=From:To:Cc:Subject:Date:From;
        b=W4U0qVMiS+093dfVaSMitxZA8aYb3fFGT3b7xEGoGLQLfOiWx3RFG5R+/dYQAyh0L
         dua5u8dDBYpDZCbIyLW3Ufvft/jbJv5TVcUMPLRa0ZZ8qhKUcV9HE02yIXFtU9bYi/
         ffcjYZx5WKbeqFRvhmSk+U8D0jC6G3b59XAcVWg1lDW+bO47ScCD6EtkcKQd0iNjQn
         A4vdZ5a5mr8rS/jOJUf/aI87XLAAlbu4mIShvPTMoAMfRsTWZvFxsu1REH11IfA3PM
         1j7YTQaq+rTiVlueVQtqGqfnyXsvvhVR51Iz9sGxir72IDtrCyD/SjpgOxfRdnVC3z
         WmXVnvmBI0Tsg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>
Cc:     linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ramji Jiyani <ramjiyani@google.com>,
        Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Martijn Coenen <maco@android.com>, stable@vger.kernel.org
Subject: [PATCH v2 0/5] aio: fix use-after-free and missing wakeups
Date:   Tue,  7 Dec 2021 01:57:21 -0800
Message-Id: <20211207095726.169766-1-ebiggers@kernel.org>
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
with, and I don't know of an easy way to test it.  Suggestions of any
aio poll tests to run would be greatly appreciated.

Note, it looks like io_uring has the same bugs as aio poll.  I haven't
tried to fix io_uring.

This series applies to v5.16-rc4.

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

