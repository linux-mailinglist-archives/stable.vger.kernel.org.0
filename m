Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE7D36440B
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242090AbhDSNZT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:25:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241572AbhDSNWx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:22:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1D0561406;
        Mon, 19 Apr 2021 13:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838291;
        bh=pgZ4aU/RyMSL0vPVZs1aMPL8OWO/M/xhCwtE0D5ydmg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B/zxwuxgcbAciioyNlv56Kjp156fCpht/eVIezLsNQY7HOLnzzdZoy26si6us0+jA
         +8SDIF/pbq0U/jXtacUVUyJeCL2J3pxMmvSn2M1h/0EZB0YWrwkAoeD22XqObszlWU
         cghJdZ3Zbf78ZcTzgwjqKtpKiIGqfOVMiu6s/o1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 075/103] ethtool: pause: make sure we init driver stats
Date:   Mon, 19 Apr 2021 15:06:26 +0200
Message-Id: <20210419130530.386347411@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130527.791982064@linuxfoundation.org>
References: <20210419130527.791982064@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

commit 16756d3e77ad58cd07e36cbed724aa13ae5a0278 upstream.

The intention was for pause statistics to not be reported
when driver does not have the relevant callback (only
report an empty netlink nest). What happens currently
we report all 0s instead. Make sure statistics are
initialized to "not set" (which is -1) so the dumping
code skips them.

Fixes: 9a27a33027f2 ("ethtool: add standard pause stats")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ethtool/pause.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/ethtool/pause.c
+++ b/net/ethtool/pause.c
@@ -38,16 +38,16 @@ static int pause_prepare_data(const stru
 	if (!dev->ethtool_ops->get_pauseparam)
 		return -EOPNOTSUPP;
 
+	ethtool_stats_init((u64 *)&data->pausestat,
+			   sizeof(data->pausestat) / 8);
+
 	ret = ethnl_ops_begin(dev);
 	if (ret < 0)
 		return ret;
 	dev->ethtool_ops->get_pauseparam(dev, &data->pauseparam);
 	if (req_base->flags & ETHTOOL_FLAG_STATS &&
-	    dev->ethtool_ops->get_pause_stats) {
-		ethtool_stats_init((u64 *)&data->pausestat,
-				   sizeof(data->pausestat) / 8);
+	    dev->ethtool_ops->get_pause_stats)
 		dev->ethtool_ops->get_pause_stats(dev, &data->pausestat);
-	}
 	ethnl_ops_complete(dev);
 
 	return 0;


