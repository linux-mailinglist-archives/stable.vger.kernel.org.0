Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 819493CA958
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242998AbhGOTGJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:06:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:39762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241545AbhGOTFO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:05:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFC26613CF;
        Thu, 15 Jul 2021 19:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375687;
        bh=V4JGcCcIve5zm2wBydiLP5y0SxYpXcftaSdlt/R27uI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zH7d2ID+1u211w/FQ+MTcAcnLc49jyyaZa3/iiLSw0yn/iEk2MVB9V35YNi4kpG0o
         8IuIJPCsZL1ASalDv/emVn8MeNcx+8L9f6syTKB0EbS0EOHgT6LAu9ySVP4gxvK9Ev
         TbQc5jIV/8VS5yNDpbsoZRxwhELi6f2eR/C+tskw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russ Weight <russell.h.weight@intel.com>,
        Xu Yilun <yilun.xu@intel.com>, Moritz Fischer <mdf@kernel.org>
Subject: [PATCH 5.12 192/242] fpga: stratix10-soc: Add missing fpga_mgr_free() call
Date:   Thu, 15 Jul 2021 20:39:14 +0200
Message-Id: <20210715182626.997307609@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russ Weight <russell.h.weight@intel.com>

commit d9ec9daa20eb8de1efe6abae78c9835ec8ed86f9 upstream.

The stratix10-soc driver uses fpga_mgr_create() function and is therefore
responsible to call fpga_mgr_free() to release the class driver resources.
Add a missing call to fpga_mgr_free in the s10_remove() function.

Signed-off-by: Russ Weight <russell.h.weight@intel.com>
Reviewed-by: Xu Yilun <yilun.xu@intel.com>
Signed-off-by: Moritz Fischer <mdf@kernel.org>
Fixes: e7eef1d7633a ("fpga: add intel stratix10 soc fpga manager driver")
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210614170909.232415-3-mdf@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/fpga/stratix10-soc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/fpga/stratix10-soc.c
+++ b/drivers/fpga/stratix10-soc.c
@@ -454,6 +454,7 @@ static int s10_remove(struct platform_de
 	struct s10_priv *priv = mgr->priv;
 
 	fpga_mgr_unregister(mgr);
+	fpga_mgr_free(mgr);
 	stratix10_svc_free_channel(priv->chan);
 
 	return 0;


