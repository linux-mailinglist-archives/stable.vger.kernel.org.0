Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 844D117209B
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730944AbgB0Nst (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:48:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:45780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730940AbgB0Nst (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:48:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E673246AE;
        Thu, 27 Feb 2020 13:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811328;
        bh=N9Jg8DQPfUghGf2xHXZsuspCOrZB+QrKBzCb02ko0ME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DVUAROsVMrRWnTJYdAZKLhjcLIaKJPWAvt+nxlvNjg32cU29hPdnd1/3F4vGSgNTj
         lgHUa0RX0lauz15hbwp/XcixT2LddOfVn4qUuPJLLrt+HWP6xYe/fhEpkCr7fAak8X
         Ar1ms6rOgcK9TsRm9unG6YtTTCkerIiwmdC2+o5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 051/165] reiserfs: Fix spurious unlock in reiserfs_fill_super() error handling
Date:   Thu, 27 Feb 2020 14:35:25 +0100
Message-Id: <20200227132238.726262183@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132230.840899170@linuxfoundation.org>
References: <20200227132230.840899170@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



