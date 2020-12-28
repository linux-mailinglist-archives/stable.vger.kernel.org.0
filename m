Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A98F2E6466
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391335AbgL1NjO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:39:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:39564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731461AbgL1NjN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:39:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DD62207C9;
        Mon, 28 Dec 2020 13:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162713;
        bh=oIi4p08Wx1ycRTgHyg8oJ/8xhZkHywW1tcedUl3Wda8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FxOnsEhk9o86OL/hIh15XmvRc27JAx6PfXIvmtFbp/3Qf3jd9MQm3FQa6so3zWnsa
         5bYuiAcVnRP3UWjCp3HTXHKA3X0H++qhISFJE1mQp/JOXEWRP9ehGMEPNfiv8ESIxM
         xdRDZ/xcoHT+IPHW7lKoMqA2H5cvtHKWFsGVxEaM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 048/453] perf/x86/intel: Check PEBS status correctly
Date:   Mon, 28 Dec 2020 13:44:44 +0100
Message-Id: <20201228124939.567620237@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

[ Upstream commit fc17db8aa4c53cbd2d5469bb0521ea0f0a6dbb27 ]

The kernel cannot disambiguate when 2+ PEBS counters overflow at the
same time. This is what the comment for this code suggests.  However,
I see the comparison is done with the unfiltered p->status which is a
copy of IA32_PERF_GLOBAL_STATUS at the time of the sample. This
register contains more than the PEBS counter overflow bits. It also
includes many other bits which could also be set.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20201126110922.317681-2-namhyung@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/ds.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index 1aaba2c8a9ba6..eb8bd0eeace7d 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -1912,7 +1912,7 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
 		 * that caused the PEBS record. It's called collision.
 		 * If collision happened, the record will be dropped.
 		 */
-		if (p->status != (1ULL << bit)) {
+		if (pebs_status != (1ULL << bit)) {
 			for_each_set_bit(i, (unsigned long *)&pebs_status, size)
 				error[i]++;
 			continue;
-- 
2.27.0



