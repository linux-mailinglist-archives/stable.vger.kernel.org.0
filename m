Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBE503215E3
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbhBVMOJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:14:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:44484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230364AbhBVMN7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:13:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA01764E2E;
        Mon, 22 Feb 2021 12:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613995995;
        bh=A/tjXZ4Qe/7L/KH0rdQM1tzfxBiExdbxX9Xvrf5SEWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iuBYPcuFu5//obaIHqIJXRbgGDZl2HIM+NETtvbx7r1LeR1Lsmf1u5U4123ZvQEEv
         R0vlUdWLLl58CAHKxO/x9hXdTMOK2xA7cKb0U7GRowU+0DgdfWQ1HIvy0Xn+TCRy1+
         CMixgdpMn7ARc/zWsDZlPI2yZvkqqG6pq/CxkYIw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+3d2c27c2b7dc2a94814d@syzkaller.appspotmail.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5.11 10/12] tty: protect tty_write from odd low-level tty disciplines
Date:   Mon, 22 Feb 2021 13:13:02 +0100
Message-Id: <20210222121018.841201057@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121013.586597942@linuxfoundation.org>
References: <20210222121013.586597942@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 3342ff2698e9720f4040cc458a2744b2b32f5c3a upstream.

Al root-caused a new warning from syzbot to the ttyprintk tty driver
returning a write count larger than the data the tty layer actually gave
it.  Which confused the tty write code mightily, and with the new
iov_iter based code, caused a WARNING in iov_iter_revert().

syzbot correctly bisected the source of the new warning to commit
9bb48c82aced ("tty: implement write_iter"), but the oddity goes back
much further, it just didn't get caught by anything before.

Reported-by: syzbot+3d2c27c2b7dc2a94814d@syzkaller.appspotmail.com
Fixes: 9bb48c82aced ("tty: implement write_iter")
Debugged-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/tty_io.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -962,11 +962,14 @@ static inline ssize_t do_tty_write(
 		if (ret <= 0)
 			break;
 
+		written += ret;
+		if (ret > size)
+			break;
+
 		/* FIXME! Have Al check this! */
 		if (ret != size)
 			iov_iter_revert(from, size-ret);
 
-		written += ret;
 		count -= ret;
 		if (!count)
 			break;


