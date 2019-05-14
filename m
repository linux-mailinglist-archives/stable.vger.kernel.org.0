Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AFB51D08D
	for <lists+stable@lfdr.de>; Tue, 14 May 2019 22:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726036AbfENUZQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 16:25:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:34752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726452AbfENUZH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 May 2019 16:25:07 -0400
Received: from localhost (c-67-180-165-146.hsd1.ca.comcast.net [67.180.165.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 119F020873;
        Tue, 14 May 2019 20:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557865506;
        bh=s3C47J5Nx7iT+B8/KN1g5wj7fPbn9EIFp0Z0+cSyuYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sf+QUe4rbmyQfOdGuFVEtREbiUMoD1NK8C2cLge3vMxHaHZEm4d59FAWysRS0bjzR
         UFRJgXw3rDGtqVd7Z9fsDO7zyGE/J6E+STTfOy8RamqeyA2t04KJn2oZbMaUQakeG6
         7D/Ny9jwjr0j9jcZcXChiVFldFXopxUqv/gfgrdg=
From:   Andy Lutomirski <luto@kernel.org>
To:     x86@kernel.org
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Borislav Petkov <bp@suse.de>,
        Frederic Weisbecker <frederic@kernel.org>,
        Jon Masters <jcm@redhat.com>
Subject: [PATCH 2/2] x86/speculation/mds: Improve CPU buffer clear documentation
Date:   Tue, 14 May 2019 13:24:40 -0700
Message-Id: <999fa9e126ba6a48e9d214d2f18dbde5c62ac55c.1557865329.git.luto@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1557865329.git.luto@kernel.org>
References: <cover.1557865329.git.luto@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On x86_64, all returns to usermode go through
prepare_exit_to_usermode(), with the sole exception of do_nmi().
This even includes machine checks -- this was added several years
ago to support MCE recovery.  Update the documentation.

Cc: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Jon Masters <jcm@redhat.com>
Fixes: 04dcbdb80578 ("x86/speculation/mds: Clear CPU buffers on exit to user")
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 Documentation/x86/mds.rst | 39 +++++++--------------------------------
 1 file changed, 7 insertions(+), 32 deletions(-)

diff --git a/Documentation/x86/mds.rst b/Documentation/x86/mds.rst
index 0dc812bb9249..5d4330be200f 100644
--- a/Documentation/x86/mds.rst
+++ b/Documentation/x86/mds.rst
@@ -142,38 +142,13 @@ Mitigation points
    mds_user_clear.
 
    The mitigation is invoked in prepare_exit_to_usermode() which covers
-   most of the kernel to user space transitions. There are a few exceptions
-   which are not invoking prepare_exit_to_usermode() on return to user
-   space. These exceptions use the paranoid exit code.
-
-   - Non Maskable Interrupt (NMI):
-
-     Access to sensible data like keys, credentials in the NMI context is
-     mostly theoretical: The CPU can do prefetching or execute a
-     misspeculated code path and thereby fetching data which might end up
-     leaking through a buffer.
-
-     But for mounting other attacks the kernel stack address of the task is
-     already valuable information. So in full mitigation mode, the NMI is
-     mitigated on the return from do_nmi() to provide almost complete
-     coverage.
-
-   - Machine Check Exception (#MC):
-
-     Another corner case is a #MC which hits between the CPU buffer clear
-     invocation and the actual return to user. As this still is in kernel
-     space it takes the paranoid exit path which does not clear the CPU
-     buffers. So the #MC handler repopulates the buffers to some
-     extent. Machine checks are not reliably controllable and the window is
-     extremly small so mitigation would just tick a checkbox that this
-     theoretical corner case is covered. To keep the amount of special
-     cases small, ignore #MC.
-
-   - Debug Exception (#DB):
-
-     This takes the paranoid exit path only when the INT1 breakpoint is in
-     kernel space. #DB on a user space address takes the regular exit path,
-     so no extra mitigation required.
+   all but one of the kernel to user space transitions.  The exception
+   is when we return from a Non Maskable Interrupt (NMI), which is
+   handled directly in do_nmi().
+
+   (The reason that NMI is special is that prepare_exit_to_usermode() can
+    enable IRQs.  In NMI context, NMIs are blocked, and we don't want to
+    enable IRQs with NMIs blocked.)
 
 
 2. C-State transition
-- 
2.21.0

