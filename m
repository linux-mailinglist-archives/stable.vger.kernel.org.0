Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCB2330E18
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:35:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbhCHMfR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:35:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:43946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231377AbhCHMeu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:34:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8D5D651C3;
        Mon,  8 Mar 2021 12:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615206890;
        bh=qPx5HoDeIJd5nqO3DGiogsWAn9wZ84K1xBXP1XmXZ6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=amxX52nNkt2CkEtXsfFlofUH36XiU18kYxXIhK55kPTkOWU6sjppGyL5toXrm8TS8
         M40B9fKfVF91uaUyqlOLkBAYsTCUsOlNHTzEZdDcTjC6gNgAqew+4Jfcc50FsbuzyT
         1dTBxb66mG15qT7v8WF4GaI5ayCQLDdyBO9NOghk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH 5.10 41/42] tomoyo: recognize kernel threads correctly
Date:   Mon,  8 Mar 2021 13:31:07 +0100
Message-Id: <20210308122720.101768274@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308122718.120213856@linuxfoundation.org>
References: <20210308122718.120213856@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit 9c83465f3245c2faa82ffeb7016f40f02bfaa0ad upstream.

Commit db68ce10c4f0a27c ("new helper: uaccess_kernel()") replaced
segment_eq(get_fs(), KERNEL_DS) with uaccess_kernel(). But the correct
method for tomoyo to check whether current is a kernel thread in order
to assume that kernel threads are privileged for socket operations was
(current->flags & PF_KTHREAD). Now that uaccess_kernel() became 0 on x86,
tomoyo has to fix this problem. Do like commit 942cb357ae7d9249 ("Smack:
Handle io_uring kernel thread privileges") does.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/tomoyo/network.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/security/tomoyo/network.c
+++ b/security/tomoyo/network.c
@@ -613,7 +613,7 @@ static int tomoyo_check_unix_address(str
 static bool tomoyo_kernel_service(void)
 {
 	/* Nothing to do if I am a kernel service. */
-	return uaccess_kernel();
+	return (current->flags & (PF_KTHREAD | PF_IO_WORKER)) == PF_KTHREAD;
 }
 
 /**


