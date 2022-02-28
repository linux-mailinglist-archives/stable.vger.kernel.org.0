Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2B94C75D6
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239373AbiB1R4l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:56:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240799AbiB1Ryp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:54:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7684053727;
        Mon, 28 Feb 2022 09:43:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D269B81366;
        Mon, 28 Feb 2022 17:43:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76707C340F1;
        Mon, 28 Feb 2022 17:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070234;
        bh=VcvQDz9VZtmgeBdwB1Xfn3XxoSMMVM530yEXxV6FkUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=THjvHQ6Fgdp30K2QILM9Nql8KDOXWD0zRC9DQoVjJzoK/3NquNF2HkXNKSRdoO/iC
         BIDs3X0APOefL/1MY40GMtCy4Wn4rO8ZPYbTq91/AkOPDceEXRMma8HaJNgcbRS1vt
         QxtnIIs4ls12ToDC7uFGOX+IAl/jBGn/kj9BASDg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikko Perttunen <mperttunen@nvidia.com>,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH 5.16 035/164] gpu: host1x: Always return syncpoint value when waiting
Date:   Mon, 28 Feb 2022 18:23:17 +0100
Message-Id: <20220228172403.442823527@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikko Perttunen <mperttunen@nvidia.com>

commit 184b58fa816fb5ee1854daf0d430766422bf2a77 upstream.

The new TegraDRM UAPI uses syncpoint waiting with timeout set to
zero to indicate reading the syncpoint value. To support that we
need to return the syncpoint value always when waiting.

Fixes: 44e961381354 ("drm/tegra: Implement syncpoint wait UAPI")
Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/host1x/syncpt.c |   19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

--- a/drivers/gpu/host1x/syncpt.c
+++ b/drivers/gpu/host1x/syncpt.c
@@ -225,27 +225,12 @@ int host1x_syncpt_wait(struct host1x_syn
 	void *ref;
 	struct host1x_waitlist *waiter;
 	int err = 0, check_count = 0;
-	u32 val;
 
 	if (value)
-		*value = 0;
-
-	/* first check cache */
-	if (host1x_syncpt_is_expired(sp, thresh)) {
-		if (value)
-			*value = host1x_syncpt_load(sp);
+		*value = host1x_syncpt_load(sp);
 
+	if (host1x_syncpt_is_expired(sp, thresh))
 		return 0;
-	}
-
-	/* try to read from register */
-	val = host1x_hw_syncpt_load(sp->host, sp);
-	if (host1x_syncpt_is_expired(sp, thresh)) {
-		if (value)
-			*value = val;
-
-		goto done;
-	}
 
 	if (!timeout) {
 		err = -EAGAIN;


