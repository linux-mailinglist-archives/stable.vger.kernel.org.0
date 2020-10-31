Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3812A1AED
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 23:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725949AbgJaWJx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 18:09:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:39708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbgJaWJx (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 18:09:53 -0400
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96A282072C;
        Sat, 31 Oct 2020 22:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604182192;
        bh=S03k1YGXaJQvf3NAsk0rAuPNkYHGojNJSpqWlOKkY6Y=;
        h=From:To:Cc:Subject:Date:From;
        b=a8mMgEQtpZ3jNyytBfAA07mZtl+9vbm6YLLv+FzNDnWsLRWKesdnQyD8DGDQ9NlKo
         NBZjY049c5RkEWrHQHTQiUYaXvEuh5HHjNvlFxn20MOKcGS2hg5wFkYa2cWehnnO0k
         uwKX3GPe/Eyo28ZG698zXqwWlaIL66HoIPdZkgxU=
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org
Subject: [PATCH 4.19 0/5] backport some more fscrypt fixes to 4.19
Date:   Sat, 31 Oct 2020 15:05:48 -0700
Message-Id: <20201031220553.1085782-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Backport some fscrypt fixes from upstream 5.2 to 4.19-stable.

This is needed to get 'kvm-xfstests -c ext4,f2fs,ubifs -g encrypt' to
fully pass on 4.19-stable.  Before, generic/397 and generic/429 failed
on UBIFS due to missing "fscrypt: fix race where ->lookup() marks
plaintext dentry as ciphertext".

This also fixes some bugs that aren't yet covered by the xfstests.
E.g., "fs, fscrypt: clear DCACHE_ENCRYPTED_NAME when unaliasing
directory" fixes a bug that caused real-world problems on Chrome OS.

Some relatively straightforward adjustments were needed to the patches,
mainly due to the refactoring of fscrypt.h that was done in 5.1.

Eric Biggers (5):
  fscrypt: clean up and improve dentry revalidation
  fscrypt: fix race allowing rename() and link() of ciphertext dentries
  fs, fscrypt: clear DCACHE_ENCRYPTED_NAME when unaliasing directory
  fscrypt: only set dentry_operations on ciphertext dentries
  fscrypt: fix race where ->lookup() marks plaintext dentry as
    ciphertext

 fs/crypto/crypto.c              | 58 +++++++++++++------------
 fs/crypto/fname.c               |  1 +
 fs/crypto/hooks.c               | 28 ++++++++----
 fs/dcache.c                     | 15 +++++++
 fs/ext4/ext4.h                  | 62 ++++++++++++++++++++-------
 fs/ext4/namei.c                 | 76 ++++++++++++++++++++++-----------
 fs/f2fs/namei.c                 | 17 +++++---
 fs/ubifs/dir.c                  |  8 ++--
 include/linux/dcache.h          |  2 +-
 include/linux/fscrypt.h         | 30 +++++++------
 include/linux/fscrypt_notsupp.h |  9 ++--
 include/linux/fscrypt_supp.h    |  6 ++-
 12 files changed, 205 insertions(+), 107 deletions(-)

-- 
2.29.1

