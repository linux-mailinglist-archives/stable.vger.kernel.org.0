Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 314C168D853
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232267AbjBGNIe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:08:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232272AbjBGNId (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:08:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 711B63B3CF
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:08:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C492C613F8
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:07:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4551C433D2;
        Tue,  7 Feb 2023 13:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775252;
        bh=y2lR5wTufN+3XO4Pksl4GAytSosY7tsE5z1ebI2IkSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I51KJWMVQ7YrvhJOmv3F23nZe2e1vvwtff2bDF3gxQJQMwpLN5UeRSzfGetDIWgtI
         8eqMLYRsUgk0iBNiSPd7IV3ax0xRDCwHsr0ygoZDZxx9lmOPqJ/8yGYSt5yUZWUkhq
         H9c60Xjf+CIQXcKsOR50DOmHx9jkspvLDlYlX5k0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Michael Walle <michael@walle.cc>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.1 188/208] nvmem: core: fix device node refcounting
Date:   Tue,  7 Feb 2023 13:57:22 +0100
Message-Id: <20230207125642.992438342@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Walle <michael@walle.cc>

commit edcf2fb660526b5ed29f93bd17328a2b4835c8b2 upstream.

In of_nvmem_cell_get(), of_get_next_parent() is used on cell_np. This
will decrement the refcount on cell_np, but cell_np is still used later
in the code. Use of_get_parent() instead and of_node_put() in the
appropriate places.

Fixes: 69aba7948cbe ("nvmem: Add a simple NVMEM framework for consumers")
Fixes: 7ae6478b304b ("nvmem: core: rework nvmem cell instance creation")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Walle <michael@walle.cc>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20230127104015.23839-8-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/core.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -1237,16 +1237,21 @@ struct nvmem_cell *of_nvmem_cell_get(str
 	if (!cell_np)
 		return ERR_PTR(-ENOENT);
 
-	nvmem_np = of_get_next_parent(cell_np);
-	if (!nvmem_np)
+	nvmem_np = of_get_parent(cell_np);
+	if (!nvmem_np) {
+		of_node_put(cell_np);
 		return ERR_PTR(-EINVAL);
+	}
 
 	nvmem = __nvmem_device_get(nvmem_np, device_match_of_node);
 	of_node_put(nvmem_np);
-	if (IS_ERR(nvmem))
+	if (IS_ERR(nvmem)) {
+		of_node_put(cell_np);
 		return ERR_CAST(nvmem);
+	}
 
 	cell_entry = nvmem_find_cell_entry_by_node(nvmem, cell_np);
+	of_node_put(cell_np);
 	if (!cell_entry) {
 		__nvmem_device_put(nvmem);
 		return ERR_PTR(-ENOENT);


