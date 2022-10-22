Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4AE608A2E
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234280AbiJVIrz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231969AbiJVIq3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:46:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18C8727170;
        Sat, 22 Oct 2022 01:09:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2768F60B93;
        Sat, 22 Oct 2022 08:08:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26150C433B5;
        Sat, 22 Oct 2022 08:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666426105;
        bh=Nu/8SgC7SIH9saHjokos5h2G6lpvcu/bw7NjIhvY4m0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AhQrvyxojQDS7FN/qnjz54KrR8jKltFgtU7rbxO4wz8MV54OYy/tSqufuZ01VFDwS
         S8qNnin7VCGd0LCZ7tiY4y52Gqar7nt46r1DOkE2nLopYi0e8siNgcM5RXJZRtXZIB
         OvYS+heLhRW9vEAxkUjx6NhWE0Wwnzm0n3CSUE3w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eddie James <eajames@linux.ibm.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Joel Stanley <joel@jms.id.au>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 690/717] hwmon (occ): Retry for checksum failure
Date:   Sat, 22 Oct 2022 09:29:29 +0200
Message-Id: <20221022072529.012389948@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index a91937e28e12..775147f31cb1 100644
--- a/drivers/hwmon/occ/p9_sbe.c
+++ b/drivers/hwmon/occ/p9_sbe.c
@@ -14,6 +14,8 @@
 
 #include "common.h"
 
+#define OCC_CHECKSUM_RETRIES	3
+
 struct p9_sbe_occ {
 	struct occ occ;
 	bool sbe_error;
@@ -81,18 +83,23 @@ static bool p9_sbe_occ_save_ffdc(struct p9_sbe_occ *ctx, const void *resp,
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



