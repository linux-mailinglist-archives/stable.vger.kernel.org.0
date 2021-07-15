Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 263373CAB96
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242941AbhGOTU4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:20:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:58676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244985AbhGOTTG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:19:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 36BE0613CF;
        Thu, 15 Jul 2021 19:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376421;
        bh=YuweoZV+Q0HO9FtsgisyhkUx55eopAuEa8pRRSusLlA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I92hrAo5VmU3eWv1EaaoAwYhXtbQC5F1QXdDXbkIA4+G5dYDxJaWvHKj/48P4vB5z
         ddBnvuLq/jZNOIBki2+EfYmkgPJngXttj/E88xhx8eEJDyqR9uJ5CMxPmhd1QUDtpK
         In43M1FgAuC7K0ddGR9WT3TiGjJ9s4REa6eift/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+77c53db50c9fff774e8e@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH 5.13 265/266] smackfs: restrict bytes count in smk_set_cipso()
Date:   Thu, 15 Jul 2021 20:40:20 +0200
Message-Id: <20210715182653.571022568@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
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
Subject: [PATCH 5.13 265/266] smackfs: restrict bytes count in smk_set_cipso()

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
@@ -855,6 +855,8 @@ static ssize_t smk_set_cipso(struct file
 	if (format == SMK_FIXED24_FMT &&
 	    (count < SMK_CIPSOMIN || count > SMK_CIPSOMAX))
 		return -EINVAL;
+	if (count > PAGE_SIZE)
+		return -EINVAL;
 
 	data = memdup_user_nul(buf, count);
 	if (IS_ERR(data))


