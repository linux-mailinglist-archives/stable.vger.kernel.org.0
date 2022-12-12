Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BCB864A22F
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:50:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232959AbiLLNuk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:50:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232967AbiLLNtz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:49:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04C15E8F
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:49:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC3C4B80D50
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:49:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4187C433EF;
        Mon, 12 Dec 2022 13:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852978;
        bh=2AmPHVVhxCRaZVaP0G8xuglUrWzwb8H8vng6wlOQKPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DnrW9QIWMjynj87YiR6kE7NwJhaMOLDVe5oWJcKXQOXSyBavXjj1MQrrTvmpPozNI
         CxgyuWPmV2V2wJWVHBGugF5M+FS8km5OUdy3QDaImml1BwRdsddv6+y8UUMyR5WsHV
         qUv03pMPZ/1Y4Vldwl+GNJuCmNhBFrUnIByEsp+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <error27@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 34/49] net: mvneta: Prevent out of bounds read in mvneta_config_rss()
Date:   Mon, 12 Dec 2022 14:19:12 +0100
Message-Id: <20221212130915.349784558@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130913.666185567@linuxfoundation.org>
References: <20221212130913.666185567@linuxfoundation.org>
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

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit e8b4fc13900b8e8be48debffd0dfd391772501f7 ]

The pp->indir[0] value comes from the user.  It is passed to:

	if (cpu_online(pp->rxq_def))

inside the mvneta_percpu_elect() function.  It needs bounds checkeding
to ensure that it is not beyond the end of the cpu bitmap.

Fixes: cad5d847a093 ("net: mvneta: Fix the CPU choice in mvneta_percpu_elect")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 382d010e1294..5107382cefb5 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -4141,6 +4141,9 @@ static int  mvneta_config_rss(struct mvneta_port *pp)
 		napi_disable(&pp->napi);
 	}
 
+	if (pp->indir[0] >= nr_cpu_ids)
+		return -EINVAL;
+
 	pp->rxq_def = pp->indir[0];
 
 	/* Update unicast mapping */
-- 
2.35.1



