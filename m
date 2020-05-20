Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 580B61DAFBC
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 12:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgETKLq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 06:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbgETKLp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 06:11:45 -0400
Received: from mail-lf1-x164.google.com (mail-lf1-x164.google.com [IPv6:2a00:1450:4864:20::164])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B038C061A0E
        for <stable@vger.kernel.org>; Wed, 20 May 2020 03:11:43 -0700 (PDT)
Received: by mail-lf1-x164.google.com with SMTP id c12so1935087lfc.10
        for <stable@vger.kernel.org>; Wed, 20 May 2020 03:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flowbird.group; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=yp51Q0sOB5VzCHGDErAd468gZKoo7fbqGFyeoX1zhRY=;
        b=ThEl8Oxvvu2EpOgExjI1uw9IJaWrOTyN6TeoIOAx66gl8ZXbMJfUAKKMeLsAnRwDKe
         9+61cEz99V0JnrapuBITGj08OB2JjzLIQmmHGMvzul/KNjYnomamrTG45VavwijuJAaX
         fnTCW+XQdTt7EzgQQitb7oA966p5UrUDMKCFjcOHlPn8zuejMQ/l6Oko6ApauFyyJKyD
         /OnfLeowMAHn9WlDNpsbv/K4GwI8Tk0t9MfetoG5KNcPHHJtLbIG4GKXqS/5gjBOQe/H
         YDmm+DvGX+3VBGHnrFJdhzqGZFyOX/d4IeO70/MdrJtL6P//p4z6i7yuesLlLI8yoZsV
         D1Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=yp51Q0sOB5VzCHGDErAd468gZKoo7fbqGFyeoX1zhRY=;
        b=mCPi/xhnC9R1ub1ccyOtmrLhUEZbHTpfJmPkgySsbZOwgCp+JIc2jfH2boQy4Ks3kS
         mRC+d3I6oqMjsQz4MSFt8+ywBa3dWMuOzPdZBou7ZA+32mgAgwcvbAeqxSyKSVzSCY7m
         VaqQbiQefqnVq1HcOrYJoqvdz0kgVY6LJij5oEaNu1QOpGbceBeoolVfXBvWWFwZbwaS
         g8PR++gPIGcgpvwi+9x6J6mdwKjmCbsriyVlk/IZ9WgAlLOLVs7CbfeeYdI71AkHqA5i
         VEnVKk8MX4DSgFxRCqOnXsvnkafe67iCmPU8OwnuYTzlSF0Bqs859ExBEYDxwFRWbxvx
         9+eA==
X-Gm-Message-State: AOAM532nI5R7EYFMe9zpLoswmpSvN+RiYrWDt6D3NaS92UvtcrR5ArHu
        wZTUSmCS84+ylgM+UJG9UBrTj6ILlU0yyaAGsXCz1tTEmGvL
X-Google-Smtp-Source: ABdhPJy2NKKbUt6o8dwz2I3/kDRRKV+s2TFbEoOUyNC+W7l4M+gSyIhS7fKhPsOMazs4jPjQDBaXZWKDlgm3
X-Received: by 2002:a19:3855:: with SMTP id d21mr2248332lfj.156.1589969501504;
        Wed, 20 May 2020 03:11:41 -0700 (PDT)
Received: from mail.besancon.parkeon.com ([185.149.63.251])
        by smtp-relay.gmail.com with ESMTPS id a25sm12902lfl.26.2020.05.20.03.11.41
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Wed, 20 May 2020 03:11:41 -0700 (PDT)
X-Relaying-Domain: flowbird.group
Received: from [172.16.13.226] (port=44934 helo=PC12445-BES.dynamic.besancon.parkeon.com)
        by mail.besancon.parkeon.com with esmtp (Exim 4.71)
        (envelope-from <martin.fuzzey@flowbird.group>)
        id 1jbLhM-0001dH-QH; Wed, 20 May 2020 12:11:40 +0200
From:   Martin Fuzzey <martin.fuzzey@flowbird.group>
To:     Lucas Stach <l.stach@pengutronix.de>
Cc:     stable@vger.kernel.org,
        Christian Gmeiner <christian.gmeiner@gmail.com>,
        etnaviv@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drm/etnaviv: fix memory leak when mapping prime imported buffers
Date:   Wed, 20 May 2020 12:10:02 +0200
Message-Id: <1589969500-6554-1-git-send-email-martin.fuzzey@flowbird.group>
X-Mailer: git-send-email 1.9.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When using mmap() on a prime imported buffer allocated by a
different driver (such as imx-drm) the later munmap() does
not correctly decrement the refcount of the original enaviv_gem_object,
leading to a leak.

Signed-off-by: Martin Fuzzey <martin.fuzzey@flowbird.group>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c b/drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c
index f24dd21..28a01b8 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c
@@ -93,7 +93,25 @@ static void *etnaviv_gem_prime_vmap_impl(struct etnaviv_gem_object *etnaviv_obj)
 static int etnaviv_gem_prime_mmap_obj(struct etnaviv_gem_object *etnaviv_obj,
 		struct vm_area_struct *vma)
 {
-	return dma_buf_mmap(etnaviv_obj->base.dma_buf, vma, 0);
+	int ret;
+
+	ret = dma_buf_mmap(etnaviv_obj->base.dma_buf, vma, 0);
+
+	/* drm_gem_mmap_obj() has already been called before this function
+	 * and has incremented our refcount, expecting it to be decremented
+	 * on unmap() via drm_gem_vm_close().
+	 * However dma_buf_mmap() invokes drm_gem_cma_prime_mmap()
+	 * that ends up updating the vma->vma_private_data to point to the
+	 * dma_buf's gem object.
+	 * Hence our gem object here will not have its refcount decremented
+	 * when userspace does unmap().
+	 * So decrement the refcount here to avoid a memory leak if the dma
+	 * buf mapping was successful.
+	 */
+	if (!ret)
+		drm_gem_object_put_unlocked(&etnaviv_obj->base);
+
+	return ret;
 }
 
 static const struct etnaviv_gem_ops etnaviv_gem_prime_ops = {
-- 
1.9.1

