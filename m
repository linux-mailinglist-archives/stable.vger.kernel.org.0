Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27CF76AEFE9
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:28:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232913AbjCGS1j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:27:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232820AbjCGS0E (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:26:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED66AA92FB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:20:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 874F1B818EB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:20:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9322C4339B;
        Tue,  7 Mar 2023 18:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213232;
        bh=zwCp/TzFBxOCChyKuqfzhPCVZOcORZurrqr9VlFjAqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MJdJbKq+V8+Qd3i9FJsHdEC5dxMfzsLQEPW2OBZUtNG2j9hEq1i71mgl4vg5DGpAT
         uqw0Rfb5qdwl7Wy6HFSQ7xP2QqxxOaLmSN+huymsyxSIGDdY/KtwlLfh1xuDwgW9Zo
         U4snfq1SwlhBiu+P3AZPth3W5KQ3UuJmptviCzeA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 411/885] soundwire: cadence: Dont overflow the command FIFOs
Date:   Tue,  7 Mar 2023 17:55:45 +0100
Message-Id: <20230307170020.286460296@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 7cbfee2e2e40d2be54196362a845a3ea0a3f877d ]

The command FIFOs in the Cadence IP can be configured during design
up to 32 entries, and the code in cadence_master.c was assuming the
full 32-entry FIFO. But all current Intel implementations use an 8-entry
FIFO.

Up to now the longest message used was 6 entries so this wasn't
causing any problem. But future Cirrus Logic codecs have downloadable
firmware or tuning blobs. It is more efficient for the codec driver to
issue long transfers that can take advantage of any queuing in the
Soundwire controller and avoid the overhead of repeatedly writing the
page registers.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Fixes: 2f52a5177caa ("soundwire: cdns: Add cadence library")
Link: https://lore.kernel.org/r/20221202161812.4186897-2-rf@opensource.cirrus.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/cadence_master.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/soundwire/cadence_master.c b/drivers/soundwire/cadence_master.c
index 93929f19d0831..b65cdf2a7593e 100644
--- a/drivers/soundwire/cadence_master.c
+++ b/drivers/soundwire/cadence_master.c
@@ -127,7 +127,8 @@ MODULE_PARM_DESC(cdns_mcp_int_mask, "Cadence MCP IntMask");
 
 #define CDNS_MCP_CMD_BASE			0x80
 #define CDNS_MCP_RESP_BASE			0x80
-#define CDNS_MCP_CMD_LEN			0x20
+/* FIFO can hold 8 commands */
+#define CDNS_MCP_CMD_LEN			8
 #define CDNS_MCP_CMD_WORD_LEN			0x4
 
 #define CDNS_MCP_CMD_SSP_TAG			BIT(31)
-- 
2.39.2



