Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FABA12191C
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727225AbfLPRv4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:51:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:42728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727215AbfLPRvy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:51:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5B2621739;
        Mon, 16 Dec 2019 17:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576518714;
        bh=y6SxkjAzAzxq5nfbeRrVyDabhK6DoAJUxIAZp6O+qRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j960hFHJpgvjjKiw3oMJLiI/Cfp85XgK5ERe8My8SpFr5ULZhSjlxDeO45n4vkvx1
         rUw4bLgzzjqTJk9vKFl282JXJrBNAo3Ed7h4tZ/i+prTon+5LJysloAfpTcF3oarg6
         EcNU43eF1ORDhtP8W7patoGx7tZg8t3Tp4SVKxgA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 037/267] dlm: fix missing idr_destroy for recover_idr
Date:   Mon, 16 Dec 2019 18:46:03 +0100
Message-Id: <20191216174853.042431666@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Teigland <teigland@redhat.com>

[ Upstream commit 8fc6ed9a3508a0435b9270c313600799d210d319 ]

Which would leak memory for the idr internals.

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lockspace.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index 610f72ae7ad67..9c8c9a09b4a6d 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -807,6 +807,7 @@ static int release_lockspace(struct dlm_ls *ls, int force)
 
 	dlm_delete_debug_file(ls);
 
+	idr_destroy(&ls->ls_recover_idr);
 	kfree(ls->ls_recover_buf);
 
 	/*
-- 
2.20.1



