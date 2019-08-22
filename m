Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E93C299D93
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388663AbfHVRnr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:43:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:44022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391587AbfHVRXl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:23:41 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7C0823431;
        Thu, 22 Aug 2019 17:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494620;
        bh=giSa+3AeMObBMalEXDvba3j57DZkWuSWwoFfgjSx5Hk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wTbup/c0VKMpMicCbP4yRQQuiOvNBENmXJ2rzUGxKLL7qR4XTk4La/3O8tDJLeqgF
         ErWFiZVC7PbmFhSI4E3tls19sXxKzBBEmm0QH0mG4OF8p+VqyMm8qg0r5/Y2naTJ5W
         0Gt6R82vg0SaGjv//++Bq/BOrv027xlPM8pv6DGs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.9 050/103] vhost_net: introduce vhost_exceeds_weight()
Date:   Thu, 22 Aug 2019 10:18:38 -0700
Message-Id: <20190822171730.822103500@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171728.445189830@linuxfoundation.org>
References: <20190822171728.445189830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>

commit 272f35cba53d088085e5952fd81d7a133ab90789 upstream.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 4.9: adjust context]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vhost/net.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -357,6 +357,12 @@ static int vhost_net_tx_get_vq_desc(stru
 	return r;
 }
 
+static bool vhost_exceeds_weight(int pkts, int total_len)
+{
+	return total_len >= VHOST_NET_WEIGHT ||
+	       pkts >= VHOST_NET_PKT_WEIGHT;
+}
+
 /* Expects to be always run from workqueue - which acts as
  * read-size critical section for our kind of RCU. */
 static void handle_tx(struct vhost_net *net)
@@ -481,8 +487,7 @@ static void handle_tx(struct vhost_net *
 			vhost_zerocopy_signal_used(net, vq);
 		total_len += len;
 		vhost_net_tx_packet(net);
-		if (unlikely(total_len >= VHOST_NET_WEIGHT) ||
-		    unlikely(++sent_pkts >= VHOST_NET_PKT_WEIGHT)) {
+		if (unlikely(vhost_exceeds_weight(++sent_pkts, total_len))) {
 			vhost_poll_queue(&vq->poll);
 			break;
 		}
@@ -763,8 +768,7 @@ static void handle_rx(struct vhost_net *
 			vhost_log_write(vq, vq_log, log, vhost_len,
 					vq->iov, in);
 		total_len += vhost_len;
-		if (unlikely(total_len >= VHOST_NET_WEIGHT) ||
-		    unlikely(++recv_pkts >= VHOST_NET_PKT_WEIGHT)) {
+		if (unlikely(vhost_exceeds_weight(++recv_pkts, total_len))) {
 			vhost_poll_queue(&vq->poll);
 			goto out;
 		}


