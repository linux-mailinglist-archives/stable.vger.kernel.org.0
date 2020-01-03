Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A78F12FCAF
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 19:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728372AbgACSlM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 13:41:12 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:39715 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728279AbgACSlM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jan 2020 13:41:12 -0500
Received: by mail-pl1-f193.google.com with SMTP id g6so16385341plp.6
        for <stable@vger.kernel.org>; Fri, 03 Jan 2020 10:41:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9D9VKvlmP4xcm6mxezMI2I1JZqbgHJUV5TDzvPDXAZc=;
        b=mOCzmArRiEdKbKLIV75kzBRFbotMbnbRqZiB6g3ozt1sF661siuhpBbbkMMLCGIMqA
         OcKQE0HBEVM6djbylxYWhWqetE46pLwjmu2ta0zO9/PFtu2DOz22Eh1JuZ5tghmTo22H
         YxxYXHdxS3dOxuIcSXUMFgDm15nC0XuwPylLY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9D9VKvlmP4xcm6mxezMI2I1JZqbgHJUV5TDzvPDXAZc=;
        b=NG6tT0LxjimZ2rUEvAJYZkD82lmSkcrDIEs6S+78aS+c3zHIX28M97mbW2MZ2Da1eK
         6wx2K2HKJLQ9z8tCq6xdSkcRz5gvtICDscDDWodn31RYActYCBK0kRgTHYpH9M2MSgXP
         ZQt46VgO82SDWwjFlrUGA/AOnHnpU6pNazSVJ2tvsC68PABsshkYJ4X/OQLGy0jNASNz
         Qg92wtrmXsTbpLiuuI80uch54Iv7Vdh2J6ARSLDZ6zyba0J/c7jCw6uYmaKQSD5o1Rj9
         2N532jCxCRHGxMbrQNa5+XOE3SYAy+Dg9ghqBWlM5CR/c/PmXbXYrimHcd9iXEWE2Ch6
         YESQ==
X-Gm-Message-State: APjAAAVzavhw6GiCmkDH9FAK3h64SzcKKjt56lVYTDxcm4ZaLb5GFAYV
        zHaJMyAJd9F5HIJe9WuQb2Ul3g==
X-Google-Smtp-Source: APXvYqwfOLQ/OQ5FETpgrQxvjhXZ82bQ04yNryRwdwQ2sYGhyU7RRcf9EXByhH4WUopQW4J4aVz8Ig==
X-Received: by 2002:a17:902:fe8b:: with SMTP id x11mr85211967plm.83.1578076871842;
        Fri, 03 Jan 2020 10:41:11 -0800 (PST)
Received: from localhost ([2620:15c:202:201:bfdf:e7dd:b034:6ac7])
        by smtp.gmail.com with ESMTPSA id q63sm45907923pfb.149.2020.01.03.10.41.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jan 2020 10:41:11 -0800 (PST)
From:   Daniel Verkamp <dverkamp@chromium.org>
To:     virtualization@lists.linux-foundation.org
Cc:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Daniel Verkamp <dverkamp@chromium.org>, stable@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH v2 2/2] virtio-pci: check name when counting MSI-X vectors
Date:   Fri,  3 Jan 2020 10:40:45 -0800
Message-Id: <20200103184044.73568-2-dverkamp@chromium.org>
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
In-Reply-To: <20200103184044.73568-1-dverkamp@chromium.org>
References: <20200103184044.73568-1-dverkamp@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

VQs without a name specified are not valid; they are skipped in the
later loop that assigns MSI-X vectors to queues, but the per_vq_vectors
loop above that counts the required number of vectors previously still
counted any queue with a non-NULL callback as needing a vector.

Add a check to the per_vq_vectors loop so that vectors with no name are
not counted to make the two loops consistent.  This prevents
over-counting unnecessary vectors (e.g. for features which were not
negotiated with the device).

Cc: stable@vger.kernel.org
Fixes: 86a559787e6f ("virtio-balloon: VIRTIO_BALLOON_F_FREE_PAGE_HINT")
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Daniel Verkamp <dverkamp@chromium.org>
---

v1:
https://lists.linuxfoundation.org/pipermail/virtualization/2019-December/044828.html

 drivers/virtio/virtio_pci_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
index f2862f66c2ac..222d630c41fc 100644
--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -294,7 +294,7 @@ static int vp_find_vqs_msix(struct virtio_device *vdev, unsigned nvqs,
 		/* Best option: one for change interrupt, one per vq. */
 		nvectors = 1;
 		for (i = 0; i < nvqs; ++i)
-			if (callbacks[i])
+			if (names[i] && callbacks[i])
 				++nvectors;
 	} else {
 		/* Second best: one for change, shared for all vqs. */
-- 
2.24.1.735.g03f4e72817-goog

