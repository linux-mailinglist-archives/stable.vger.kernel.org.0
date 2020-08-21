Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19B4024DA88
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 18:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728453AbgHUQVe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 12:21:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:49882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728146AbgHUQUu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 12:20:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A95E22D2C;
        Fri, 21 Aug 2020 16:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598026804;
        bh=8kd2JWfylGbyX5junfsVFBIFiC5m0s7OyUEiuP3YRFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gZ9jFDVwmCaXZXBb1deWpdSWZD/rmKF3B0u5K+8t27bEnrGEBC/0b7WR02YtYXraX
         JEqLUQIc9Vl3MZ8XCEEocpfmJLE4rLt6SUT6DGNsEpjBZig3QuROsnky397fnFuVCN
         p0GSoNUJ3zErU0aKjkBgbdBqvCkDVCL28GZvjCEs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 4.9 19/26] cec-api: prevent leaking memory through hole in structure
Date:   Fri, 21 Aug 2020 12:19:30 -0400
Message-Id: <20200821161938.349246-19-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821161938.349246-1-sashal@kernel.org>
References: <20200821161938.349246-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 6c42227c3467549ddc65efe99c869021d2f4a570 ]

Fix this smatch warning:

drivers/media/cec/core/cec-api.c:156 cec_adap_g_log_addrs() warn: check that 'log_addrs' doesn't leak information (struct has a hole after
'features')

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/cec/cec-api.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/cec/cec-api.c b/drivers/staging/media/cec/cec-api.c
index e274e2f223986..264bb7d1efcb8 100644
--- a/drivers/staging/media/cec/cec-api.c
+++ b/drivers/staging/media/cec/cec-api.c
@@ -141,7 +141,13 @@ static long cec_adap_g_log_addrs(struct cec_adapter *adap,
 	struct cec_log_addrs log_addrs;
 
 	mutex_lock(&adap->lock);
-	log_addrs = adap->log_addrs;
+	/*
+	 * We use memcpy here instead of assignment since there is a
+	 * hole at the end of struct cec_log_addrs that an assignment
+	 * might ignore. So when we do copy_to_user() we could leak
+	 * one byte of memory.
+	 */
+	memcpy(&log_addrs, &adap->log_addrs, sizeof(log_addrs));
 	if (!adap->is_configured)
 		memset(log_addrs.log_addr, CEC_LOG_ADDR_INVALID,
 		       sizeof(log_addrs.log_addr));
-- 
2.25.1

