Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8001C3D61E1
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234226AbhGZPdT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:33:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:47946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233137AbhGZPcC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:32:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2341460F5B;
        Mon, 26 Jul 2021 16:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315920;
        bh=9mAhG5e3hWoTLI5LKpV48Lm56dw07oYbu3rPbEM6QLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IJs7oZ08ZoVeytfyd9U+HmcNGUdDrcYsdZbwMopPRQWfLefR/7tsHoMIRffdafwlw
         +RPVoMz8/LJz+Sn2191r1/GOiu/Vu4+9zF2iRk6bOfJFn/KRtZckYJ+4JeW1BzrCoW
         2FwxF9ez6FumAN+lrIykjruLU74jFkE7kGBG4SPs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luis Henriques <lhenriques@suse.de>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 119/223] ceph: dont WARN if were still opening a session to an MDS
Date:   Mon, 26 Jul 2021 17:38:31 +0200
Message-Id: <20210726153850.159502936@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
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
index e5af591d3bd4..86f09b1110a2 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4468,7 +4468,7 @@ bool check_session_state(struct ceph_mds_session *s)
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



