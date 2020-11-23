Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 025282C0AE6
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730855AbgKWMb2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:31:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:42222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730847AbgKWMbZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:31:25 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72BB92076E;
        Mon, 23 Nov 2020 12:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134685;
        bh=m+6Ivt4YjbhoMgnnjH0z+omp/8njCcODphmrNNh/EGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TNgW3y4/OS+DAzAiYdVkl/T+u2NC72rCOEWM07xaiLbNWpalg3jgAkAN3/h6SoTch
         kKSxToopOKRDJiqAM2tcofHo9lWWzQ+kwUONMIT6/IlJWkATH1Bdlsx8F10ivLhi8l
         rwl42dPkrae9CP+4nNElmoAs8VSAA1QcD78O4Fk4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leo Yan <leo.yan@linaro.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 46/91] perf lock: Dont free "lock_seq_stat" if read_count isnt zero
Date:   Mon, 23 Nov 2020 13:22:06 +0100
Message-Id: <20201123121811.555738702@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121809.285416732@linuxfoundation.org>
References: <20201123121809.285416732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leo Yan <leo.yan@linaro.org>

[ Upstream commit b0e5a05cc9e37763c7f19366d94b1a6160c755bc ]

When execute command "perf lock report", it hits failure and outputs log
as follows:

  perf: builtin-lock.c:623: report_lock_release_event: Assertion `!(seq->read_count < 0)' failed.
  Aborted

This is an imbalance issue.  The locking sequence structure
"lock_seq_stat" contains the reader counter and it is used to check if
the locking sequence is balance or not between acquiring and releasing.

If the tool wrongly frees "lock_seq_stat" when "read_count" isn't zero,
the "read_count" will be reset to zero when allocate a new structure at
the next time; thus it causes the wrong counting for reader and finally
results in imbalance issue.

To fix this issue, if detects "read_count" is not zero (means still have
read user in the locking sequence), goto the "end" tag to skip freeing
structure "lock_seq_stat".

Fixes: e4cef1f65061 ("perf lock: Fix state machine to recognize lock sequence")
Signed-off-by: Leo Yan <leo.yan@linaro.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Link: https://lore.kernel.org/r/20201104094229.17509-2-leo.yan@linaro.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-lock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 6e0189df2b3ba..0cb7f7b731fb0 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -620,7 +620,7 @@ static int report_lock_release_event(struct perf_evsel *evsel,
 	case SEQ_STATE_READ_ACQUIRED:
 		seq->read_count--;
 		BUG_ON(seq->read_count < 0);
-		if (!seq->read_count) {
+		if (seq->read_count) {
 			ls->nr_release++;
 			goto end;
 		}
-- 
2.27.0



