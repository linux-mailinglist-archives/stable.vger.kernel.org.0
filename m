Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 773836A70F7
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 17:30:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbjCAQaD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 11:30:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbjCAQ3w (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 11:29:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36BBBFF05;
        Wed,  1 Mar 2023 08:29:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA1F861447;
        Wed,  1 Mar 2023 16:29:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96E5AC4339E;
        Wed,  1 Mar 2023 16:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677688186;
        bh=YKefre9Jvc6Lxl3JY7rnaim0zfA+qJGhlhH0R3hZHcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BlRexvhIbkwaXzYzkvNfZdEIF1NVLPWtzVWcpXJM3Zoit081TA06JagP23G+Z+A8g
         qb5c52naxiSjiE6YDil1myvavAcHfQE4W8jo8jyb51Ru5yE+4o6F5Zx/OtrZFKvjCU
         yuPE5PmoPVYuQrn8OtwrM32gVmdDa2A3rHCDLyzDMdwuCMRCJ2iBxNDwDmoeZqCju4
         aJtwZ9rdD1GZlZEyUah7U0qEKek2uT5mo+C4cFmjCE4PDMwX8lGlWLFfZIm0iBQCxg
         CmtZ26ZQic0HJYdMyFE3b+b/17S2HRUxyVTvwIgGSmjoM+GrPg0Jmilf4XrwTzL+f+
         oG09f9X3LxR4g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Souradeep Chowdhury <quic_schowdhu@quicinc.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-trace-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 5/6] bootconfig: Increase max nodes of bootconfig from 1024 to 8192 for DCC support
Date:   Wed,  1 Mar 2023 11:29:37 -0500
Message-Id: <20230301162938.1302886-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301162938.1302886-1-sashal@kernel.org>
References: <20230301162938.1302886-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Souradeep Chowdhury <quic_schowdhu@quicinc.com>

[ Upstream commit 6c40624930c58529185a257380442547580ed837 ]

The Data Capture and Compare(DCC) is a debugging tool that uses the bootconfig
for configuring the register values during boot-time. Increase the max nodes
supported by bootconfig to cater to the requirements of the Data Capture and
Compare Driver.

Link: https://lore.kernel.org/all/1674536682-18404-1-git-send-email-quic_schowdhu@quicinc.com/

Signed-off-by: Souradeep Chowdhury <quic_schowdhu@quicinc.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bootconfig.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/bootconfig.h b/include/linux/bootconfig.h
index 1611f9db878e7..ca73940e26df8 100644
--- a/include/linux/bootconfig.h
+++ b/include/linux/bootconfig.h
@@ -59,7 +59,7 @@ struct xbc_node {
 /* Maximum size of boot config is 32KB - 1 */
 #define XBC_DATA_MAX	(XBC_VALUE - 1)
 
-#define XBC_NODE_MAX	1024
+#define XBC_NODE_MAX	8192
 #define XBC_KEYLEN_MAX	256
 #define XBC_DEPTH_MAX	16
 
-- 
2.39.2

