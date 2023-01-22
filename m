Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E20E676FD3
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbjAVPZi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:25:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231398AbjAVPZh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:25:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 996D822A01
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:25:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 326D260C43
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:25:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48CB7C433EF;
        Sun, 22 Jan 2023 15:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674401135;
        bh=OcWXXBoI5i3Npsz3WUGmM4zn+4nitJ+kLf9q/IMjQFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HFzukF9jtf2Yo14+wDitk7/xfL4lIlkpbH9UJPwDQLMsP5awOnhrvpm8j3f1Jrn1H
         f268hZKYJsFNWtR7mgSvSnpwnrPDSUezJ+pGdAPOkt8E6YhPxNvY8+Xq9tCDL2KMlB
         vRKEZBdWGfD94A/7e6jwQfnJKu3Dww7hITI3yYFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dave Jiang <dave.jiang@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1 123/193] dmaengine: idxd: Prevent use after free on completion memory
Date:   Sun, 22 Jan 2023 16:04:12 +0100
Message-Id: <20230122150251.946125840@linuxfoundation.org>
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

From: Reinette Chatre <reinette.chatre@intel.com>

commit 1beeec45f9ac31eba52478379f70a5fa9c2ad005 upstream.

On driver unload any pending descriptors are flushed at the
time the interrupt is freed:
idxd_dmaengine_drv_remove() ->
	drv_disable_wq() ->
		idxd_wq_free_irq() ->
			idxd_flush_pending_descs().

If there are any descriptors present that need to be flushed this
flow triggers a "not present" page fault as below:

 BUG: unable to handle page fault for address: ff391c97c70c9040
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page

The address that triggers the fault is the address of the
descriptor that was freed moments earlier via:
drv_disable_wq()->idxd_wq_free_resources()

Fix the use after free by freeing the descriptors after any possible
usage. This is done after idxd_wq_reset() to ensure that the memory
remains accessible during possible completion writes by the device.

Fixes: 63c14ae6c161 ("dmaengine: idxd: refactor wq driver enable/disable operations")
Suggested-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Fenghua Yu <fenghua.yu@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/6c4657d9cff0a0a00501a7b928297ac966e9ec9d.1670452419.git.reinette.chatre@intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/idxd/device.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -1408,11 +1408,11 @@ void drv_disable_wq(struct idxd_wq *wq)
 		dev_warn(dev, "Clients has claim on wq %d: %d\n",
 			 wq->id, idxd_wq_refcount(wq));
 
-	idxd_wq_free_resources(wq);
 	idxd_wq_unmap_portal(wq);
 	idxd_wq_drain(wq);
 	idxd_wq_free_irq(wq);
 	idxd_wq_reset(wq);
+	idxd_wq_free_resources(wq);
 	percpu_ref_exit(&wq->wq_active);
 	wq->type = IDXD_WQT_NONE;
 	wq->client_count = 0;


