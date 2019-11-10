Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69EDDF6619
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727341AbfKJDLh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 22:11:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:42114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728375AbfKJCni (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:43:38 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1400121019;
        Sun, 10 Nov 2019 02:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353817;
        bh=QJxa5nK1H1nKWLhJmsQHhMbrd/v7Of9YYRk/3G1Mo8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=seK1D1yCY6f7tgDmexbhRUJ42vF0EnUuqan3PAc3aFVaGJ7uxh162qFowE1t3d9ia
         hrLBvV7Qu4YS89DQAt6UaDP08jg5vKaCmneFoY8DtOD5IqvEX8f1gG486T4rAA2oJU
         E/O9Jwqf5gVO5o8/ELRWGjfNxm8E7QEX1Jp5HeZo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 113/191] coresight: perf: Disable trace path upon source error
Date:   Sat,  9 Nov 2019 21:38:55 -0500
Message-Id: <20191110024013.29782-113-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

[ Upstream commit 4f8ef21007531c3d7cb5b826e7b2c8999b65ecae ]

We enable the trace path, before activating the source.
If we fail to enable the source, we must disable the path
to make sure it is available for another session.

Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-etm-perf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm-perf.c b/drivers/hwtracing/coresight/coresight-etm-perf.c
index 4b53d55788a07..c3c6452015142 100644
--- a/drivers/hwtracing/coresight/coresight-etm-perf.c
+++ b/drivers/hwtracing/coresight/coresight-etm-perf.c
@@ -306,11 +306,13 @@ static void etm_event_start(struct perf_event *event, int flags)
 
 	/* Finally enable the tracer */
 	if (source_ops(csdev)->enable(csdev, event, CS_MODE_PERF))
-		goto fail_end_stop;
+		goto fail_disable_path;
 
 out:
 	return;
 
+fail_disable_path:
+	coresight_disable_path(path);
 fail_end_stop:
 	perf_aux_output_flag(handle, PERF_AUX_FLAG_TRUNCATED);
 	perf_aux_output_end(handle, 0);
-- 
2.20.1

