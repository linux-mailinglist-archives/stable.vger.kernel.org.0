Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 783445EBDC8
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 10:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiI0IvB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 04:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbiI0Iu7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 04:50:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F25176964
        for <stable@vger.kernel.org>; Tue, 27 Sep 2022 01:50:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9B0161744
        for <stable@vger.kernel.org>; Tue, 27 Sep 2022 08:50:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3658C433B5;
        Tue, 27 Sep 2022 08:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664268657;
        bh=13VlzrdAdICjBbCuKDC8vNbVnr0RpsX0Iq/AwEMLK3o=;
        h=Subject:To:From:Date:From;
        b=sdUYEYIlAE7jW4/76omICfY3FsP5CRMuDwKNUYxLURx7vv5NxUXBJYdyXEMc/Eugh
         f+bim71H2wRqYCmk+cCqtSeB8tHiDUINiZJR04sOMQMiPfiuzME1jPeJkbtr12pvd1
         TT2OgS5c9YnwsDSlWa3s/T6LIjrybYWVPpTAtaqM=
Subject: patch "usb: typec: ucsi: Remove incorrect warning" added to usb-linus
To:     heikki.krogerus@linux.intel.com, gregkh@linuxfoundation.org,
        pmenzel@molgen.mpg.de, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 27 Sep 2022 10:50:54 +0200
Message-ID: <166426865432237@kroah.com>
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
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 415ba26cb73f7d22a892043301b91b57ae54db02 Mon Sep 17 00:00:00 2001
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


