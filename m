Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18A3127CB0F
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732336AbgI2MYG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:24:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:49220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729768AbgI2LfJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:35:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F04523C85;
        Tue, 29 Sep 2020 11:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378923;
        bh=oFUnuwBODfm1xVNGIRhJSrXk9mqoYKZ92KDhQm6/BS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K4QKLhovSbvy9KE92DoGizlbCOsJXkgcqR8FHk63aIY9MCMx5j/D0FQFWoXQgX0PB
         1PW8jmOKXc/qo3Q1Sw3CvWuFHZT7nl8b0jGaE7ju7NtH9aXjCM5JjwVBHxk4zbjSuJ
         DZJcHAM0EWdhsXkkecz9YQ7NKF1rmno/S1wF1Gw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 189/245] ceph: fix potential race in ceph_check_caps
Date:   Tue, 29 Sep 2020 13:00:40 +0200
Message-Id: <20200929105956.173144388@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
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
index a2d4eed27f804..c0dbf8b7762b4 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2015,12 +2015,24 @@ ack:
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



