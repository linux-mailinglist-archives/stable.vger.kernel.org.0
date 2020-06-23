Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED548206190
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392341AbgFWUpB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:45:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:42306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389681AbgFWUo7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:44:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEB2421BE5;
        Tue, 23 Jun 2020 20:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592945100;
        bh=0ITsDM3fOKZh+tWWm63frmHczA2dJQnz3x74cD9OrLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cFdI+rrKPkpFIKKto9/J4AfXX4I5T/8zcJx8aq7ccEmSp6Sl3A6tNJqwHdxgFFVXc
         CiTF29umMVTKsm5Ac6Mal5sIjU76o2yvDcAcz7S2YxHNz0mGilaxm1/BezHJ1qajk/
         Ink+UYTnljUZmDYplGdiv/9hebaDLi8fWJ1JBU5Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, ashimida <ashimida@linux.alibaba.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 032/136] mksysmap: Fix the mismatch of .L symbols in System.map
Date:   Tue, 23 Jun 2020 21:58:08 +0200
Message-Id: <20200623195305.267444170@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195303.601828702@linuxfoundation.org>
References: <20200623195303.601828702@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index a35acc0d0b827..9aa23d15862a0 100755
--- a/scripts/mksysmap
+++ b/scripts/mksysmap
@@ -41,4 +41,4 @@
 # so we just ignore them to let readprofile continue to work.
 # (At least sparc64 has __crc_ in the middle).
 
-$NM -n $1 | grep -v '\( [aNUw] \)\|\(__crc_\)\|\( \$[adt]\)\|\( .L\)' > $2
+$NM -n $1 | grep -v '\( [aNUw] \)\|\(__crc_\)\|\( \$[adt]\)\|\( \.L\)' > $2
-- 
2.25.1



