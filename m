Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED6834CA75
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234303AbhC2Iil (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:38:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:55278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234606AbhC2Igv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:36:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA0A661929;
        Mon, 29 Mar 2021 08:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006962;
        bh=BWha6g2ReB6vQK8qQFmrEzo3gadJxJSoJqqOplO8hSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ITuh8IH3MwYGE8OnYUJ2pojXi6tx5eyQ6Iqet1kdfSCpbOLpILFItFantJmJeqESC
         aNkIfAd6MX8ZhSrNw3g1zqL/eIqG5Rhwx3ZpbYuGO/uIktzTizKupmihubuj2pP2EW
         XvW3D7MnOBta5nZDI8kStMHP5dpvbqSTzSXOVQ6s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 170/254] libbpf: Use SOCK_CLOEXEC when opening the netlink socket
Date:   Mon, 29 Mar 2021 09:58:06 +0200
Message-Id: <20210329075638.758700890@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit 58bfd95b554f1a23d01228672f86bb489bdbf4ba ]

Otherwise, there exists a small window between the opening and closing
of the socket fd where it may leak into processes launched by some other
thread.

Fixes: 949abbe88436 ("libbpf: add function to setup XDP")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://lore.kernel.org/bpf/20210317115857.6536-1-memxor@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
index 4dd73de00b6f..d2cb28e9ef52 100644
--- a/tools/lib/bpf/netlink.c
+++ b/tools/lib/bpf/netlink.c
@@ -40,7 +40,7 @@ static int libbpf_netlink_open(__u32 *nl_pid)
 	memset(&sa, 0, sizeof(sa));
 	sa.nl_family = AF_NETLINK;
 
-	sock = socket(AF_NETLINK, SOCK_RAW, NETLINK_ROUTE);
+	sock = socket(AF_NETLINK, SOCK_RAW | SOCK_CLOEXEC, NETLINK_ROUTE);
 	if (sock < 0)
 		return -errno;
 
-- 
2.30.1



