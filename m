Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65CA33AEFFA
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233313AbhFUQnz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:43:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:33338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231645AbhFUQlx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:41:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A387E61374;
        Mon, 21 Jun 2021 16:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293065;
        bh=r8ldDYFW49HT63E45cLdkyMzH3hk3zp1IR8/Iej1kCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fhmewRQDbvovTetVWb+2akhXDhSi7YVXNRz6XI7mvXCtoKFdJV2HYRut8ZgkdNFRr
         YJQAXO8Fxh/SANebO1L3UdY9k25juz1kbz4QbyeqOZD1IHwPxFh/zcqe15E9J6ANGi
         4BVUSDj4y7enphgQJX07FaKjkqYN1IWhEg1ilIMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Somnath Kotur <somnath.kotur@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 085/178] bnxt_en: Call bnxt_ethtool_free() in bnxt_init_one() error path
Date:   Mon, 21 Jun 2021 18:14:59 +0200
Message-Id: <20210621154925.549570933@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Somnath Kotur <somnath.kotur@broadcom.com>

[ Upstream commit 03400aaa69f916a376e11526cf591901a96a3a5c ]

bnxt_ethtool_init() may have allocated some memory and we need to
call bnxt_ethtool_free() to properly unwind if bnxt_init_one()
fails.

Fixes: 7c3809181468 ("bnxt_en: Refactor bnxt_init_one() and turn on TPA support on 57500 chips.")
Signed-off-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 48c19602a0f3..c118de27bc5c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -12981,6 +12981,7 @@ init_err_pci_clean:
 	bnxt_hwrm_func_drv_unrgtr(bp);
 	bnxt_free_hwrm_short_cmd_req(bp);
 	bnxt_free_hwrm_resources(bp);
+	bnxt_ethtool_free(bp);
 	kfree(bp->fw_health);
 	bp->fw_health = NULL;
 	bnxt_cleanup_pci(bp);
-- 
2.30.2



