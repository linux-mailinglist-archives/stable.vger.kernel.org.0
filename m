Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3DCF26EFFA
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727907AbgIRCjh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:39:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:37876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728191AbgIRCL5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:11:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0F1B23899;
        Fri, 18 Sep 2020 02:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395117;
        bh=oFUnuwBODfm1xVNGIRhJSrXk9mqoYKZ92KDhQm6/BS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vv/ck1Y4T1AOnZhd1xlFNtv2gw/0cIs/yO0bCBYvd6qKZ7tt3bG61lmjNnkKRz9if
         u82/6L5nanBn4TuWv7Al4u5YZyeUyl/aUafpJYFjh1Ww6j+1MSuqqg638dIMkZqaMc
         7zUPpWhoMBFvit8NBiPE6fugG1xy9deDvvcA0EK0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 190/206] ceph: fix potential race in ceph_check_caps
Date:   Thu, 17 Sep 2020 22:07:46 -0400
Message-Id: <20200918020802.2065198-190-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

