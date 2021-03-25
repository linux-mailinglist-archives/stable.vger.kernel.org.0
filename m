Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 021AD348F94
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbhCYL2N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:28:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:35302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231284AbhCYL0r (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 07:26:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2C9661A37;
        Thu, 25 Mar 2021 11:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671607;
        bh=Fn+7n/epq8bT6dV8fGf7vbv/be+VA2frF0OvHBHiXOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z4TOO5BJTomRf7LkIz0dm7xENeubulwztOYEprmDMLvRRH60c9h+g4BZxbRTir0Xb
         u9cYjoJdHcQpyT0XeJ79jAeNT1V0iECkQCW3Oc1dEM8yeHmoyakVrQBOSn1VIgOEjZ
         VN5n8VYfMQCKcCIcmI5ngO71HmtxBMwXh4zzexVpL0jPhrVRb9kOXQ8BQw4I+ZCZsU
         +h3knUe1woYH9ezE2Rf3EfkWEEsSKdlbSrpGyVUDaH0c8DaNSKiGgvuV6/qzai55iB
         uAP0YPqUviDb82E5s64AvNMRIIMq/10q4XqL3ZLLjFEafpUF58bIckXDJ0SUncKd9D
         k5NVysd1HD2oQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Stefan Metzmacher <metze@samba.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 37/39] signal: don't allow sending any signals to PF_IO_WORKER threads
Date:   Thu, 25 Mar 2021 07:25:56 -0400
Message-Id: <20210325112558.1927423-37-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112558.1927423-1-sashal@kernel.org>
References: <20210325112558.1927423-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 5be28c8f85ce99ed2d329d2ad8bdd18ea19473a5 ]

They don't take signals individually, and even if they share signals with
the parent task, don't allow them to be delivered through the worker
thread. Linux does allow this kind of behavior for regular threads, but
it's really a compatability thing that we need not care about for the IO
threads.

Reported-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/signal.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/signal.c b/kernel/signal.c
index ef8f2a28d37c..18ed1f853439 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -833,6 +833,9 @@ static int check_kill_permission(int sig, struct kernel_siginfo *info,
 
 	if (!valid_signal(sig))
 		return -EINVAL;
+	/* PF_IO_WORKER threads don't take any signals */
+	if (t->flags & PF_IO_WORKER)
+		return -ESRCH;
 
 	if (!si_fromuser(info))
 		return 0;
-- 
2.30.1

