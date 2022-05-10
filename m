Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD99E521B10
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 16:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244773AbiEJOIN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 10:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344069AbiEJOH1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 10:07:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D09037CDFA;
        Tue, 10 May 2022 06:41:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C52AB81DA0;
        Tue, 10 May 2022 13:41:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7023C385C2;
        Tue, 10 May 2022 13:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652190100;
        bh=AAu3wZQM5TXMCSefAdcqdNYX8X6nheEiGnbu9e2bf/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KG/oedabcfRWnfeIYAwEgkjGOp/46Yzo/RXSq4DVJFewy4dt38PWttp3LZ+I1zh15
         ydlU+7fK9akGRdyQb6Jel6slVJMq5jfekq9DSAy+faJmMrP9mk6Ofqa3hVMsYJm033
         ddhv0XXNEOo1cg13Ozo2LUn2SHU/malR4PCG/qng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.17 088/140] net: cpsw: add missing of_node_put() in cpsw_probe_dt()
Date:   Tue, 10 May 2022 15:07:58 +0200
Message-Id: <20220510130744.126648305@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
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
@@ -1246,8 +1246,10 @@ static int cpsw_probe_dt(struct cpsw_com
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
@@ -1341,6 +1343,7 @@ static int cpsw_probe_dt(struct cpsw_com
 
 err_node_put:
 	of_node_put(port_np);
+	of_node_put(tmp_node);
 	return ret;
 }
 


