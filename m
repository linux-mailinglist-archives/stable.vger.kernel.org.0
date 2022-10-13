Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 180675FD19C
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbiJMAkm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:40:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232308AbiJMAj1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:39:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE6EEE082;
        Wed, 12 Oct 2022 17:32:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21734B81CE5;
        Thu, 13 Oct 2022 00:22:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16484C433D6;
        Thu, 13 Oct 2022 00:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620543;
        bh=wLeGD5lVu1lsgq/jvNvxiLz5HP1zA+sY5Dwb1dXSLoo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o62Y4EMA8rwgcZ2WkyPSsIgtMLYAayoaPYw+HXQMyyL8G8IGtth8UrfxUSHTjnl9M
         VNZGW8zr1GcUoo3O0RVzFUlxPlwSfHMa6B0WWLBY+xSwn8c0BDEQljDKdrM+plJgx4
         PBcPp3gxLDs9OH2HY5JPJHezDtCTIFFGhHzsmnxJArRV0j5mmo6sqQ69XTDV6evnBr
         z9Q3jXjw6r9k2+LkubvFYisnl1sGYR+1+wQOHb/rwGRdccLUSDBoMJ93v71YQuAIBg
         cDVOQtfGo6y9i4ZxG3zwjGUQH/2HnOI2ADbGyFFI9UmG5AHsA9ODjwhRNwbEv8cEZz
         dG6Nzo5i0ChmQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Richard Fitzgerald <rf@opensource.cirrus.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        yung-chuan.liao@linux.intel.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.15 21/47] soundwire: cadence: Don't overwrite msg->buf during write commands
Date:   Wed, 12 Oct 2022 20:20:56 -0400
Message-Id: <20221013002124.1894077-21-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013002124.1894077-1-sashal@kernel.org>
References: <20221013002124.1894077-1-sashal@kernel.org>
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
index 4fcc3ba93004..18d2f9b3e201 100644
--- a/drivers/soundwire/cadence_master.c
+++ b/drivers/soundwire/cadence_master.c
@@ -545,9 +545,12 @@ cdns_fill_msg_resp(struct sdw_cdns *cdns,
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

