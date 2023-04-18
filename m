Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3B6A6E62BE
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231676AbjDRMfB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231704AbjDRMe6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:34:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E30D10242
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:34:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1F356326E
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:34:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8133C433D2;
        Tue, 18 Apr 2023 12:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821296;
        bh=ol+lBlJkR7zdGSJo0GNax1VF07ZK1pzRC7x/a4MvU68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uFF+KFMH/PybPfCJWCK2VthXjWIr1ocDVOPPRg6KLnxbkBfks4l8uCzDBlF0xqZ8E
         WdITkVqjRzowtcaJ+Ui1OqnUsNguA9z8PYWPUC2rnDq5ojKPV6ZfDZrvtw4fxcXYX/
         pTsymxhbOb8CyEIr9HPqsvnxDla4bXYGYEViRIxE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Simon Horman <simon.horman@corigine.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 073/124] niu: Fix missing unwind goto in niu_alloc_channels()
Date:   Tue, 18 Apr 2023 14:21:32 +0200
Message-Id: <20230418120312.504117959@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120309.539243408@linuxfoundation.org>
References: <20230418120309.539243408@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

[ Upstream commit 8ce07be703456acb00e83d99f3b8036252c33b02 ]

Smatch reports: drivers/net/ethernet/sun/niu.c:4525
	niu_alloc_channels() warn: missing unwind goto?

If niu_rbr_fill() fails, then we are directly returning 'err' without
freeing the channels.

Fix this by changing direct return to a goto 'out_err'.

Fixes: a3138df9f20e ("[NIU]: Add Sun Neptune ethernet driver.")
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sun/niu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index 860644d182ab0..1a269fa8c1a07 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -4503,7 +4503,7 @@ static int niu_alloc_channels(struct niu *np)
 
 		err = niu_rbr_fill(np, rp, GFP_KERNEL);
 		if (err)
-			return err;
+			goto out_err;
 	}
 
 	tx_rings = kcalloc(num_tx_rings, sizeof(struct tx_ring_info),
-- 
2.39.2



