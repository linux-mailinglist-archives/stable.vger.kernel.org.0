Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D62D74BA3EC
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 16:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234301AbiBQPC7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 10:02:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiBQPC6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 10:02:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB0891D0EC
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 07:02:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7AC2861E74
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 15:02:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E8B6C340E9;
        Thu, 17 Feb 2022 15:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645110158;
        bh=FtBhB67av2ZfPY0VMQF6gqc4EOoqWCPa+0YrfGzYLtE=;
        h=Subject:To:From:Date:From;
        b=GDKYLQUPeNF9YMDi08mecsDSnxOfln/3q5JBoOn+1A0OlFGf3lj5nvjxf/dQH7wNU
         OdQQEFbVCt1sRIMnuDBHVcCgBsqlz6LAjpA3P7WHQyYrJQaEkfeIF8SOWcdfa1I1WL
         Rux6eY8bb6TRk/xPr6allcehA8nB0MEBxb68fHfU=
Subject: patch "tps6598x: clear int mask on probe failure" added to usb-linus
To:     axboe@kernel.dk, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, stable@vger.kernel.org,
        sven@svenpeter.dev
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 17 Feb 2022 16:02:36 +0100
Message-ID: <164511015615244@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    tps6598x: clear int mask on probe failure

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From aba2081e0a9c977396124aa6df93b55ed5912b19 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Tue, 15 Feb 2022 11:22:04 -0700
Subject: tps6598x: clear int mask on probe failure

The interrupt mask is enabled before any potential failure points in
the driver, which can leave a failure path where we exit with
interrupts enabled but the device not live. This causes an infinite
stream of interrupts on an Apple M1 Pro laptop on USB-C.

Add a failure label that's used post enabling interrupts, where we
mask them again before returning an error.

Suggested-by: Sven Peter <sven@svenpeter.dev>
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Link: https://lore.kernel.org/r/e6b80669-20f3-06e7-9ed5-8951a9c6db6f@kernel.dk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tipd/core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/typec/tipd/core.c b/drivers/usb/typec/tipd/core.c
index 6d27a5b5e3ca..7ffcda94d323 100644
--- a/drivers/usb/typec/tipd/core.c
+++ b/drivers/usb/typec/tipd/core.c
@@ -761,12 +761,12 @@ static int tps6598x_probe(struct i2c_client *client)
 
 	ret = tps6598x_read32(tps, TPS_REG_STATUS, &status);
 	if (ret < 0)
-		return ret;
+		goto err_clear_mask;
 	trace_tps6598x_status(status);
 
 	ret = tps6598x_read32(tps, TPS_REG_SYSTEM_CONF, &conf);
 	if (ret < 0)
-		return ret;
+		goto err_clear_mask;
 
 	/*
 	 * This fwnode has a "compatible" property, but is never populated as a
@@ -855,7 +855,8 @@ static int tps6598x_probe(struct i2c_client *client)
 	usb_role_switch_put(tps->role_sw);
 err_fwnode_put:
 	fwnode_handle_put(fwnode);
-
+err_clear_mask:
+	tps6598x_write64(tps, TPS_REG_INT_MASK1, 0);
 	return ret;
 }
 
-- 
2.35.1


