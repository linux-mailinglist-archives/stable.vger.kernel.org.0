Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3ECD5FD1D5
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232289AbiJMAxO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:53:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232024AbiJMAwt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:52:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01098C786F;
        Wed, 12 Oct 2022 17:49:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CC5A616FC;
        Thu, 13 Oct 2022 00:24:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21A32C433C1;
        Thu, 13 Oct 2022 00:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620655;
        bh=Af8giS2+ZfpdZxS5MHM8Plt2o38OtS7fPeNrZbHoCb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q/f68lHg47fS8OBF/c1oED9rcZir5yso1sW6zvyVN/QyE6r3brKA03aFWdx8N8BUk
         87DK+z/2gc1Q9ZLZPWoQF3AvHTw/xasy/fdfA0wxJ86ExMboBX7M8G1KLTNmTMzI0b
         FSuUvuDljJSp+vJ2rrsbanNWlK4TZ7gj2JxK8EhybA3qVLue93phK7Nax9tiXIwDR+
         NDQdVqyemmmQDFA2T9y+WFPpGAmxVCxXPcE14OVPC6VMSX2ufF4r2jNbSVfBIt0GRZ
         JSt0PQmNWOWeOZyBQQFaZEnR1baS5Dl5D8Pq3MnqHdhZS2Lz2DtLUxDBAiM8TCyO23
         gYP3uhN51u/Kg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Richard Fitzgerald <rf@opensource.cirrus.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        yung-chuan.liao@linux.intel.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 16/33] soundwire: cadence: Don't overwrite msg->buf during write commands
Date:   Wed, 12 Oct 2022 20:23:15 -0400
Message-Id: <20221013002334.1894749-16-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013002334.1894749-1-sashal@kernel.org>
References: <20221013002334.1894749-1-sashal@kernel.org>
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

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit ba05b39d265bdd16913f7684600d9d41e2796745 ]

The buf passed in struct sdw_msg must only be written for a READ,
in that case the RDATA part of the response is the data value of the
register.

For a write command there is no RDATA, and buf should be assumed to
be const and unmodifable. The original caller should not expect its data
buffer to be corrupted by an sdw_nwrite().

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20220916103505.1562210-1-rf@opensource.cirrus.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/cadence_master.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/soundwire/cadence_master.c b/drivers/soundwire/cadence_master.c
index c6d421a4b91b..a3247692ddc0 100644
--- a/drivers/soundwire/cadence_master.c
+++ b/drivers/soundwire/cadence_master.c
@@ -501,9 +501,12 @@ cdns_fill_msg_resp(struct sdw_cdns *cdns,
 		return SDW_CMD_IGNORED;
 	}
 
-	/* fill response */
-	for (i = 0; i < count; i++)
-		msg->buf[i + offset] = FIELD_GET(CDNS_MCP_RESP_RDATA, cdns->response_buf[i]);
+	if (msg->flags == SDW_MSG_FLAG_READ) {
+		/* fill response */
+		for (i = 0; i < count; i++)
+			msg->buf[i + offset] = FIELD_GET(CDNS_MCP_RESP_RDATA,
+							 cdns->response_buf[i]);
+	}
 
 	return SDW_CMD_OK;
 }
-- 
2.35.1

