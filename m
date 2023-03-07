Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3AF26AEE28
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbjCGSKE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:10:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232269AbjCGSJ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:09:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7928C9EF41
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:03:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27B3DB818F6
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:03:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D719C433EF;
        Tue,  7 Mar 2023 18:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212228;
        bh=KAk0oZasXRugIlZBKo++C1iBRi0g6tQoBMwUXNnaUIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ARQNuiAQwjCr8QhSNNKW/l14Ig9zPxwiExou1RZEHTxpLu6Un81tkLbHfMVD1MCaY
         +kcUE3zX5OnqDBrKPwDBfL3mYILuluJmn4KpWWokGSMb6xxE09PUYpCjFsjxnRHcsB
         N6JhOyNd69luvRIiscoAy7aRm992K1yGTUxxGhCc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wang Yufen <wangyufen@huawei.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 111/885] wifi: mt76: mt7915: add missing of_node_put()
Date:   Tue,  7 Mar 2023 17:50:45 +0100
Message-Id: <20230307170006.699902362@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

From: Wang Yufen <wangyufen@huawei.com>

[ Upstream commit 18425d7d74c5be88b13b970a21e52e2498abf4ba ]

Add missing of_node_put() after of_reserved_mem_lookup()

Fixes: 99ad32a4ca3a ("mt76: mt7915: add support for MT7986")
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/soc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/soc.c b/drivers/net/wireless/mediatek/mt76/mt7915/soc.c
index c74afa746251b..ee7ddda4288b8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/soc.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/soc.c
@@ -278,6 +278,7 @@ static int mt7986_wmac_coninfra_setup(struct mt7915_dev *dev)
 		return -EINVAL;
 
 	rmem = of_reserved_mem_lookup(np);
+	of_node_put(np);
 	if (!rmem)
 		return -EINVAL;
 
-- 
2.39.2



