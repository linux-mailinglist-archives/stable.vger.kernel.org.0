Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4422433E5
	for <lists+stable@lfdr.de>; Thu, 13 Aug 2020 08:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726244AbgHMGVT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Aug 2020 02:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726192AbgHMGVS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Aug 2020 02:21:18 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70CBBC061757;
        Wed, 12 Aug 2020 23:21:18 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id t23so4927940ljc.3;
        Wed, 12 Aug 2020 23:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=C9rQWo6syT3cF37ubQbW7IMBpmbXyJ1+Ny4Hmm3+D9g=;
        b=IdrdS+jhl4Oa2APlUEh5hsmWHLnjlvcEeLbNwd/9wCAajQpSXHE0zHJiFdgcdiK26J
         WFO1pugdzNj04qdFOagFuIp86Sv+478MpJWML1/H1kFhojn/ZOWrcGdudLoSBrsxQlzR
         EcAC59A3E3nwwwp9ENtv3ctQM7YTyIq69C2d3wIoR6R4PQMfsF7LGC2lLBut5bKO3Zu/
         4WoL1gVFon0Xdx/deulTB/UQkk/ztsecEql/JO68s3NP1mEPDzfT/LNeQz9VllyIv0PT
         9Tj8AssK9SOO8AwcvjXm8WGOQKyaIJFbORNO4CgMimKGYH01+Ebjmr55PZr3TuSs8iQd
         jupg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=C9rQWo6syT3cF37ubQbW7IMBpmbXyJ1+Ny4Hmm3+D9g=;
        b=WtgnzLvqqWqZnrjILqTcDglSxU4ppYZL3X68FCFQS7LwVAAT5EBRwtxZMTTZdk1M9K
         9lAKTF1KzSxl5N1RUuFQqPn5eGkpcYjqoXcPqjLfQYLvkkOxOaV6aoD1QoDXnLe4Gyf+
         Q85Ukd2+3sJGRpADmWPXL4wi05grGDQydKsbWsTfYi9CK4gqcfs5NTnYnW5qAc7LgTCq
         mGsvL+vEPYPYO37/8uAtA5fHH7q+hUPlcK8fqYTkEB8CHgP3yRKZeY3y9pm8HTKpfhVv
         cvRvE1hJAbVI/bAvZJKp1SaL014lvkHUv6OT4aJyGX9tZ1mUm3P6mm8cs1WEbtjFnATT
         5lOg==
X-Gm-Message-State: AOAM530WIYNmiPw6HP/MhJtwLvprnEAl2bCG6FHdEY5j69MN1VGhVo7q
        jEuwQYKYZHrYHPtbMVIO+S0=
X-Google-Smtp-Source: ABdhPJw/Ec8BtgwxAUxLq9z6Cta34KMASOkvjBC0EU4THFS9zVDqv01yrhycLJUzJXCaRxXFKv6jLg==
X-Received: by 2002:a2e:8098:: with SMTP id i24mr1308903ljg.50.1597299676613;
        Wed, 12 Aug 2020 23:21:16 -0700 (PDT)
Received: from a2klaptop.localdomain ([185.199.97.5])
        by smtp.gmail.com with ESMTPSA id f14sm964060lfd.2.2020.08.12.23.21.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2020 23:21:16 -0700 (PDT)
From:   Oleksandr Andrushchenko <andr2000@gmail.com>
To:     xen-devel@lists.xenproject.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, boris.ostrovsky@oracle.com,
        jgross@suse.com, airlied@linux.ie, daniel@ffwll.ch
Cc:     sstabellini@kernel.org, dan.carpenter@oracle.com,
        intel-gfx@lists.freedesktop.org,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 1/5] xen/gntdev: Fix dmabuf import with non-zero sgt offset
Date:   Thu, 13 Aug 2020 09:21:09 +0300
Message-Id: <20200813062113.11030-2-andr2000@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200813062113.11030-1-andr2000@gmail.com>
References: <20200813062113.11030-1-andr2000@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>

It is possible that the scatter-gather table during dmabuf import has
non-zero offset of the data, but user-space doesn't expect that.
Fix this by failing the import, so user-space doesn't access wrong data.

Fixes: bf8dc55b1358 ("xen/gntdev: Implement dma-buf import functionality")

Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
Acked-by: Juergen Gross <jgross@suse.com>
Cc: <stable@vger.kernel.org>
---
 drivers/xen/gntdev-dmabuf.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/xen/gntdev-dmabuf.c b/drivers/xen/gntdev-dmabuf.c
index 75d3bb948bf3..b1b6eebafd5d 100644
--- a/drivers/xen/gntdev-dmabuf.c
+++ b/drivers/xen/gntdev-dmabuf.c
@@ -613,6 +613,14 @@ dmabuf_imp_to_refs(struct gntdev_dmabuf_priv *priv, struct device *dev,
 		goto fail_detach;
 	}
 
+	/* Check that we have zero offset. */
+	if (sgt->sgl->offset) {
+		ret = ERR_PTR(-EINVAL);
+		pr_debug("DMA buffer has %d bytes offset, user-space expects 0\n",
+			 sgt->sgl->offset);
+		goto fail_unmap;
+	}
+
 	/* Check number of pages that imported buffer has. */
 	if (attach->dmabuf->size != gntdev_dmabuf->nr_pages << PAGE_SHIFT) {
 		ret = ERR_PTR(-EINVAL);
-- 
2.17.1

