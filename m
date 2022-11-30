Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C63E63DFAA
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231337AbiK3Ste (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:49:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231514AbiK3StQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:49:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E329B7BF
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:49:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 813A5B81CAA
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:49:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D473BC433D6;
        Wed, 30 Nov 2022 18:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834153;
        bh=CCaW/k/7B35DkKML/TLvGq/DCzTW80EVaH4QozGNgbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ofsU1pCw6XPaHVTUf4IDpP154jCpHh8ir5VO763UL0Xzp2uR9fKObk7U8jpyX/Rs8
         g3gJEPEP87aKrm/Mn+Mu6E7mQuqPc3KxJ+6FGgQjNpcfJ8d1IKwvmOeSpdYb1Z+h6v
         5jNxhyF3ncfxP77LPdw33eik+Ib09Wy3JMibuBhs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 149/289] net: marvell: prestera: add missing unregister_netdev() in prestera_port_create()
Date:   Wed, 30 Nov 2022 19:22:14 +0100
Message-Id: <20221130180547.514210540@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit 9a234a2a085ab9fd2be8d0c1eedfcd10f74b97eb ]

If prestera_port_sfp_bind() fails, unregister_netdev() should be called
in error handling path.

Compile tested only.

Fixes: 52323ef75414 ("net: marvell: prestera: add phylink support")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Link: https://lore.kernel.org/r/1669115432-36841-1-git-send-email-zhangchangzhong@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/prestera/prestera_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index a0ad0bcbf89f..9f588ecba93e 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -730,6 +730,7 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
 	return 0;
 
 err_sfp_bind:
+	unregister_netdev(dev);
 err_register_netdev:
 	prestera_port_list_del(port);
 err_port_init:
-- 
2.35.1



