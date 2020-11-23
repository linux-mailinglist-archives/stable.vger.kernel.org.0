Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 021E12C0ABB
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730164AbgKWM0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:26:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:36616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730161AbgKWM0g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:26:36 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F16372076E;
        Mon, 23 Nov 2020 12:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134395;
        bh=fGuMjDQB6aewA/ah+Bku1v2flQrg5ZmdrHoOCslK4mw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E9vOlZ0rExRx1NJEwjAxXuDdQc/2UVDAholsXhnCdWGcVLXNetXeL4aU1g3NKeUW3
         x3FrY56qNf88gRMK2svmMHDOH64jaNonqkt2YwI8YCZ4XROyy22rFVuPjoFAcphhu9
         W4DNt5yJycxjB0T5Sz8EAt8KkP9nQ7S8MJ/h8JcM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leo Yan <leo.yan@linaro.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 26/47] perf lock: Dont free "lock_seq_stat" if read_count isnt zero
Date:   Mon, 23 Nov 2020 13:22:12 +0100
Message-Id: <20201123121806.814869489@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121805.530891002@linuxfoundation.org>
References: <20201123121805.530891002@linuxfoundation.org>
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
index ce3bfb48b26f0..956b0aa916cfe 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -616,7 +616,7 @@ static int report_lock_release_event(struct perf_evsel *evsel,
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



