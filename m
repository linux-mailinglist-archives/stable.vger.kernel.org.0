Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6B542E6425
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:48:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404340AbgL1Nm5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:42:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:40536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403953AbgL1Nki (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:40:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F8FD2072C;
        Mon, 28 Dec 2020 13:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162822;
        bh=2+oDNdF3k9fwoU/ipwxkY7oRcQWc2iXuah6OTolMeLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yywaIVKcAbzC6bgUEQUJDBxUKACkUW3pBInh4bYcI7KlXtZzXXJEDC+2mD8MO9F5k
         XvzMP+4RKCQ9VP1m53sfWpbMo70NaEhPsC2tupm6+evjU2h20HuVZm+qbfwpP7ZqE5
         Ev/cL7AQ/3DzublJkzNDYYlqxiI837562Koltw5w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Eckelmann <sven@narfation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 043/453] vxlan: Copy needed_tailroom from lowerdev
Date:   Mon, 28 Dec 2020 13:44:39 +0100
Message-Id: <20201228124939.323398400@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

[ Upstream commit a5e74021e84bb5eadf760aaf2c583304f02269be ]

While vxlan doesn't need any extra tailroom, the lowerdev might need it. In
that case, copy it over to reduce the chance for additional (re)allocations
in the transmit path.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Link: https://lore.kernel.org/r/20201126125247.1047977-2-sven@narfation.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 3753cf0942865..5502e145aa17b 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -3540,6 +3540,8 @@ static void vxlan_config_apply(struct net_device *dev,
 		needed_headroom = lowerdev->hard_header_len;
 		needed_headroom += lowerdev->needed_headroom;
 
+		dev->needed_tailroom = lowerdev->needed_tailroom;
+
 		max_mtu = lowerdev->mtu - (use_ipv6 ? VXLAN6_HEADROOM :
 					   VXLAN_HEADROOM);
 		if (max_mtu < ETH_MIN_MTU)
-- 
2.27.0



