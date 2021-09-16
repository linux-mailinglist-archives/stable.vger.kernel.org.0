Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0355640E334
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242888AbhIPQqH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:46:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:59260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243580AbhIPQoF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:44:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3CAC60F6C;
        Thu, 16 Sep 2021 16:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809526;
        bh=CCqSZBrjoqhbOd+VZEKVATTkTGbF+yGwyIWlC/YNMf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P6KP+WhIwcxMfyLCp+dIwd5v0AQoT/xXIwQzgicFj9lpfcAkODopY8kvX/COnicct
         zkdOZRxnP+QrNTRe3oN0699BBCovQdmPz6/pQafBNmfva77naDzWDeF6gJN1k0rgY2
         Ask86u6H/QateCjiYd3sNmoMZn1IWYyRbNUuPHaM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 187/380] nfp: fix return statement in nfp_net_parse_meta()
Date:   Thu, 16 Sep 2021 17:59:04 +0200
Message-Id: <20210916155810.437423230@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Söderlund <niklas.soderlund@corigine.com>

[ Upstream commit 4431531c482a2c05126caaa9fcc5053a4a5c495b ]

The return type of the function is bool and while NULL do evaluate to
false it's not very nice, fix this by explicitly returning false. There
is no functional change.

Signed-off-by: Niklas Söderlund <niklas.soderlund@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index eeb30680b4dc..0a0a26376bea 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1697,7 +1697,7 @@ nfp_net_parse_meta(struct net_device *netdev, struct nfp_meta_parsed *meta,
 		case NFP_NET_META_RESYNC_INFO:
 			if (nfp_net_tls_rx_resync_req(netdev, data, pkt,
 						      pkt_len))
-				return NULL;
+				return false;
 			data += sizeof(struct nfp_net_tls_resync_req);
 			break;
 		default:
-- 
2.30.2



