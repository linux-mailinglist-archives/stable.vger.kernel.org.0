Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BED32E9A43
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:12:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbhADQHp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:07:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:38732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728722AbhADQCA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:02:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92CF0224D4;
        Mon,  4 Jan 2021 16:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609776105;
        bh=HnNaHNJxfVxU+EAUPCD8OQpZsquJAgWFDNBE0aZ9X8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DafRc9zDBKjEoZvO5awXn5VCzU+F8BCDtF+eUIsO24jbDp4oD3lKq5D+ghaIYtAVe
         tRG5DwNuR84S8EFJtlQCAloOgoUTvmjZFuKobtzaRpUct2Hm1btBvNbqSBXNWDck2z
         A1n8KMM0jhnsabnYb4s8j+/5Bumc7niFED7nky04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Petr Vorel <petr.vorel@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.10 23/63] tools headers UAPI: Sync linux/const.h with the kernel headers
Date:   Mon,  4 Jan 2021 16:57:16 +0100
Message-Id: <20210104155709.946028449@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155708.800470590@linuxfoundation.org>
References: <20210104155708.800470590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

commit 7ddcdea5b54492f54700f427f58690cf1e187e5e upstream.

To pick up the changes in:

  a85cbe6159ffc973 ("uapi: move constants from <linux/kernel.h> to <linux/const.h>")

That causes no changes in tooling, just addresses this perf build
warning:

  Warning: Kernel ABI header at 'tools/include/uapi/linux/const.h' differs from latest version at 'include/uapi/linux/const.h'
  diff -u tools/include/uapi/linux/const.h include/uapi/linux/const.h

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Petr Vorel <petr.vorel@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/include/uapi/linux/const.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/tools/include/uapi/linux/const.h
+++ b/tools/include/uapi/linux/const.h
@@ -28,4 +28,9 @@
 #define _BITUL(x)	(_UL(1) << (x))
 #define _BITULL(x)	(_ULL(1) << (x))
 
+#define __ALIGN_KERNEL(x, a)		__ALIGN_KERNEL_MASK(x, (typeof(x))(a) - 1)
+#define __ALIGN_KERNEL_MASK(x, mask)	(((x) + (mask)) & ~(mask))
+
+#define __KERNEL_DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))
+
 #endif /* _UAPI_LINUX_CONST_H */


