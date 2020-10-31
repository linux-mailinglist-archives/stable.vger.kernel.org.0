Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40F642A1B23
	for <lists+stable@lfdr.de>; Sun,  1 Nov 2020 00:13:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbgJaXNE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 19:13:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:54160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725809AbgJaXND (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 19:13:03 -0400
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C01A2087E;
        Sat, 31 Oct 2020 23:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604185983;
        bh=7W770UmoHOq+XJfX9XCbouj37nY4hXyYEf+d83ifZVo=;
        h=From:To:Cc:Subject:Date:From;
        b=p74WX71zHj2ebwSX5Bobq8aLbGs4nvtfFwa6F/wXpnSYQ0w5fJrk2Hc07BU8UauMv
         /xYwqR+GU6R379i3+poCFfkRDadiz3sMSlrWOG93rzrPcUNw3jknqCY+q/klkbE87B
         EGgPJTl9m4tyZiw82YysaZwQmo4XSRkwrJdFisjY=
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 4.9 0/2] backport some more fscrypt fixes to 4.9
Date:   Sat, 31 Oct 2020 16:11:22 -0700
Message-Id: <20201031231124.1199710-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Backport some fscrypt fixes from 4.10 and 4.11 to 4.9-stable.
These will be needed for xfstest generic/395 to pass if
https://lkml.kernel.org/fstests/20201031054018.695314-1-ebiggers@kernel.org
is applied.

These are clean cherry picks.

Tested with 'kvm-xfstests -c ext4,f2fs -g encrypt'.

Eric Biggers (2):
  fscrypto: move ioctl processing more fully into common code
  fscrypt: use EEXIST when file already uses different policy

 fs/crypto/policy.c       | 36 ++++++++++++++++++++++--------------
 fs/ext4/ext4.h           |  4 ++--
 fs/ext4/ioctl.c          | 34 +++++-----------------------------
 fs/f2fs/f2fs.h           |  4 ++--
 fs/f2fs/file.c           | 19 ++-----------------
 include/linux/fscrypto.h | 12 ++++++------
 6 files changed, 39 insertions(+), 70 deletions(-)

-- 
2.29.1

