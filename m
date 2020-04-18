Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9611AEFE9
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 16:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728280AbgDROqB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 10:46:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:56588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728104AbgDROol (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Apr 2020 10:44:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCCF722202;
        Sat, 18 Apr 2020 14:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587221081;
        bh=i9oB0dWxDNaCMNzJ49QtNMg8oBTQEzJPXjtqfewqocE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BL8luFIVEgZ5URTqYhY9vcanD76ShAl/CZEGEZl6bDkwtHSMcATIZGDOQCDFQUBOw
         IpMbO48NQY2rhMkU4+PcnQvFZi7WIjBV7e2Z+elmOJDmQ001ygo4proHpF+WMngopD
         1iF2uLXEpj/LH+5yL0KzkfbgXkrJ4Q9IQGGyn1gM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Yan, Zheng" <zyan@redhat.com>, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 04/19] ceph: don't skip updating wanted caps when cap is stale
Date:   Sat, 18 Apr 2020 10:44:21 -0400
Message-Id: <20200418144436.10818-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200418144436.10818-1-sashal@kernel.org>
References: <20200418144436.10818-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Yan, Zheng" <zyan@redhat.com>

[ Upstream commit 0aa971b6fd3f92afef6afe24ef78d9bb14471519 ]

1. try_get_cap_refs() fails to get caps and finds that mds_wanted
   does not include what it wants. It returns -ESTALE.
2. ceph_get_caps() calls ceph_renew_caps(). ceph_renew_caps() finds
   that inode has cap, so it calls ceph_check_caps().
3. ceph_check_caps() finds that issued caps (without checking if it's
   stale) already includes caps wanted by open file, so it skips
   updating wanted caps.

Above events can cause an infinite loop inside ceph_get_caps().

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/caps.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index aa4df4a022525..efdf81ea3b5f8 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1734,8 +1734,12 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
 		}
 
 		/* want more caps from mds? */
-		if (want & ~(cap->mds_wanted | cap->issued))
-			goto ack;
+		if (want & ~cap->mds_wanted) {
+			if (want & ~(cap->mds_wanted | cap->issued))
+				goto ack;
+			if (!__cap_is_valid(cap))
+				goto ack;
+		}
 
 		/* things we might delay */
 		if ((cap->issued & ~retain) == 0 &&
-- 
2.20.1

