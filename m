Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2BB936AE8C
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233147AbhDZHpg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:45:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:56330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233762AbhDZHoJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:44:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B73A1613E2;
        Mon, 26 Apr 2021 07:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422830;
        bh=f+ZOyiIVIDMvKa78Ed05egQkhxVQ65Qhn1l+FSOw2Js=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uADrbW/JRUqBdH8c0SLZZ06nalgkiyQGraItp9azq/EX0JZYdS8mfLdInlBs1p0iW
         /DPK68pG8fKbDWAr0P/ykRtIds4y7SAGUcsktvc9dAz5Z3InjAWghh1C1U98hJp3PJ
         l8chT+6evSgiPoBk1fwNNpqHSgTnr8aEj6DT4cIY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 5.11 01/41] vhost-vdpa: protect concurrent access to vhost device iotlb
Date:   Mon, 26 Apr 2021 09:29:48 +0200
Message-Id: <20210426072819.722442784@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072819.666570770@linuxfoundation.org>
References: <20210426072819.666570770@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xie Yongji <xieyongji@bytedance.com>

commit a9d064524fc3cf463b3bb14fa63de78aafb40dab upstream.

Protect vhost device iotlb by vhost_dev->mutex. Otherwise,
it might cause corruption of the list and interval tree in
struct vhost_iotlb if userspace sends the VHOST_IOTLB_MSG_V2
message concurrently.

Fixes: 4c8cf318("vhost: introduce vDPA-based backend")
Cc: stable@vger.kernel.org
Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://lore.kernel.org/r/20210412095512.178-1-xieyongji@bytedance.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vhost/vdpa.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -745,9 +745,11 @@ static int vhost_vdpa_process_iotlb_msg(
 	const struct vdpa_config_ops *ops = vdpa->config;
 	int r = 0;
 
+	mutex_lock(&dev->mutex);
+
 	r = vhost_dev_check_owner(dev);
 	if (r)
-		return r;
+		goto unlock;
 
 	switch (msg->type) {
 	case VHOST_IOTLB_UPDATE:
@@ -768,6 +770,8 @@ static int vhost_vdpa_process_iotlb_msg(
 		r = -EINVAL;
 		break;
 	}
+unlock:
+	mutex_unlock(&dev->mutex);
 
 	return r;
 }


