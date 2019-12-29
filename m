Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FAD412C846
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:16:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732384AbfL2RxC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:53:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:39596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731949AbfL2Rw7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:52:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3895721744;
        Sun, 29 Dec 2019 17:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641978;
        bh=RSGSsyf03Dbu8lsGLZLR8k+YhIx5Q8bXJFSPqjS7qoA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZjvkqlKynrzjLRpb9qZV3NK2mNTFo2784xTyBbK25bokWFHYl6MFbb4c4+AsYC4A2
         bI9FIXPv2/EKg7VKU9rpvf4VE3PGzip9uftrDq1lR8mki/BH6TiIxEXT2J3tAXd2fs
         SEhVEvWgeh48THANarKdp/Pxe2aKd4WZIxui/gIg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 292/434] net: dsa: sja1105: Disallow management xmit during switch reset
Date:   Sun, 29 Dec 2019 18:25:45 +0100
Message-Id: <20191229172721.344705552@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>

[ Upstream commit af580ae2dcb250719857b4b7024bd4bb0c2e05fb ]

The purpose here is to avoid ptp4l fail due to this condition:

  timed out while polling for tx timestamp
  increasing tx_timestamp_timeout may correct this issue, but it is likely caused by a driver bug
  port 1: send peer delay request failed

So either reset the switch before the management frame was sent, or
after it was timestamped as well, but not in the middle.

The condition may arise either due to a true timeout (i.e. because
re-uploading the static config takes time), or due to the TX timestamp
actually getting lost due to reset. For the former we can increase
tx_timestamp_timeout in userspace, for the latter we need this patch.

Locking all traffic during switch reset does not make sense at all,
though. Forcing all CPU-originated traffic to potentially block waiting
for a sleepable context to send > 800 bytes over SPI is not a good idea.
Flows that are autonomously forwarded by the switch will get dropped
anyway during switch reset no matter what. So just let all other
CPU-originated traffic be dropped as well.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index aa140662c7c2..4e5a428ab1a4 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1389,6 +1389,8 @@ int sja1105_static_config_reload(struct sja1105_private *priv)
 	int speed_mbps[SJA1105_NUM_PORTS];
 	int rc, i;
 
+	mutex_lock(&priv->mgmt_lock);
+
 	mac = priv->static_config.tables[BLK_IDX_MAC_CONFIG].entries;
 
 	/* Back up the dynamic link speed changed by sja1105_adjust_port_config
@@ -1420,6 +1422,8 @@ int sja1105_static_config_reload(struct sja1105_private *priv)
 			goto out;
 	}
 out:
+	mutex_unlock(&priv->mgmt_lock);
+
 	return rc;
 }
 
-- 
2.20.1



