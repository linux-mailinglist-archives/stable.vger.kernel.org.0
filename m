Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D67141C159D
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729229AbgEANbK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:31:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:55480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730086AbgEANbH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:31:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96DAC216FD;
        Fri,  1 May 2020 13:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588339867;
        bh=IHKMkznH5+WzMwt3VUfjz9EcU8ZVmEBSa2JrGydAdwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t/rn1CCGbJdSo+fR0XjotdrxMFVzO5v9CEZrAHwOCRbm6QmQpeqM4+5L3w/TIT7zE
         hOf2/mI4FMs/h68AGxcKlddQIoBuRTgOewdCA0vPwHd5+jBUZe17FhJG2+tKQq8xVw
         ZcpXr0P4jnsFMGw4KWgmEAz+MqmT3pkNsGIvBd0s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Yan, Zheng" <zyan@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 011/117] ceph: dont skip updating wanted caps when cap is stale
Date:   Fri,  1 May 2020 15:20:47 +0200
Message-Id: <20200501131546.441013426@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131544.291247695@linuxfoundation.org>
References: <20200501131544.291247695@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yan, Zheng <zyan@redhat.com>

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
index c3a3ee74e2d84..1b5a50848b5be 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1863,8 +1863,12 @@ retry_locked:
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



