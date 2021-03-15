Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0939033B722
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232720AbhCON7f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:59:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:37540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232165AbhCON6Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:58:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9544264F4A;
        Mon, 15 Mar 2021 13:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816703;
        bh=98MF8/ODNy3scW7fgMkNaWKxFbnVN2mLF74ZaQb+7E0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dVjXs9Wvn23JpbedzeIcYmPwLk7L5NBttdmPrxtyIJeOqYdX98pa9LH8ROm5LRaK/
         d1WyIiP+xnfmZUcwMm4JIxRWNXyksJRIpV5/2MMc7qsVsB9DhhjLJ0ytZMSyMnksiW
         BR0aR2GmdDIixVQyB1LFERE1e6o6XFr3GQmZVPJ4=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Antonio Terceiro <antonio.terceiro@linaro.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        He Zhe <zhe.he@windriver.com>, Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 5.10 065/290] perf build: Fix ccache usage in $(CC) when generating arch errno table
Date:   Mon, 15 Mar 2021 14:52:38 +0100
Message-Id: <20210315135544.109381805@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Antonio Terceiro <antonio.terceiro@linaro.org>

commit dacfc08dcafa7d443ab339592999e37bbb8a3ef0 upstream.

This was introduced by commit e4ffd066ff440a57 ("perf: Normalize gcc
parameter when generating arch errno table").

Assuming the first word of $(CC) is the actual compiler breaks usage
like CC="ccache gcc": the script ends up calling ccache directly with
gcc arguments, what fails. Instead of getting the first word, just
remove from $(CC) any word that starts with a "-". This maintains the
spirit of the original patch, while not breaking ccache users.

Fixes: e4ffd066ff440a57 ("perf: Normalize gcc parameter when generating arch errno table")
Signed-off-by: Antonio Terceiro <antonio.terceiro@linaro.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: He Zhe <zhe.he@windriver.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: http://lore.kernel.org/lkml/20210224130046.346977-1-antonio.terceiro@linaro.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/Makefile.perf |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -600,7 +600,7 @@ arch_errno_hdr_dir := $(srctree)/tools
 arch_errno_tbl := $(srctree)/tools/perf/trace/beauty/arch_errno_names.sh
 
 $(arch_errno_name_array): $(arch_errno_tbl)
-	$(Q)$(SHELL) '$(arch_errno_tbl)' $(firstword $(CC)) $(arch_errno_hdr_dir) > $@
+	$(Q)$(SHELL) '$(arch_errno_tbl)' '$(patsubst -%,,$(CC))' $(arch_errno_hdr_dir) > $@
 
 sync_file_range_arrays := $(beauty_outdir)/sync_file_range_arrays.c
 sync_file_range_tbls := $(srctree)/tools/perf/trace/beauty/sync_file_range.sh


