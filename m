Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 128B7137D20
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 10:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728998AbgAKJx6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 04:53:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:41664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728810AbgAKJx5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 04:53:57 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 774BB2082E;
        Sat, 11 Jan 2020 09:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578736437;
        bh=S4Jh/OvFPQA9rENmomRKgQgHIUJGjsJYF5xuUfKmKng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VKWTyyg0eU5I6zS1DBHRzEwPdeZgDrFg95VKJ/2UdeqhM0suPby7lapFSWhQz33NG
         JozIbbsAb1BKN/cq8LoxHFrdGPNvTPo1SoKXHq76cI3rJ7P6HjMfVTlTX/wvj0KzEl
         8fCwwTiK17DWXFdtI7bu4MS0ap0hI0JXm9ObWYaM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 4.4 17/59] locks: print unsigned ino in /proc/locks
Date:   Sat, 11 Jan 2020 10:49:26 +0100
Message-Id: <20200111094842.183186246@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094835.417654274@linuxfoundation.org>
References: <20200111094835.417654274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

commit 98ca480a8f22fdbd768e3dad07024c8d4856576c upstream.

An ino is unsigned, so display it as such in /proc/locks.

Cc: stable@vger.kernel.org
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/locks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/locks.c
+++ b/fs/locks.c
@@ -2599,7 +2599,7 @@ static void lock_get_status(struct seq_f
 	}
 	if (inode) {
 		/* userspace relies on this representation of dev_t */
-		seq_printf(f, "%d %02x:%02x:%ld ", fl_pid,
+		seq_printf(f, "%d %02x:%02x:%lu ", fl_pid,
 				MAJOR(inode->i_sb->s_dev),
 				MINOR(inode->i_sb->s_dev), inode->i_ino);
 	} else {


