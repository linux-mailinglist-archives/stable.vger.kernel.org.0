Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60F9F1132D5
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731079AbfLDSMQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:12:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:40836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731584AbfLDSMQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:12:16 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B803E20866;
        Wed,  4 Dec 2019 18:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575483135;
        bh=VJHTaa8af8C2n6uEHdlFvjPNZc6bJr90kjfPgFbMiAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u7ptMV18yJKRMiwqEcoOl7Ep6qNUr9KrqAZjDn8wcqIM6io/gy2t0mpLLUBpO5Eya
         jmNsWQthHdQuzV9GrqTTuRECHCMfxDpHTKNlCBsAnP1elZczsDMriD8Co1/LX8dsu8
         Rpilo/5QsWSD5zOIipfgr0WdUCuaoZIVVa6RCrLU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars Ellenberg <lars.ellenberg@linbit.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 065/125] drbd: ignore "all zero" peer volume sizes in handshake
Date:   Wed,  4 Dec 2019 18:56:10 +0100
Message-Id: <20191204175322.915506397@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175308.377746305@linuxfoundation.org>
References: <20191204175308.377746305@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

[ Upstream commit 94c43a13b8d6e3e0dd77b3536b5e04a84936b762 ]

During handshake, if we are diskless ourselves, we used to accept any size
presented by the peer.

Which could be zero if that peer was just brought up and connected
to us without having a disk attached first, in which case both
peers would just "flip" their volume sizes.

Now, even a diskless node will ignore "zero" sizes
presented by a diskless peer.

Also a currently Diskless Primary will refuse to shrink during handshake:
it may be frozen, and waiting for a "suitable" local disk or peer to
re-appear (on-no-data-accessible suspend-io). If the peer is smaller
than what we used to be, it is not suitable.

The logic for a diskless node during handshake is now supposed to be:
believe the peer, if
 - I don't have a current size myself
 - we agree on the size anyways
 - I do have a current size, am Secondary, and he has the only disk
 - I do have a current size, am Primary, and he has the only disk,
   which is larger than my current size

Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/drbd/drbd_receiver.c | 33 +++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 8e8e4ccb128f3..bbd50d7dce43d 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -4037,6 +4037,7 @@ static int receive_sizes(struct drbd_connection *connection, struct packet_info
 	struct o_qlim *o = (connection->agreed_features & DRBD_FF_WSAME) ? p->qlim : NULL;
 	enum determine_dev_size dd = DS_UNCHANGED;
 	sector_t p_size, p_usize, p_csize, my_usize;
+	sector_t new_size, cur_size;
 	int ldsc = 0; /* local disk size changed */
 	enum dds_flags ddsf;
 
@@ -4044,6 +4045,7 @@ static int receive_sizes(struct drbd_connection *connection, struct packet_info
 	if (!peer_device)
 		return config_unknown_volume(connection, pi);
 	device = peer_device->device;
+	cur_size = drbd_get_capacity(device->this_bdev);
 
 	p_size = be64_to_cpu(p->d_size);
 	p_usize = be64_to_cpu(p->u_size);
@@ -4054,7 +4056,6 @@ static int receive_sizes(struct drbd_connection *connection, struct packet_info
 	device->p_size = p_size;
 
 	if (get_ldev(device)) {
-		sector_t new_size, cur_size;
 		rcu_read_lock();
 		my_usize = rcu_dereference(device->ldev->disk_conf)->disk_size;
 		rcu_read_unlock();
@@ -4072,7 +4073,6 @@ static int receive_sizes(struct drbd_connection *connection, struct packet_info
 		/* Never shrink a device with usable data during connect.
 		   But allow online shrinking if we are connected. */
 		new_size = drbd_new_dev_size(device, device->ldev, p_usize, 0);
-		cur_size = drbd_get_capacity(device->this_bdev);
 		if (new_size < cur_size &&
 		    device->state.disk >= D_OUTDATED &&
 		    device->state.conn < C_CONNECTED) {
@@ -4137,9 +4137,36 @@ static int receive_sizes(struct drbd_connection *connection, struct packet_info
 		 *
 		 * However, if he sends a zero current size,
 		 * take his (user-capped or) backing disk size anyways.
+		 *
+		 * Unless of course he does not have a disk himself.
+		 * In which case we ignore this completely.
 		 */
+		sector_t new_size = p_csize ?: p_usize ?: p_size;
 		drbd_reconsider_queue_parameters(device, NULL, o);
-		drbd_set_my_capacity(device, p_csize ?: p_usize ?: p_size);
+		if (new_size == 0) {
+			/* Ignore, peer does not know nothing. */
+		} else if (new_size == cur_size) {
+			/* nothing to do */
+		} else if (cur_size != 0 && p_size == 0) {
+			drbd_warn(device, "Ignored diskless peer device size (peer:%llu != me:%llu sectors)!\n",
+					(unsigned long long)new_size, (unsigned long long)cur_size);
+		} else if (new_size < cur_size && device->state.role == R_PRIMARY) {
+			drbd_err(device, "The peer's device size is too small! (%llu < %llu sectors); demote me first!\n",
+					(unsigned long long)new_size, (unsigned long long)cur_size);
+			conn_request_state(peer_device->connection, NS(conn, C_DISCONNECTING), CS_HARD);
+			return -EIO;
+		} else {
+			/* I believe the peer, if
+			 *  - I don't have a current size myself
+			 *  - we agree on the size anyways
+			 *  - I do have a current size, am Secondary,
+			 *    and he has the only disk
+			 *  - I do have a current size, am Primary,
+			 *    and he has the only disk,
+			 *    which is larger than my current size
+			 */
+			drbd_set_my_capacity(device, new_size);
+		}
 	}
 
 	if (get_ldev(device)) {
-- 
2.20.1



