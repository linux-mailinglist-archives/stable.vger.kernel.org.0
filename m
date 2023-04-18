Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FBCB6E6155
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbjDRMZB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbjDRMY7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:24:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B05065BF
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:24:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9648630FD
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:24:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFF2AC433EF;
        Tue, 18 Apr 2023 12:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681820672;
        bh=imV8i/zCboZoDMuSamyBCvXl0jVvq4qvjGP8Fz9tUU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=evNOmj+2M3DMzJoKsrrbQJIOYr49ObQ+iBNTeNRscrg366FlWEiMmRQzQQOP43cO1
         m/0P+9PMVcizszmdCAKhbg+Qsxgy6fi/MTKQG2Lx5Od3xh2o1EDk2rWcw1vvTttdpj
         ZwHSzmb7Y8UyW17r8PmSmWCE8tJXNWA22X2H2N1k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Simon Horman <simon.horman@corigine.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 25/37] niu: Fix missing unwind goto in niu_alloc_channels()
Date:   Tue, 18 Apr 2023 14:21:35 +0200
Message-Id: <20230418120255.558708922@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120254.687480980@linuxfoundation.org>
References: <20230418120254.687480980@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
index 7ba9cad183414..08ac19884133b 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -4520,7 +4520,7 @@ static int niu_alloc_channels(struct niu *np)
 
 		err = niu_rbr_fill(np, rp, GFP_KERNEL);
 		if (err)
-			return err;
+			goto out_err;
 	}
 
 	tx_rings = kcalloc(num_tx_rings, sizeof(struct tx_ring_info),
-- 
2.39.2



