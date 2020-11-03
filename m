Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4C452A5719
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732156AbgKCVeQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:34:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:58628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732252AbgKCU4k (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:56:40 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4E0820732;
        Tue,  3 Nov 2020 20:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437000;
        bh=md9wSusj+UYDdkbmuUuq3AZ/paY7fC3MwE3iDZlR9iw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tWg0sLoDWfhAL7xDQfo9eD6/5QY5H92dW7qehbraRJDPWP1tW1RNEjXHKJDfeTxKZ
         DMFq1LG0WRpTi0q1iQ49suN/YcOexndF2KzVimBwGk8GMY+O8//qbI5QXCVfNs5AdC
         Cw6fBktuV/qSSWNp4n3/RwzFtUYm4MUGEv88s9Po=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kim Phillips <kim.phillips@amd.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.4 102/214] perf/x86/amd/ibs: Dont include randomized bits in get_ibs_op_count()
Date:   Tue,  3 Nov 2020 21:35:50 +0100
Message-Id: <20201103203300.110510920@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kim Phillips <kim.phillips@amd.com>

commit 680d69635005ba0e58fe3f4c52fc162b8fc743b0 upstream.

get_ibs_op_count() adds hardware's current count (IbsOpCurCnt) bits
to its count regardless of hardware's valid status.

According to the PPR for AMD Family 17h Model 31h B0 55803 Rev 0.54,
if the counter rolls over, valid status is set, and the lower 7 bits
of IbsOpCurCnt are randomized by hardware.

Don't include those bits in the driver's event count.

Fixes: 8b1e13638d46 ("perf/x86-ibs: Fix usage of IBS op current count")
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/events/amd/ibs.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -335,11 +335,15 @@ static u64 get_ibs_op_count(u64 config)
 {
 	u64 count = 0;
 
+	/*
+	 * If the internal 27-bit counter rolled over, the count is MaxCnt
+	 * and the lower 7 bits of CurCnt are randomized.
+	 * Otherwise CurCnt has the full 27-bit current counter value.
+	 */
 	if (config & IBS_OP_VAL)
-		count += (config & IBS_OP_MAX_CNT) << 4; /* cnt rolled over */
-
-	if (ibs_caps & IBS_CAPS_RDWROPCNT)
-		count += (config & IBS_OP_CUR_CNT) >> 32;
+		count = (config & IBS_OP_MAX_CNT) << 4;
+	else if (ibs_caps & IBS_CAPS_RDWROPCNT)
+		count = (config & IBS_OP_CUR_CNT) >> 32;
 
 	return count;
 }


