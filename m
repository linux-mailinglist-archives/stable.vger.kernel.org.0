Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0070D1F44AE
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388315AbgFISHT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:07:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41552 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388197AbgFISF7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 14:05:59 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidH-0001qH-Sv; Tue, 09 Jun 2020 19:05:55 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidG-006VyS-Gv; Tue, 09 Jun 2020 19:05:54 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Al Viro" <viro@zeniv.linux.org.uk>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Alexey Dobriyan" <adobriyan@gmail.com>,
        "Kees Cook" <keescook@chromium.org>,
        "Alexander Potapenko" <glider@google.com>,
        "sam" <sunhaoyl@outlook.com>
Date:   Tue, 09 Jun 2020 19:04:52 +0100
Message-ID: <lsq.1591725832.570281262@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 61/61] fs/binfmt_elf.c: allocate initialized memory
 in fill_thread_core_info()
In-Reply-To: <lsq.1591725831.850867383@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.85-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Potapenko <glider@google.com>

commit 1d605416fb7175e1adf094251466caa52093b413 upstream.

KMSAN reported uninitialized data being written to disk when dumping
core.  As a result, several kilobytes of kmalloc memory may be written
to the core file and then read by a non-privileged user.

Reported-by: sam <sunhaoyl@outlook.com>
Signed-off-by: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Link: http://lkml.kernel.org/r/20200419100848.63472-1-glider@google.com
Link: https://github.com/google/kmsan/issues/76
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/binfmt_elf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1575,7 +1575,7 @@ static int fill_thread_core_info(struct
 		    (!regset->active || regset->active(t->task, regset) > 0)) {
 			int ret;
 			size_t size = regset->n * regset->size;
-			void *data = kmalloc(size, GFP_KERNEL);
+			void *data = kzalloc(size, GFP_KERNEL);
 			if (unlikely(!data))
 				return 0;
 			ret = regset->get(t->task, regset,

