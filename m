Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4FF39FF6E
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234020AbhFHSdF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:33:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:57310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234355AbhFHScN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:32:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26940613C5;
        Tue,  8 Jun 2021 18:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177010;
        bh=bNPUCVGmymxx+AMhaYS0kFv0psUZ7hmT5CTAZCJz0jU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RPNpgSFRspIJLosJlnJpG01v29dEG5AXOsiD99CveszhgnSoeV4WCMkxHgfrMJM7W
         OdgPtNCchhrdiv8FWyIN0Rmze5Lp2dTJGxPqCX6Yb93yMBzmg57lBwYEhac/dKfylN
         jb74N4zMiQ6ngJBFK2glLnLyxEX+A/hbAvCXU3Fw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [PATCH 4.9 26/29] bnxt_en: Remove the setting of dev_port.
Date:   Tue,  8 Jun 2021 20:27:20 +0200
Message-Id: <20210608175928.669082541@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175927.821075974@linuxfoundation.org>
References: <20210608175927.821075974@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

commit 1d86859fdf31a0d50cc82b5d0d6bfb5fe98f6c00 upstream.

The dev_port is meant to distinguish the network ports belonging to
the same PCI function.  Our devices only have one network port
associated with each PCI function and so we should not set it for
correctness.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4262,7 +4262,6 @@ int bnxt_hwrm_func_qcaps(struct bnxt *bp
 
 		pf->fw_fid = le16_to_cpu(resp->fid);
 		pf->port_id = le16_to_cpu(resp->port_id);
-		bp->dev->dev_port = pf->port_id;
 		memcpy(pf->mac_addr, resp->mac_address, ETH_ALEN);
 		memcpy(bp->dev->dev_addr, pf->mac_addr, ETH_ALEN);
 		pf->max_rsscos_ctxs = le16_to_cpu(resp->max_rsscos_ctx);


