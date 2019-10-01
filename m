Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 045F8C3D3C
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 18:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbfJAQ6R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 12:58:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731246AbfJAQlm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 12:41:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41671222C2;
        Tue,  1 Oct 2019 16:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569948102;
        bh=uG8pyqNu47t48+jnAMuQnIofuYm1uh3S7EUJw98IcNI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mpv2+1Q4uMbxFmAFLGflogRmw4T5f3E6M/91RrbghxsvdbsymEEnSvV41sSRJ9tjd
         HGO7SaOcEAVOWU5IBdgllGIzHrGuejoPNFVbeeWiYNj9ibaMhxWwA7Ww750UQH1OSy
         cOs1DcgUBby2vbT+qZgQtWW+YQRHWYdqOC3xHI/U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Erqi Chen <chenerqi@gmail.com>, "Yan, Zheng" <zyan@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 13/63] ceph: reconnect connection if session hang in opening state
Date:   Tue,  1 Oct 2019 12:40:35 -0400
Message-Id: <20191001164125.15398-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001164125.15398-1-sashal@kernel.org>
References: <20191001164125.15398-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Erqi Chen <chenerqi@gmail.com>

[ Upstream commit 71a228bc8d65900179e37ac309e678f8c523f133 ]

If client mds session is evicted in CEPH_MDS_SESSION_OPENING state,
mds won't send session msg to client, and delayed_work skip
CEPH_MDS_SESSION_OPENING state session, the session hang forever.

Allow ceph_con_keepalive to reconnect a session in OPENING to avoid
session hang. Also, ensure that we skip sessions in RESTARTING and
REJECTED states since those states can't be resurrected by issuing
a keepalive.

Link: https://tracker.ceph.com/issues/41551
Signed-off-by: Erqi Chen chenerqi@gmail.com
Reviewed-by: "Yan, Zheng" <zyan@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/mds_client.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index c8a9b89b922d7..b8e268e6add27 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4033,7 +4033,9 @@ static void delayed_work(struct work_struct *work)
 				pr_info("mds%d hung\n", s->s_mds);
 			}
 		}
-		if (s->s_state < CEPH_MDS_SESSION_OPEN) {
+		if (s->s_state == CEPH_MDS_SESSION_NEW ||
+		    s->s_state == CEPH_MDS_SESSION_RESTARTING ||
+		    s->s_state == CEPH_MDS_SESSION_REJECTED) {
 			/* this mds is failed or recovering, just wait */
 			ceph_put_mds_session(s);
 			continue;
-- 
2.20.1

