Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 246273AEDE2
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbhFUQXt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:23:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:42214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231877AbhFUQWR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:22:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 965B56128A;
        Mon, 21 Jun 2021 16:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292393;
        bh=c45O5PKH4jcr3/1H1tThPHvnWp+9hIxnRtSWZwGxvHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B3djjWsHNIcpm7M2xN/dIpuCcd+uQCLnEkgN9FEpinXxgAQB9d/5T6yCdOckGq5S1
         +MBHxcL4cNXjgzoIRlFq5MZbPs8p7VD40vZh0OxkWO3T4lNxruILSJYoReGKPAz9B0
         E9hFTrFT3ytv1CYNCyzIuQN041kCkW3ssJxopEEg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Somnath Kotur <somnath.kotur@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 40/90] bnxt_en: Call bnxt_ethtool_free() in bnxt_init_one() error path
Date:   Mon, 21 Jun 2021 18:15:15 +0200
Message-Id: <20210621154905.477927069@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154904.159672728@linuxfoundation.org>
References: <20210621154904.159672728@linuxfoundation.org>
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
index f983d03da1e4..d1c3939b0307 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11963,6 +11963,7 @@ init_err_cleanup:
 init_err_pci_clean:
 	bnxt_free_hwrm_short_cmd_req(bp);
 	bnxt_free_hwrm_resources(bp);
+	bnxt_ethtool_free(bp);
 	kfree(bp->fw_health);
 	bp->fw_health = NULL;
 	bnxt_cleanup_pci(bp);
-- 
2.30.2



