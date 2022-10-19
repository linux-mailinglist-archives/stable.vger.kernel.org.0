Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D68EE603D95
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232248AbiJSJFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232149AbiJSJDt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:03:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D55321658A;
        Wed, 19 Oct 2022 01:56:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8B4861812;
        Wed, 19 Oct 2022 08:55:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06DC1C433D6;
        Wed, 19 Oct 2022 08:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169700;
        bh=KNf54MzYOzZQ7PIZ9pF8uzpHZeVH6NK8nEr5MpJ/Xzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qBuk/t0Q1n4pINunZfKttzn1cIZ73BZaO9gkVUc4KsA4qt+qrFzDU7Wd5vQxnZlCN
         1m7rThqbWm4ev+pirA7zYlYYQ657Z4h8W6zePbsdGTtEHL7oxD6bM31d1xwb2f9uJw
         WiJ0ewZRNqbPRipDR0WhPCqpVjuPyWMd3ofELgk4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maxtram95@gmail.com>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 342/862] net: wwan: iosm: Call mutex_init before locking it
Date:   Wed, 19 Oct 2022 10:27:09 +0200
Message-Id: <20221019083305.170906285@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maxtram95@gmail.com>

[ Upstream commit ba0fbdb95da5ddd8db457ce6ba09d16dd979a294 ]

wwan_register_ops calls wwan_create_default_link, which ends up in the
ipc_wwan_newlink callback that locks ipc_wwan->if_mutex. However, this
mutex is not yet initialized by that point. Fix it by moving mutex_init
above the wwan_register_ops call. This also makes the order of
operations in ipc_wwan_init symmetric to ipc_wwan_deinit.

Fixes: 83068395bbfc ("net: iosm: create default link via WWAN core")
Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
Reviewed-by: M Chetan Kumar <m.chetan.kumar@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wwan/iosm/iosm_ipc_wwan.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_wwan.c b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
index 27151148c782..4712f01a7e33 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_wwan.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
@@ -323,15 +323,16 @@ struct iosm_wwan *ipc_wwan_init(struct iosm_imem *ipc_imem, struct device *dev)
 	ipc_wwan->dev = dev;
 	ipc_wwan->ipc_imem = ipc_imem;
 
+	mutex_init(&ipc_wwan->if_mutex);
+
 	/* WWAN core will create a netdev for the default IP MUX channel */
 	if (wwan_register_ops(ipc_wwan->dev, &iosm_wwan_ops, ipc_wwan,
 			      IP_MUX_SESSION_DEFAULT)) {
+		mutex_destroy(&ipc_wwan->if_mutex);
 		kfree(ipc_wwan);
 		return NULL;
 	}
 
-	mutex_init(&ipc_wwan->if_mutex);
-
 	return ipc_wwan;
 }
 
-- 
2.35.1



