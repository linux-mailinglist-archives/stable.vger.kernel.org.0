Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01E6D3D609E
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237567AbhGZPX1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:23:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:38364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237529AbhGZPXS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:23:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D60B360EB2;
        Mon, 26 Jul 2021 16:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315427;
        bh=EbI8xoAF1Uc9GQwcULMt9iXYokM+w/UwDs8a6JaKhQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G2wzVuzeWX/NwyZ16G/8dLiCW66Q6VkTxl2NaQpOZsldiaFcscMPDZN7POkhPFk3c
         //VvCQ18ZhLtbX4xQzQH3Bqsg/V60yTk0ZwbnIAAOSGRiiMku8eOvtV9SFZu/BYrDJ
         07edQZQ22CJM7iLqobJZCxrdlcw5MkkINx+SeTHU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luis Henriques <lhenriques@suse.de>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 092/167] ceph: dont WARN if were still opening a session to an MDS
Date:   Mon, 26 Jul 2021 17:38:45 +0200
Message-Id: <20210726153842.485284159@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luis Henriques <lhenriques@suse.de>

[ Upstream commit cdb330f4b41ab55feb35487729e883c9e08b8a54 ]

If MDSs aren't available while mounting a filesystem, the session state
will transition from SESSION_OPENING to SESSION_CLOSING.  And in that
scenario check_session_state() will be called from delayed_work() and
trigger this WARN.

Avoid this by only WARNing after a session has already been established
(i.e., the s_ttl will be different from 0).

Fixes: 62575e270f66 ("ceph: check session state after bumping session->s_seq")
Signed-off-by: Luis Henriques <lhenriques@suse.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/mds_client.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index d560752b764d..6b00f1d7c8e7 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4401,7 +4401,7 @@ bool check_session_state(struct ceph_mds_session *s)
 		break;
 	case CEPH_MDS_SESSION_CLOSING:
 		/* Should never reach this when we're unmounting */
-		WARN_ON_ONCE(true);
+		WARN_ON_ONCE(s->s_ttl);
 		fallthrough;
 	case CEPH_MDS_SESSION_NEW:
 	case CEPH_MDS_SESSION_RESTARTING:
-- 
2.30.2



