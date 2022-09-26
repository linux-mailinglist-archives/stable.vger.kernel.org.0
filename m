Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 319745EA339
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237823AbiIZLVj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237664AbiIZLTm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:19:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E29852454;
        Mon, 26 Sep 2022 03:39:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD1FBB8095C;
        Mon, 26 Sep 2022 10:37:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F182C433C1;
        Mon, 26 Sep 2022 10:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188670;
        bh=6Z96eXjVRRr1HvpDRdgPDwRE1VX2O2GqrBUwuYg3+Dk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oQQrc1z3kuxF9+05VSiaSRCe+bdiCC251tBASoOQbA0AmaupGzHhEm+2nP9dAXFDq
         qfwp/0vF4uz1BWjUi9+/yUir3tFsVwR9KVGHhEzdVDfrRZnGaXOwNROmkWQHqmdnuT
         JGEcTRq+uK7peegjLa1AFk+XHCFNTKdPFpM8j9GQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Meyer <thomas@m3y3r.de>,
        Christian Lamparter <chunkeey@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 082/148] um: fix default console kernel parameter
Date:   Mon, 26 Sep 2022 12:11:56 +0200
Message-Id: <20220926100759.119720109@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
References: <20220926100756.074519146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Lamparter <chunkeey@gmail.com>

[ Upstream commit 782b1f70f8a8b28571949d2ba43fe88b96d75ec3 ]

OpenWrt's UML with 5.15 was producing odd errors/warnings during preinit
part of the early userspace portion:

|[    0.000000] Kernel command line: ubd0=root.img root=98:0 console=tty
|[...]
|[    0.440000] random: jshn: uninitialized urandom read (4 bytes read)
|[    0.460000] random: jshn: uninitialized urandom read (4 bytes read)
|/etc/preinit: line 47: can't create /dev/tty: No such device or address
|/etc/preinit: line 48: can't create /dev/tty: No such device or address
|/etc/preinit: line 58: can't open /dev/tty: No such device or address
|[...] repeated many times

That "/dev/tty" came from the command line (which is automatically
added if no console= parameter was specified for the uml binary).

The TLDP project tells the following about the /dev/tty:
<https://tldp.org/HOWTO/Text-Terminal-HOWTO-7.html#ss7.3>
| /dev/tty stands for the controlling terminal (if any) for the current
| process.[...]
| /dev/tty is something like a link to the actually terminal device[..]

The "(if any)" is important here, since it's possible for processes to
not have a controlling terminal.

I think this was a simple typo and the author wanted tty0 there.

CC: Thomas Meyer <thomas@m3y3r.de>
Fixes: d7ffac33631b ("um: stdio_console: Make preferred console")
Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/kernel/um_arch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/um/kernel/um_arch.c b/arch/um/kernel/um_arch.c
index 960f5c35ad1b..8dc7ab1f3cd4 100644
--- a/arch/um/kernel/um_arch.c
+++ b/arch/um/kernel/um_arch.c
@@ -31,7 +31,7 @@
 #include <os.h>
 
 #define DEFAULT_COMMAND_LINE_ROOT "root=98:0"
-#define DEFAULT_COMMAND_LINE_CONSOLE "console=tty"
+#define DEFAULT_COMMAND_LINE_CONSOLE "console=tty0"
 
 /* Changed in add_arg and setup_arch, which run before SMP is started */
 static char __initdata command_line[COMMAND_LINE_SIZE] = { 0 };
-- 
2.35.1



