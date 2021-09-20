Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 417C9412601
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385862AbhITSwb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:52:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:33338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1385478AbhITSu2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:50:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E36D63381;
        Mon, 20 Sep 2021 17:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159289;
        bh=1vU2pc2dafStELicyKO2T62E2HcMJTcWH94LaUxYn0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SgkEH/LVXRtSizpwRa5EG/sjZjqmIWoUJSD6k6lb7bOm7EgqG7fIbmhAUAzTcSEE5
         i7YK+qJRuPAJsvNPYFio0EwalFJOlFDqQgxKsbV/LevcQ9bVcgcwS8Kx0jozexFGn5
         gy9ETfQPaIcdQdj/J9Lp/LzNmiOAnpQjkf6EBilI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edwin Peer <edwin.peer@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 162/168] bnxt_en: fix stored FW_PSID version masks
Date:   Mon, 20 Sep 2021 18:45:00 +0200
Message-Id: <20210920163926.997463008@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
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
index 64381be935a8..8b7f6a0ad401 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -471,8 +471,8 @@ static int bnxt_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
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



