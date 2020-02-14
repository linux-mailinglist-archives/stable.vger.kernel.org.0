Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5D915E569
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405490AbgBNQWg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:22:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:58262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405487AbgBNQWf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:22:35 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51825246D4;
        Fri, 14 Feb 2020 16:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697355;
        bh=N9Jg8DQPfUghGf2xHXZsuspCOrZB+QrKBzCb02ko0ME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fTQ8uBfFa8l11bAmiGzSelXQrzxbex8fhSTXJ5EqzVCuIfzRDNdCiFYRFAjL6Nc2U
         OeoN6GtgQXA0Oi87xroDSxy8+KGTZEGTrsLJTrFtMC9ByxzJBkSCsm4DtP6Dad7To0
         ZVzcsI4b5i8JhmJtUP2OI2k2h66w/GZ/2/2zGJ6o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>,
        reiserfs-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 057/141] reiserfs: Fix spurious unlock in reiserfs_fill_super() error handling
Date:   Fri, 14 Feb 2020 11:19:57 -0500
Message-Id: <20200214162122.19794-57-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214162122.19794-1-sashal@kernel.org>
References: <20200214162122.19794-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit 4d5c1adaf893b8aa52525d2b81995e949bcb3239 ]

When we fail to allocate string for journal device name we jump to
'error' label which tries to unlock reiserfs write lock which is not
held. Jump to 'error_unlocked' instead.

Fixes: f32485be8397 ("reiserfs: delay reiserfs lock until journal initialization")
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/reiserfs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index bfed2a7000154..677608a89b08d 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -1928,7 +1928,7 @@ static int reiserfs_fill_super(struct super_block *s, void *data, int silent)
 		if (!sbi->s_jdev) {
 			SWARN(silent, s, "", "Cannot allocate memory for "
 				"journal device name");
-			goto error;
+			goto error_unlocked;
 		}
 	}
 #ifdef CONFIG_QUOTA
-- 
2.20.1

