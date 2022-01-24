Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40999498D05
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:33:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351522AbiAXT1T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:27:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346817AbiAXTXY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:23:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE457C061243;
        Mon, 24 Jan 2022 11:10:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FC1B60918;
        Mon, 24 Jan 2022 19:10:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A7BBC340E5;
        Mon, 24 Jan 2022 19:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051405;
        bh=6yxjCLmz7FOBlTE/Tsexre3Bd4vbdy6BP/CvZlsRvK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xmiexJpiZXLqlVVSE05+l5LykwRZJQwquEB9IaZo3SOx3nA5tJCLFFaAQjvoj7bBy
         zwh/zMLjejq1xwCFTFMDPxnFbANJkb8aReadWsCHTKP2R+S4L/EJspDDv73qCCmXsh
         vYh4rfTPRDugeUPMqJKqozdjFxPY9vbEc4Qhm32M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Christian Gmeiner <christian.gmeiner@gmail.com>
Subject: [PATCH 4.14 152/186] drm/etnaviv: limit submit sizes
Date:   Mon, 24 Jan 2022 19:43:47 +0100
Message-Id: <20220124183941.992828598@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183937.101330125@linuxfoundation.org>
References: <20220124183937.101330125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Stach <l.stach@pengutronix.de>

commit 6dfa2fab8ddd46faa771a102672176bee7a065de upstream.

Currently we allow rediculous amounts of kernel memory being allocated
via the etnaviv GEM_SUBMIT ioctl, which is a pretty easy DoS vector. Put
some reasonable limits in to fix this.

The commandstream size is limited to 64KB, which was already a soft limit
on older kernels after which the kernel only took submits on a best effort
base, so there is no userspace that tries to submit commandstreams larger
than this. Even if the whole commandstream is a single incrementing address
load, the size limit also limits the number of potential relocs and
referenced buffers to slightly under 64K, so use the same limit for those
arguments. The performance monitoring infrastructure currently supports
less than 50 performance counter signals, so limiting them to 128 on a
single submit seems like a reasonably future-proof number for now. This
number can be bumped if needed without breaking the interface.

Cc: stable@vger.kernel.org
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Reviewed-by: Christian Gmeiner <christian.gmeiner@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c
@@ -341,6 +341,12 @@ int etnaviv_ioctl_gem_submit(struct drm_
 		return -EINVAL;
 	}
 
+	if (args->stream_size > SZ_64K || args->nr_relocs > SZ_64K ||
+	    args->nr_bos > SZ_64K || args->nr_pmrs > 128) {
+		DRM_ERROR("submit arguments out of size limits\n");
+		return -EINVAL;
+	}
+
 	/*
 	 * Copy the command submission and bo array to kernel space in
 	 * one go, and do this outside of any locks.


