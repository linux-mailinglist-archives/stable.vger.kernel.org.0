Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A91C31F4357
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 19:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732893AbgFIRwb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 13:52:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:42826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732896AbgFIRwa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:52:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3616520774;
        Tue,  9 Jun 2020 17:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591725149;
        bh=8YhENcGm/KsO1RO/b6JPjuxL+YBUf0Nsx3uSX/EKGHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H4JzjI7+x3+bKhnwCYLss/0ZUUsFynVUeyUw23WMwyS/CXt4JaLEV0rki/ioGQZ2W
         E4qT6GdUY+EKZyzOBpBFzf1AGFw17+FnfhU4aAesvNW+mERjQx/lXOZT/eUwuJ0+aL
         o0CsTjQ7tyhyh20ZiTfX8b0p30t7z4H3RkyC472M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heinrich Kuhn <heinrich.kuhn@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 08/34] nfp: flower: fix used time of merge flow statistics
Date:   Tue,  9 Jun 2020 19:45:04 +0200
Message-Id: <20200609174053.651825953@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200609174052.628006868@linuxfoundation.org>
References: <20200609174052.628006868@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heinrich Kuhn <heinrich.kuhn@netronome.com>

[ Upstream commit 5b186cd60f033110960a3db424ffbd6de4cee528 ]

Prior to this change the correct value for the used counter is calculated
but not stored nor, therefore, propagated to user-space. In use-cases such
as OVS use-case at least this results in active flows being removed from
the hardware datapath. Which results in both unnecessary flow tear-down
and setup, and packet processing on the host.

This patch addresses the problem by saving the calculated used value
which allows the value to propagate to user-space.

Found by inspection.

Fixes: aa6ce2ea0c93 ("nfp: flower: support stats update for merge flows")
Signed-off-by: Heinrich Kuhn <heinrich.kuhn@netronome.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/netronome/nfp/flower/offload.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1368,7 +1368,8 @@ __nfp_flower_update_merge_stats(struct n
 		ctx_id = be32_to_cpu(sub_flow->meta.host_ctx_id);
 		priv->stats[ctx_id].pkts += pkts;
 		priv->stats[ctx_id].bytes += bytes;
-		max_t(u64, priv->stats[ctx_id].used, used);
+		priv->stats[ctx_id].used = max_t(u64, used,
+						 priv->stats[ctx_id].used);
 	}
 }
 


