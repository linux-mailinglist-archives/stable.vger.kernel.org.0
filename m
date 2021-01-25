Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06D34302CBA
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 21:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732216AbhAYUjq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 15:39:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:46026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732314AbhAYUij (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 15:38:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3AA22255F;
        Mon, 25 Jan 2021 20:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611607078;
        bh=lw32l1t0dRZLUuanOslN2u/5d3IrLpkLAxRYXoCKC1I=;
        h=From:To:Cc:Subject:Date:From;
        b=nOlNxACUzJVX0nvm/PFzdXfpSz9CyCucpzK3B0Gl1uw915VmUT2vga0gO9MLbmFUR
         C+Aoa7CPaRLeysJZtSrDeBimyjf7V0FBl/G6QWZlBRyONSpwALLRY/6H0JhbWsFH2Y
         gmx9qC3qrlB+YCMwgnO5Bw6w+yZ8E2Yi1rsdIxByC4jGMpMjWkxe5ysN2Zs+8lLenj
         VIkg6/xHUU4fOirleytO5qpg9noleJx2S7jIlJDanmmFXdgcsamklBQu0Kgfk2F9Ck
         6vRez944sXX3HkiqNkzAz9MEoDFYDXocJBT5NV/pUvpx2lb55Y+6TdsHUskEOd6A6l
         FfyOFclcDceqg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4.14 0/3] backport lazytime fix to 4.14
Date:   Mon, 25 Jan 2021 12:37:41 -0800
Message-Id: <20210125203744.325479-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Backport a lazytime fix from upstream to 4.14-stable.  To make it
cherry-pick cleanly, I first cherry-picked two other commits.  Commit #2
had a conflict due to it making a change to fs/xfs/ which isn't
applicable to 4.14.  I dropped that part of the change.

Christoph Hellwig (1):
  fs: move I_DIRTY_INODE to fs.h

Eric Biggers (1):
  fs: fix lazytime expiration handling in __writeback_single_inode()

Jan Kara (1):
  writeback: Drop I_DIRTY_TIME_EXPIRE

 fs/ext4/inode.c                  |  6 ++---
 fs/fs-writeback.c                | 43 +++++++++++++-------------------
 fs/gfs2/super.c                  |  2 +-
 include/linux/fs.h               |  4 +--
 include/trace/events/writeback.h |  1 -
 5 files changed, 24 insertions(+), 32 deletions(-)

-- 
2.30.0

