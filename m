Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84A531924A
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbfEITGL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 15:06:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:39522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727686AbfEISrE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:47:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FF4B2183E;
        Thu,  9 May 2019 18:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427623;
        bh=Ss5X+RIKrkfObLBIwJoE0jZwf0fTuAOXHaRiDfCHvfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t3d6YlFgd4ZYlNlWeFwrcUgeMvtitS83IAheta+l3WE3MKDKn7Sjr/gaVYIl+q1hr
         hvwNTnG5fJ8+2yR6wAZncjM1cvtinOsAww3QSlfuqZZ5djm3dUVVVwPuSGZmWTj7Gz
         dt6I+Zj91Vqysdj5Gq7f8dUucPHUsEFm/IzxvoF4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Aaro Koskinen <aaro.koskinen@nokia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 4.19 01/66] net: stmmac: Use bfsize1 in ndesc_init_rx_desc
Date:   Thu,  9 May 2019 20:41:36 +0200
Message-Id: <20190509181301.896150656@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181301.719249738@linuxfoundation.org>
References: <20190509181301.719249738@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

commit f87db4dbd52f2f8a170a2b51cb0926221ca7c9e2 upstream.

gcc warn this:

drivers/net/ethernet/stmicro/stmmac/norm_desc.c: In function ndesc_init_rx_desc:
drivers/net/ethernet/stmicro/stmmac/norm_desc.c:138:6: warning: variable 'bfsize1' set but not used [-Wunused-but-set-variable]

Like enh_desc_init_rx_desc, we should use bfsize1
in ndesc_init_rx_desc to calculate 'p->des1'

Fixes: 583e63614149 ("net: stmmac: use correct DMA buffer size in the RX descriptor")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Aaro Koskinen <aaro.koskinen@nokia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/stmicro/stmmac/norm_desc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/stmicro/stmmac/norm_desc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/norm_desc.c
@@ -140,7 +140,7 @@ static void ndesc_init_rx_desc(struct dm
 	p->des0 |= cpu_to_le32(RDES0_OWN);
 
 	bfsize1 = min(bfsize, BUF_SIZE_2KiB - 1);
-	p->des1 |= cpu_to_le32(bfsize & RDES1_BUFFER1_SIZE_MASK);
+	p->des1 |= cpu_to_le32(bfsize1 & RDES1_BUFFER1_SIZE_MASK);
 
 	if (mode == STMMAC_CHAIN_MODE)
 		ndesc_rx_set_on_chain(p, end);


