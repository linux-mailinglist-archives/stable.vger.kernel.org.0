Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92C0F302AE2
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 19:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726009AbhAYSzo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:55:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:41512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731379AbhAYSzZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:55:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CE4A20758;
        Mon, 25 Jan 2021 18:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600885;
        bh=jVlH8Oisnq79pMgh25oxgoGFNmPq9uod6/mnhapDK14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IgiVz5HLUEpQO2xpUtH7sOdcn7U88/X5NrfM3fqq2GdFjJkTbD/k2Hby7JGWws2zq
         3JwAZIU1UmGAGB7a+yFfAAl56258MisBG/pw8KMMn3Afd8K4ooB7preSoR9317+SBr
         efti6QvBHxcLIvBbLxqMCvHVekcZvQpQFiG1nUCs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yingjie Wang <wangyingjie55@126.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 158/199] octeontx2-af: Fix missing check bugs in rvu_cgx.c
Date:   Mon, 25 Jan 2021 19:39:40 +0100
Message-Id: <20210125183222.867127167@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yingjie Wang <wangyingjie55@126.com>

commit b7ba6cfabc42fc846eb96e33f1edcd3ea6290a27 upstream.

In rvu_mbox_handler_cgx_mac_addr_get()
and rvu_mbox_handler_cgx_mac_addr_set(),
the msg is expected only from PFs that are mapped to CGX LMACs.
It should be checked before mapping,
so we add the is_cgx_config_permitted() in the functions.

Fixes: 96be2e0da85e ("octeontx2-af: Support for MAC address filters in CGX")
Signed-off-by: Yingjie Wang <wangyingjie55@126.com>
Reviewed-by: Geetha sowjanya<gakula@marvell.com>
Link: https://lore.kernel.org/r/1610719804-35230-1-git-send-email-wangyingjie55@126.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -454,6 +454,9 @@ int rvu_mbox_handler_cgx_mac_addr_set(st
 	int pf = rvu_get_pf(req->hdr.pcifunc);
 	u8 cgx_id, lmac_id;
 
+	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
+		return -EPERM;
+
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 
 	cgx_lmac_addr_set(cgx_id, lmac_id, req->mac_addr);
@@ -470,6 +473,9 @@ int rvu_mbox_handler_cgx_mac_addr_get(st
 	int rc = 0, i;
 	u64 cfg;
 
+	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
+		return -EPERM;
+
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 
 	rsp->hdr.rc = rc;


