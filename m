Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDC23441887
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:48:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232968AbhKAJtR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:49:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:50956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234558AbhKAJrK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:47:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E5AF613B1;
        Mon,  1 Nov 2021 09:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635759033;
        bh=wb6UdS9unL+8UcF1/3f3ToloHueJvASjzfukwRypU58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sXgDSh1HkoMP0z88G3hrXzZQ2OUGDWZTOPuRx4YbZp6MqGGV7YB+tEQQkrPEH3axl
         lBGvXUQfTWIWUN9nDcsKVczRlYhWH0tTqvEIZ14ssdEfm1x7dPan1Uq+Y/R345+eGS
         ZtICO1a7/F4jBHnO+QS804aKZJ8IIZMVw9hzStJ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rakesh Babu Saladi <rsaladi2@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.14 069/125] octeontx2-af: Fix possible null pointer dereference.
Date:   Mon,  1 Nov 2021 10:17:22 +0100
Message-Id: <20211101082546.273863707@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rakesh Babu Saladi <rsaladi2@marvell.com>

commit c2d4c543f74c90f883e8ec62a31973ae8807d354 upstream.

This patch fixes possible null pointer dereference in files
"rvu_debugfs.c" and "rvu_nix.c"

Fixes: 8756828a8148 ("octeontx2-af: Add NPA aura and pool contexts to debugfs")
Fixes: 9a946def264d ("octeontx2-af: Modify nix_vtag_cfg mailbox to support TX VTAG entries")
Signed-off-by: Rakesh Babu Saladi <rsaladi2@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c |    2 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c     |    3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -581,7 +581,7 @@ static ssize_t rvu_dbg_qsize_write(struc
 	if (cmd_buf)
 		ret = -EINVAL;
 
-	if (!strncmp(subtoken, "help", 4) || ret < 0) {
+	if (ret < 0 || !strncmp(subtoken, "help", 4)) {
 		dev_info(rvu->dev, "Use echo <%s-lf > qsize\n", blk_string);
 		goto qsize_write_done;
 	}
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -2146,6 +2146,9 @@ static void nix_free_tx_vtag_entries(str
 		return;
 
 	nix_hw = get_nix_hw(rvu->hw, blkaddr);
+	if (!nix_hw)
+		return;
+
 	vlan = &nix_hw->txvlan;
 
 	mutex_lock(&vlan->rsrc_lock);


