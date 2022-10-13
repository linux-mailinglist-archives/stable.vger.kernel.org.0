Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD0B5FCFD1
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbiJMAWP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbiJMAVm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:21:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74BB8104D3B;
        Wed, 12 Oct 2022 17:18:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5588FB81CC9;
        Thu, 13 Oct 2022 00:18:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 041F0C433C1;
        Thu, 13 Oct 2022 00:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620299;
        bh=3t7YvvkwEOPmixL8bgqdKSwqQRF35jS7csXR8qeViUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a5JUz1xGdVPwk5cWJIOMJ3knj5rKdN76SMtb9fwOEuxDdW+9ngm4u4O94EVB837wu
         De2xIJwxoT53fmRMNFdYautybVIAgtsHBneTBJCwlDOxDGSddLrkWjejLNiD7GkdDC
         tVuf5+bkaQ0DddGZWJoyCevqziIF9PRmo0wHTGho2SqynKVVi4/aHb511NYZpHqyWr
         VrODz3JJZVm30GVz6gxJMbsRHaJz2blfvKgWPprHbDJyUhcAtMbkyCv6gWQxopvri0
         sZ+Eet+SwuWw9v/Ji57mHE9+XaFa8S6RneGgJPUS8VFGXVvWq9Q//OfH38vun3G2Db
         k1Kjj527D7iWg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eddie James <eajames@linux.ibm.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Joel Stanley <joel@jms.id.au>, Sasha Levin <sashal@kernel.org>,
        jdelvare@suse.com, william.xuanziyang@huawei.com,
        akpm@linux-foundation.org, willy@infradead.org,
        linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 60/67] hwmon (occ): Retry for checksum failure
Date:   Wed, 12 Oct 2022 20:15:41 -0400
Message-Id: <20221013001554.1892206-60-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013001554.1892206-1-sashal@kernel.org>
References: <20221013001554.1892206-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eddie James <eajames@linux.ibm.com>

[ Upstream commit dbed963ed62c4c2b8870a02c8b7dcb0c2af3ee0b ]

Due to the OCC communication design with a shared SRAM area,
checkum errors are expected due to corrupted buffer from OCC
communications with other system components. Therefore, retry
the command twice in the event of a checksum failure.

Signed-off-by: Eddie James <eajames@linux.ibm.com>
Acked-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20220426154956.27205-3-eajames@linux.ibm.com
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/occ/p9_sbe.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/hwmon/occ/p9_sbe.c b/drivers/hwmon/occ/p9_sbe.c
index c1e0a1d96cd4..f3791a589b01 100644
--- a/drivers/hwmon/occ/p9_sbe.c
+++ b/drivers/hwmon/occ/p9_sbe.c
@@ -14,6 +14,8 @@
 
 #include "common.h"
 
+#define OCC_CHECKSUM_RETRIES	3
+
 struct p9_sbe_occ {
 	struct occ occ;
 	bool sbe_error;
@@ -80,18 +82,23 @@ static bool p9_sbe_occ_save_ffdc(struct p9_sbe_occ *ctx, const void *resp,
 static int p9_sbe_occ_send_cmd(struct occ *occ, u8 *cmd, size_t len,
 			       void *resp, size_t resp_len)
 {
+	size_t original_resp_len = resp_len;
 	struct p9_sbe_occ *ctx = to_p9_sbe_occ(occ);
-	int rc;
+	int rc, i;
 
-	rc = fsi_occ_submit(ctx->sbe, cmd, len, resp, &resp_len);
-	if (rc < 0) {
+	for (i = 0; i < OCC_CHECKSUM_RETRIES; ++i) {
+		rc = fsi_occ_submit(ctx->sbe, cmd, len, resp, &resp_len);
+		if (rc >= 0)
+			break;
 		if (resp_len) {
 			if (p9_sbe_occ_save_ffdc(ctx, resp, resp_len))
 				sysfs_notify(&occ->bus_dev->kobj, NULL,
 					     bin_attr_ffdc.attr.name);
+			return rc;
 		}
-
-		return rc;
+		if (rc != -EBADE)
+			return rc;
+		resp_len = original_resp_len;
 	}
 
 	switch (((struct occ_response *)resp)->return_status) {
-- 
2.35.1

