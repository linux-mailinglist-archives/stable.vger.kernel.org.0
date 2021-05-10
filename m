Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAD75378801
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238877AbhEJLUQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:20:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:46276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236432AbhEJLIH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:08:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 817FB6198A;
        Mon, 10 May 2021 11:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644474;
        bh=ym8ZuTlEVSzNQGwyZowbIdkgJPMGjPeZSA/e3tQ8mwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nziitf/3/sKWHjV3PIaAKZgvY6FQEaJGQcYqa7Il5X1Yk9+ICdOf8YN7wJw7s/7JE
         D8ZDwgJ7caPHM7QAdgvyA7WcTPkO88lT4RmqXgplwAI+mv/jlzXdZgBdSJ/l7F+h8E
         wfNi3HVaq7ZnPTw2MHbfMhZuuxmyJNXHagt62pQs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 097/384] soundwire: cadence: only prepare attached devices on clock stop
Date:   Mon, 10 May 2021 12:18:06 +0200
Message-Id: <20210510102018.084599313@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 58ef9356260c291a4321e07ff507f31a1d8212af ]

We sometimes see COMMAND_IGNORED responses during the clock stop
sequence. It turns out we already have information if devices are
present on a link, so we should only prepare those when they
are attached.

In addition, even when COMMAND_IGNORED are received, we should still
proceed with the clock stop. The device will not be prepared but
that's not a problem.

The only case where the clock stop will fail is if the Cadence IP
reports an error (including a timeout), or if the devices throw a
COMMAND_FAILED response.

BugLink: https://github.com/thesofproject/linux/issues/2621
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20210323013707.21455-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/cadence_master.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/soundwire/cadence_master.c b/drivers/soundwire/cadence_master.c
index d05442e646a3..57c59a33ce61 100644
--- a/drivers/soundwire/cadence_master.c
+++ b/drivers/soundwire/cadence_master.c
@@ -1450,10 +1450,12 @@ int sdw_cdns_clock_stop(struct sdw_cdns *cdns, bool block_wake)
 	}
 
 	/* Prepare slaves for clock stop */
-	ret = sdw_bus_prep_clk_stop(&cdns->bus);
-	if (ret < 0) {
-		dev_err(cdns->dev, "prepare clock stop failed %d", ret);
-		return ret;
+	if (slave_present) {
+		ret = sdw_bus_prep_clk_stop(&cdns->bus);
+		if (ret < 0 && ret != -ENODATA) {
+			dev_err(cdns->dev, "prepare clock stop failed %d\n", ret);
+			return ret;
+		}
 	}
 
 	/*
-- 
2.30.2



