Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 010DE27C3BC
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728668AbgI2LIV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:08:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:44248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728846AbgI2LGn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:06:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D614621D43;
        Tue, 29 Sep 2020 11:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601377602;
        bh=0DYThMcMEwXruMBnQ2Tklc/P7QvnSqF1jjBm4YAjmow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I61mi21FRO1vWZwwJjymoBEFeYPWrGzD5A8yYTfsen76lAg8Fr73ivx7s7Hx9dAHq
         zg/INgoBNQ3jaKjad/IUlYH53AlOHUvoQsAhGfrzmDjLiSYvjmZkNDJ/xhubU86bXk
         vf7wBWgSEIRasWP5XHAuzO8964tk2/DYR7R70qQ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 68/85] ceph: fix potential race in ceph_check_caps
Date:   Tue, 29 Sep 2020 13:00:35 +0200
Message-Id: <20200929105931.616933450@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105928.198942536@linuxfoundation.org>
References: <20200929105928.198942536@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit dc3da0461cc4b76f2d0c5b12247fcb3b520edbbf ]

Nothing ensures that session will still be valid by the time we
dereference the pointer. Take and put a reference.

In principle, we should always be able to get a reference here, but
throw a warning if that's ever not the case.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/caps.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 3d0497421e62b..49e693232916f 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1777,12 +1777,24 @@ ack:
 			if (mutex_trylock(&session->s_mutex) == 0) {
 				dout("inverting session/ino locks on %p\n",
 				     session);
+				session = ceph_get_mds_session(session);
 				spin_unlock(&ci->i_ceph_lock);
 				if (took_snap_rwsem) {
 					up_read(&mdsc->snap_rwsem);
 					took_snap_rwsem = 0;
 				}
-				mutex_lock(&session->s_mutex);
+				if (session) {
+					mutex_lock(&session->s_mutex);
+					ceph_put_mds_session(session);
+				} else {
+					/*
+					 * Because we take the reference while
+					 * holding the i_ceph_lock, it should
+					 * never be NULL. Throw a warning if it
+					 * ever is.
+					 */
+					WARN_ON_ONCE(true);
+				}
 				goto retry;
 			}
 		}
-- 
2.25.1



