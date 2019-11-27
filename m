Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72ED610AC36
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 09:49:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfK0Itc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 03:49:32 -0500
Received: from foss.arm.com ([217.140.110.172]:44570 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726909AbfK0It2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 03:49:28 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3FC6031B;
        Wed, 27 Nov 2019 00:49:28 -0800 (PST)
Received: from e110176-lin.kfn.arm.com (unknown [10.50.4.153])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D4DCF3F52E;
        Wed, 27 Nov 2019 00:49:26 -0800 (PST)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, stable@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] crypto: ccree: fix backlog memory leak
Date:   Wed, 27 Nov 2019 10:49:08 +0200
Message-Id: <20191127084909.14472-5-gilad@benyossef.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191127084909.14472-1-gilad@benyossef.com>
References: <20191127084909.14472-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix brown paper bag bug of not releasing backlog list item buffer
when backlog was consumed causing a memory leak when backlog is
used.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: stable@vger.kernel.org # v4.19+
---
 drivers/crypto/ccree/cc_request_mgr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/ccree/cc_request_mgr.c b/drivers/crypto/ccree/cc_request_mgr.c
index 3ed3164820eb..a5606dc04b06 100644
--- a/drivers/crypto/ccree/cc_request_mgr.c
+++ b/drivers/crypto/ccree/cc_request_mgr.c
@@ -404,6 +404,7 @@ static void cc_proc_backlog(struct cc_drvdata *drvdata)
 		spin_lock(&mgr->bl_lock);
 		list_del(&bli->list);
 		--mgr->bl_len;
+		kfree(bli);
 	}
 
 	spin_unlock(&mgr->bl_lock);
-- 
2.23.0

