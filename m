Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD4B2592E9
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729187AbgIAPSf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:18:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:36862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729391AbgIAPSa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:18:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57744206EB;
        Tue,  1 Sep 2020 15:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973509;
        bh=Gtz/RmK+vN597YxQslboCRgSw2E0RPm7+U08Qg2SdzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jRxn7TptnWZtvwxlkg97Yajopn5E8z1NBONxuChn/gDOPdLAMKsm5ILsAgxPuLLl0
         yCUrghaBoVfpWBFiZ+xJuxNNi/kA5GvMqS6fUAWdOcD/4OaPxDcE3zOcQLsyO7e1ba
         y8rQ3SObcMJULhXuERdCplmnFtl5toTuT3W1v3zE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 27/91] cec-api: prevent leaking memory through hole in structure
Date:   Tue,  1 Sep 2020 17:10:01 +0200
Message-Id: <20200901150929.505945989@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150928.096174795@linuxfoundation.org>
References: <20200901150928.096174795@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 drivers/media/cec/cec-api.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/cec/cec-api.c b/drivers/media/cec/cec-api.c
index 21a5f45e0259e..66ef06f4670c8 100644
--- a/drivers/media/cec/cec-api.c
+++ b/drivers/media/cec/cec-api.c
@@ -159,7 +159,13 @@ static long cec_adap_g_log_addrs(struct cec_adapter *adap,
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



