Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9EF21B369
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 12:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727947AbgGJKs7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 06:48:59 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:44761 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727848AbgGJKs6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jul 2020 06:48:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594378136;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=zH+SoJc9FA+IxVxr5cux+vmHnM4kK2aczPlNcB2fA0g=;
        b=GVnyIem8Rc/LebOyLDXJmWiZQrlDorG1nSYF4iG1Ku+EsaODON8fC6GBM3gFkqcHoJ5cA5
        ETuRqtgRyowzQRY0GCdbKcQ2hQPG8mtq40BIPBAtQzic0hY0mahw/gymxYmEQ6UtXHtO1F
        ppjEDPnO22gFpSxTnmSRCH6/LJxNcPY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-325-h937yT4zObmYCzkUMb7qVw-1; Fri, 10 Jul 2020 06:48:55 -0400
X-MC-Unique: h937yT4zObmYCzkUMb7qVw-1
Received: by mail-wm1-f69.google.com with SMTP id g124so6362465wmg.6
        for <stable@vger.kernel.org>; Fri, 10 Jul 2020 03:48:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=zH+SoJc9FA+IxVxr5cux+vmHnM4kK2aczPlNcB2fA0g=;
        b=t/d4VNdDK1lflg1vaLBZ265gpqIxx1J+sYZOdvC+zMLKkcNyi7FfmHz2AdtLP+zrIB
         8qBA+qPuMWRt5g7fL5ANnT8UGoAoBLsxYSESCZna70ZJCius74pXqpntNpO6r71myfO/
         o+LWJBNv64hjq8gkEFXW94d37/egKTzxvmXyYDGoGJgF00k3d2ko0WzbbU4i/LcMo+dB
         MOFsViiiYx6iHlFIzhRzth3VgKBjmeASDufOcb6bTjEfwAGBgC4M0HoTXzpfNbeODhgf
         CmqOXt8UCW9QW0RveG864phSBp/3+gEWOy9M7CsF06XqFEQcDjqO/Vl6HKgvqxBHBq0U
         56lw==
X-Gm-Message-State: AOAM533Ygz38edOSaOoIZuWKk7HecQ86L5D8YEPEVDI2nbRIIdZ7Q7LO
        GWLzA8lfZotrqU6TuRTNt/JmRMAlFuBHO78OtnSDYbKlEipZgWupdxS068CqKUTG8505E7fMdhY
        5VV+WMTzTz7TV+Pgm
X-Received: by 2002:a05:6000:1143:: with SMTP id d3mr55214235wrx.235.1594378134132;
        Fri, 10 Jul 2020 03:48:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyw4fIgUrx6Lb8RIpTWJ39EeNc2fRHHzE0+AdkrVCaNR8Aj75HUF42WJR8yehI/TNv6QqsbOQ==
X-Received: by 2002:a05:6000:1143:: with SMTP id d3mr55214221wrx.235.1594378133933;
        Fri, 10 Jul 2020 03:48:53 -0700 (PDT)
Received: from redhat.com (bzq-79-182-31-92.red.bezeqint.net. [79.182.31.92])
        by smtp.gmail.com with ESMTPSA id 68sm8898710wmz.40.2020.07.10.03.48.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2020 03:48:53 -0700 (PDT)
Date:   Fri, 10 Jul 2020 06:48:51 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH] vhost/scsi: fix up req type endian-ness
Message-ID: <20200710104849.406023-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

vhost/scsi doesn't handle type conversion correctly
for request type when using virtio 1.0 and up for BE,
or cross-endian platforms.

Fix it up using vhost_32_to_cpu.

Cc: stable@vger.kernel.org
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 6fb4d7ecfa19..b22adf03f584 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1215,7 +1215,7 @@ vhost_scsi_ctl_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 			continue;
 		}
 
-		switch (v_req.type) {
+		switch (vhost32_to_cpu(vq, v_req.type)) {
 		case VIRTIO_SCSI_T_TMF:
 			vc.req = &v_req.tmf;
 			vc.req_size = sizeof(struct virtio_scsi_ctrl_tmf_req);
-- 
MST

