Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCABE3288F5
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238687AbhCARr0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:47:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:34728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238317AbhCARls (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:41:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8543650C2;
        Mon,  1 Mar 2021 16:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617808;
        bh=iYHuuJGSUMX2lGtEJq+VRuy6rsSovSdoHrBsWOUB3do=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xFuisfpQKqykyDI0xeWA5/YbtF4kRGcIxDE6gkXqMU6nJu3bZqPEvRbgkug5FVhJA
         4VsZMnHdxnaEq88DvAiJtcvq05ibgBsmim4huE6QI0+X/WHW82rrQqrTMbro9jFb77
         +tzUGQNEa2edV64Priz/kkG0snpWkiDRIZ37MiNU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 204/340] soundwire: cadence: fix ACK/NAK handling
Date:   Mon,  1 Mar 2021 17:12:28 +0100
Message-Id: <20210301161058.347317488@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit db9d9f944f95e7f3aa60ac00cbd502415152c421 ]

The existing code reports a NAK only when ACK=0
This is not aligned with the SoundWire 1.x specifications.

Table 32 in the SoundWire 1.2 specification shows that a Device shall
not set NAK=1 if ACK=1. But Table 33 shows the Combined Response
may very well be NAK=1/ACK=1, e.g. if another Device than the one
addressed reports a parity error.

NAK=1 signals a 'Command_Aborted', regardless of the ACK bit value.

Move the tests for NAK so that the NAK=1/ACK=1 combination is properly
detected according to the specification.

Fixes: 956baa1992f9a ('soundwire: cdns: Add sdw_master_ops and IO transfer support')
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20210115053738.22630-5-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/cadence_master.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/soundwire/cadence_master.c b/drivers/soundwire/cadence_master.c
index e3d06330d1258..f7d0f63921dc2 100644
--- a/drivers/soundwire/cadence_master.c
+++ b/drivers/soundwire/cadence_master.c
@@ -368,10 +368,10 @@ cdns_fill_msg_resp(struct sdw_cdns *cdns,
 		if (!(cdns->response_buf[i] & CDNS_MCP_RESP_ACK)) {
 			no_ack = 1;
 			dev_dbg_ratelimited(cdns->dev, "Msg Ack not received\n");
-			if (cdns->response_buf[i] & CDNS_MCP_RESP_NACK) {
-				nack = 1;
-				dev_err_ratelimited(cdns->dev, "Msg NACK received\n");
-			}
+		}
+		if (cdns->response_buf[i] & CDNS_MCP_RESP_NACK) {
+			nack = 1;
+			dev_err_ratelimited(cdns->dev, "Msg NACK received\n");
 		}
 	}
 
-- 
2.27.0



