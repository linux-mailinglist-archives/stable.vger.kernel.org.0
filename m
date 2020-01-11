Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8DBB137DA0
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729078AbgAKJ7m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 04:59:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:54612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728768AbgAKJ7m (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 04:59:42 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3BF22077C;
        Sat, 11 Jan 2020 09:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578736781;
        bh=FcKDkoL4hUJwb/IRfjZI2sCgStj/wMe/Fo10W6vTUk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZoFfKpLwKlnpDg5IfQI+C0CawLAmHhXXDTvAqNoe1NI5nKJxOYOlQWbnsnh/3NuDp
         +/zhGcneUOjcr/P91yUEpRQ9hMQzo+Hyh1d2iLG8S0wArJYsM1mq2R1dTxj92iKvNG
         6vi+OXLj4/fTPPxG5zSQSxm0fQg41+rFAEFYpCgc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 4.9 23/91] locks: print unsigned ino in /proc/locks
Date:   Sat, 11 Jan 2020 10:49:16 +0100
Message-Id: <20200111094852.696473549@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094844.748507863@linuxfoundation.org>
References: <20200111094844.748507863@linuxfoundation.org>
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
@@ -2681,7 +2681,7 @@ static void lock_get_status(struct seq_f
 	}
 	if (inode) {
 		/* userspace relies on this representation of dev_t */
-		seq_printf(f, "%d %02x:%02x:%ld ", fl_pid,
+		seq_printf(f, "%d %02x:%02x:%lu ", fl_pid,
 				MAJOR(inode->i_sb->s_dev),
 				MINOR(inode->i_sb->s_dev), inode->i_ino);
 	} else {


