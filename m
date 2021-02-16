Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70F1B31CBDC
	for <lists+stable@lfdr.de>; Tue, 16 Feb 2021 15:26:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbhBPO0k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Feb 2021 09:26:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23904 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230209AbhBPO0j (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Feb 2021 09:26:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613485512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=bEYlHxQooqe+xGIkI4vm2sICM9j4dZzNidpeF7Tl3rc=;
        b=B9DQktYVgJQLD1DUlztuhmJ5H4HUC0K5X5KtCzSdMHw8ANJLa9CiGqN9zJItUVyPidAFph
        Y0LDf4tWU3uNj2sjFaoDk7c/3UdoD8IH/TW0wn9UOWDcx0U4alzFRJZfNdejSjukp0oVDU
        mG1mwCBRvtrgOaCdrJgAryv16DKECoA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-534-DGN1ci5AN5eunODbYRJTMQ-1; Tue, 16 Feb 2021 09:25:10 -0500
X-MC-Unique: DGN1ci5AN5eunODbYRJTMQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5190B80197B;
        Tue, 16 Feb 2021 14:25:08 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-113-212.ams2.redhat.com [10.36.113.212])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D7354100AE34;
        Tue, 16 Feb 2021 14:24:40 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, stable@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH for 5.10 v2 0/5] vdpa_sim: fix param validation in vdpasim_get_config()
Date:   Tue, 16 Feb 2021 15:24:34 +0100
Message-Id: <20210216142439.258713-1-sgarzare@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

v1: https://lore.kernel.org/stable/20210211162519.215418-1-sgarzare@redhat.com/

v2:
- backport the upstream patch and related patches needed

Commit 65b709586e22 ("vdpa_sim: add get_config callback in
vdpasim_dev_attr") unintentionally solved an issue in vdpasim_get_config()
upstream while refactoring vdpa_sim.c to support multiple devices.

Before that patch, if 'offset + len' was equal to
sizeof(struct virtio_net_config), the entire buffer wasn't filled,
returning incorrect values to the caller.

Since 'vdpasim->config' type is 'struct virtio_net_config', we can
safely copy its content under this condition.

The minimum set of patches to backport the patch that fixes the issue, is the
following:

   423248d60d2b vdpa_sim: remove hard-coded virtq count
   6c6e28fe4579 vdpa_sim: add struct vdpasim_dev_attr for device attributes
   cf1a3b35382c vdpa_sim: store parsed MAC address in a buffer
   f37cbbc65178 vdpa_sim: make 'config' generic and usable for any device type
   65b709586e22 vdpa_sim: add get_config callback in vdpasim_dev_attr

The patches apply fairly cleanly. There are a few contextual differences
due to the lack of the other patches:

   $ git backport-diff -u master -r linux-5.10.y..HEAD
   Key:
   [----] : patches are identical
   [####] : number of functional differences between upstream/downstream patch
   [down] : patch is downstream-only
   The flags [FC] indicate (F)unctional and (C)ontextual differences, respectively

   001/5:[----] [--] 'vdpa_sim: remove hard-coded virtq count'
   002/5:[----] [-C] 'vdpa_sim: add struct vdpasim_dev_attr for device attributes'
   003/5:[----] [--] 'vdpa_sim: store parsed MAC address in a buffer'
   004/5:[----] [-C] 'vdpa_sim: make 'config' generic and usable for any device type'
   005/5:[----] [-C] 'vdpa_sim: add get_config callback in vdpasim_dev_attr'

Thanks,
Stefano

Max Gurtovoy (1):
  vdpa_sim: remove hard-coded virtq count

Stefano Garzarella (4):
  vdpa_sim: add struct vdpasim_dev_attr for device attributes
  vdpa_sim: store parsed MAC address in a buffer
  vdpa_sim: make 'config' generic and usable for any device type
  vdpa_sim: add get_config callback in vdpasim_dev_attr

 drivers/vdpa/vdpa_sim/vdpa_sim.c | 83 +++++++++++++++++++++++---------
 1 file changed, 60 insertions(+), 23 deletions(-)

-- 
2.29.2

