Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDBEA1FE114
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730545AbgFRBwN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:52:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:34440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731724AbgFRB0p (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:26:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA5C720776;
        Thu, 18 Jun 2020 01:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443604;
        bh=1KICtU+7Ipxdndkbsv962r1msAcOgKW2WYbRsAws1IE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pc8BC7XYuunNerwob5gE+ziuQeGKXwDdBs7+ttAtvReE4Uw9JU2efxZiWLChLumFt
         eUyMm4URkeDCH+0EsoyTtWaM3+2bV01Iqj5J6puW7VV0kSmH5XfOD+nSUlK2LVWDM6
         deldGPk/UJIpcohwxGK9HzdyYFWAAAXn5A3JPIZE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     ashimida <ashimida@linux.alibaba.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-kbuild@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 033/108] mksysmap: Fix the mismatch of '.L' symbols in System.map
Date:   Wed, 17 Jun 2020 21:24:45 -0400
Message-Id: <20200618012600.608744-33-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012600.608744-1-sashal@kernel.org>
References: <20200618012600.608744-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: ashimida <ashimida@linux.alibaba.com>

[ Upstream commit 72d24accf02add25e08733f0ecc93cf10fcbd88c ]

When System.map was generated, the kernel used mksysmap to
filter the kernel symbols, but all the symbols with the
second letter 'L' in the kernel were filtered out, not just
the symbols starting with 'dot + L'.

For example:
ashimida@ubuntu:~/linux$ cat System.map |grep ' .L'
ashimida@ubuntu:~/linux$ nm -n vmlinux |grep ' .L'
ffff0000088028e0 t bLength_show
......
ffff0000092e0408 b PLLP_OUTC_lock
ffff0000092e0410 b PLLP_OUTA_lock

The original intent should be to filter out all local symbols
starting with '.L', so the dot should be escaped.

Fixes: 00902e984732 ("mksysmap: Add h8300 local symbol pattern")
Signed-off-by: ashimida <ashimida@linux.alibaba.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/mksysmap | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/mksysmap b/scripts/mksysmap
index a35acc0d0b82..9aa23d15862a 100755
--- a/scripts/mksysmap
+++ b/scripts/mksysmap
@@ -41,4 +41,4 @@
 # so we just ignore them to let readprofile continue to work.
 # (At least sparc64 has __crc_ in the middle).
 
-$NM -n $1 | grep -v '\( [aNUw] \)\|\(__crc_\)\|\( \$[adt]\)\|\( .L\)' > $2
+$NM -n $1 | grep -v '\( [aNUw] \)\|\(__crc_\)\|\( \$[adt]\)\|\( \.L\)' > $2
-- 
2.25.1

