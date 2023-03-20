Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACCF76C1968
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:33:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233113AbjCTPdW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233104AbjCTPdG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:33:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC47B34C2D
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:25:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E972B80EC8
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:25:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94BD4C433D2;
        Mon, 20 Mar 2023 15:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325948;
        bh=7NBaoj5epw2EWaCt3Ia8FlZOBg2J+aRdzIyMQe5D3gg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jvu8JozPhLD82ODlt3sNHXdWNlFYTAiMjMff26N06CuTCyxRB5keF5AufTxLCXOCN
         wAccH+I+2d9JtbGKrN3vAJ56HXGAXrENCWYEdbHO5EXKcwdNFihdFtcKn3i0fQTRe8
         CvsgJ8wrlx0ahE49D26ItvCz/I74LJ//WGxVUgUw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Konrad Dybcio <konrad.dybcio@linaro.org>,
        Johan Hovold <johan+linaro@kernel.org>,
        Georgi Djakov <djakov@kernel.org>,
        Luca Ceresoli <luca.ceresoli@bootlin.com>
Subject: [PATCH 6.2 130/211] interconnect: fix icc_provider_del() error handling
Date:   Mon, 20 Mar 2023 15:54:25 +0100
Message-Id: <20230320145518.856678151@linuxfoundation.org>
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

commit e0e7089bf9a87bc5e3997422e4e24563424f9018 upstream.

The interconnect framework currently expects that providers are only
removed when there are no users and after all nodes have been removed.

There is currently nothing that guarantees this to be the case and the
framework does not do any reference counting, but refusing to remove the
provider is never correct as that would leave a dangling pointer to a
resource that is about to be released in the global provider list (e.g.
accessible through debugfs).

Replace the current sanity checks with WARN_ON() so that the provider is
always removed.

Fixes: 11f1ceca7031 ("interconnect: Add generic on-chip interconnect API")
Cc: stable@vger.kernel.org      # 5.1: 680f8666baf6: interconnect: Make icc_provider_del() return void
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Luca Ceresoli <luca.ceresoli@bootlin.com> # i.MX8MP MSC SM2-MB-EP1 Board
Link: https://lore.kernel.org/r/20230306075651.2449-3-johan+linaro@kernel.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/interconnect/core.c |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

--- a/drivers/interconnect/core.c
+++ b/drivers/interconnect/core.c
@@ -1061,18 +1061,8 @@ EXPORT_SYMBOL_GPL(icc_provider_add);
 void icc_provider_del(struct icc_provider *provider)
 {
 	mutex_lock(&icc_lock);
-	if (provider->users) {
-		pr_warn("interconnect provider still has %d users\n",
-			provider->users);
-		mutex_unlock(&icc_lock);
-		return;
-	}
-
-	if (!list_empty(&provider->nodes)) {
-		pr_warn("interconnect provider still has nodes\n");
-		mutex_unlock(&icc_lock);
-		return;
-	}
+	WARN_ON(provider->users);
+	WARN_ON(!list_empty(&provider->nodes));
 
 	list_del(&provider->provider_list);
 	mutex_unlock(&icc_lock);


