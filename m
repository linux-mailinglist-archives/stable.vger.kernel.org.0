Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9384C3C4F23
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240959AbhGLHXU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:23:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:59320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240184AbhGLHVQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:21:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC920613EE;
        Mon, 12 Jul 2021 07:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074308;
        bh=syAVqQuSoIiuS7JHQ+4SXvTlNSBhSa1x9TSIYG6imP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q20x5iuey4kBQJKt7PZEDsIvgsb6xPbQ0pqdl4gX0qmtKPrH0HC9sVcwh4Twq+Zn6
         K2xk6aLRXPqneOCM3RI1w4toQIakK6xuroPOKPizQm6IDqR23XrVzFjCOB6E5JaeYE
         EwpO51I5Ae8n09kLhcl8P8ghOiZ2dt8i7FqME4pw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 493/700] net: dsa: sja1105: fix NULL pointer dereference in sja1105_reload_cbs()
Date:   Mon, 12 Jul 2021 08:09:36 +0200
Message-Id: <20210712061028.979830367@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit be7f62eebaff2f86c1467a2d33930a0a7a87675b ]

priv->cbs is an array of priv->info->num_cbs_shapers elements of type
struct sja1105_cbs_entry which only get allocated if CONFIG_NET_SCH_CBS
is enabled.

However, sja1105_reload_cbs() is called from sja1105_static_config_reload()
which in turn is called for any of the items in sja1105_reset_reasons,
therefore during the normal runtime of the driver and not just from a
code path which can be triggered by the tc-cbs offload.

The sja1105_reload_cbs() function does not contain a check whether the
priv->cbs array is NULL or not, it just assumes it isn't and proceeds to
iterate through the credit-based shaper elements. This leads to a NULL
pointer dereference.

The solution is to return success if the priv->cbs array has not been
allocated, since sja1105_reload_cbs() has nothing to do.

Fixes: 4d7525085a9b ("net: dsa: sja1105: offload the Credit-Based Shaper qdisc")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 926544440f02..42a0fb588f64 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1798,6 +1798,12 @@ static int sja1105_reload_cbs(struct sja1105_private *priv)
 {
 	int rc = 0, i;
 
+	/* The credit based shapers are only allocated if
+	 * CONFIG_NET_SCH_CBS is enabled.
+	 */
+	if (!priv->cbs)
+		return 0;
+
 	for (i = 0; i < priv->info->num_cbs_shapers; i++) {
 		struct sja1105_cbs_entry *cbs = &priv->cbs[i];
 
-- 
2.30.2



