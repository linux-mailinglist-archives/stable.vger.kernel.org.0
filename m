Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6D034C897
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232838AbhC2IX3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:23:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:38976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233585AbhC2IVt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:21:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE79E61601;
        Mon, 29 Mar 2021 08:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006109;
        bh=b/0ocKoDF281bXAWTvrZcmWZ7NkTfq1eRBYzHXFz/jI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o+pbg947YR18j+Qzb+G2CpA3PRtbtDX1AJJRTAq4zsfRMNstvIHVUFSdvzh45St7R
         x4vI8fsB1O8PXvM6HeVZdLsy+j3qMKnqTLZfsAwJ8Q8FLIKtIHDKwU1GUPYDxqXZRD
         yeTmyRbHKNLres8XwoQA/mWGS1KGKY2M/iktCktc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ong Boon Leong <boon.leong.ong@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 121/221] net: phylink: Fix phylink_err() function name error in phylink_major_config
Date:   Mon, 29 Mar 2021 09:57:32 +0200
Message-Id: <20210329075633.250778580@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ong Boon Leong <boon.leong.ong@intel.com>

[ Upstream commit d82c6c1aaccd2877b6082cebcb1746a13648a16d ]

if pl->mac_ops->mac_finish() failed, phylink_err should use
"mac_finish" instead of "mac_prepare".

Fixes: b7ad14c2fe2d4 ("net: phylink: re-implement interface configuration with PCS")
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phylink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index fe2296fdda19..6072e87ed6c3 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -472,7 +472,7 @@ static void phylink_major_config(struct phylink *pl, bool restart,
 		err = pl->mac_ops->mac_finish(pl->config, pl->cur_link_an_mode,
 					      state->interface);
 		if (err < 0)
-			phylink_err(pl, "mac_prepare failed: %pe\n",
+			phylink_err(pl, "mac_finish failed: %pe\n",
 				    ERR_PTR(err));
 	}
 }
-- 
2.30.1



