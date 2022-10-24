Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 333B860B98E
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 22:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233103AbiJXUO0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 16:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234021AbiJXUNx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 16:13:53 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CFBE550AB;
        Mon, 24 Oct 2022 11:32:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A1DC0CE16D8;
        Mon, 24 Oct 2022 12:54:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDECCC433B5;
        Mon, 24 Oct 2022 12:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666616078;
        bh=wLeGD5lVu1lsgq/jvNvxiLz5HP1zA+sY5Dwb1dXSLoo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MgfN6R8pOuxWWDoLePqYXWVS0UM8FZfChbcsad7/d+q+83KnRFVTi55e+FYTgTbvg
         Wt4wf44hikqrcq9e1dq0+NHqTKiRgK1rObLry1kvNcyydPBCAE9Tj9VQM6FUeF3p1B
         Tb42H9y2HuRdl/mMiFXRpnU4WuxybTEeEY4Av4lw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 491/530] soundwire: cadence: Dont overwrite msg->buf during write commands
Date:   Mon, 24 Oct 2022 13:33:55 +0200
Message-Id: <20221024113107.280535494@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



