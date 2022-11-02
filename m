Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91237615909
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbiKBDEF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230373AbiKBDDN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:03:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C91E23395
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:03:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD1B9617CF
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:03:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B74C433C1;
        Wed,  2 Nov 2022 03:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667358180;
        bh=gagRoc1PCa6Ou1GKb1Z/z9uOaU5o/QH4birrMvATaIw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U2rSBrY6ZD3ViG2FohROqW82sDBWyTnDDczDz3IfJqYLUoLeyTlO3FxCZ2GGU1cYM
         0whi/Ua4jCyzJXr2v1cSctjfjppNFkTJL1rvc60k0NCFvIXxShJG4ofxzM+bOoEZvK
         PQ/Jp3271j0k160Dgqx5Oj6ZSa0wd2C52mfXw24g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wei Yongjun <weiyongjun1@huawei.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [PATCH 5.15 055/132] net: ieee802154: fix error return code in dgram_bind()
Date:   Wed,  2 Nov 2022 03:32:41 +0100
Message-Id: <20221102022101.058594024@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

commit 444d8ad4916edec8a9fc684e841287db9b1e999f upstream.

Fix to return error code -EINVAL from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: 94160108a70c ("net/ieee802154: fix uninit value bug in dgram_sendmsg")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Link: https://lore.kernel.org/r/20220919160830.1436109-1-weiyongjun@huaweicloud.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ieee802154/socket.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/ieee802154/socket.c
+++ b/net/ieee802154/socket.c
@@ -502,8 +502,10 @@ static int dgram_bind(struct sock *sk, s
 	if (err < 0)
 		goto out;
 
-	if (addr->family != AF_IEEE802154)
+	if (addr->family != AF_IEEE802154) {
+		err = -EINVAL;
 		goto out;
+	}
 
 	ieee802154_addr_from_sa(&haddr, &addr->addr);
 	dev = ieee802154_get_dev(sock_net(sk), &haddr);


