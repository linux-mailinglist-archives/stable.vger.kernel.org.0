Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB3F9615ADF
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbiKBDm7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbiKBDm6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:42:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EA7526AD8
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:42:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B002B61799
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:42:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 579C5C433D6;
        Wed,  2 Nov 2022 03:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667360577;
        bh=wwlvKWo+SuVYZgPxr/mRtKjGDiQybdO+NPJJ2R/I0HU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O9JRtrz44jRoelu56bbCGs0kWAWgoMyX2AVeyOhXwuC1dZrQsfobagibD2FMqw7/O
         YzcO6xkVSbASRfnaVqcqwmRo0OKtMnlqHIgbfCeIkkpoPhkpIfNl6Q7Kl+l7ImW8pN
         gZdkuAsY4/UE0UqB3SBdWNQB4eUYqRHGWTsVy4PU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wei Yongjun <weiyongjun1@huawei.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [PATCH 4.14 35/60] net: ieee802154: fix error return code in dgram_bind()
Date:   Wed,  2 Nov 2022 03:34:56 +0100
Message-Id: <20221102022052.228452831@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022051.081761052@linuxfoundation.org>
References: <20221102022051.081761052@linuxfoundation.org>
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
@@ -515,8 +515,10 @@ static int dgram_bind(struct sock *sk, s
 	if (err < 0)
 		goto out;
 
-	if (addr->family != AF_IEEE802154)
+	if (addr->family != AF_IEEE802154) {
+		err = -EINVAL;
 		goto out;
+	}
 
 	ieee802154_addr_from_sa(&haddr, &addr->addr);
 	dev = ieee802154_get_dev(sock_net(sk), &haddr);


