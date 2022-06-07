Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72A77540B11
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350617AbiFGSYu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352052AbiFGSQw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:16:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B68C3737B6;
        Tue,  7 Jun 2022 10:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55D1A6172E;
        Tue,  7 Jun 2022 17:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C56C34119;
        Tue,  7 Jun 2022 17:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624219;
        bh=mDFz1Qi4GnqNJH6WQQ+Dvts8B4pXR9evP9/but+/NqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P1k5ZU7aR4flCVCGwvrCN7QthvFHpzaAQsKqF9aAGhhxphyecFLWc21jGqkts9UxT
         g6bZMpAF2EQY+E3HNFQvM+ygHXujyj9p8s+rEscqlywcjNg47w32YHZ/xhTUdntnwC
         BzqbphCH/312cW3F1RwX50qaszuicvxR4p+61+4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 247/667] of: overlay: do not break notify on NOTIFY_{OK|STOP}
Date:   Tue,  7 Jun 2022 18:58:32 +0200
Message-Id: <20220607164942.193242384@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nuno Sá <nuno.sa@analog.com>

[ Upstream commit 5f756a2eaa4436d7d3dc1e040147f5e992ae34b5 ]

We should not break overlay notifications on NOTIFY_{OK|STOP}
otherwise we might break on the first fragment. We should only stop
notifications if a *real* errno is returned by one of the listeners.

Fixes: a1d19bd4cf1fe ("of: overlay: pr_err from return NOTIFY_OK to overlay apply/remove")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20220420130205.89435-1-nuno.sa@analog.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/overlay.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/of/overlay.c b/drivers/of/overlay.c
index d80160cf34bb..d1187123c4fc 100644
--- a/drivers/of/overlay.c
+++ b/drivers/of/overlay.c
@@ -170,9 +170,7 @@ static int overlay_notify(struct overlay_changeset *ovcs,
 
 		ret = blocking_notifier_call_chain(&overlay_notify_chain,
 						   action, &nd);
-		if (ret == NOTIFY_OK || ret == NOTIFY_STOP)
-			return 0;
-		if (ret) {
+		if (notifier_to_errno(ret)) {
 			ret = notifier_to_errno(ret);
 			pr_err("overlay changeset %s notifier error %d, target: %pOF\n",
 			       of_overlay_action_name[action], ret, nd.target);
-- 
2.35.1



