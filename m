Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8729F60ACAC
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 16:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbiJXOLP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 10:11:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237168AbiJXOKT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 10:10:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4AF3C8234;
        Mon, 24 Oct 2022 05:52:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D34EB8125C;
        Mon, 24 Oct 2022 12:31:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B305EC433D6;
        Mon, 24 Oct 2022 12:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614707;
        bh=Af8giS2+ZfpdZxS5MHM8Plt2o38OtS7fPeNrZbHoCb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z+spuVQCWbSyFqKhLvWyHTvaQHzSG+Vp+lGcdRfYujMIuig+IfEWCDlcvlN6qF5LK
         MiPilTmgtZycf7R/4DhIcQPcNNhWgEIfxli0i5JlgU8K/tHxVeZHsWyvB0VsLsHmjE
         s0/SC48i+itijmqAD+I/3CQwfAZgXbBZiSGUwUU8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 364/390] soundwire: cadence: Dont overwrite msg->buf during write commands
Date:   Mon, 24 Oct 2022 13:32:41 +0200
Message-Id: <20221024113038.497535574@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
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



