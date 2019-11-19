Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DBDC1017C0
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730009AbfKSFjv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:39:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:33846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730005AbfKSFjq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:39:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C8722071A;
        Tue, 19 Nov 2019 05:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141986;
        bh=QJxa5nK1H1nKWLhJmsQHhMbrd/v7Of9YYRk/3G1Mo8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f2AqO7p8tIEMhSZdy+wsFXEHzJwO+ILZ1XppSHOPaT/+RQcE/iyDGQ9LILz1zSCg7
         okiBXbUg01ME/t8od1vjvQueDEhu3CkBrElUq0weZWFF9FboTR2GJOxDBApSosAPSv
         8YXd9S6BjcQZ4ZQlHfV4iiNmuk63jIs6/u/feLNk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 347/422] coresight: perf: Disable trace path upon source error
Date:   Tue, 19 Nov 2019 06:19:04 +0100
Message-Id: <20191119051421.497738470@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
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



