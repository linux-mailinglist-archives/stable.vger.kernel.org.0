Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89FCE6A7119
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 17:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbjCAQbX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 11:31:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbjCAQaz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 11:30:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E05E48E29;
        Wed,  1 Mar 2023 08:30:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D50D361419;
        Wed,  1 Mar 2023 16:30:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6590C4339B;
        Wed,  1 Mar 2023 16:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677688206;
        bh=IOpSy9e0pg/S/x7wRcGSFA+IZpQ3MyoJMN0TNT1S0+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nXf8jEFJFJvYffVGIcrX2vU4ddlqFwHoC2Prg51cnP9Dp3xw/jrL4HPgqHAm7ZoJ8
         TOwRgRUdVyH6RZ/+pdO49VMRG7Crd7wTou609oGxs6B0jjzeY47C2n0GXbZ2olcW3B
         ck+oHSNPE2BzOgMxE8ydIdENAaXIoXDXcoj+1SZ51CK7VymObDRIMEf9716dMLYyEQ
         AI4MlR+IkGKh0sa/XQMrPqOIBuK+dMBLhxDND/ZURTKOdo59NS2Og53V5eiy5KvodW
         JdlGjk4Oe5qS0WifTYHSa2jkcsS/qyLd5CpIGa7svrYZjLFuFYgHpaydIjAiCXWFd6
         0mj2eNmagJAkg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Souradeep Chowdhury <quic_schowdhu@quicinc.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-trace-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 4/5] bootconfig: Increase max nodes of bootconfig from 1024 to 8192 for DCC support
Date:   Wed,  1 Mar 2023 11:29:56 -0500
Message-Id: <20230301162957.1303086-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301162957.1303086-1-sashal@kernel.org>
References: <20230301162957.1303086-1-sashal@kernel.org>
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
index 2696eb0fc1497..df9cbf02d0303 100644
--- a/include/linux/bootconfig.h
+++ b/include/linux/bootconfig.h
@@ -29,7 +29,7 @@ struct xbc_node {
 /* Maximum size of boot config is 32KB - 1 */
 #define XBC_DATA_MAX	(XBC_VALUE - 1)
 
-#define XBC_NODE_MAX	1024
+#define XBC_NODE_MAX	8192
 #define XBC_KEYLEN_MAX	256
 #define XBC_DEPTH_MAX	16
 
-- 
2.39.2

