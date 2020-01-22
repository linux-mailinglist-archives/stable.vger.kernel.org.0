Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86A8A1455C9
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731195AbgAVNZN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:25:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:44824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730771AbgAVNZN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:25:13 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A21D2467B;
        Wed, 22 Jan 2020 13:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699512;
        bh=m1ojr+3KUybYQi0kamHI+nKZrFOBunYE+YxiTEQEp3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eR5yUvxVufW2YvyDiYoZ5OHyu3TV1f/MzFNnYTJZqU+HN+7WxQiatbhIl0dCwCBDp
         yzjnZI4EovTBaNgEGzvVuriG5hOQ5e1Yn4ti1y/p3FPj+YvjpJ6cDZm7jWVd1lTa/o
         mAv9UiBvfHLliJslo1Hwvc8M66nFJOE6dEB0sKaU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 168/222] net: stmmac: tc: Do not setup flower filtering if RSS is enabled
Date:   Wed, 22 Jan 2020 10:29:14 +0100
Message-Id: <20200122092845.739671803@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>

commit 7bd754c47dd3ad1b048c9641294b0234fcce2c58 upstream.

RSS, when enabled, will bypass the L3 and L4 filtering causing it not
to work. Add a check before trying to setup the filters.

Fixes: 425eabddaf0f ("net: stmmac: Implement L3/L4 Filters using TC Flower")
Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -579,6 +579,10 @@ static int tc_setup_cls(struct stmmac_pr
 {
 	int ret = 0;
 
+	/* When RSS is enabled, the filtering will be bypassed */
+	if (priv->rss.enable)
+		return -EBUSY;
+
 	switch (cls->command) {
 	case FLOW_CLS_REPLACE:
 		ret = tc_add_flow(priv, cls);


