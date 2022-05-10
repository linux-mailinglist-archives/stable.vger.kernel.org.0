Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A31F5218C0
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243235AbiEJNj4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:39:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245010AbiEJNiW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:38:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E42AA98F44;
        Tue, 10 May 2022 06:26:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22C1C61820;
        Tue, 10 May 2022 13:26:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F279C385A6;
        Tue, 10 May 2022 13:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189211;
        bh=f6/fAM20VGRb4U0ansRcxlQekxwjGuCT/6+lSGaEZz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f0Gu6chCp4sTlO6Wq/tA9E1oXn8KAa/Q0Uk2/3EVW7LMvZ9DRzKaXmI1erysbuUZe
         wDWtxyTqYvOhMmlJaRVjdg6hGeMIJ2VxhHtUN4ao15G2XXbGo3Od4mNjOo1VOQsyQh
         gDnRuBsXW08h2YJh88600mjGI3jNxcXtniGKd8BE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 48/70] net: cpsw: add missing of_node_put() in cpsw_probe_dt()
Date:   Tue, 10 May 2022 15:08:07 +0200
Message-Id: <20220510130734.266836554@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130732.861729621@linuxfoundation.org>
References: <20220510130732.861729621@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

commit 95098d5ac2551769807031444e55a0da5d4f0952 upstream.

'tmp_node' need be put before returning from cpsw_probe_dt(),
so add missing of_node_put() in error path.

Fixes: ed3525eda4c4 ("net: ethernet: ti: introduce cpsw switchdev based driver part 1 - dual-emac")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ti/cpsw_new.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -1255,8 +1255,10 @@ static int cpsw_probe_dt(struct cpsw_com
 	data->slave_data = devm_kcalloc(dev, CPSW_SLAVE_PORTS_NUM,
 					sizeof(struct cpsw_slave_data),
 					GFP_KERNEL);
-	if (!data->slave_data)
+	if (!data->slave_data) {
+		of_node_put(tmp_node);
 		return -ENOMEM;
+	}
 
 	/* Populate all the child nodes here...
 	 */
@@ -1353,6 +1355,7 @@ static int cpsw_probe_dt(struct cpsw_com
 
 err_node_put:
 	of_node_put(port_np);
+	of_node_put(tmp_node);
 	return ret;
 }
 


