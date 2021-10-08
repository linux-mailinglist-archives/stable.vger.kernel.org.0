Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4755A4269B7
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242733AbhJHLkk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:40:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:39490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243265AbhJHLjH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:39:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F7E8617E4;
        Fri,  8 Oct 2021 11:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692803;
        bh=URTIX7csHgSfr/PXlRPi6sf11mamz8TaxWjqo7QXMAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u8EQ4x2KEpD5uNjppGA6Mf01/Ene6FfOzsYOurdNVcRNkdx9wrw1BLdNPUnTyFtG7
         CojRelNn6i00ULYACERQ3W/wJWQTWJ0pnpfGHclpXqog0f2wNd6Bna/3ekFZpxl5Qe
         52izW8kn6dGOOcAmJrR35JLH84NCKbBgfAv6qdec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Changbin Du <changbin.du@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 38/48] tools/vm/page-types: remove dependency on opt_file for idle page tracking
Date:   Fri,  8 Oct 2021 13:28:14 +0200
Message-Id: <20211008112721.305491017@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112720.008415452@linuxfoundation.org>
References: <20211008112720.008415452@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Changbin Du <changbin.du@gmail.com>

[ Upstream commit ebaeab2fe87987cef28eb5ab174c42cd28594387 ]

Idle page tracking can also be used for process address space, not only
file mappings.

Without this change, using with '-i' option for process address space
encounters below errors reported.

  $ sudo ./page-types -p $(pidof bash) -i
  mark page idle: Bad file descriptor
  mark page idle: Bad file descriptor
  mark page idle: Bad file descriptor
  mark page idle: Bad file descriptor
  ...

Link: https://lkml.kernel.org/r/20210917032826.10669-1-changbin.du@gmail.com
Signed-off-by: Changbin Du <changbin.du@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/vm/page-types.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/vm/page-types.c b/tools/vm/page-types.c
index 0517c744b04e..f62f10c988db 100644
--- a/tools/vm/page-types.c
+++ b/tools/vm/page-types.c
@@ -1331,7 +1331,7 @@ int main(int argc, char *argv[])
 	if (opt_list && opt_list_mapcnt)
 		kpagecount_fd = checked_open(PROC_KPAGECOUNT, O_RDONLY);
 
-	if (opt_mark_idle && opt_file)
+	if (opt_mark_idle)
 		page_idle_fd = checked_open(SYS_KERNEL_MM_PAGE_IDLE, O_RDWR);
 
 	if (opt_list && opt_pid)
-- 
2.33.0



