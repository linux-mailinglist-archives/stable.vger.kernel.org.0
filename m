Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 063EC676D21
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 14:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbjAVNWm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 08:22:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbjAVNWl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 08:22:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB70116AFE
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 05:22:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 463CC60C0F
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 13:22:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57A06C433D2;
        Sun, 22 Jan 2023 13:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674393754;
        bh=cov3fJutITco/GtNFq+5iDJQ7NtzTst7VwfsAb16HlM=;
        h=Subject:To:Cc:From:Date:From;
        b=p2vLQ+GUF49nIuypnF8Qdor4ObR6rVIxawQftdzZCIQl0Q44obOJ2CyzxghIp2+3R
         eaCvT4h0In6BFp6SdlN4Jww3keB9U0nxS/sKBPn+JFEqx/ZQ7gTWHV78sbQBoRDtVa
         OT61eQ+ig2Oex7LZqgYtuio0qdQIOVEJjAcwkEcI=
Subject: FAILED: patch "[PATCH] mei: bus: fix unlink on bus in error path" failed to apply to 4.14-stable tree
To:     alexander.usyskin@intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, tomas.winkler@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 22 Jan 2023 14:22:24 +0100
Message-ID: <167439374417884@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

a43866856125 ("mei: bus: fix unlink on bus in error path")
2cca3465147d ("mei: bus: add client dma interface")
e5617d2bf549 ("mei: bus: use zero vtag for bus clients.")
b5958faa34e2 ("mei: bus: move hw module get/put to probe/release")
34f1166afd67 ("mei: bus: need to unlink client before freeing")
69bf53130359 ("mei: bus: fix hw module get/put balance")
257355a44b99 ("mei: make module referencing local to the bus.c")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a43866856125c3c432e2fbb6cc63cee1539ec4a7 Mon Sep 17 00:00:00 2001
From: Alexander Usyskin <alexander.usyskin@intel.com>
Date: Tue, 13 Dec 2022 00:02:46 +0200
Subject: [PATCH] mei: bus: fix unlink on bus in error path

Unconditional call to mei_cl_unlink in mei_cl_bus_dev_release leads
to call of the mei_cl_unlink without corresponding mei_cl_link.
This leads to miscalculation of open_handle_count (decrease without
increase).

Call unlink in mei_cldev_enable fail path and remove blanket unlink
from mei_cl_bus_dev_release.

Fixes: 34f1166afd67 ("mei: bus: need to unlink client before freeing")
Cc: <stable@vger.kernel.org>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Reviewed-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20221212220247.286019-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index 4a08b624910a..a81b890c7ee6 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -702,13 +702,15 @@ void *mei_cldev_dma_map(struct mei_cl_device *cldev, u8 buffer_id, size_t size)
 	if (cl->state == MEI_FILE_UNINITIALIZED) {
 		ret = mei_cl_link(cl);
 		if (ret)
-			goto out;
+			goto notlinked;
 		/* update pointers */
 		cl->cldev = cldev;
 	}
 
 	ret = mei_cl_dma_alloc_and_map(cl, NULL, buffer_id, size);
-out:
+	if (ret)
+		mei_cl_unlink(cl);
+notlinked:
 	mutex_unlock(&bus->device_lock);
 	if (ret)
 		return ERR_PTR(ret);
@@ -758,7 +760,7 @@ int mei_cldev_enable(struct mei_cl_device *cldev)
 	if (cl->state == MEI_FILE_UNINITIALIZED) {
 		ret = mei_cl_link(cl);
 		if (ret)
-			goto out;
+			goto notlinked;
 		/* update pointers */
 		cl->cldev = cldev;
 	}
@@ -785,6 +787,9 @@ int mei_cldev_enable(struct mei_cl_device *cldev)
 	}
 
 out:
+	if (ret)
+		mei_cl_unlink(cl);
+notlinked:
 	mutex_unlock(&bus->device_lock);
 
 	return ret;
@@ -1277,7 +1282,6 @@ static void mei_cl_bus_dev_release(struct device *dev)
 	mei_cl_flush_queues(cldev->cl, NULL);
 	mei_me_cl_put(cldev->me_cl);
 	mei_dev_bus_put(cldev->bus);
-	mei_cl_unlink(cldev->cl);
 	kfree(cldev->cl);
 	kfree(cldev);
 }

