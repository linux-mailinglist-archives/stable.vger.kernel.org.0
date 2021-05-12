Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC61D37C23C
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233259AbhELPII (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:08:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:58866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232532AbhELPGI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:06:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2461161959;
        Wed, 12 May 2021 15:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831655;
        bh=RcW17yEpprrcJBjwBZinKm14ZuE9ekd/3tVi4ft1fcU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ze+JLBGjwqnKj7DshSDz8pg4QH3rBx807+qWFncNBg5yyqeh28amHcmdpwjOB1XEv
         K16OoDzevzQAr77GF4gn28beFAy/PQ1s+ePJhUVB/GgxQITwD7Mm2rlTfKi46ptRMY
         oh76vXYBc4zBDB+c4S08jcHaV1a0QN9ejYgMHB5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Chikunov <vt@altlinux.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        "Dmitry V . Levin" <ldv@altlinux.org>
Subject: [PATCH 5.4 208/244] perf beauty: Fix fsconfig generator
Date:   Wed, 12 May 2021 16:49:39 +0200
Message-Id: <20210512144749.646651439@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Chikunov <vt@altlinux.org>

[ Upstream commit 2e1daee14e67fbf9b27280b974e2c680a22cabea ]

After gnulib update sed stopped matching `[[:space:]]*+' as before,
causing the following compilation error:

  In file included from builtin-trace.c:719:
  trace/beauty/generated/fsconfig_arrays.c:2:3: error: expected expression before ']' token
      2 |  [] = "",
	|   ^
  trace/beauty/generated/fsconfig_arrays.c:2:3: error: array index in initializer not of integer type
  trace/beauty/generated/fsconfig_arrays.c:2:3: note: (near initialization for 'fsconfig_cmds')

Fix this by correcting the regular expression used in the generator.
Also, clean up the script by removing redundant egrep, xargs, and printf
invocations.

Committer testing:

Continues to work:

  $ cat tools/perf/trace/beauty/fsconfig.sh
  #!/bin/sh
  # SPDX-License-Identifier: LGPL-2.1

  if [ $# -ne 1 ] ; then
  	linux_header_dir=tools/include/uapi/linux
  else
  	linux_header_dir=$1
  fi

  linux_mount=${linux_header_dir}/mount.h

  printf "static const char *fsconfig_cmds[] = {\n"
  ms='[[:space:]]*'
  sed -nr "s/^${ms}FSCONFIG_([[:alnum:]_]+)${ms}=${ms}([[:digit:]]+)${ms},.*/\t[\2] = \"\1\",/p" \
  	${linux_mount}
  printf "};\n"
  $ tools/perf/trace/beauty/fsconfig.sh
  static const char *fsconfig_cmds[] = {
  	[0] = "SET_FLAG",
  	[1] = "SET_STRING",
  	[2] = "SET_BINARY",
  	[3] = "SET_PATH",
  	[4] = "SET_PATH_EMPTY",
  	[5] = "SET_FD",
  	[6] = "CMD_CREATE",
  	[7] = "CMD_RECONFIGURE",
  };
  $

Fixes: d35293004a5e4 ("perf beauty: Add generator for fsconfig's 'cmd' arg values")
Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
Co-authored-by: Dmitry V. Levin <ldv@altlinux.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Link: http://lore.kernel.org/lkml/20210414182723.1670663-1-vt@altlinux.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/trace/beauty/fsconfig.sh | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/tools/perf/trace/beauty/fsconfig.sh b/tools/perf/trace/beauty/fsconfig.sh
index 83fb24df05c9..bc6ef7bb7a5f 100755
--- a/tools/perf/trace/beauty/fsconfig.sh
+++ b/tools/perf/trace/beauty/fsconfig.sh
@@ -10,8 +10,7 @@ fi
 linux_mount=${linux_header_dir}/mount.h
 
 printf "static const char *fsconfig_cmds[] = {\n"
-regex='^[[:space:]]*+FSCONFIG_([[:alnum:]_]+)[[:space:]]*=[[:space:]]*([[:digit:]]+)[[:space:]]*,[[:space:]]*.*'
-egrep $regex ${linux_mount} | \
-	sed -r "s/$regex/\2 \1/g"	| \
-	xargs printf "\t[%s] = \"%s\",\n"
+ms='[[:space:]]*'
+sed -nr "s/^${ms}FSCONFIG_([[:alnum:]_]+)${ms}=${ms}([[:digit:]]+)${ms},.*/\t[\2] = \"\1\",/p" \
+	${linux_mount}
 printf "};\n"
-- 
2.30.2



