Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73AEA3CE361
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241721AbhGSPhq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:37:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:59680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347710AbhGSPfQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3019A61410;
        Mon, 19 Jul 2021 16:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711169;
        bh=KOYnsDWTDdmxB83dYNzQRqmu49H6U+m1KWY9ZG07zyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AFgPsV5Ktu//AUt/XJVbPjVLnSq8eASaWB1Kn38SDfZGMgN3VvS9FH45SaC/mnTxS
         LFb7tNGH5yPChQEjHI3eI2VPT9HkNoDOBiycGzNi895WIP/zODHh/LBhWobr009A+L
         JqB4fn3eAoqD35Du3S8awMNVEjzHt7p4Sc+AupIY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maurizio Lombardi <mlombard@redhat.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 254/351] nvme-tcp: cant set sk_user_data without write_lock
Date:   Mon, 19 Jul 2021 16:53:20 +0200
Message-Id: <20210719144953.353308932@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 0755d3be2d9bb6ea38598ccd30d6bbaa1a5c3a50 ]

The sk_user_data pointer is supposed to be modified only while
holding the write_lock "sk_callback_lock", otherwise
we could race with other threads and crash the kernel.

we can't take the write_lock in nvmet_tcp_state_change()
because it would cause a deadlock, but the release_work queue
will set the pointer to NULL later so we can simply remove
the assignment.

Fixes: b5332a9f3f3d ("nvmet-tcp: fix incorrect locking in state_change sk callback")

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index d8aceef83284..07ee347ea3f3 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1497,7 +1497,6 @@ static void nvmet_tcp_state_change(struct sock *sk)
 	case TCP_CLOSE_WAIT:
 	case TCP_CLOSE:
 		/* FALLTHRU */
-		sk->sk_user_data = NULL;
 		nvmet_tcp_schedule_release_queue(queue);
 		break;
 	default:
-- 
2.30.2



