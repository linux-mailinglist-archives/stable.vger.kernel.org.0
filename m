Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C38534D770
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729017AbfFTSPA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:15:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:43520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726276AbfFTSPA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:15:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 916AE2082C;
        Thu, 20 Jun 2019 18:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054499;
        bh=nUY6ILTxX+DakTlISDVeWnorLgfPe9zH17lpV8hhCvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l1jZs8HxyMb1n1ODBDsvx19cZW9GkiGiRPa4Qeb1E0boSjtNZUu26uCg6RgPsO5pM
         47Bh90FldCYYxXnfX5hmF5rF3I7jUerJgB2V8Z/CNJIFv5oarmX6vZPslr4QNJw89b
         DzGWKPn2/JRQDzrClBv3tYFde+ByrvwrX/nwTko4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuri Chipchev <yuric@marvell.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 20/98] net: mvpp2: prs: Use the correct helpers when removing all VID filters
Date:   Thu, 20 Jun 2019 19:56:47 +0200
Message-Id: <20190620174350.152141876@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174349.443386789@linuxfoundation.org>
References: <20190620174349.443386789@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Chevallier <maxime.chevallier@bootlin.com>

[ Upstream commit 6b7a3430c163455cf8a514d636bda52b04654972 ]

When removing all VID filters, the mvpp2_prs_vid_entry_remove would be
called with the TCAM id incorrectly used as a VID, causing the wrong
TCAM entries to be invalidated.

Fix this by directly invalidating entries in the VID range.

Fixes: 56beda3db602 ("net: mvpp2: Add hardware offloading for VLAN filtering")
Suggested-by: Yuri Chipchev <yuric@marvell.com>
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
@@ -2025,8 +2025,10 @@ void mvpp2_prs_vid_remove_all(struct mvp
 
 	for (tid = MVPP2_PRS_VID_PORT_FIRST(port->id);
 	     tid <= MVPP2_PRS_VID_PORT_LAST(port->id); tid++) {
-		if (priv->prs_shadow[tid].valid)
-			mvpp2_prs_vid_entry_remove(port, tid);
+		if (priv->prs_shadow[tid].valid) {
+			mvpp2_prs_hw_inv(priv, tid);
+			priv->prs_shadow[tid].valid = false;
+		}
 	}
 }
 


