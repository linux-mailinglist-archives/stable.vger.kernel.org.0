Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 859904ABAA5
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383975AbiBGLYS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:24:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376872AbiBGLPQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:15:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21633C0401F2;
        Mon,  7 Feb 2022 03:14:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 174F76113B;
        Mon,  7 Feb 2022 11:14:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF8F7C340F0;
        Mon,  7 Feb 2022 11:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232491;
        bh=+xFqXhiOYB6EBvF7+DEQtDi3iSvbToZdWSF+mNcRdGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fw3rNBdGCwigApkZM8cVFyqWVeG5Y1MkXGrTBwOmzZ8UJJ/WdfbQ0cpdC51iC2E8f
         5u5V1sXdQvn0uWCI0h72edD4/BBw+KQabE7Gpk2MOoTQcCmtjuc3SxA+b/rJ+FixV3
         dNF6kORK6pkKyZ1bXZtUIOmXHD43X5pTHu8s/0yg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Christian Gmeiner <christian.gmeiner@gmail.com>
Subject: [PATCH 4.19 07/86] drm/etnaviv: relax submit size limits
Date:   Mon,  7 Feb 2022 12:05:30 +0100
Message-Id: <20220207103757.797933402@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103757.550973048@linuxfoundation.org>
References: <20220207103757.550973048@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Lucas Stach <l.stach@pengutronix.de>

commit e3d26528e083e612314d4dcd713f3d5a26143ddc upstream.

While all userspace tried to limit commandstreams to 64K in size,
a bug in the Mesa driver lead to command streams of up to 128K
being submitted. Allow those to avoid breaking existing userspace.

Fixes: 6dfa2fab8ddd ("drm/etnaviv: limit submit sizes")
Cc: stable@vger.kernel.org
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Reviewed-by: Christian Gmeiner <christian.gmeiner@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c
@@ -444,8 +444,8 @@ int etnaviv_ioctl_gem_submit(struct drm_
 		return -EINVAL;
 	}
 
-	if (args->stream_size > SZ_64K || args->nr_relocs > SZ_64K ||
-	    args->nr_bos > SZ_64K || args->nr_pmrs > 128) {
+	if (args->stream_size > SZ_128K || args->nr_relocs > SZ_128K ||
+	    args->nr_bos > SZ_128K || args->nr_pmrs > 128) {
 		DRM_ERROR("submit arguments out of size limits\n");
 		return -EINVAL;
 	}


