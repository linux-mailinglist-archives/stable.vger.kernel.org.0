Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7465A4B28
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 14:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231361AbiH2MLQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 08:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiH2MK5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 08:10:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7EC217E3A;
        Mon, 29 Aug 2022 04:56:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32D2EB80F9D;
        Mon, 29 Aug 2022 11:08:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CC2FC433D6;
        Mon, 29 Aug 2022 11:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771299;
        bh=XVBy5YYAmZTabxphfrc07k0GOwcNROcUKNUHewQpHg8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J1QRJoc/bGnH7XuTzZ8M1bJvQsZkXD3p5UaBo/L/V9OTk/VyYKSQrTG1Vk7Q/acM3
         6XCgtCrP1DXJi9uBkus4HyoWwZhIn2cj/UgDP3m/R1mNbi7/PqL9voTpHTllbT+MfQ
         rKqIQ/j76GT4TrVAJYL8FUA1R2NuNziP629NAcB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Antony Antony <antony.antony@secunet.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 014/158] xfrm: clone missing x->lastused in xfrm_do_migrate
Date:   Mon, 29 Aug 2022 12:57:44 +0200
Message-Id: <20220829105809.408012384@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
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
index ccfb172eb5b8d..11d89af9cb55a 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1592,6 +1592,7 @@ static struct xfrm_state *xfrm_state_clone(struct xfrm_state *orig,
 	x->replay = orig->replay;
 	x->preplay = orig->preplay;
 	x->mapping_maxage = orig->mapping_maxage;
+	x->lastused = orig->lastused;
 	x->new_mapping = 0;
 	x->new_mapping_sport = 0;
 
-- 
2.35.1



