Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5F26C1970
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:33:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233109AbjCTPdj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233139AbjCTPdS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:33:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C228B775
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:26:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1855B80EC5
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:26:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F066DC433EF;
        Mon, 20 Mar 2023 15:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325967;
        bh=0YqCqh+Qg+2o7MkvMn8iGQ1yHulaS9ofUuDEMfWzGW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XIE5XFXf6bigRQHMr/kDcUjBU+TBT5+ndyiX9lPvksIWtFEXRF3CQemWPHXNjFeQh
         bAC+p/O55e1jd7v1kVXeB60bPTvT9LBx7PbLkhOE6XKl6LkI75eU6r5Fth8bGCpZG1
         6mMcff8wbFabgkceAC+HhfOXd7d4Iv3ke4r9YRu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Konrad Dybcio <konrad.dybcio@linaro.org>,
        Johan Hovold <johan+linaro@kernel.org>,
        Georgi Djakov <djakov@kernel.org>,
        Luca Ceresoli <luca.ceresoli@bootlin.com>
Subject: [PATCH 6.2 133/211] interconnect: fix mem leak when freeing nodes
Date:   Mon, 20 Mar 2023 15:54:28 +0100
Message-Id: <20230320145519.008590481@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
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

From: Johan Hovold <johan+linaro@kernel.org>

commit a5904f415e1af72fa8fe6665aa4f554dc2099a95 upstream.

The node link array is allocated when adding links to a node but is not
deallocated when nodes are destroyed.

Fixes: 11f1ceca7031 ("interconnect: Add generic on-chip interconnect API")
Cc: stable@vger.kernel.org      # 5.1
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Luca Ceresoli <luca.ceresoli@bootlin.com> # i.MX8MP MSC SM2-MB-EP1 Board
Link: https://lore.kernel.org/r/20230306075651.2449-2-johan+linaro@kernel.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/interconnect/core.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/interconnect/core.c
+++ b/drivers/interconnect/core.c
@@ -850,6 +850,10 @@ void icc_node_destroy(int id)
 
 	mutex_unlock(&icc_lock);
 
+	if (!node)
+		return;
+
+	kfree(node->links);
 	kfree(node);
 }
 EXPORT_SYMBOL_GPL(icc_node_destroy);


