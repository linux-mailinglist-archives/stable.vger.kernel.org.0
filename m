Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAB3A83CB4
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 23:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727243AbfHFVdo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 17:33:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:51560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727165AbfHFVdn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 17:33:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7029B217D9;
        Tue,  6 Aug 2019 21:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565127223;
        bh=s6L8OP4RVDz/IuSN61W9whRCpF375hdigkwWMzjI6no=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QqfOXtOk78kkbxny5O0kidMS95u0awEirmQeZjDhwS5AEJrNlJk+L5MshdGSsMu1C
         VcE3o8tlP5nJb61vFXfbOF3o3BPXIJhILMqqqQm+MxWfdTznVyrGg2OSEL79HFox4l
         uW1zj6nMzNIPtFS7UzwHP/SrajCgk7ZEzIrGLyUM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        =?UTF-8?q?Luis=20Cl=C3=A1udio=20Gon=C3=A7alves?= 
        <lclaudio@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 15/59] tools perf beauty: Fix usbdevfs_ioctl table generator to handle _IOC()
Date:   Tue,  6 Aug 2019 17:32:35 -0400
Message-Id: <20190806213319.19203-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190806213319.19203-1-sashal@kernel.org>
References: <20190806213319.19203-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 7ee526152db7a75d7b8713346dac76ffc3662b29 ]

In addition to _IOW() and _IOR(), to handle this case:

  #define USBDEVFS_CONNINFO_EX(len)  _IOC(_IOC_READ, 'U', 32, len)

That will happen in the next sync of this header file.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Luis Cláudio Gonçalves <lclaudio@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://lkml.kernel.org/n/tip-3br5e4t64e4lp0goo84che3s@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/trace/beauty/usbdevfs_ioctl.sh | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/perf/trace/beauty/usbdevfs_ioctl.sh b/tools/perf/trace/beauty/usbdevfs_ioctl.sh
index 930b80f422e83..aa597ae537470 100755
--- a/tools/perf/trace/beauty/usbdevfs_ioctl.sh
+++ b/tools/perf/trace/beauty/usbdevfs_ioctl.sh
@@ -3,10 +3,13 @@
 
 [ $# -eq 1 ] && header_dir=$1 || header_dir=tools/include/uapi/linux/
 
+# also as:
+# #define USBDEVFS_CONNINFO_EX(len)  _IOC(_IOC_READ, 'U', 32, len)
+
 printf "static const char *usbdevfs_ioctl_cmds[] = {\n"
-regex="^#[[:space:]]*define[[:space:]]+USBDEVFS_(\w+)[[:space:]]+_IO[WR]{0,2}\([[:space:]]*'U'[[:space:]]*,[[:space:]]*([[:digit:]]+).*"
-egrep $regex ${header_dir}/usbdevice_fs.h | egrep -v 'USBDEVFS_\w+32[[:space:]]' | \
-	sed -r "s/$regex/\2 \1/g"	| \
+regex="^#[[:space:]]*define[[:space:]]+USBDEVFS_(\w+)(\(\w+\))?[[:space:]]+_IO[CWR]{0,2}\([[:space:]]*(_IOC_\w+,[[:space:]]*)?'U'[[:space:]]*,[[:space:]]*([[:digit:]]+).*"
+egrep "$regex" ${header_dir}/usbdevice_fs.h | egrep -v 'USBDEVFS_\w+32[[:space:]]' | \
+	sed -r "s/$regex/\4 \1/g"	| \
 	sort | xargs printf "\t[%s] = \"%s\",\n"
 printf "};\n\n"
 printf "#if 0\n"
-- 
2.20.1

