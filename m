Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10813627F58
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237594AbiKNM57 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:57:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237444AbiKNM57 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:57:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 995D827DEB
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:57:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A0F36116E
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:57:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3010BC433D6;
        Mon, 14 Nov 2022 12:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430677;
        bh=jE4G07JwY05tqy4ztcnYFQ5D/snzJsHBsQupgxqDtZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MhoAvHIyfVe5Ne13uCPQWib1ZR2O2kzAkJemTDfhmbJXQISaSu+GvWmGIQjYP89pg
         mLVGl/vtyX9mqFlZXpI28bDOL6MeIy8hLSl6gu06VxqCuuTBaVfgAF3DGvtfqjQrfc
         LajNjIlMln4cbQHsB+Df5soKYqOKMhjP4iL0QZrM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 069/131] cxgb4vf: shut down the adapter when t4vf_update_port_info() failed in cxgb4vf_open()
Date:   Mon, 14 Nov 2022 13:45:38 +0100
Message-Id: <20221114124451.628888763@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
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

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit c6092ea1e6d7bd12acd881f6aa2b5054cd70e096 ]

When t4vf_update_port_info() failed in cxgb4vf_open(), resources applied
during adapter goes up are not cleared. Fix it. Only be compiled, not be
tested.

Fixes: 18d79f721e0a ("cxgb4vf: Update port information in cxgb4vf_open()")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Link: https://lore.kernel.org/r/20221109012100.99132-1-shaozhengchao@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
index 49b76fd47daa..464c2b365721 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
@@ -858,7 +858,7 @@ static int cxgb4vf_open(struct net_device *dev)
 	 */
 	err = t4vf_update_port_info(pi);
 	if (err < 0)
-		return err;
+		goto err_unwind;
 
 	/*
 	 * Note that this interface is up and start everything up ...
-- 
2.35.1



