Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A77266C510
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbjAPQBO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:01:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231951AbjAPQBJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:01:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE6981B56F
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:01:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71CE2B81061
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:01:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB0BEC433EF;
        Mon, 16 Jan 2023 16:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884864;
        bh=tERfO+X1TmGGJzheN449LOiZD0zmm86ixLFy675uRmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dIPUAsJROlbcg7wtN/f9aOEXFGrX/e+erJ06tASujl5vgM9/R06eUjZx75eiv0SNb
         uL5cFjMZOiraZRSYPuaK3ZgvIicn3G3JFajwmYiCCzeiPUkW3w+tHm7KpisFqbzey2
         tl9S0Isb2NRouUYNIN+gog39+6Dy1XYONtTeXQAI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Jiri Pirko <jiri@nvidia.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH 6.1 140/183] ice: Add check for kzalloc
Date:   Mon, 16 Jan 2023 16:51:03 +0100
Message-Id: <20230116154809.280722285@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 40543b3d9d2c13227ecd3aa90a713c201d1d7f09 ]

Add the check for the return value of kzalloc in order to avoid
NULL pointer dereference.
Moreover, use the goto-label to share the clean code.

Fixes: d6b98c8d242a ("ice: add write functionality for GNSS TTY")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_gnss.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_gnss.c b/drivers/net/ethernet/intel/ice/ice_gnss.c
index a1915551c69a..43e199b5b513 100644
--- a/drivers/net/ethernet/intel/ice/ice_gnss.c
+++ b/drivers/net/ethernet/intel/ice/ice_gnss.c
@@ -461,6 +461,9 @@ static struct tty_driver *ice_gnss_create_tty_driver(struct ice_pf *pf)
 	for (i = 0; i < ICE_GNSS_TTY_MINOR_DEVICES; i++) {
 		pf->gnss_tty_port[i] = kzalloc(sizeof(*pf->gnss_tty_port[i]),
 					       GFP_KERNEL);
+		if (!pf->gnss_tty_port[i])
+			goto err_out;
+
 		pf->gnss_serial[i] = NULL;
 
 		tty_port_init(pf->gnss_tty_port[i]);
@@ -470,21 +473,23 @@ static struct tty_driver *ice_gnss_create_tty_driver(struct ice_pf *pf)
 	err = tty_register_driver(tty_driver);
 	if (err) {
 		dev_err(dev, "Failed to register TTY driver err=%d\n", err);
-
-		for (i = 0; i < ICE_GNSS_TTY_MINOR_DEVICES; i++) {
-			tty_port_destroy(pf->gnss_tty_port[i]);
-			kfree(pf->gnss_tty_port[i]);
-		}
-		kfree(ttydrv_name);
-		tty_driver_kref_put(pf->ice_gnss_tty_driver);
-
-		return NULL;
+		goto err_out;
 	}
 
 	for (i = 0; i < ICE_GNSS_TTY_MINOR_DEVICES; i++)
 		dev_info(dev, "%s%d registered\n", ttydrv_name, i);
 
 	return tty_driver;
+
+err_out:
+	while (i--) {
+		tty_port_destroy(pf->gnss_tty_port[i]);
+		kfree(pf->gnss_tty_port[i]);
+	}
+	kfree(ttydrv_name);
+	tty_driver_kref_put(pf->ice_gnss_tty_driver);
+
+	return NULL;
 }
 
 /**
-- 
2.35.1



