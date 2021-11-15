Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF3DE4520C3
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245159AbhKPA41 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:56:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:44636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343553AbhKOTVU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DE2B6330C;
        Mon, 15 Nov 2021 18:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001724;
        bh=q9EQLU2WvniMgv8iRNNAQyvqK1PKtwk7Z9G6qUsx17Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hAybzZ8JfYWVynOKX5UMbaVl7ummUiBskIvU2tkzDNwEXSSzSuZswZbfBCEXjXvqo
         asMNqlJnUhVcZ02TYpKWZMNBeoneK3iUhpHttSpyfhCR4MuFttnLzfv7h0OY4hpQt/
         qx5TNNV7g/vZ0iyDpa+mQ6tFQGaebpfYJ+NWf3nI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>,
        Viktor Rosendahl <Viktor.Rosendahl@bmw.de>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 296/917] tools/latency-collector: Use correct size when writing queue_full_warning
Date:   Mon, 15 Nov 2021 17:56:31 +0100
Message-Id: <20211115165438.803643310@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Viktor Rosendahl <Viktor.Rosendahl@bmw.de>

[ Upstream commit f604de20c0a47e0e9518940a1810193678c92fa8 ]

queue_full_warning is a pointer, so it is wrong to use sizeof to calculate
the number of characters of the string it points to. The effect is that we
only print out the first few characters of the warning string.

The correct way is to use strlen(). We don't need to add 1 to the strlen()
because we don't want to write the terminating null character to stdout.

Link: https://lkml.kernel.org/r/20211019160701.15587-1-Viktor.Rosendahl@bmw.de

Link: https://lore.kernel.org/r/8fd4bb65ef3da67feac9ce3258cdbe9824752cf1.1629198502.git.jing.yangyang@zte.com.cn
Link: https://lore.kernel.org/r/20211012025424.180781-1-davidcomponentone@gmail.com
Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Viktor Rosendahl <Viktor.Rosendahl@bmw.de>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/tracing/latency/latency-collector.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/tracing/latency/latency-collector.c b/tools/tracing/latency/latency-collector.c
index 3a2e6bb781a8c..59a7f2346eab4 100644
--- a/tools/tracing/latency/latency-collector.c
+++ b/tools/tracing/latency/latency-collector.c
@@ -1538,7 +1538,7 @@ static void tracing_loop(void)
 				mutex_lock(&print_mtx);
 				check_signals();
 				write_or_die(fd_stdout, queue_full_warning,
-					     sizeof(queue_full_warning));
+					     strlen(queue_full_warning));
 				mutex_unlock(&print_mtx);
 			}
 			modified--;
-- 
2.33.0



