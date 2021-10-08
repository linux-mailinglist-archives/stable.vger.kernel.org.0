Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD444268F0
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240749AbhJHLcy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:32:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:59314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240764AbhJHLcF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:32:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD5F461040;
        Fri,  8 Oct 2021 11:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692580;
        bh=vItgBdU7Zpij+YFPmETvQ4GYWk6GNPFn4Vv0M4mh/zk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q7681ysmjOPaH2HSFoX5WNPY1Q0ioF17DPV1+XiS34sx0mTKMsfH53tMVYYFApqfR
         LALutJjqKa1KI3AyX10yVkZPyKU7ncMBNLcjnNPLf//zIx/d5GjNBpWbfYeGW7HsUe
         lR6ybRp9y78IlxcOldMhNavbitI9zZPWqeyN4mzg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Changbin Du <changbin.du@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 10/12] tools/vm/page-types: remove dependency on opt_file for idle page tracking
Date:   Fri,  8 Oct 2021 13:27:58 +0200
Message-Id: <20211008112714.924979518@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112714.601107695@linuxfoundation.org>
References: <20211008112714.601107695@linuxfoundation.org>
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
index 1ff3a6c0367b..89063b967b6b 100644
--- a/tools/vm/page-types.c
+++ b/tools/vm/page-types.c
@@ -1341,7 +1341,7 @@ int main(int argc, char *argv[])
 	if (opt_list && opt_list_mapcnt)
 		kpagecount_fd = checked_open(PROC_KPAGECOUNT, O_RDONLY);
 
-	if (opt_mark_idle && opt_file)
+	if (opt_mark_idle)
 		page_idle_fd = checked_open(SYS_KERNEL_MM_PAGE_IDLE, O_RDWR);
 
 	if (opt_list && opt_pid)
-- 
2.33.0



