Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 230122E9A07
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727661AbhADQGz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:06:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:39992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728887AbhADQCl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:02:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 304E520769;
        Mon,  4 Jan 2021 16:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609776120;
        bh=Urmp3LZyNEiDAWxKitlay1pbxR6eTJ1/CA6J9KRDnMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R1yTaxf7dJeqJEJgCZrIkhadohgMWNjMsika6RbWt7tM+U+wTt4y9bmL5jsasBmRJ
         QEGZyElsHM9VAfwxAjvPvsq1G7E2JFB7fUsnGC6ADqR8XgBR3NZumTlahlao7DKMlV
         iATZwYmiYcT9+vnsZgZtsIQQbKC4J9COfdoQ8vwY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, LiLiang <liali@redhat.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 03/63] ethtool: fix error paths in ethnl_set_channels()
Date:   Mon,  4 Jan 2021 16:56:56 +0100
Message-Id: <20210104155708.972099071@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155708.800470590@linuxfoundation.org>
References: <20210104155708.800470590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ivan Vecera <ivecera@redhat.com>

[ Upstream commit ef72cd3c5ce168829c6684ecb2cae047d3493690 ]

Fix two error paths in ethnl_set_channels() to avoid lock-up caused
but unreleased RTNL.

Fixes: e19c591eafad ("ethtool: set device channel counts with CHANNELS_SET request")
Reported-by: LiLiang <liali@redhat.com>
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Michal Kubecek <mkubecek@suse.cz>
Link: https://lore.kernel.org/r/20201215090810.801777-1-ivecera@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ethtool/channels.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/ethtool/channels.c
+++ b/net/ethtool/channels.c
@@ -194,8 +194,9 @@ int ethnl_set_channels(struct sk_buff *s
 	if (netif_is_rxfh_configured(dev) &&
 	    !ethtool_get_max_rxfh_channel(dev, &max_rx_in_use) &&
 	    (channels.combined_count + channels.rx_count) <= max_rx_in_use) {
+		ret = -EINVAL;
 		GENL_SET_ERR_MSG(info, "requested channel counts are too low for existing indirection table settings");
-		return -EINVAL;
+		goto out_ops;
 	}
 
 	/* Disabling channels, query zero-copy AF_XDP sockets */
@@ -203,8 +204,9 @@ int ethnl_set_channels(struct sk_buff *s
 		       min(channels.rx_count, channels.tx_count);
 	for (i = from_channel; i < old_total; i++)
 		if (xsk_get_pool_from_qid(dev, i)) {
+			ret = -EINVAL;
 			GENL_SET_ERR_MSG(info, "requested channel counts are too low for existing zerocopy AF_XDP sockets");
-			return -EINVAL;
+			goto out_ops;
 		}
 
 	ret = dev->ethtool_ops->set_channels(dev, &channels);


