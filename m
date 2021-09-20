Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3BC64124A5
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349053AbhITSgS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:36:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:53064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1380560AbhITSe2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:34:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57BD26330B;
        Mon, 20 Sep 2021 17:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158911;
        bh=ewc69y/F6LFv42I1lm/qQybPhoWFzmIud7/vDV0fXhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=amW5ADwVv512gmUTrh+smNg2vnGfdIr9rZv66wyu6jpQzlJadNtyZ1ZvYllSymFcl
         RTMXzIfQv+Y3QJ76HYBXX0ikF/kg6OnbO6VGtHZYBApemVV1wTSigRXA1e3QC0YBuB
         yY0pfb4f/9707GeQnbLPrPUAU/kXj/xG0yrosuOA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edwin Peer <edwin.peer@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 113/122] bnxt_en: Fix asic.rev in devlink dev info command
Date:   Mon, 20 Sep 2021 18:44:45 +0200
Message-Id: <20210920163919.520834557@linuxfoundation.org>
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

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 6fdab8a3ade2adc123bbf5c4fdec3394560b1fb1 ]

The current asic.rev is incomplete and does not include the metal
revision.  Add the metal revision and decode the complete asic
revision into the more common and readable form (A0, B0, etc).

Fixes: 7154917a12b2 ("bnxt_en: Refactor bnxt_dl_info_get().")
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 2bd476a501bd..e2fd625fc6d2 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -452,7 +452,7 @@ static int bnxt_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 		return rc;
 
 	ver_resp = &bp->ver_resp;
-	sprintf(buf, "%X", ver_resp->chip_rev);
+	sprintf(buf, "%c%d", 'A' + ver_resp->chip_rev, ver_resp->chip_metal);
 	rc = bnxt_dl_info_put(bp, req, BNXT_VERSION_FIXED,
 			      DEVLINK_INFO_VERSION_GENERIC_ASIC_REV, buf);
 	if (rc)
-- 
2.30.2



