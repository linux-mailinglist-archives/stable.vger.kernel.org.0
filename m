Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11321468136
	for <lists+stable@lfdr.de>; Sat,  4 Dec 2021 01:23:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233113AbhLDA06 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Dec 2021 19:26:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344335AbhLDA06 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Dec 2021 19:26:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6654AC061751;
        Fri,  3 Dec 2021 16:23:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE8EDB829BB;
        Sat,  4 Dec 2021 00:23:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53496C341C1;
        Sat,  4 Dec 2021 00:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638577410;
        bh=MWLPGPvSEBOeSGv3V//27du0LgznvwiHFxKx5VhWjl8=;
        h=From:To:Cc:Subject:Date:From;
        b=Sb9vQiJwJj32RMcNcYtlIQjV/g5YBTijPgIW7pEA9foTrqxtCOBeh01gHr3SCUWB1
         R1Q2R+cwb0/jnlehuOy1QK45INFx5k1m/KrtjiGEFdUWfuKuAxTKWX5ltrtvdD8DeI
         gX+9QI1uphvvgObhVuj7S8CskfHxkM7YZ1QWKcopO6L5rj2CXkvIXEpWx8c8SS+/Hk
         EMOgAdP0pN/lTSRCID01fw4wOf2uH3e4am4PbzbMzud6H0BLLEao2GbrOjEXnZKhVg
         wRtDnIsgfkkQrbi4SIjUnir/URP3ly9GcECy3OasnKcIknuHwAbt3Gw0pKnIFGw/K1
         YAXaHlbneBhAw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>
Cc:     linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ramji Jiyani <ramjiyani@google.com>,
        Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        stable@vger.kernel.org
Subject: [PATCH 0/2] aio poll: fix use-after-free and missing wakeups
Date:   Fri,  3 Dec 2021 16:22:59 -0800
Message-Id: <20211204002301.116139-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This series fixes some bugs in aio poll.  This is intended to replace
"[PATCH v5] aio: Add support for the POLLFREE"
(https://lore.kernel.org/r/20211027011834.2497484-1-ramjiyani@google.com)
which has some bugs.

Careful review is appreciated; this code is very hard to work with, and
I don't know of an easy way to test it.

Note, it looks like io_uring has these same bugs too.  I haven't tried
to fix io_uring.

This applies to v5.16-rc3.

Eric Biggers (2):
  aio: keep poll requests on waitqueue until completed
  aio: fix use-after-free due to missing POLLFREE handling

 fs/aio.c                        | 138 +++++++++++++++++++++++++-------
 include/uapi/asm-generic/poll.h |   2 +-
 2 files changed, 111 insertions(+), 29 deletions(-)


base-commit: d58071a8a76d779eedab38033ae4c821c30295a5
-- 
2.34.1

