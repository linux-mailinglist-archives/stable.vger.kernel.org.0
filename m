Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE53D498A79
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344708AbiAXTEK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:04:10 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58958 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344722AbiAXTCB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:02:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE2E8B8123F;
        Mon, 24 Jan 2022 19:01:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E5DC340E5;
        Mon, 24 Jan 2022 19:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050917;
        bh=HiMokRcWVrkWobPHLR9Q0PWQ6ThwoWIl6UQONrxaaJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Idna65wm5caU5zLWG2RQ4s1u1fQci000oWjIEWhFHFOpwbUL1rQ3E2chFr/kNQtFM
         pHpKSVerWno8JUpMfM1tsmIxE1eYNEaAAaDy29RTFMYRBehzRqL4nauWxPOIz7uPE1
         +UDSIhZaFu3YbgVFbDdnz/5IF1MHHkjZeYV490zk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Christian Gmeiner <christian.gmeiner@gmail.com>
Subject: [PATCH 4.9 121/157] drm/etnaviv: limit submit sizes
Date:   Mon, 24 Jan 2022 19:43:31 +0100
Message-Id: <20220124183936.614611281@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183932.787526760@linuxfoundation.org>
References: <20220124183932.787526760@linuxfoundation.org>
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
@@ -325,6 +325,12 @@ int etnaviv_ioctl_gem_submit(struct drm_
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


