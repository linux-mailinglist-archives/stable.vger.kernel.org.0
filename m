Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70D4224B4DB
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731132AbgHTKN0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:13:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:57486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731123AbgHTKNX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:13:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30BBD206DA;
        Thu, 20 Aug 2020 10:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918401;
        bh=fHlcARBscWrbi6Cfe41srC03El6M9OA2QK3vLjYD0no=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NcgHoPS8dm/4sRGHdCVG0Xf4Rubw/NtaqP/nBUBDc4c+UNBvw7aEVMYLTFp9uRwn9
         pnkbkvMsaUtmSr8odg2XfWsvD3WpGeBY3MiXQE0hvVEikMC8Tinn/tTa0ejCcZ6uqs
         m3JkRyPi09o6QDvInsxTkzmZzzpYaL+7wxuG6Pco=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@redhat.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 126/228] tools, build: Propagate build failures from tools/build/Makefile.build
Date:   Thu, 20 Aug 2020 11:21:41 +0200
Message-Id: <20200820091613.886042839@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091607.532711107@linuxfoundation.org>
References: <20200820091607.532711107@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

[ Upstream commit a278f3d8191228212c553a5d4303fa603214b717 ]

The '&&' command seems to have a bad effect when $(cmd_$(1)) exits with
non-zero effect: the command failure is masked (despite `set -e`) and all but
the first command of $(dep-cmd) is executed (successfully, as they are mostly
printfs), thus overall returning 0 in the end.

This means in practice that despite compilation errors, tools's build Makefile
will return success. We see this very reliably with libbpf's Makefile, which
doesn't get compilation error propagated properly. This in turns causes issues
with selftests build, as well as bpftool and other projects that rely on
building libbpf.

The fix is simple: don't use &&. Given `set -e`, we don't need to chain
commands with &&. The shell will exit on first failure, giving desired
behavior and propagating error properly.

Fixes: 275e2d95591e ("tools build: Move dependency copy into function")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Link: https://lore.kernel.org/bpf/20200731024244.872574-1-andriin@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/build/Build.include | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/build/Build.include b/tools/build/Build.include
index d9048f145f97a..63bb9752612a8 100644
--- a/tools/build/Build.include
+++ b/tools/build/Build.include
@@ -74,7 +74,8 @@ dep-cmd = $(if $(wildcard $(fixdep)),
 #                   dependencies in the cmd file
 if_changed_dep = $(if $(strip $(any-prereq) $(arg-check)),         \
                   @set -e;                                         \
-                  $(echo-cmd) $(cmd_$(1)) && $(dep-cmd))
+                  $(echo-cmd) $(cmd_$(1));                         \
+                  $(dep-cmd))
 
 # if_changed      - execute command if any prerequisite is newer than
 #                   target, or command line has changed
-- 
2.25.1



