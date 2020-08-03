Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 928A623A702
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726585AbgHCMV1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:21:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:44658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726276AbgHCMVY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:21:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEFE12076E;
        Mon,  3 Aug 2020 12:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457283;
        bh=1JjwvQSZ4M0VBLRdBVcCv8G8o/5zetcQ2B4CQCnzuTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IqNu7EHahpjaTuRDOZ1k/5Rng8EKEs5qaNdk75gmHR+Bn4uqj++UZQ4qpg3At5PWf
         efCs1lUkSiNvg3s0oMSAxn+ZVW5nBwbRIIDge8Py9sJxu6mqoRxov5gsXE3VvlB2tP
         +t6V4tu3kbRw4MsIcWY7mgcs8UDwl7oebOH1gM3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: [PATCH 5.7 012/120] vhost/scsi: fix up req type endian-ness
Date:   Mon,  3 Aug 2020 14:17:50 +0200
Message-Id: <20200803121903.456428318@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael S. Tsirkin <mst@redhat.com>

commit 295c1b9852d000580786375304a9800bd9634d15 upstream.

vhost/scsi doesn't handle type conversion correctly
for request type when using virtio 1.0 and up for BE,
or cross-endian platforms.

Fix it up using vhost_32_to_cpu.

Cc: stable@vger.kernel.org
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/vhost/scsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1215,7 +1215,7 @@ vhost_scsi_ctl_handle_vq(struct vhost_sc
 			continue;
 		}
 
-		switch (v_req.type) {
+		switch (vhost32_to_cpu(vq, v_req.type)) {
 		case VIRTIO_SCSI_T_TMF:
 			vc.req = &v_req.tmf;
 			vc.req_size = sizeof(struct virtio_scsi_ctrl_tmf_req);


