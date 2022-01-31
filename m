Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C03C64A4354
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359210AbiAaLU5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:20:57 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37162 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376407AbiAaLRY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:17:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9DF24B82A64;
        Mon, 31 Jan 2022 11:17:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6FD0C340E8;
        Mon, 31 Jan 2022 11:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627842;
        bh=hIkFO2I3lmGEmGDltcRJMnRhfcQ7QQuEO3j2VNgMPQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qNJcTl0GlLje5UnFE0yH5OPABQpI3zFuCKfnWQbOxnJhG2iCy72mDhZM5LXgyw2Yq
         3Xwt3z0albRl2+ZtFBmdsY1xSbI701koQ380KVGbW+uUFMyFL05DaQQlNFSxuxc6v2
         1f1Q9vkvqrlBpCqmI9yrqqrwkxi9QcnNjzaWReuk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Christian Gmeiner <christian.gmeiner@gmail.com>
Subject: [PATCH 5.16 042/200] drm/etnaviv: relax submit size limits
Date:   Mon, 31 Jan 2022 11:55:05 +0100
Message-Id: <20220131105234.971770332@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
@@ -469,8 +469,8 @@ int etnaviv_ioctl_gem_submit(struct drm_
 		return -EINVAL;
 	}
 
-	if (args->stream_size > SZ_64K || args->nr_relocs > SZ_64K ||
-	    args->nr_bos > SZ_64K || args->nr_pmrs > 128) {
+	if (args->stream_size > SZ_128K || args->nr_relocs > SZ_128K ||
+	    args->nr_bos > SZ_128K || args->nr_pmrs > 128) {
 		DRM_ERROR("submit arguments out of size limits\n");
 		return -EINVAL;
 	}


