Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 928546C1804
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231615AbjCTPTe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232238AbjCTPTN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:19:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C985F18148
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:13:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9224D61582
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:13:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E2CFC4339B;
        Mon, 20 Mar 2023 15:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325219;
        bh=0YqCqh+Qg+2o7MkvMn8iGQ1yHulaS9ofUuDEMfWzGW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FkSZ815FMczF7MWViphQ96W7LA7pDs675IZkpiHtk6NiZqTdd9WCHJ+HcKlNityki
         J8d3kFlHpL2JTyc0tiIBdm1hK06cz+nag0+g3WHZZI9tvAVhWDXdHe83l4D9Qz3gyz
         8Flj8KmiGjRB+0A26xLBsNXQN49+/dr1avc/Sj48=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Konrad Dybcio <konrad.dybcio@linaro.org>,
        Johan Hovold <johan+linaro@kernel.org>,
        Georgi Djakov <djakov@kernel.org>,
        Luca Ceresoli <luca.ceresoli@bootlin.com>
Subject: [PATCH 5.15 079/115] interconnect: fix mem leak when freeing nodes
Date:   Mon, 20 Mar 2023 15:54:51 +0100
Message-Id: <20230320145452.739962310@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
References: <20230320145449.336983711@linuxfoundation.org>
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


