Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72E18419A07
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235876AbhI0RGI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:06:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:44778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235880AbhI0RFx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:05:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3BCB61074;
        Mon, 27 Sep 2021 17:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762255;
        bh=qpgKfRSy0WRL//yUVgg/fqWsO5jm6cAXesAzEz4hoBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oOUyCfhNLmwn0LAY5s980Nn8ChI8Vr6g4LdjVtIVAqSliRPgiqgsMVd9mhBs5jsoh
         kVJwUPP5LC0iDk4VxjFwpm5m7rIzNeBmByNXzRAIvzEZc8mkxZjqfcyhKJsM1fqzfl
         VGbJjZhwsAOJIPsjfs3rQlHhosnSNpXQjvvD23Xw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <chao@kernel.org>,
        Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH 5.4 20/68] erofs: fix up erofs_lookup tracepoint
Date:   Mon, 27 Sep 2021 19:02:16 +0200
Message-Id: <20210927170220.647524522@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170219.901812470@linuxfoundation.org>
References: <20210927170219.901812470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gao Xiang <hsiangkao@linux.alibaba.com>

commit 93368aab0efc87288cac65e99c9ed2e0ffc9e7d0 upstream.

Fix up a misuse that the filename pointer isn't always valid in
the ring buffer, and we should copy the content instead.

Link: https://lore.kernel.org/r/20210921143531.81356-1-hsiangkao@linux.alibaba.com
Fixes: 13f06f48f7bf ("staging: erofs: support tracepoint")
Cc: stable@vger.kernel.org # 4.19+
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/trace/events/erofs.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

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
 


