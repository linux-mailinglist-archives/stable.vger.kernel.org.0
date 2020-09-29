Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83F8B27C8DD
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731712AbgI2MFU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:05:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:58100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730267AbgI2Lhi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2139823BDE;
        Tue, 29 Sep 2020 11:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379443;
        bh=XEBY+ySL28HI3Qf2KU3rL1hSOn0QU4cW074zH3m3UIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z3ULDZ5VtLJXEINL67bB6dXOF7oNaaQBjhYDD7z/4OAKhcHMgAmZuNbGP5qDPlXXr
         x9IHOWScjwn1XwTxqPt+02YnTlb0STHAStYoATPAAvdE0H9WcN7J3oK3vqfyt3m4sR
         yhlMr+W/Oh5MvhtuOvT+XD7DrzszYMkX2c2CpQ3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 166/388] xfs: mark dir corrupt when lookup-by-hash fails
Date:   Tue, 29 Sep 2020 12:58:17 +0200
Message-Id: <20200929110018.517420886@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

[ Upstream commit 2e107cf869eecc770e3f630060bb4e5f547d0fd8 ]

In xchk_dir_actor, we attempt to validate the directory hash structures
by performing a directory entry lookup by (hashed) name.  If the lookup
returns ENOENT, that means that the hash information is corrupt.  The
_process_error functions don't catch this, so we have to add that
explicitly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/dir.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 1e2e11721eb99..20eca2d8e7c77 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -152,6 +152,9 @@ xchk_dir_actor(
 	xname.type = XFS_DIR3_FT_UNKNOWN;
 
 	error = xfs_dir_lookup(sdc->sc->tp, ip, &xname, &lookup_ino, NULL);
+	/* ENOENT means the hash lookup failed and the dir is corrupt */
+	if (error == -ENOENT)
+		error = -EFSCORRUPTED;
 	if (!xchk_fblock_process_error(sdc->sc, XFS_DATA_FORK, offset,
 			&error))
 		goto out;
-- 
2.25.1



