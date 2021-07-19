Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9265C3CDE60
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343525AbhGSPCv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:02:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:58902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345315AbhGSPAc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:00:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A99CB60238;
        Mon, 19 Jul 2021 15:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709271;
        bh=FsPxri3gfRLtr9txcmOvhLNCaxYZiy2IXVIUQXOPk5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uIaJIJGtfrUvByChC6SZYriW6p90TyblMJs1LvLHrvkjOXIizyThWMMB2+TTN38hj
         JBHkHwkwrtM5Ys4rDJV2wqz6whjL1UgvrlzMsc2fYE8wlEPncj+rAzsrFMWL6YETiN
         8bULYRvH8u2Q9GntG79Au6jAVG4SIQflbSs5hjUo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+77c53db50c9fff774e8e@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH 4.19 316/421] smackfs: restrict bytes count in smk_set_cipso()
Date:   Mon, 19 Jul 2021 16:52:07 +0200
Message-Id: <20210719144957.265183240@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

commit 49ec114a6e62d8d320037ce71c1aaf9650b3cafd upstream.

Oops, I failed to update subject line.

>From 07571157c91b98ce1a4aa70967531e64b78e8346 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Mon, 12 Apr 2021 22:25:06 +0900
Subject: [PATCH 4.19 316/421] smackfs: restrict bytes count in smk_set_cipso()

Commit 7ef4c19d245f3dc2 ("smackfs: restrict bytes count in smackfs write
functions") missed that count > SMK_CIPSOMAX check applies to only
format == SMK_FIXED24_FMT case.

Reported-by: syzbot <syzbot+77c53db50c9fff774e8e@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/smack/smackfs.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -883,6 +883,8 @@ static ssize_t smk_set_cipso(struct file
 	if (format == SMK_FIXED24_FMT &&
 	    (count < SMK_CIPSOMIN || count > SMK_CIPSOMAX))
 		return -EINVAL;
+	if (count > PAGE_SIZE)
+		return -EINVAL;
 
 	data = memdup_user_nul(buf, count);
 	if (IS_ERR(data))


