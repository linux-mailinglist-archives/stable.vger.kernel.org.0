Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1E4012C9D0
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728238AbfL2R0i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:26:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:47882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727908AbfL2R0h (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:26:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B183E207FD;
        Sun, 29 Dec 2019 17:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640397;
        bh=/2cofFv4jiQcCenMb/O5CQ05iDJ500lxRiBNuVyfjP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qP+xK0+45wHyqMGmAKekRN+xzLOaBgbjXgOQ9y/2WSnp8whIsB/sZXcBVBiAeoFXq
         NqDYKmTAHTdlETOkrZzCf9iaBzPZe4Wb9twbtC1fCxcyyY3lrDldEi5tBmSZL8Juyt
         lumGf3Lin0Nb8OXqay/YH5fARKej/QVIzH25QL0U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 141/161] s390/ftrace: fix endless recursion in function_graph tracer
Date:   Sun, 29 Dec 2019 18:19:49 +0100
Message-Id: <20191229162441.825230276@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162355.500086350@linuxfoundation.org>
References: <20191229162355.500086350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Schnelle <svens@linux.ibm.com>

[ Upstream commit 6feeee8efc53035c3195b02068b58ae947538aa4 ]

The following sequence triggers a kernel stack overflow on s390x:

mount -t tracefs tracefs /sys/kernel/tracing
cd /sys/kernel/tracing
echo function_graph > current_tracer
[crash]

This is because preempt_count_{add,sub} are in the list of traced
functions, which can be demonstrated by:

echo preempt_count_add >set_ftrace_filter
echo function_graph > current_tracer
[crash]

The stack overflow happens because get_tod_clock_monotonic() gets called
by ftrace but itself calls preempt_{disable,enable}(), which leads to a
endless recursion. Fix this by using preempt_{disable,enable}_notrace().

Fixes: 011620688a71 ("s390/time: ensure get_clock_monotonic() returns monotonic values")
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Reviewed-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/timex.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/timex.h b/arch/s390/include/asm/timex.h
index 0f12a3f91282..2dc9eb4e1acc 100644
--- a/arch/s390/include/asm/timex.h
+++ b/arch/s390/include/asm/timex.h
@@ -195,9 +195,9 @@ static inline unsigned long long get_tod_clock_monotonic(void)
 {
 	unsigned long long tod;
 
-	preempt_disable();
+	preempt_disable_notrace();
 	tod = get_tod_clock() - *(unsigned long long *) &tod_clock_base[1];
-	preempt_enable();
+	preempt_enable_notrace();
 	return tod;
 }
 
-- 
2.20.1



