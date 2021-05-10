Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1C0537870E
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235112AbhEJLNS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:13:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:39736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235873AbhEJLGo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:06:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39CB261606;
        Mon, 10 May 2021 10:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644208;
        bh=DIItjvddofOd61EZziGfIY/0ApXe1STJV2zOgTiU0ps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1svyPT7jjJVi1S5GNgNIN/V4sG47soDlrJNACALIVREwVdTyzsWo48facF3cSQ1Hl
         u+QeXPKBhu2jV6123bjBQnHL7yPCO2BSp7VLAODAh7jsAPUmXa2TgP/+Hd1RAcBlQG
         QpUcQ9IiH+7j3YEPQnrXap783HdITROaBRU09ncg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Calvin Walton <calvin.walton@kepstin.ca>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 5.11 332/342] tools/power turbostat: Fix offset overflow issue in index converting
Date:   Mon, 10 May 2021 12:22:02 +0200
Message-Id: <20210510102021.074444936@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Calvin Walton <calvin.walton@kepstin.ca>

commit 13a779de4175df602366d129e41782ad7168cef0 upstream.

The idx_to_offset() function returns type int (32-bit signed), but
MSR_PKG_ENERGY_STAT is u32 and would be interpreted as a negative number.
The end result is that it hits the if (offset < 0) check in update_msr_sum()
which prevents the timer callback from updating the stat in the background when
long durations are used. The similar issue exists in offset_to_idx() and
update_msr_sum(). Fix this issue by converting the 'int' to 'off_t' accordingly.

Fixes: 9972d5d84d76 ("tools/power turbostat: Enable accumulate RAPL display")
Signed-off-by: Calvin Walton <calvin.walton@kepstin.ca>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/power/x86/turbostat/turbostat.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -291,9 +291,9 @@ struct msr_sum_array {
 /* The percpu MSR sum array.*/
 struct msr_sum_array *per_cpu_msr_sum;
 
-int idx_to_offset(int idx)
+off_t idx_to_offset(int idx)
 {
-	int offset;
+	off_t offset;
 
 	switch (idx) {
 	case IDX_PKG_ENERGY:
@@ -323,7 +323,7 @@ int idx_to_offset(int idx)
 	return offset;
 }
 
-int offset_to_idx(int offset)
+int offset_to_idx(off_t offset)
 {
 	int idx;
 
@@ -3276,7 +3276,7 @@ static int update_msr_sum(struct thread_
 
 	for (i = IDX_PKG_ENERGY; i < IDX_COUNT; i++) {
 		unsigned long long msr_cur, msr_last;
-		int offset;
+		off_t offset;
 
 		if (!idx_valid(i))
 			continue;
@@ -3285,7 +3285,8 @@ static int update_msr_sum(struct thread_
 			continue;
 		ret = get_msr(cpu, offset, &msr_cur);
 		if (ret) {
-			fprintf(outf, "Can not update msr(0x%x)\n", offset);
+			fprintf(outf, "Can not update msr(0x%llx)\n",
+				(unsigned long long)offset);
 			continue;
 		}
 


