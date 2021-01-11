Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01DD42F15D4
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731257AbhAKNKp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:10:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:57856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729045AbhAKNKp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:10:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BEECE21973;
        Mon, 11 Jan 2021 13:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370604;
        bh=GBnuyhv+xTOA/Q3+Ul00Wf4GB1SWcWwNZ5P9pjPKjQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=00T9dFR7YR20l+EkAShFROuMnMxADWWxwKFVGPQvLnO+Mo2fmVtIvTOg5OYuFDk/q
         EWUzLjTmE0hESX6I4qaqMHDR1ZcUe+H7BE5hreC2KybdzG/HGc7K8YSaEmen9yaqi7
         sOAN6A3FdIKjNhwlN3ZQFwUZsG9GIN99kfM+GdFM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marcin Wojtas <mw@semihalf.com>,
        Stefan Chulski <stefanc@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 18/92] net: mvpp2: Fix GoP port 3 Networking Complex Control configurations
Date:   Mon, 11 Jan 2021 14:01:22 +0100
Message-Id: <20210111130040.037429097@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130039.165470698@linuxfoundation.org>
References: <20210111130039.165470698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

[ Upstream commit 2575bc1aa9d52a62342b57a0b7d0a12146cf6aed ]

During GoP port 2 Networking Complex Control mode of operation configurations,
also GoP port 3 mode of operation was wrongly set.
Patch removes these configurations.

Fixes: f84bf386f395 ("net: mvpp2: initialize the GoP")
Acked-by: Marcin Wojtas <mw@semihalf.com>
Signed-off-by: Stefan Chulski <stefanc@marvell.com>
Link: https://lore.kernel.org/r/1608462149-1702-1-git-send-email-stefanc@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -1129,7 +1129,7 @@ static void mvpp22_gop_init_rgmii(struct
 
 	regmap_read(priv->sysctrl_base, GENCONF_CTRL0, &val);
 	if (port->gop_id == 2)
-		val |= GENCONF_CTRL0_PORT0_RGMII | GENCONF_CTRL0_PORT1_RGMII;
+		val |= GENCONF_CTRL0_PORT0_RGMII;
 	else if (port->gop_id == 3)
 		val |= GENCONF_CTRL0_PORT1_RGMII_MII;
 	regmap_write(priv->sysctrl_base, GENCONF_CTRL0, val);


