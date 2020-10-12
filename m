Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFD7728B73A
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730386AbgJLNls (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:41:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:45648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389141AbgJLNlN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:41:13 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B25620838;
        Mon, 12 Oct 2020 13:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510073;
        bh=H00gdKbOcw73ro1X9YZ6telnMBRHu+RvedHOJbRmcdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O8Nes4gVxqJgfUORmpNDYN8uJvpOoQ0byN/Myv0QWeqUC0U3pOPbf77k8kTu0s3vZ
         QyJLF1QEG5t+5+E6oqwc5y41WHRhGOPLn/OGufi7wKIHMz93HTQ//AOV/Vn6qSmP1h
         hBzd4C9LsWGjvc4tbfkazVaOS8tW81KVXI0WrsNQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, jasowang@redhat.com,
        Greg Kurz <groug@kaod.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 5.4 11/85] vhost: Dont call access_ok() when using IOTLB
Date:   Mon, 12 Oct 2020 15:26:34 +0200
Message-Id: <20201012132633.407247882@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132632.846779148@linuxfoundation.org>
References: <20201012132632.846779148@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kurz <groug@kaod.org>

commit 0210a8db2aeca393fb3067e234967877e3146266 upstream.

When the IOTLB device is enabled, the vring addresses we get
from userspace are GIOVAs. It is thus wrong to pass them down
to access_ok() which only takes HVAs.

Access validation is done at prefetch time with IOTLB. Teach
vq_access_ok() about that by moving the (vq->iotlb) check
from vhost_vq_access_ok() to vq_access_ok(). This prevents
vhost_vring_set_addr() to fail when verifying the accesses.
No behavior change for vhost_vq_access_ok().

BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1883084
Fixes: 6b1e6cc7855b ("vhost: new device IOTLB API")
Cc: jasowang@redhat.com
CC: stable@vger.kernel.org # 4.14+
Signed-off-by: Greg Kurz <groug@kaod.org>
Acked-by: Jason Wang <jasowang@redhat.com>
Link: https://lore.kernel.org/r/160171931213.284610.2052489816407219136.stgit@bahia.lan
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/vhost/vhost.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1299,6 +1299,11 @@ static bool vq_access_ok(struct vhost_vi
 			 struct vring_used __user *used)
 
 {
+	/* If an IOTLB device is present, the vring addresses are
+	 * GIOVAs. Access validation occurs at prefetch time. */
+	if (vq->iotlb)
+		return true;
+
 	return access_ok(desc, vhost_get_desc_size(vq, num)) &&
 	       access_ok(avail, vhost_get_avail_size(vq, num)) &&
 	       access_ok(used, vhost_get_used_size(vq, num));
@@ -1394,10 +1399,6 @@ bool vhost_vq_access_ok(struct vhost_vir
 	if (!vq_log_access_ok(vq, vq->log_base))
 		return false;
 
-	/* Access validation occurs at prefetch time with IOTLB */
-	if (vq->iotlb)
-		return true;
-
 	return vq_access_ok(vq, vq->num, vq->desc, vq->avail, vq->used);
 }
 EXPORT_SYMBOL_GPL(vhost_vq_access_ok);


