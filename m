Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5995B3C4AAF
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240081AbhGLGxV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:53:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:51274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240641AbhGLGv7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:51:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D34F60FE3;
        Mon, 12 Jul 2021 06:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072551;
        bh=Ad2ectahd90H5iqxjE8PMFaHNMTUCCZS86ts+IwNhHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B5bzymh0S6O5Qs+jWhorSqWK0T9euRoJK2kM1/9ibduJAePA8bnHOzgC8mJd6KtCa
         XQQFlVNAjDtceQKVmn9Wzk6iz1kHa9oyBre2BxwwvEoZr6QuhCruCVLEmlAifFONuX
         N6WVpRr3hjhdNoomqQf8zShULyOcnZXcN9MT1LA0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 536/593] soundwire: stream: Fix test for DP prepare complete
Date:   Mon, 12 Jul 2021 08:11:36 +0200
Message-Id: <20210712060952.679702086@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 3d3e88e336338834086278236d42039f3cde50e1 ]

In sdw_prep_deprep_slave_ports(), after the wait_for_completion()
the DP prepare status register is read. If this indicates that the
port is now prepared, the code should continue with the port setup.
It is irrelevant whether the wait_for_completion() timed out if the
port is now ready.

The previous implementation would always fail if the
wait_for_completion() timed out, even if the port was reporting
successful prepare.

This patch also fixes a minor bug where the return from sdw_read()
was not checked for error - any error code with LSBits clear could
be misinterpreted as a successful port prepare.

Fixes: 79df15b7d37c ("soundwire: Add helpers for ports operations")
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20210618144745.30629-1-rf@opensource.cirrus.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/stream.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/soundwire/stream.c b/drivers/soundwire/stream.c
index a418c3c7001c..304ff2ee7d75 100644
--- a/drivers/soundwire/stream.c
+++ b/drivers/soundwire/stream.c
@@ -422,7 +422,6 @@ static int sdw_prep_deprep_slave_ports(struct sdw_bus *bus,
 	struct completion *port_ready;
 	struct sdw_dpn_prop *dpn_prop;
 	struct sdw_prepare_ch prep_ch;
-	unsigned int time_left;
 	bool intr = false;
 	int ret = 0, val;
 	u32 addr;
@@ -479,15 +478,15 @@ static int sdw_prep_deprep_slave_ports(struct sdw_bus *bus,
 
 		/* Wait for completion on port ready */
 		port_ready = &s_rt->slave->port_ready[prep_ch.num];
-		time_left = wait_for_completion_timeout(port_ready,
-				msecs_to_jiffies(dpn_prop->ch_prep_timeout));
+		wait_for_completion_timeout(port_ready,
+			msecs_to_jiffies(dpn_prop->ch_prep_timeout));
 
 		val = sdw_read(s_rt->slave, SDW_DPN_PREPARESTATUS(p_rt->num));
-		val &= p_rt->ch_mask;
-		if (!time_left || val) {
+		if ((val < 0) || (val & p_rt->ch_mask)) {
+			ret = (val < 0) ? val : -ETIMEDOUT;
 			dev_err(&s_rt->slave->dev,
-				"Chn prep failed for port:%d\n", prep_ch.num);
-			return -ETIMEDOUT;
+				"Chn prep failed for port %d: %d\n", prep_ch.num, ret);
+			return ret;
 		}
 	}
 
-- 
2.30.2



