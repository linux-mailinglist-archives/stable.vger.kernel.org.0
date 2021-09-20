Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E34E74124A1
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379734AbhITSgR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:36:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1380563AbhITSe2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:34:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2708863309;
        Mon, 20 Sep 2021 17:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158909;
        bh=IBLKpr5bvv3nLHOKxEPI9htXDRz2JbuZiJEOsuYo0rA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cmvj0zwAF3LvQytpti9Y1Qh+HBGkLQXs6FNl1ZucJV1dwIBKVHveE68SwR92YTUbG
         x1aQmdGpLipPNaiFhtqQSE+5uMVqeofIwxNIoJPhYc/U3lAurh2fDWQTFEm9QC5AWw
         5xcCGzN+xbKM+SiMFdEhzR0sUdvsxk0JDLTnzh44=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edwin Peer <edwin.peer@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 112/122] bnxt_en: fix stored FW_PSID version masks
Date:   Mon, 20 Sep 2021 18:44:44 +0200
Message-Id: <20210920163919.488311124@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
References: <20210920163915.757887582@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Edwin Peer <edwin.peer@broadcom.com>

[ Upstream commit 1656db67233e4259281d2ac35b25f712edbbc20b ]

The FW_PSID version components are 8 bits wide, not 4.

Fixes: db28b6c77f40 ("bnxt_en: Fix devlink info's stored fw.psid version format.")
Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 8b0e916afe6b..2bd476a501bd 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -474,8 +474,8 @@ static int bnxt_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 	if (BNXT_PF(bp) && !bnxt_hwrm_get_nvm_cfg_ver(bp, &nvm_cfg_ver)) {
 		u32 ver = nvm_cfg_ver.vu32;
 
-		sprintf(buf, "%d.%d.%d", (ver >> 16) & 0xf, (ver >> 8) & 0xf,
-			ver & 0xf);
+		sprintf(buf, "%d.%d.%d", (ver >> 16) & 0xff, (ver >> 8) & 0xff,
+			ver & 0xff);
 		rc = bnxt_dl_info_put(bp, req, BNXT_VERSION_STORED,
 				      DEVLINK_INFO_VERSION_GENERIC_FW_PSID,
 				      buf);
-- 
2.30.2



