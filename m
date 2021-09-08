Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5904F4040AF
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 23:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235571AbhIHVwi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 17:52:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:38270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234144AbhIHVwg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Sep 2021 17:52:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F27A610FF;
        Wed,  8 Sep 2021 21:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631137888;
        bh=AXEwcqG3tA0z2Pq2CtpORf9Ep9Dl9pqblNnUmHoDhjQ=;
        h=From:To:Cc:Subject:Date:From;
        b=fdmiZxK8ekMOjOCM6rBVyxzrcFHIcCLOdVoQ3mAnT+m5ceEppiXu/2lrEa7c8RzD2
         hNqe+pQBotx+3L9wWQxIzYJRsllAaqTEV5EzpYVjQ0uQ2WIbO5SA0rrkAEJHVOfhx7
         VKQAO5/mqnwHzMUplqvyMrtTOWdjukY29mBNQGzzTohu9hceIQe/zjqU1T+flZcaDQ
         uAAZudkSVSmLk3BKHCyRxn087bIKIK3HtpXoAUWmIUxqQEeD8YhoPpcEaWwBK4nE34
         aB+XN81vV7v+p2u3DuKwIKvv5pLsGislHlkZ7JkrYF3KTaI0pnjtYKTxi+CX35RV92
         lIss4pNBPmkpg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org
Subject: [PATCH 0/4] backport fscrypt symlink fixes to 4.19
Date:   Wed,  8 Sep 2021 14:50:29 -0700
Message-Id: <20210908215033.1122580-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This series backports some patches that failed to apply to 4.19-stable
due to the prototype of inode_operations::getattr having changed in
v5.12, as well as several other conflicts.  Please apply to 4.19-stable.

Eric Biggers (4):
  fscrypt: add fscrypt_symlink_getattr() for computing st_size
  ext4: report correct st_size for encrypted symlinks
  f2fs: report correct st_size for encrypted symlinks
  ubifs: report correct st_size for encrypted symlinks

 fs/crypto/hooks.c               | 44 +++++++++++++++++++++++++++++++++
 fs/ext4/symlink.c               | 11 ++++++++-
 fs/f2fs/namei.c                 | 11 ++++++++-
 fs/ubifs/file.c                 | 12 ++++++++-
 include/linux/fscrypt_notsupp.h |  6 +++++
 include/linux/fscrypt_supp.h    |  1 +
 6 files changed, 82 insertions(+), 3 deletions(-)

-- 
2.33.0.153.gba50c8fa24-goog

