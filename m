Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24AA31FE09B
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731404AbgFRBsg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:48:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:36252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731335AbgFRB1x (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:27:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C778221F7;
        Thu, 18 Jun 2020 01:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443673;
        bh=H09lIr58TSUWoVk6WcWtTsuF+1QdjEMVrxFDP/b/wOE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VZTHdVZejs4wfzvN35FTtdmCDswOSJHMKTiREfoNm21C2mRKumMXFH1lJ++/OE+Vj
         9wEBBY6+BW2gDtJbjfqSiK77MYKH044E9BQpwLy2NMA10Si/01JXzhHxc7gqqO951+
         ySFgNN12cPQ5N2gxF891AV9G0ZoSXWvrEtvEpV30=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 4.14 089/108] gfs2: Allow lock_nolock mount to specify jid=X
Date:   Wed, 17 Jun 2020 21:25:41 -0400
Message-Id: <20200618012600.608744-89-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012600.608744-1-sashal@kernel.org>
References: <20200618012600.608744-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

[ Upstream commit ea22eee4e6027d8927099de344f7fff43c507ef9 ]

Before this patch, a simple typo accidentally added \n to the jid=
string for lock_nolock mounts. This made it impossible to mount a
gfs2 file system with a journal other than journal0. Thus:

mount -tgfs2 -o hostdata="jid=1" <device> <mount pt>

Resulted in:
mount: wrong fs type, bad option, bad superblock on <device>

In most cases this is not a problem. However, for debugging and
testing purposes we sometimes want to test the integrity of other
journals. This patch removes the unnecessary \n and thus allows
lock_nolock users to specify an alternate journal.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/ops_fstype.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 057be88eb1b4..7ed0359ebac6 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -922,7 +922,7 @@ static int init_per_node(struct gfs2_sbd *sdp, int undo)
 }
 
 static const match_table_t nolock_tokens = {
-	{ Opt_jid, "jid=%d\n", },
+	{ Opt_jid, "jid=%d", },
 	{ Opt_err, NULL },
 };
 
-- 
2.25.1

