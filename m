Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B34B85AEBE0
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241433AbiIFOU1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241856AbiIFOSy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:18:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F93248C9;
        Tue,  6 Sep 2022 06:49:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E6AEB818DD;
        Tue,  6 Sep 2022 13:48:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D082CC43140;
        Tue,  6 Sep 2022 13:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662472113;
        bh=cYNczMPEdfN9c4vCdA78f6vSVMnyKAddTZfKhNbc4p0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g2IvWsGdkEL+aru9QLx8KHmYwKy+0jWUmNGZ0miRryvi9VNyY6zYrL44p6cxgeyun
         wU+ikaQrlMLASkj9o+UTiLiNQglJrz1qDW9YSuc4AGJgvcSLJmj20FcCp+level9Bg
         m4sKpML3CheZxZWNf6kPC+JkIvaFUEpgsVEI8zh4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable <stable@kernel.org>,
        Mazin Al Haddad <mazinalhaddad05@gmail.com>,
        syzbot+e3563f0c94e188366dbb@syzkaller.appspotmail.com
Subject: [PATCH 5.19 152/155] tty: n_gsm: add sanity check for gsm->receive in gsm_receive_buf()
Date:   Tue,  6 Sep 2022 15:31:40 +0200
Message-Id: <20220906132835.818479922@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mazin Al Haddad <mazinalhaddad05@gmail.com>

commit f16c6d2e58a4c2b972efcf9eb12390ee0ba3befb upstream.

A null pointer dereference can happen when attempting to access the
"gsm->receive()" function in gsmld_receive_buf(). Currently, the code
assumes that gsm->recieve is only called after MUX activation.
Since the gsmld_receive_buf() function can be accessed without the need to
initialize the MUX, the gsm->receive() function will not be set and a
NULL pointer dereference will occur.

Fix this by avoiding the call to "gsm->receive()" in case the function is
not initialized by adding a sanity check.

Call Trace:
 <TASK>
 gsmld_receive_buf+0x1c2/0x2f0 drivers/tty/n_gsm.c:2861
 tiocsti drivers/tty/tty_io.c:2293 [inline]
 tty_ioctl+0xa75/0x15d0 drivers/tty/tty_io.c:2692
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Link: https://syzkaller.appspot.com/bug?id=bdf035c61447f8c6e0e6920315d577cb5cc35ac5
Fixes: 01aecd917114 ("tty: n_gsm: fix tty registration before control channel open")
Cc: stable <stable@kernel.org>
Reported-and-tested-by: syzbot+e3563f0c94e188366dbb@syzkaller.appspotmail.com
Signed-off-by: Mazin Al Haddad <mazinalhaddad05@gmail.com>
Link: https://lore.kernel.org/r/20220814015211.84180-1-mazinalhaddad05@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/n_gsm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2858,7 +2858,8 @@ static void gsmld_receive_buf(struct tty
 			flags = *fp++;
 		switch (flags) {
 		case TTY_NORMAL:
-			gsm->receive(gsm, *cp);
+			if (gsm->receive)
+				gsm->receive(gsm, *cp);
 			break;
 		case TTY_OVERRUN:
 		case TTY_BREAK:


