Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CFCC4188FA
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 15:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231690AbhIZNJg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Sep 2021 09:09:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:35918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231671AbhIZNJf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 26 Sep 2021 09:09:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 439E561019;
        Sun, 26 Sep 2021 13:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632661679;
        bh=/T4Zvnff4XYV0k5QxaUOWziNUh/Q1hyEDsrq45J/hv8=;
        h=Subject:To:Cc:From:Date:From;
        b=HiwBFGgouP8Yh4wLULVnQGCrKlsvlVrd7KWXOK5i5tRGWFr9K9VTfa7Xk50ezmXuM
         P1YG6RaHzDdN09xgkn1hlVjx1eZdEHaOiQm3mK5p5h4t1Ow6avZdZMPKXELBscTgOM
         wIx7rl0Er6Ccys7kYF4JVtYqph3WwifHFDHsPCVg=
Subject: FAILED: patch "[PATCH] erofs: fix up erofs_lookup tracepoint" failed to apply to 4.19-stable tree
To:     hsiangkao@linux.alibaba.com, chao@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 26 Sep 2021 15:07:57 +0200
Message-ID: <163266167710981@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 93368aab0efc87288cac65e99c9ed2e0ffc9e7d0 Mon Sep 17 00:00:00 2001
From: Gao Xiang <hsiangkao@linux.alibaba.com>
Date: Tue, 21 Sep 2021 22:35:30 +0800
Subject: [PATCH] erofs: fix up erofs_lookup tracepoint

Fix up a misuse that the filename pointer isn't always valid in
the ring buffer, and we should copy the content instead.

Link: https://lore.kernel.org/r/20210921143531.81356-1-hsiangkao@linux.alibaba.com
Fixes: 13f06f48f7bf ("staging: erofs: support tracepoint")
Cc: stable@vger.kernel.org # 4.19+
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>

diff --git a/include/trace/events/erofs.h b/include/trace/events/erofs.h
index bf9806fd1306..db4f2cec8360 100644
--- a/include/trace/events/erofs.h
+++ b/include/trace/events/erofs.h
@@ -35,20 +35,20 @@ TRACE_EVENT(erofs_lookup,
 	TP_STRUCT__entry(
 		__field(dev_t,		dev	)
 		__field(erofs_nid_t,	nid	)
-		__field(const char *,	name	)
+		__string(name,		dentry->d_name.name	)
 		__field(unsigned int,	flags	)
 	),
 
 	TP_fast_assign(
 		__entry->dev	= dir->i_sb->s_dev;
 		__entry->nid	= EROFS_I(dir)->nid;
-		__entry->name	= dentry->d_name.name;
+		__assign_str(name, dentry->d_name.name);
 		__entry->flags	= flags;
 	),
 
 	TP_printk("dev = (%d,%d), pnid = %llu, name:%s, flags:%x",
 		show_dev_nid(__entry),
-		__entry->name,
+		__get_str(name),
 		__entry->flags)
 );
 

