Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F53DD251C
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389302AbfJJIyD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:54:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:58128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389179AbfJJIuw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:50:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99B5921D71;
        Thu, 10 Oct 2019 08:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697452;
        bh=Hocc63BL0I0Fgrn+QymLAblajZc0ZEE1HFWH9U3eyJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1cvn4SUAVbO8KHqpE3GhW+Sy2b8oa78Afbc+DFTcApKV6z7IAcXRZppJGbhmwnAFQ
         l/qskYLlVowfDTqLDxmw3aADFnllDtbhaZIQWRduvaxJtBHHHxzK9KWek8tIXsp2Aw
         0crxabwsYY78D7GjhQfe2htwqZLDtlraCbiprMv8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Yan, Zheng" <zyan@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 33/61] ceph: reconnect connection if session hang in opening state
Date:   Thu, 10 Oct 2019 10:36:58 +0200
Message-Id: <20191010083510.605813829@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083449.500442342@linuxfoundation.org>
References: <20191010083449.500442342@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index e1ded4bd61154..b968334f841e8 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -3543,7 +3543,9 @@ static void delayed_work(struct work_struct *work)
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



