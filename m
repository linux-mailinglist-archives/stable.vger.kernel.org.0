Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02138676FEB
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231422AbjAVP0i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:26:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231424AbjAVP0h (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:26:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 874B622DC9
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:26:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25CF060C60
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:26:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32B45C433D2;
        Sun, 22 Jan 2023 15:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674401195;
        bh=MgrnPs2DysF1KwZsRahnpCqovgJtXooyBL01CAcUZlw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mg/rOtyWjJYo3z/gtEcpEjC/wCosYo2sqgGcFeD/2026Zaa/7dzfmuLJ43UCWLBFi
         R39umKEwvATmB2owKaoSo7gZo7yadsMCtzX63oXOrQ/AfVYYyewNLbKi1oOE/HAtGI
         QpoDoElBa4RVdsLjh/U280Y4lPmwNW7kL5EWCAVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 6.1 129/193] mei: bus: fix unlink on bus in error path
Date:   Sun, 22 Jan 2023 16:04:18 +0100
Message-Id: <20230122150252.218199010@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit a43866856125c3c432e2fbb6cc63cee1539ec4a7 upstream.

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
---
 drivers/misc/mei/bus.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -665,13 +665,15 @@ void *mei_cldev_dma_map(struct mei_cl_de
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
@@ -721,7 +723,7 @@ int mei_cldev_enable(struct mei_cl_devic
 	if (cl->state == MEI_FILE_UNINITIALIZED) {
 		ret = mei_cl_link(cl);
 		if (ret)
-			goto out;
+			goto notlinked;
 		/* update pointers */
 		cl->cldev = cldev;
 	}
@@ -748,6 +750,9 @@ int mei_cldev_enable(struct mei_cl_devic
 	}
 
 out:
+	if (ret)
+		mei_cl_unlink(cl);
+notlinked:
 	mutex_unlock(&bus->device_lock);
 
 	return ret;
@@ -1115,7 +1120,6 @@ static void mei_cl_bus_dev_release(struc
 	mei_cl_flush_queues(cldev->cl, NULL);
 	mei_me_cl_put(cldev->me_cl);
 	mei_dev_bus_put(cldev->bus);
-	mei_cl_unlink(cldev->cl);
 	kfree(cldev->cl);
 	kfree(cldev);
 }


