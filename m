Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 739394418C1
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:49:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234597AbhKAJvJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:51:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:51404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234771AbhKAJtC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:49:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDAE3611C9;
        Mon,  1 Nov 2021 09:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635759092;
        bh=I6hRXO/d5I2HczES4M/gAfl+H7Wg+ADNMP2/U84gHNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1FdAskFtOJZxxM6rOjfCPAZKCX28SyYXr0AULOat6l55Raqlx8/DrvOoVUga+bSv2
         9gpT07TuKndQ0/u4pukIwPTnrSjVIQKDtb3Ytk20K/kqF8VV6YZarb+KGFj1bmpiIa
         DTfBCwGLyjW0JQR8Cm02+EiyNxSY07VCQ/Bu9+J0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Subbaraya Sundeep <sbhatta@marvell.com>,
        Rakesh Babu <rsaladi2@marvell.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 112/125] octeontx2-af: Check whether ipolicers exists
Date:   Mon,  1 Nov 2021 10:18:05 +0100
Message-Id: <20211101082554.297590859@linuxfoundation.org>
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

From: Subbaraya Sundeep <sbhatta@marvell.com>

[ Upstream commit cc45b96e2de7ada26520f101dada0abafa4ba997 ]

While displaying ingress policers information in
debugfs check whether ingress policers exist in
the hardware or not because some platforms(CN9XXX)
do not have this feature.

Fixes: e7d8971763f3 ("octeontx2-af: cn10k: Debugfs support for bandwidth")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Rakesh Babu <rsaladi2@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index 75794c8590c4..a606de56678d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -1796,6 +1796,10 @@ static int rvu_dbg_nix_band_prof_ctx_display(struct seq_file *m, void *unused)
 	u16 pcifunc;
 	char *str;
 
+	/* Ingress policers do not exist on all platforms */
+	if (!nix_hw->ipolicer)
+		return 0;
+
 	for (layer = 0; layer < BAND_PROF_NUM_LAYERS; layer++) {
 		if (layer == BAND_PROF_INVAL_LAYER)
 			continue;
@@ -1845,6 +1849,10 @@ static int rvu_dbg_nix_band_prof_rsrc_display(struct seq_file *m, void *unused)
 	int layer;
 	char *str;
 
+	/* Ingress policers do not exist on all platforms */
+	if (!nix_hw->ipolicer)
+		return 0;
+
 	seq_puts(m, "\nBandwidth profile resource free count\n");
 	seq_puts(m, "=====================================\n");
 	for (layer = 0; layer < BAND_PROF_NUM_LAYERS; layer++) {
-- 
2.33.0



