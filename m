Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC6E5419FF
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378891AbiFGV1e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:27:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379130AbiFGVZO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:25:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2899A150B6F;
        Tue,  7 Jun 2022 12:01:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C070AB82391;
        Tue,  7 Jun 2022 19:01:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BEA2C385A2;
        Tue,  7 Jun 2022 19:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628498;
        bh=mDFz1Qi4GnqNJH6WQQ+Dvts8B4pXR9evP9/but+/NqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dQzKWwyFAPL/brqkNRqA5N5RV5AGJW/NQ5bi5NyJ5HA9dYwNEyfufTl1q/o7dGZux
         mBZb7fqfInuqHPZYQgMHpf5caHfSjadfp956G1D5Rkv+QASQ7TZmAduYr2TyBmWp1a
         p285EU09exYKjLl6hvlMKcS6PVb4L2X1xj/PG95g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 351/879] of: overlay: do not break notify on NOTIFY_{OK|STOP}
Date:   Tue,  7 Jun 2022 18:57:49 +0200
Message-Id: <20220607165013.049725782@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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



