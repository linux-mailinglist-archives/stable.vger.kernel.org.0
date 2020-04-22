Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C81A81B423A
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 13:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbgDVKDH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:03:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:52570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725994AbgDVKDG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:03:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4668120774;
        Wed, 22 Apr 2020 10:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587549785;
        bh=fCbnyq0035wIDV3foIDFdpOQFjmvL8wKvS4WwdKxTAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oLR/o+Nx4vlNXlMDjZp5rfpAJzECwWDtqFMRHMgrVhzgSM4pVao7dnk+u/Jejefq3
         jzXAjTBpe7rmmyDHYisxI1j1fu83Gab+2ExWc5kjOL3sn9yaVeieID2p2RTNX+yfO2
         MPPCzU5IJkHD/wHzNuMooXP19B3jXzg9SZSigLEM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 067/100] dm flakey: check for null arg_name in parse_features()
Date:   Wed, 22 Apr 2020 11:56:37 +0200
Message-Id: <20200422095035.128693758@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095022.476101261@linuxfoundation.org>
References: <20200422095022.476101261@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

[ Upstream commit 7690e25302dc7d0cd42b349e746fe44b44a94f2b ]

One can crash dm-flakey by specifying more feature arguments than the
number of features supplied.  Checking for null in arg_name avoids
this.

dmsetup create flakey-test --table "0 66076080 flakey /dev/sdb9 0 0 180 2 drop_writes"

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-flakey.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index 78f403b45ab3e..bf82e4ccb5847 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -69,6 +69,11 @@ static int parse_features(struct dm_arg_set *as, struct flakey_c *fc,
 		arg_name = dm_shift_arg(as);
 		argc--;
 
+		if (!arg_name) {
+			ti->error = "Insufficient feature arguments";
+			return -EINVAL;
+		}
+
 		/*
 		 * drop_writes
 		 */
-- 
2.20.1



