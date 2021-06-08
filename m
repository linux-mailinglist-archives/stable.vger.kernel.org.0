Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4DE53A0102
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234118AbhFHSus (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:50:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:42532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235107AbhFHSrU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:47:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A95E6613C3;
        Tue,  8 Jun 2021 18:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177476;
        bh=jqKA3ceQSt2X0YUX2MLM3uyTurwTYgRVoeoavKSo7Gk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cbCKoLqUe1p3BAjZTO72mrb9/4B7Wkbo1op1d1OT127c5JF9MLESrReq4L98SGfVc
         xUhXuqjYFfoJyq07KqtGpcxnvCAXXK6mpDbH+grdyCBkSSF17cnDptHbQCfG0vUCue
         ZyTazzV7c39+mIc+lCinjfxacKD+4lAkqbnyPNxA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [PATCH 5.4 64/78] bnxt_en: Remove the setting of dev_port.
Date:   Tue,  8 Jun 2021 20:27:33 +0200
Message-Id: <20210608175937.432125502@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175935.254388043@linuxfoundation.org>
References: <20210608175935.254388043@linuxfoundation.org>
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
@@ -7003,7 +7003,6 @@ static int __bnxt_hwrm_func_qcaps(struct
 
 		pf->fw_fid = le16_to_cpu(resp->fid);
 		pf->port_id = le16_to_cpu(resp->port_id);
-		bp->dev->dev_port = pf->port_id;
 		memcpy(pf->mac_addr, resp->mac_address, ETH_ALEN);
 		pf->first_vf_id = le16_to_cpu(resp->first_vf_id);
 		pf->max_vfs = le16_to_cpu(resp->max_vfs);


