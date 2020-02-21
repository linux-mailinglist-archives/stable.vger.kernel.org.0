Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B550616768A
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731989AbgBUIgJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:36:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:40588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731966AbgBUIGh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:06:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59A9120722;
        Fri, 21 Feb 2020 08:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272396;
        bh=+y4TUkxDaRyUqP3FAdHw8MSgA1dwvEyfRjGmLs+5+nQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VKvBH8UphmeiM7uFYKu0qGplZDVu8ZAKJCGcoJGro0gjn3GdE/Z3NPA1DD4pfDmlC
         a6HkbNf0Nux681b10qHZtTONLOv22A+xY3TEcmWOn9DSNruKo9PyeGRzamF5QRt/XL
         m8q+AqwVSv/tPXZYmaIdMxCCZTA7IcQOVBRFG6x4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 127/344] reiserfs: Fix spurious unlock in reiserfs_fill_super() error handling
Date:   Fri, 21 Feb 2020 08:38:46 +0100
Message-Id: <20200221072400.397314867@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
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
index d127af64283e3..a6bce5b1fb1dc 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -1948,7 +1948,7 @@ static int reiserfs_fill_super(struct super_block *s, void *data, int silent)
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



