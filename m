Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E999469EF6
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359161AbhLFPo7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:44:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390732AbhLFPmt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:42:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B12BC07E5DD;
        Mon,  6 Dec 2021 07:30:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4145CB81123;
        Mon,  6 Dec 2021 15:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DE40C34901;
        Mon,  6 Dec 2021 15:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804610;
        bh=zgKNIIkxEue0rAgadGy/CCj7/3ZhbOjqTlLbdU8Bexg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zc8H9mcvhjJWuk0zuNe7AlmoP8BaQbSvCa8V2IyFujS6d6ug1dEjn+1Q/CwPCFTui
         /HqWyKyxcQulEkikUltWZc5A1j6vjOAjhN5+NnQ2LIFyFtxqSDXi3MyZZtL9nWA4QR
         D9r2u7bPrs/wjeriIWfFAS9CpCntQ0O8nwwICb94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Andrew Halaney <ahalaney@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 176/207] preempt/dynamic: Fix setup_preempt_mode() return value
Date:   Mon,  6 Dec 2021 15:57:10 +0100
Message-Id: <20211206145616.355012600@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Halaney <ahalaney@redhat.com>

[ Upstream commit 9ed20bafc85806ca6c97c9128cec46c3ef80ae86 ]

__setup() callbacks expect 1 for success and 0 for failure. Correct the
usage here to reflect that.

Fixes: 826bfeb37bb4 ("preempt/dynamic: Support dynamic preempt with preempt= boot option")
Reported-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20211203233203.133581-1-ahalaney@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 6f4625f8276f1..4170ec15926ee 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6660,11 +6660,11 @@ static int __init setup_preempt_mode(char *str)
 	int mode = sched_dynamic_mode(str);
 	if (mode < 0) {
 		pr_warn("Dynamic Preempt: unsupported mode: %s\n", str);
-		return 1;
+		return 0;
 	}
 
 	sched_dynamic_update(mode);
-	return 0;
+	return 1;
 }
 __setup("preempt=", setup_preempt_mode);
 
-- 
2.33.0



