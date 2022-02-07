Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C220C4ABD7D
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 13:00:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345613AbiBGLon (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:44:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384900AbiBGLab (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:30:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42886C03C193;
        Mon,  7 Feb 2022 03:28:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 382B06006F;
        Mon,  7 Feb 2022 11:28:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F227FC004E1;
        Mon,  7 Feb 2022 11:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233324;
        bh=7QUCjhG7b2OWuM/D+SKi0gaN56aTrCQMmg2TU98RO+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tPcuJzdFirvmXUL/TljN7v+TYRpLxFnSpWLE1PK9+TvO2hK9pJXI2RWUUhDr1QUq2
         kMsHUuQ+ieOUn7C6oFd4b9QJlDmNHAtsii5sorf7rxINvSvAGmu3Z/W9Ek9s2ypU4x
         sJKw9MdtNddTG55J5dH0bQnzVmyQLFzjjRNnrqjs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Mark Zhang <markzhang@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.15 055/110] IB/cm: Release previously acquired reference counter in the cm_id_priv
Date:   Mon,  7 Feb 2022 12:06:28 +0100
Message-Id: <20220207103804.145489928@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103802.280120990@linuxfoundation.org>
References: <20220207103802.280120990@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Zhang <markzhang@nvidia.com>

commit b856101a1774b5f1c8c99e8dfdef802856520732 upstream.

In failure flow, the reference counter acquired was not released,
and the following error was reported:

  drivers/infiniband/core/cm.c:3373 cm_lap_handler() warn: inconsistent
			refcounting 'cm_id_priv->refcount.refs.counter':

Fixes: 7345201c3963 ("IB/cm: Improve the calling of cm_init_av_for_lap and cm_init_av_by_path")
Link: https://lore.kernel.org/r/7615f23bbb5c5b66d03f6fa13e1c99d51dae6916.1642581448.git.leonro@nvidia.com
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/core/cm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -3322,7 +3322,7 @@ static int cm_lap_handler(struct cm_work
 	ret = cm_init_av_by_path(param->alternate_path, NULL, &alt_av);
 	if (ret) {
 		rdma_destroy_ah_attr(&ah_attr);
-		return -EINVAL;
+		goto deref;
 	}
 
 	spin_lock_irq(&cm_id_priv->lock);


