Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19F786B4115
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbjCJNt1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:49:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbjCJNtZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:49:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45570856B0
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:49:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5BBDB822B1
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:49:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51EACC433EF;
        Fri, 10 Mar 2023 13:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456158;
        bh=XV1gQK8iGN1GT9c2+Sx0SjtmLszZjWWL3OHBrUQZj7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wg5M9U0fRtUjbW+bGJCjc3l4C1pXLtkIU8hyQr/FnCUvJ340jxTsyFzlKuo2DOHeJ
         AdWqLYRhHY3ZwilfpTPeO3BC2SMTqKFJPCWNPczH44KV/AgBVo2c1hMqaKoXFUMRU4
         pshgeKeQMzur/qT9rx+wFSghDh/sjpA3C6eMiQhQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nathan Lynch <nathanl@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 070/193] powerpc/pseries/lparcfg: add missing RTAS retry status handling
Date:   Fri, 10 Mar 2023 14:37:32 +0100
Message-Id: <20230310133713.369608715@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
References: <20230310133710.926811681@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Lynch <nathanl@linux.ibm.com>

[ Upstream commit 5d08633e5f6564b60f1cbe09af3af40a74d66431 ]

The ibm,get-system-parameter RTAS function may return -2 or 990x,
which indicate that the caller should try again.

lparcfg's parse_system_parameter_string() ignores this, making it
possible to intermittently report incorrect SPLPAR characteristics.

Move the RTAS call into a coventional rtas_busy_delay()-based loop.

Signed-off-by: Nathan Lynch <nathanl@linux.ibm.com>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20230125-b4-powerpc-rtas-queue-v3-4-26929c8cce78@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/lparcfg.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/lparcfg.c b/arch/powerpc/platforms/pseries/lparcfg.c
index 779fc2a1c8f77..f40dabf7d163f 100644
--- a/arch/powerpc/platforms/pseries/lparcfg.c
+++ b/arch/powerpc/platforms/pseries/lparcfg.c
@@ -289,6 +289,7 @@ static void parse_mpp_x_data(struct seq_file *m)
  */
 static void parse_system_parameter_string(struct seq_file *m)
 {
+	const s32 token = rtas_token("ibm,get-system-parameter");
 	int call_status;
 
 	unsigned char *local_buffer = kmalloc(SPLPAR_MAXLENGTH, GFP_KERNEL);
@@ -298,16 +299,15 @@ static void parse_system_parameter_string(struct seq_file *m)
 		return;
 	}
 
-	spin_lock(&rtas_data_buf_lock);
-	memset(rtas_data_buf, 0, SPLPAR_MAXLENGTH);
-	call_status = rtas_call(rtas_token("ibm,get-system-parameter"), 3, 1,
-				NULL,
-				SPLPAR_CHARACTERISTICS_TOKEN,
-				__pa(rtas_data_buf),
-				RTAS_DATA_BUF_SIZE);
-	memcpy(local_buffer, rtas_data_buf, SPLPAR_MAXLENGTH);
-	local_buffer[SPLPAR_MAXLENGTH - 1] = '\0';
-	spin_unlock(&rtas_data_buf_lock);
+	do {
+		spin_lock(&rtas_data_buf_lock);
+		memset(rtas_data_buf, 0, SPLPAR_MAXLENGTH);
+		call_status = rtas_call(token, 3, 1, NULL, SPLPAR_CHARACTERISTICS_TOKEN,
+					__pa(rtas_data_buf), RTAS_DATA_BUF_SIZE);
+		memcpy(local_buffer, rtas_data_buf, SPLPAR_MAXLENGTH);
+		local_buffer[SPLPAR_MAXLENGTH - 1] = '\0';
+		spin_unlock(&rtas_data_buf_lock);
+	} while (rtas_busy_delay(call_status));
 
 	if (call_status != 0) {
 		printk(KERN_INFO
-- 
2.39.2



