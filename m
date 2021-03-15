Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6422133B748
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbhCOOAA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:00:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232563AbhCON7D (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D176364F4F;
        Mon, 15 Mar 2021 13:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816715;
        bh=ojDc9D3E3hd5ZYnPogSehenysN9zwXgUMtUat7vM1bs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=utbu5h4Ecp0doZpYJrQNmZoYVd0iOQlcCEccVw2uw+QQmzzvr04rmsDgD7NRa/SFL
         wfVYDVi4Q77saIi9lKYaJ0iTksLTDlBqlC/7HwCxMMaNS99btD7evdbfsdcBtN3GzD
         OQbo/R2vhutYIaR3QcBc5MXFNipIW2m8mEKdUx0g=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 15/95] sh_eth: fix TRSCER mask for SH771x
Date:   Mon, 15 Mar 2021 14:56:45 +0100
Message-Id: <20210315135740.770736119@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135740.245494252@linuxfoundation.org>
References: <20210315135740.245494252@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Sergey Shtylyov <s.shtylyov@omprussia.ru>

commit 8c91bc3d44dfef8284af384877fbe61117e8b7d1 upstream.

According  to  the SH7710, SH7712, SH7713 Group User's Manual: Hardware,
Rev. 3.00, the TRSCER register actually has only bit 7 valid (and named
differently), with all the other bits reserved. Apparently, this was not
the case with some early revisions of the manual as we have the other
bits declared (and set) in the original driver.  Follow the suit and add
the explicit sh_eth_cpu_data::trscer_err_mask initializer for SH771x...

Fixes: 86a74ff21a7a ("net: sh_eth: add support for Renesas SuperH Ethernet")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/renesas/sh_eth.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -935,6 +935,9 @@ static struct sh_eth_cpu_data sh771x_dat
 			  EESIPR_CEEFIP | EESIPR_CELFIP |
 			  EESIPR_RRFIP | EESIPR_RTLFIP | EESIPR_RTSFIP |
 			  EESIPR_PREIP | EESIPR_CERFIP,
+
+	.trscer_err_mask = DESC_I_RINT8,
+
 	.tsu		= 1,
 	.dual_port	= 1,
 };


