Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 872775A4864
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbiH2LJf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231236AbiH2LI4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:08:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C5D5924F;
        Mon, 29 Aug 2022 04:06:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8ED3AB80EE6;
        Mon, 29 Aug 2022 11:04:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4AA0C433C1;
        Mon, 29 Aug 2022 11:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771049;
        bh=ZY+39YoS1KQ/nzpx8QF2bN9pbwC5e8JdY3tGQteHWLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b7BfGu7EnvfzX3hJYsoKDyDtb70IOKhGL3EgMssHNPF+9cMdNlcpJWYk0YkRl1+Xl
         z+EjNSmxqEwvn09hNBTBHB5h1JT3ah7iYy29yClw7kJi3xCmtLRqBd+NzJTTyOUEYo
         6fZVceJuYeGwCk7wE7K08ANM8b11WVsllkU1TabY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Antony Antony <antony.antony@secunet.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 13/86] xfrm: clone missing x->lastused in xfrm_do_migrate
Date:   Mon, 29 Aug 2022 12:58:39 +0200
Message-Id: <20220829105757.066188996@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105756.500128871@linuxfoundation.org>
References: <20220829105756.500128871@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antony Antony <antony.antony@secunet.com>

[ Upstream commit 6aa811acdb76facca0b705f4e4c1d948ccb6af8b ]

x->lastused was not cloned in xfrm_do_migrate. Add it to clone during
migrate.

Fixes: 80c9abaabf42 ("[XFRM]: Extension for dynamic update of endpoint address(es)")
Signed-off-by: Antony Antony <antony.antony@secunet.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_state.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index bc0bbb1571cef..fdbd56ed4bd52 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1557,6 +1557,7 @@ static struct xfrm_state *xfrm_state_clone(struct xfrm_state *orig,
 	x->replay = orig->replay;
 	x->preplay = orig->preplay;
 	x->mapping_maxage = orig->mapping_maxage;
+	x->lastused = orig->lastused;
 	x->new_mapping = 0;
 	x->new_mapping_sport = 0;
 
-- 
2.35.1



