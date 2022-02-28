Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0004C74B6
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:45:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237748AbiB1RqX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:46:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240013AbiB1Ro6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:44:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24CD427CE4;
        Mon, 28 Feb 2022 09:37:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3EABE61357;
        Mon, 28 Feb 2022 17:37:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59A3AC340E7;
        Mon, 28 Feb 2022 17:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069850;
        bh=VcvQDz9VZtmgeBdwB1Xfn3XxoSMMVM530yEXxV6FkUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yl03wHa/ZF6x6CLXBIK4TukTQQtkNVaD/lr9bEREQxQq9Fa0zBVy+JaESYjNT+cNE
         Ok8Zb0C0YPpd+fMMO5VJq+nnGQow6JpbWjbmugkAqytIS1HvuCthceSipDHlLRukM8
         vWU4R16SvayNpb62JINqNuZKfl3FoXU63mv+XvAo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikko Perttunen <mperttunen@nvidia.com>,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH 5.15 034/139] gpu: host1x: Always return syncpoint value when waiting
Date:   Mon, 28 Feb 2022 18:23:28 +0100
Message-Id: <20220228172351.358052186@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
References: <20220228172347.614588246@linuxfoundation.org>
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


