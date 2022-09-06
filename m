Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D162D5AEC4D
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241522AbiIFOOv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:14:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241412AbiIFOMx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:12:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 652827F261;
        Tue,  6 Sep 2022 06:47:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE5DA61561;
        Tue,  6 Sep 2022 13:46:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9782C433C1;
        Tue,  6 Sep 2022 13:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471971;
        bh=nKLZwhD1Q+PeuwavRXY37/ogbZlrYinm/NqlmAcPX6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V9iSlozGF3tx5M1jQ4kY2lmPrcmoqJhXBxiGvRnCXaxrpQw/eF4IDiF07oKgdzuVg
         vuvT4KmI8MbQ1VsTtv5qyYiQTecLBajHthVr3UIFGa6sXRy16WS7scMVFTfjaKojx7
         +DBsrlvXsWJqoD/STrzYQ08Z09sitTPDRnh+vLWE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan+linaro@kernel.org>
Subject: [PATCH 5.19 072/155] misc: fastrpc: fix memory corruption on probe
Date:   Tue,  6 Sep 2022 15:30:20 +0200
Message-Id: <20220906132832.470289714@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Johan Hovold <johan+linaro@kernel.org>

commit 9baa1415d9abdd1e08362ea2dcfadfacee8690b5 upstream.

Add the missing sanity check on the probed-session count to avoid
corrupting memory beyond the fixed-size slab-allocated session array
when there are more than FASTRPC_MAX_SESSIONS sessions defined in the
devicetree.

Fixes: f6f9279f2bf0 ("misc: fastrpc: Add Qualcomm fastrpc basic driver model")
Cc: stable@vger.kernel.org      # 5.1
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20220829080531.29681-2-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -1943,6 +1943,11 @@ static int fastrpc_cb_probe(struct platf
 	of_property_read_u32(dev->of_node, "qcom,nsessions", &sessions);
 
 	spin_lock_irqsave(&cctx->lock, flags);
+	if (cctx->sesscount >= FASTRPC_MAX_SESSIONS) {
+		dev_err(&pdev->dev, "too many sessions\n");
+		spin_unlock_irqrestore(&cctx->lock, flags);
+		return -ENOSPC;
+	}
 	sess = &cctx->session[cctx->sesscount];
 	sess->used = false;
 	sess->valid = true;


