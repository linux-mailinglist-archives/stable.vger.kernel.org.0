Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4169C34C644
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232218AbhC2IGO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:06:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:48512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232221AbhC2IFZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:05:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85EC2619A6;
        Mon, 29 Mar 2021 08:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005121;
        bh=W08GJSeIMMLzF16cGv85/Nq/gNBkFj2teDRdoAaF/lE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yamdjDEVwC6b145VsvCGwrmu350gvdWcUCBk9LEK3Bjo4pT1Q7ctURidqoGRg1Yhu
         RoccSxTkRrovdBO/c/M57H4fx0pafMaywvWO6947SX8T2BDJqLRXlKE7Q7tdVwTqpA
         NPQ9UoRNlndGX9k30/F6gNKmNwg3vGEU9BM/coTI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Georgi Valkov <gvalkov@abv.bg>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 30/59] libbpf: Fix INSTALL flag order
Date:   Mon, 29 Mar 2021 09:58:10 +0200
Message-Id: <20210329075609.887656104@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075608.898173317@linuxfoundation.org>
References: <20210329075608.898173317@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Georgi Valkov <gvalkov@abv.bg>

[ Upstream commit e7fb6465d4c8e767e39cbee72464e0060ab3d20c ]

It was reported ([0]) that having optional -m flag between source and
destination arguments in install command breaks bpftools cross-build
on MacOS. Move -m to the front to fix this issue.

  [0] https://github.com/openwrt/openwrt/pull/3959

Fixes: 7110d80d53f4 ("libbpf: Makefile set specified permission mode")
Signed-off-by: Georgi Valkov <gvalkov@abv.bg>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20210308183038.613432-1-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index f02448e86d38..9fa466d4417b 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -183,7 +183,7 @@ define do_install
 	if [ ! -d '$(DESTDIR_SQ)$2' ]; then		\
 		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$2';	\
 	fi;						\
-	$(INSTALL) $1 $(if $3,-m $3,) '$(DESTDIR_SQ)$2'
+	$(INSTALL) $(if $3,-m $3,) $1 '$(DESTDIR_SQ)$2'
 endef
 
 install_lib: all_cmd
-- 
2.30.1



