Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31A24469BF7
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243340AbhLFPTJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:19:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359398AbhLFPRL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:17:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32503C08EAE5;
        Mon,  6 Dec 2021 07:10:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CCE8AB81018;
        Mon,  6 Dec 2021 15:10:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04DD1C341C2;
        Mon,  6 Dec 2021 15:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803426;
        bh=jvzNmJK63+tjJYtDhzEY6ibaTayFSQtHZM1E31RcI/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D5Q/Jx7/QWIgNPviJvX5QArsX3FsHXUfK5J68ogur3Gqly+FjKpf3ntQUeXrSqyne
         CIwos/sQGp3OU4sz4JFKovZ5EsMzNX4RNxy6HaYxVPPiTwuV3qqimo6FCTAZq7Q9Nm
         Jm7UgJFUuP/zb0Cgz3Va7mOI94OIPST/BBBBUg4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>
Subject: [PATCH 4.19 38/48] parisc: Fix "make install" on newer debian releases
Date:   Mon,  6 Dec 2021 15:56:55 +0100
Message-Id: <20211206145550.145472422@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145548.859182340@linuxfoundation.org>
References: <20211206145548.859182340@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit 0f9fee4cdebfbe695c297e5b603a275e2557c1cc upstream.

On newer debian releases the debian-provided "installkernel" script is
installed in /usr/sbin. Fix the kernel install.sh script to look for the
script in this directory as well.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: <stable@vger.kernel.org> # v3.13+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/install.sh |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/parisc/install.sh
+++ b/arch/parisc/install.sh
@@ -39,6 +39,7 @@ verify "$3"
 if [ -n "${INSTALLKERNEL}" ]; then
   if [ -x ~/bin/${INSTALLKERNEL} ]; then exec ~/bin/${INSTALLKERNEL} "$@"; fi
   if [ -x /sbin/${INSTALLKERNEL} ]; then exec /sbin/${INSTALLKERNEL} "$@"; fi
+  if [ -x /usr/sbin/${INSTALLKERNEL} ]; then exec /usr/sbin/${INSTALLKERNEL} "$@"; fi
 fi
 
 # Default install


