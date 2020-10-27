Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 325B729B264
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1750055AbgJ0Okr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:40:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:39200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761524AbgJ0Oj5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:39:57 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA47D207BB;
        Tue, 27 Oct 2020 14:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809597;
        bh=sGaL95rRbM6Xb0b0k4a0ZZs9+QinxU6WgZWQsL7BSOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RpxA9v9sdnDFznSsrnUweKKMMefY33yiXlixEsEzfMl5OfjEDGHUHY/2c6ktALDM+
         zHkIS++akXCWN/F1NUX9j5Tb8zs0T+aaV9HUsUXckUDZaUzSUbySMPBUvu6UPmSA8X
         V5GaCxAtUhDnMqTQZoiPf+4WR3mnAVrMa+X4RRXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 213/408] xfs: limit entries returned when counting fsmap records
Date:   Tue, 27 Oct 2020 14:52:31 +0100
Message-Id: <20201027135504.973339803@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

[ Upstream commit acd1ac3aa22fd58803a12d26b1ab7f70232f8d8d ]

If userspace asked fsmap to count the number of entries, we cannot
return more than UINT_MAX entries because fmh_entries is u32.
Therefore, stop counting if we hit this limit or else we will waste time
to return truncated results.

Fixes: e89c041338ed ("xfs: implement the GETFSMAP ioctl")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_fsmap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index c13754e119be1..5b864985bc648 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -255,6 +255,9 @@ xfs_getfsmap_helper(
 
 	/* Are we just counting mappings? */
 	if (info->head->fmh_count == 0) {
+		if (info->head->fmh_entries == UINT_MAX)
+			return -ECANCELED;
+
 		if (rec_daddr > info->next_daddr)
 			info->head->fmh_entries++;
 
-- 
2.25.1



