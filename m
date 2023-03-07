Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3B8B6AF46C
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233797AbjCGTQy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:16:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233835AbjCGTQR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:16:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7525DB78A2
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:59:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21E03B819DC
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:59:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65717C433D2;
        Tue,  7 Mar 2023 18:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215582;
        bh=sudEGX5W3BmZp3WlcZvi252H6S5xawGJzPodbomXd9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FNLg0+m8+jKApI561q+OxPVv2TCvCKv9fz8Tv2MEQ4PEzknyYkpvSC33c9bp7wq2j
         aPk7LQ0Bx9Srja0S0K00TiKHyE8woeW+b5IKhOrZTBFcDGX+lpq6HhlBrxBhnB7BQn
         2grtoOxdIjXZDw7eW5AXDqeWo8bzz/g9QI0+XTYw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 309/567] drivers: base: transport_class: fix possible memory leak
Date:   Tue,  7 Mar 2023 18:00:45 +0100
Message-Id: <20230307165919.252108436@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit a86367803838b369fe5486ac18771d14723c258c ]

Current some drivers(like iscsi) call transport_register_device()
failed, they don't call transport_destroy_device() to release the
memory allocated in transport_setup_device(), because they don't
know what was done, it should be internal thing to release the
resource in register function. So fix this leak by calling destroy
function inside register function.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221110102307.3492557-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/transport_class.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/transport_class.h b/include/linux/transport_class.h
index 63076fb835e34..2efc271a96fa6 100644
--- a/include/linux/transport_class.h
+++ b/include/linux/transport_class.h
@@ -70,8 +70,14 @@ void transport_destroy_device(struct device *);
 static inline int
 transport_register_device(struct device *dev)
 {
+	int ret;
+
 	transport_setup_device(dev);
-	return transport_add_device(dev);
+	ret = transport_add_device(dev);
+	if (ret)
+		transport_destroy_device(dev);
+
+	return ret;
 }
 
 static inline void
-- 
2.39.2



