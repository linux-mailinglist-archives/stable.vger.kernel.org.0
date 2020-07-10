Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27DE121B3FF
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 13:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728025AbgGJLbn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 07:31:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20216 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727901AbgGJLbm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jul 2020 07:31:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594380701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=5Ofr2MCGvPvfpwIdGlSnpSEf1nx+bNb0i5ZzaI9/r3g=;
        b=ea77Z4Rozl+oBx2N//ruO8G7A9G75ak3Inwg3JToKlffzcobwWScPB2HGLGZcf33DjwTar
        jerbmzPFL7PlAwB5vr9Mp6iCO8Bb1Buq0Gt4jdYPZzs+SlvLpAt8fU2sVUVfciWIskRQea
        F50Pep5csgXhBida/frXdI5iV6W7Pqo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-k9Frn0RCOVGcfvaVciYXsQ-1; Fri, 10 Jul 2020 07:31:39 -0400
X-MC-Unique: k9Frn0RCOVGcfvaVciYXsQ-1
Received: by mail-wm1-f69.google.com with SMTP id g124so6496158wmg.6
        for <stable@vger.kernel.org>; Fri, 10 Jul 2020 04:31:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=5Ofr2MCGvPvfpwIdGlSnpSEf1nx+bNb0i5ZzaI9/r3g=;
        b=jv1HW4o08auTEcQtaAugGVNP8WBOV3O/Z4TpOueDtsLfhu6nghC1Fv1hD7UQHkcQSY
         3iJGy3r/yP0STDATKnoZcBhbjz4J5ywyNWBdOamADH8AjCq0Odfkz7zHtToV1TGhvOtu
         lTdeMGQSSNNRjxUoiTGmEKPWW37Qw1mKchs4qgCW31HSJpTG0YliYKOJCYoUKPDLtl6e
         W5VCjhMRFjbFCBixnUPlNlvA7Q6umpzcqFYNrfX1WL5vmSkqFlP+umkxREaVtPEc+U7r
         2Ap/IQ2rQaFs3qJK0zJW/qzgwvtVM0Y+igwBBbqybEiG0Yi0Uvf4FMacpM8rGOUnY/Gc
         GJEw==
X-Gm-Message-State: AOAM530m/AU0VyCgOzX5Quxcg8NChMgW/Au1T8HzucSfSc8BXEpJX+mN
        g9Si09bPWiQWL1dKiOXN8LP3A4sR5opGQ2T8/n/7VqIgh+IzReG0gYOFq1cah2sUowln6ctNDEv
        RCdWQeK2G8fxKQE84
X-Received: by 2002:adf:ea06:: with SMTP id q6mr65083191wrm.69.1594380698303;
        Fri, 10 Jul 2020 04:31:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz4g++MZXIVwdtMKOQxK6lrsv51Rp7rwp+FV4RYaCSdZuYHSZRZ0n8HTomwQMFHmG03mUFrHg==
X-Received: by 2002:adf:ea06:: with SMTP id q6mr65083170wrm.69.1594380698095;
        Fri, 10 Jul 2020 04:31:38 -0700 (PDT)
Received: from redhat.com (bzq-79-182-31-92.red.bezeqint.net. [79.182.31.92])
        by smtp.gmail.com with ESMTPSA id o21sm8912958wmh.18.2020.07.10.04.31.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2020 04:31:37 -0700 (PDT)
Date:   Fri, 10 Jul 2020 07:31:34 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: [PATCH] virtio_balloon: clear modern features under legacy
Message-ID: <20200710113046.421366-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Page reporting features were never supported by legacy hypervisors.
Supporting them poses a problem: should we use native endian-ness (like
current code assumes)? Or little endian-ness like the virtio spec says?
Rather than try to figure out, and since results of
incorrect endian-ness are dire, let's just block this configuration.

Cc: stable@vger.kernel.org
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/virtio/virtio_balloon.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 5d4b891bf84f..b9bc03345157 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -1107,6 +1107,15 @@ static int virtballoon_restore(struct virtio_device *vdev)
 
 static int virtballoon_validate(struct virtio_device *vdev)
 {
+	/*
+	 * Legacy devices never specified how modern features should behave.
+	 * E.g. which endian-ness to use? Better not to assume anything.
+	 */
+	if (!virtio_has_feature(vdev, VIRTIO_F_VERSION_1)) {
+		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT);
+		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_PAGE_POISON);
+		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_REPORTING);
+	}
 	/*
 	 * Inform the hypervisor that our pages are poisoned or
 	 * initialized. If we cannot do that then we should disable
-- 
MST

