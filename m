Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEC693CA655
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234745AbhGOSrS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:47:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:49064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238608AbhGOSrN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:47:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4FA61613CF;
        Thu, 15 Jul 2021 18:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374656;
        bh=z5Rbatm3/B688/YXdmnYps1Dc0MQAoXNf2M5Dk3b6Q0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O+BIj13ymFGRTaed2CpWWO8TPRQual6O184yAIAUWIFC16Hl7UOOXzEHK4sCBddOb
         zM1m6BePvJEU8Em2xX+f97W9bzby0fEK36hyO/Gds1nndBWyTbbz5rzo7inkmPqVV4
         Hkxez7/W5B6Hk+1K2LB6oXiIJMN9lKUDdoHYQYy0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russ Weight <russell.h.weight@intel.com>,
        Xu Yilun <yilun.xu@intel.com>, Moritz Fischer <mdf@kernel.org>
Subject: [PATCH 5.4 092/122] fpga: stratix10-soc: Add missing fpga_mgr_free() call
Date:   Thu, 15 Jul 2021 20:38:59 +0200
Message-Id: <20210715182515.750125714@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182448.393443551@linuxfoundation.org>
References: <20210715182448.393443551@linuxfoundation.org>
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
@@ -476,6 +476,7 @@ static int s10_remove(struct platform_de
 	struct s10_priv *priv = mgr->priv;
 
 	fpga_mgr_unregister(mgr);
+	fpga_mgr_free(mgr);
 	stratix10_svc_free_channel(priv->chan);
 
 	return 0;


