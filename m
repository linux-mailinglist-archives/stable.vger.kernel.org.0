Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47CFD22F442
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 18:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbgG0QDw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 12:03:52 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:33424 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726265AbgG0QDw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jul 2020 12:03:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595865830;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=PzdX7wVbIx8ObG6INsApXS+qCsher40rhMpcw3UMWXc=;
        b=fRWep9/eDzx7Ww6z4zN62m+rTnXBNTYCOg7UuWVuOsuPf17ojus0npnfFNslirEqNBp0GD
        DhxnNcqh91EVD4gIY0ZAV6TvzGjcDazOfwHY04iqlTfr5Sai/0tcf0mS75P2YPjXMjF7BH
        12Xh1PcEEYssn4/Mk/n9R2d6eyic8TA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-275-1VsM7tZ3NsOtp7knTyBMaw-1; Mon, 27 Jul 2020 12:03:48 -0400
X-MC-Unique: 1VsM7tZ3NsOtp7knTyBMaw-1
Received: by mail-wr1-f71.google.com with SMTP id z12so4109155wrl.16
        for <stable@vger.kernel.org>; Mon, 27 Jul 2020 09:03:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=PzdX7wVbIx8ObG6INsApXS+qCsher40rhMpcw3UMWXc=;
        b=sreKTqti0CVLObPKdLdLcud0764oG6MXUTKY9Y7+Kl8u2Am+5gFa8+NyCmDsyAODWF
         T/+z6PWGihbny/utKDnv7C33R18vSamO/KmuklUCRHaNqTVsW7tG5Y3S8K+j1EygunN2
         nuF5aC80KOWxHBK1JOPqRfI+RCJV40+jddZG4jXa6zcjyWp+0oIbQ5o7lR0ZHgktJmKR
         aLeUaVthomTDybB9f0AbaTWS+jZtzIbLiVtCTkfRxXdvN1bPaPJGJwTDiXdP6BrNymqv
         PCnLw3EJ7muWJAb1gZyr7SE3F8/tvcvoSrCWFh317W6KW6zp7QZGBuLOuiL6O15eaGh2
         vqTQ==
X-Gm-Message-State: AOAM532gJXZqDWbBNgrhXVN/O5YuzMDU9pqbIjlvEmNAE/d3pMBEkxDR
        9wRuPk2RS2950rcT4Iy3iDNUHY3+ifNCznG9efZaVZNlBcxK821zTEspA+NnjyLiKcmA1gjgHZz
        6W1EMqPkHP2xmgqHw
X-Received: by 2002:adf:b1cf:: with SMTP id r15mr22476409wra.118.1595865827365;
        Mon, 27 Jul 2020 09:03:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz7Ef1D9xDtsNFK+f9eP9IKT0MLwb1s7S8Er/1M1xlErxN9gFMzZ7/LwGj3k9MKPcujJZ0e8g==
X-Received: by 2002:adf:b1cf:: with SMTP id r15mr22476396wra.118.1595865827149;
        Mon, 27 Jul 2020 09:03:47 -0700 (PDT)
Received: from redhat.com ([192.117.173.58])
        by smtp.gmail.com with ESMTPSA id z63sm111712wmb.2.2020.07.27.09.03.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 09:03:46 -0700 (PDT)
Date:   Mon, 27 Jul 2020 12:03:43 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Liang Li <liang.z.li@intel.com>,
        Wei Wang <wei.w.wang@intel.com>,
        virtualization@lists.linux-foundation.org,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: [PATCH] virtio_balloon: fix up endian-ness for free cmd id
Message-ID: <20200727160310.102494-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

free cmd id is read using virtio endian, spec says all fields
in balloon are LE. Fix it up.

Fixes: 86a559787e6f ("virtio-balloon: VIRTIO_BALLOON_F_FREE_PAGE_HINT")
Cc: stable@vger.kernel.org
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/virtio/virtio_balloon.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 774deb65a9bb..798ec304fe3e 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -578,10 +578,14 @@ static int init_vqs(struct virtio_balloon *vb)
 static u32 virtio_balloon_cmd_id_received(struct virtio_balloon *vb)
 {
 	if (test_and_clear_bit(VIRTIO_BALLOON_CONFIG_READ_CMD_ID,
-			       &vb->config_read_bitmap))
+			       &vb->config_read_bitmap)) {
 		virtio_cread(vb->vdev, struct virtio_balloon_config,
 			     free_page_hint_cmd_id,
 			     &vb->cmd_id_received_cache);
+		/* Legacy balloon config space is LE, unlike all other devices. */
+		if (!virtio_has_feature(vb->vdev, VIRTIO_F_VERSION_1))
+			vb->cmd_id_received_cache = le32_to_cpu((__force __le32)vb->cmd_id_received_cache);
+	}
 
 	return vb->cmd_id_received_cache;
 }
-- 
MST

