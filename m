Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25C9C5EBD8C
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 10:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbiI0IjG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 04:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231682AbiI0Iir (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 04:38:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF83B4A830
        for <stable@vger.kernel.org>; Tue, 27 Sep 2022 01:37:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9F86B81991
        for <stable@vger.kernel.org>; Tue, 27 Sep 2022 08:37:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E2C2C433D6;
        Tue, 27 Sep 2022 08:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664267867;
        bh=OZ3/YTUOg5u+Wr5IKQaVTOh+FjaH95ks0vUOXTyIcUw=;
        h=Subject:To:From:Date:From;
        b=veYJiGrLqPys0+/MY9eQ+MjaBdrhvupdWnCmrPjgMsN1JBok4kEZ2O/QqjP284Ro4
         a3p3ifNXs9QM8tpTrfL0xwQC8akli6bfQ7OZoxjZENim1V9OkotrFvYWuqwg1ZipRe
         9fwUa9Q7kz1oseb3G0mUJqu6i/cl5c3l0EzTi/sI=
Subject: patch "usb: typec: ucsi: Remove incorrect warning" added to usb-testing
To:     heikki.krogerus@linux.intel.com, gregkh@linuxfoundation.org,
        pmenzel@molgen.mpg.de, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 27 Sep 2022 10:37:31 +0200
Message-ID: <166426785124273@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: typec: ucsi: Remove incorrect warning

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From dd3de5ad032db61f3edd9c94daf27e52f8dc25ca Mon Sep 17 00:00:00 2001
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Date: Thu, 22 Sep 2022 17:59:24 +0300
Subject: usb: typec: ucsi: Remove incorrect warning

Sink only devices do not have any source capabilities, so
the driver should not warn about that. Also DRP (Dual Role
Power) capable devices, such as USB Type-C docking stations,
do not return any source capabilities unless they are
plugged to a power supply themselves.

Fixes: 1f4642b72be7 ("usb: typec: ucsi: Retrieve all the PDOs instead of just the first 4")
Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20220922145924.80667-1-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index 7f2624f42724..6364f0d467ea 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -588,8 +588,6 @@ static int ucsi_get_pdos(struct ucsi_connector *con, int is_partner,
 				num_pdos * sizeof(u32));
 	if (ret < 0 && ret != -ETIMEDOUT)
 		dev_err(ucsi->dev, "UCSI_GET_PDOS failed (%d)\n", ret);
-	if (ret == 0 && offset == 0)
-		dev_warn(ucsi->dev, "UCSI_GET_PDOS returned 0 bytes\n");
 
 	return ret;
 }
-- 
2.37.3


