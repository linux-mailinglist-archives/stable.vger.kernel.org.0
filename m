Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20D9B1B3F94
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731197AbgDVKim (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:38:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:58382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729521AbgDVKWG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:22:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E45D20781;
        Wed, 22 Apr 2020 10:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550916;
        bh=LL415fMCll3EPDqhPFrXHvuwJiE40xZIH4DFBw19Q8k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jfYXaVO61Jcqh0eYXSb6JLTG2JZGeXe/o711AYGfhb8xkPmGWHNlWmqjdI2heuJ+y
         oklI+uTdvFMXQCs/XWsvzHv4odzUJg0j4u4DqfdA6bjgz0iitxO/19Y6aBwEzLnPEf
         TgJCQ5ad9lisfYsd4PDGrLe+cAmDZBsRgoF9PbU0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrey Ignatov <rdna@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH 5.6 009/166] libbpf: Fix bpf_get_link_xdp_id flags handling
Date:   Wed, 22 Apr 2020 11:55:36 +0200
Message-Id: <20200422095049.161346249@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
References: <20200422095047.669225321@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Ignatov <rdna@fb.com>

commit f07cbad29741407ace2a9688548fa93d9cb38df3 upstream.

Currently if one of XDP_FLAGS_{DRV,HW,SKB}_MODE flags is passed to
bpf_get_link_xdp_id() and there is a single XDP program attached to
ifindex, that program's id will be returned by bpf_get_link_xdp_id() in
prog_id argument no matter what mode the program is attached in, i.e.
flags argument is not taken into account.

For example, if there is a single program attached with
XDP_FLAGS_SKB_MODE but user calls bpf_get_link_xdp_id() with flags =
XDP_FLAGS_DRV_MODE, that skb program will be returned.

Fix it by returning info->prog_id only if user didn't specify flags. If
flags is specified then return corresponding mode-specific-field from
struct xdp_link_info.

The initial error was introduced in commit 50db9f073188 ("libbpf: Add a
support for getting xdp prog id on ifindex") and then refactored in
473f4e133a12 so 473f4e133a12 is used in the Fixes tag.

Fixes: 473f4e133a12 ("libbpf: Add bpf_get_link_xdp_info() function to get more XDP information")
Signed-off-by: Andrey Ignatov <rdna@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://lore.kernel.org/bpf/0e9e30490b44b447bb2bebc69c7135e7fe7e4e40.1586236080.git.rdna@fb.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/lib/bpf/netlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/lib/bpf/netlink.c
+++ b/tools/lib/bpf/netlink.c
@@ -289,7 +289,7 @@ int bpf_get_link_xdp_info(int ifindex, s
 
 static __u32 get_xdp_id(struct xdp_link_info *info, __u32 flags)
 {
-	if (info->attach_mode != XDP_ATTACHED_MULTI)
+	if (info->attach_mode != XDP_ATTACHED_MULTI && !flags)
 		return info->prog_id;
 	if (flags & XDP_FLAGS_DRV_MODE)
 		return info->drv_prog_id;


