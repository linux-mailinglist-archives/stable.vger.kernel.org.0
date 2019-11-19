Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC65A1016D8
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731950AbfKSFwt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:52:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:50598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731290AbfKSFws (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:52:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D03520721;
        Tue, 19 Nov 2019 05:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142767;
        bh=v1U9l228jWqtWhwzn9ffmWZreUwxYYHeC5kYUpJ+idU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0hPq5tpGOZGW5uE30QL0tIlLcOMFeqLIrireI/abJX1d3znQMOtlkJjkv0dP9gtWg
         U2nMmDPgz592zY7aKAX0vIRQwAULTvS/YMnpExZXRZm6hzZuGqtamj5sMR5drvVYiy
         K/cPhWvdeiROKIOOoHAg1QuPeqMnDXge1TlqicYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 193/239] coresight: perf: Disable trace path upon source error
Date:   Tue, 19 Nov 2019 06:19:53 +0100
Message-Id: <20191119051335.791779034@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 99cbf5d5d1c1f..69349b93e8741 100644
--- a/drivers/hwtracing/coresight/coresight-etm-perf.c
+++ b/drivers/hwtracing/coresight/coresight-etm-perf.c
@@ -317,11 +317,13 @@ static void etm_event_start(struct perf_event *event, int flags)
 
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



