Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 853B71021DE
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 11:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727545AbfKSKSY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 05:18:24 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:32551 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727527AbfKSKSW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 05:18:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574158700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Acfch5/VhpABhLUFIhseap39qLoWtZkvUtr0T0hX2Tk=;
        b=YTuPQtqhN+ZGhxojIIczx2/CnL0IaqU8s8s+4FN/IXT4dc5hc/rWz3lyGtoGFFKsmO/FIK
        xht5Sgt0f9xr4iWF/DusW5Rsadfs5TQX3pGlOQlPjx1P3sVIPGDew9HJLLo8rRUwF12CtZ
        Tc81mpAUjm74ER/tGeWR9VRewO7n1tI=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-5CBZG_68NfG0wNxTPPRbug-1; Tue, 19 Nov 2019 05:18:17 -0500
Received: by mail-qt1-f200.google.com with SMTP id r12so14272865qtp.21
        for <stable@vger.kernel.org>; Tue, 19 Nov 2019 02:18:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=lnS0JzaPkUj+IPb87pokVT4FioI7ddK6q2VS+pup+Kg=;
        b=nfHFZEL/f9tVQLlnCUMQTipMOsq6GPJD2sYjqZJou5lg0Sm6YQX9F8XBIPO84vcqDY
         AokkMvdQPjBqpv8+6dI+8w5dujHeKShqjCv3PEiYSkFqY6dBZGScMJNFKTy3FeKwBD5v
         mDMLMryr5auoJ2xuzd/DyC/Oghu4MjycN9pKVNAHFG/+cWENui0oE7unFO945RgXydYU
         0/ignmYXeMtUrZHAIIxsZipP9Sd1Nwiz5XfArIvam6BgJMs2BpjlidX8j48b5ntTnUtL
         tkR18rlb0kKZo97x5ojX6MT9leBarlDm0fhN3M8XRu2zz96wvqJycTKXZE+4zmGAHRfu
         FA3Q==
X-Gm-Message-State: APjAAAUohHajY7d4i7pwhQOJbX/TTQZ30Rpo3Fbsm8cz1XCcl/3K1ZE/
        gTOBZjj5OhX//zlEqquymMX/1bUW+00cpyPLXFUDpDM8U+XlCUYS8FXfo5d7FIEtqjeuxCGuN/2
        Dw/Uo2FwASv/sMsGh
X-Received: by 2002:ac8:1858:: with SMTP id n24mr30075096qtk.334.1574158696936;
        Tue, 19 Nov 2019 02:18:16 -0800 (PST)
X-Google-Smtp-Source: APXvYqx+dUL5IV3PXYYvDTgXAOYgSLkn41lPvbWu5SefSFOoDcbaD+Kokj9abjYPen65I3ZyFIPGuQ==
X-Received: by 2002:ac8:1858:: with SMTP id n24mr30075089qtk.334.1574158696782;
        Tue, 19 Nov 2019 02:18:16 -0800 (PST)
Received: from redhat.com (bzq-79-176-6-42.red.bezeqint.net. [79.176.6.42])
        by smtp.gmail.com with ESMTPSA id b54sm12516736qta.38.2019.11.19.02.18.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 02:18:16 -0800 (PST)
Date:   Tue, 19 Nov 2019 05:18:12 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Wei Wang <wei.w.wang@intel.com>, stable@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH] virtio_balloon: fix shrinker count
Message-ID: <20191119101745.39038-1-mst@redhat.com>
MIME-Version: 1.0
X-Mailer: git-send-email 2.22.0.678.g13338e74b8
X-Mutt-Fcc: =sent
X-MC-Unique: 5CBZG_68NfG0wNxTPPRbug-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Wang <wei.w.wang@intel.com>

Instead of multiplying by page order, virtio balloon divided by page
order. The result is that it can often return 0 if there are a bit less
than MAX_ORDER - 1 pages in use, and then shrinker scan won't be called.

Cc: stable@vger.kernel.org
Fixes: 71994620bb25 ("virtio_balloon: replace oom notifier with shrinker")
Signed-off-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/virtio/virtio_balloon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloo=
n.c
index 7cee05cdf3fb..65df40f261ab 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -825,7 +825,7 @@ static unsigned long virtio_balloon_shrinker_count(stru=
ct shrinker *shrinker,
 =09unsigned long count;
=20
 =09count =3D vb->num_pages / VIRTIO_BALLOON_PAGES_PER_PAGE;
-=09count +=3D vb->num_free_page_blocks >> VIRTIO_BALLOON_FREE_PAGE_ORDER;
+=09count +=3D vb->num_free_page_blocks << VIRTIO_BALLOON_FREE_PAGE_ORDER;
=20
 =09return count;
 }
--=20
MST

