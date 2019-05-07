Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EADD615BEE
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 07:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727537AbfEGFg4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:36:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:56660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727382AbfEGFgx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:36:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C23CC214C6;
        Tue,  7 May 2019 05:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207412;
        bh=5DznuNw7z9PLodnnVnROMbB57oFbzwhOIyEtlUp36dI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tugsefIhg0d8tgBLPaFGKJqyt669v7FaCiuKL0vnlz6MN7QFyTfvyOdkGIkPNoepj
         vRgu3xgzG1IT1cCwVOWWQoX3pRMFViv7DCnjkzlEN4Q205DIidWiwOwP7w7Xy47rQa
         wfeB/HX9qE+bGzACuXhjeCUJyWSrEFHagL1jH/oY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Harald Freudenberger <freude@linux.ibm.com>,
        Christian Rund <Christian.Rund@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 29/81] s390/pkey: add one more argument space for debug feature entry
Date:   Tue,  7 May 2019 01:35:00 -0400
Message-Id: <20190507053554.30848-29-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053554.30848-1-sashal@kernel.org>
References: <20190507053554.30848-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harald Freudenberger <freude@linux.ibm.com>

[ Upstream commit 6b1f16ba730d4c0cda1247568c3a1bf4fa3a2f2f ]

The debug feature entries have been used with up to 5 arguents
(including the pointer to the format string) but there was only
space reserved for 4 arguemnts. So now the registration does
reserve space for 5 times a long value.

This fixes a sometime appearing weired value as the last
value of an debug feature entry like this:

... pkey_sec2protkey zcrypt_send_cprb (cardnr=10 domain=12)
   failed with errno -2143346254

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Reported-by: Christian Rund <Christian.Rund@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/pkey_api.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/crypto/pkey_api.c b/drivers/s390/crypto/pkey_api.c
index 1b4001e0285f..b16344479959 100644
--- a/drivers/s390/crypto/pkey_api.c
+++ b/drivers/s390/crypto/pkey_api.c
@@ -45,7 +45,8 @@ static debug_info_t *debug_info;
 
 static void __init pkey_debug_init(void)
 {
-	debug_info = debug_register("pkey", 1, 1, 4 * sizeof(long));
+	/* 5 arguments per dbf entry (including the format string ptr) */
+	debug_info = debug_register("pkey", 1, 1, 5 * sizeof(long));
 	debug_register_view(debug_info, &debug_sprintf_view);
 	debug_set_level(debug_info, 3);
 }
-- 
2.20.1

