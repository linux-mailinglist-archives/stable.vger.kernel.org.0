Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 509A5359ADE
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 12:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233954AbhDIKEI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 06:04:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:46030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233741AbhDIKCD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 06:02:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E678B6120C;
        Fri,  9 Apr 2021 10:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962402;
        bh=N8n3jcYHWyo1wp21uJxRgPbrFjs21WTUixqnVBSy01Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y3Z62XP0zPtQFvO6p4UeByqaTM8gYemtKPi3lkVVcANcazCdCY/Tz5qQmOPiYJV81
         g6kvm/TVuGpv5g7Z91pNkN8RxAajppc37eYslNa1OWcKyGct/TQxIj8eEjCH396R3K
         LGnOeODQd92RjBoE5cBWElRpZrkdFdiKpPdkZEGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 36/41] kbuild: Do not clean resolve_btfids if the output does not exist
Date:   Fri,  9 Apr 2021 11:53:58 +0200
Message-Id: <20210409095305.973227790@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409095304.818847860@linuxfoundation.org>
References: <20210409095304.818847860@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 0e1aa629f1ce9e8cb89e0cefb9e3bfb3dfa94821 ]

Nathan reported issue with cleaning empty build directory:

  $ make -s O=build distclean
  ../../scripts/Makefile.include:4: *** \
  O=/ho...build/tools/bpf/resolve_btfids does not exist.  Stop.

The problem that tools scripts require existing output
directory, otherwise it fails.

Adding check around the resolve_btfids clean target to
ensure the output directory is in place.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/bpf/20210211124004.1144344-1-jolsa@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 3a3937ab7ed0..4420131d4709 100644
--- a/Makefile
+++ b/Makefile
@@ -1085,8 +1085,14 @@ endif
 
 PHONY += resolve_btfids_clean
 
+resolve_btfids_O = $(abspath $(objtree))/tools/bpf/resolve_btfids
+
+# tools/bpf/resolve_btfids directory might not exist
+# in output directory, skip its clean in that case
 resolve_btfids_clean:
-	$(Q)$(MAKE) -sC $(srctree)/tools/bpf/resolve_btfids O=$(abspath $(objtree))/tools/bpf/resolve_btfids clean
+ifneq ($(wildcard $(resolve_btfids_O)),)
+	$(Q)$(MAKE) -sC $(srctree)/tools/bpf/resolve_btfids O=$(resolve_btfids_O) clean
+endif
 
 ifdef CONFIG_BPF
 ifdef CONFIG_DEBUG_INFO_BTF
-- 
2.30.2



