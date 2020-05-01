Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D68AD1C1743
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729844AbgEAOAa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 10:00:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:49596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728917AbgEAN1U (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:27:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAB802166E;
        Fri,  1 May 2020 13:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588339640;
        bh=iCbh3q6xWJn/RtDfI77FmGLwgX0MhGfofN7ZmqcW6tg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zsw8pFb7FmTUjzW0Q0PlajvE2waaT/GdLzwvwHuCEng8GkBh+2A5axW3qrwj3ZfKO
         zTHXnfl4tTJnE/hVw38OQ+Jto5Zwwu6y6kV7c3rSfCROXn8O5wOMpai2qQ/fvZhQVI
         moxPJqthLoqzEnnkzkaOqNip31ke1xwuzWfl8GIA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 59/70] net/cxgb4: Check the return from t4_query_params properly
Date:   Fri,  1 May 2020 15:21:47 +0200
Message-Id: <20200501131531.132718575@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131513.302599262@linuxfoundation.org>
References: <20200501131513.302599262@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

commit c799fca8baf18d1bbbbad6c3b736eefbde8bdb90 upstream.

Positive return values are also failures that don't set val,
although this probably can't happen. Fixes gcc 10 warning:

drivers/net/ethernet/chelsio/cxgb4/t4_hw.c: In function ‘t4_phy_fw_ver’:
drivers/net/ethernet/chelsio/cxgb4/t4_hw.c:3747:14: warning: ‘val’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 3747 |  *phy_fw_ver = val;

Fixes: 01b6961410b7 ("cxgb4: Add PHY firmware support for T420-BT cards")
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -3341,7 +3341,7 @@ int t4_phy_fw_ver(struct adapter *adap,
 		 FW_PARAMS_PARAM_Z_V(FW_PARAMS_PARAM_DEV_PHYFW_VERSION));
 	ret = t4_query_params(adap, adap->mbox, adap->pf, 0, 1,
 			      &param, &val);
-	if (ret < 0)
+	if (ret)
 		return ret;
 	*phy_fw_ver = val;
 	return 0;


