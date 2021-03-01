Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A55C329067
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:09:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242880AbhCAUIS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:08:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:60160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242044AbhCAT4q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:56:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E18DD65384;
        Mon,  1 Mar 2021 17:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621352;
        bh=4vUU0G44Su8J2vInzkX8zYCbfBVdGw8ZlkiSPVKNbHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qRRzYvM8di8Qv9pLdSx7M5R48NVzL6jsQHpbeBo2urfYOHyo/xPzrAyR5Kp0MBov7
         KN2TQ+nKQxRTjkCi2T+TDG0Ye6aYdpdzpCaki/+w3JX/w2Ktha6p0KvrYcoVtBqbXd
         a9HprNYp1OyaeU3rsMS7N73mdFEhdtzaWJzynjCs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 484/775] soundwire: cadence: fix ACK/NAK handling
Date:   Mon,  1 Mar 2021 17:10:52 +0100
Message-Id: <20210301161225.452908520@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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
index 9fa55164354a2..580660599f461 100644
--- a/drivers/soundwire/cadence_master.c
+++ b/drivers/soundwire/cadence_master.c
@@ -484,10 +484,10 @@ cdns_fill_msg_resp(struct sdw_cdns *cdns,
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



