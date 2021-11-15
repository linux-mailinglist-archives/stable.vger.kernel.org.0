Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66AA74512AA
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347188AbhKOTi6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:38:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:44648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233242AbhKOTSP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:18:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92F03634DF;
        Mon, 15 Nov 2021 18:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000755;
        bh=Er8wn0dvnqQ85y2qBjlFHXmGOr8K8UbLDTywZ1ZvZEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RgR90BXaS9CQGIcjhcRm1V5m56aRVzWIpAcx+vjVgxPSgWk5ZaIoO5IJMusXpNLkx
         oePBuTZnLIATdlpkoeovyZ7hdY2bLVDe3F+2dISK59A/GdT6ewiHRYYEiCFzRdHDN+
         VuwfhyXtp+kB9GuySTGd7fMDQCugIzODL/DI5GMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mehrdad Arshad Rad <arshad.rad@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 747/849] libbpf: Fix lookup_and_delete_elem_flags error reporting
Date:   Mon, 15 Nov 2021 18:03:50 +0100
Message-Id: <20211115165445.525871649@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mehrdad Arshad Rad <arshad.rad@gmail.com>

[ Upstream commit 64165ddf8ea184631c65e3bbc8d59f6d940590ca ]

Fix bpf_map_lookup_and_delete_elem_flags() to pass the return code through
libbpf_err_errno() as we do similarly in bpf_map_lookup_and_delete_elem().

Fixes: f12b65432728 ("libbpf: Streamline error reporting for low-level APIs")
Signed-off-by: Mehrdad Arshad Rad <arshad.rad@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20211104171354.11072-1-arshad.rad@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/bpf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 86dcac44f32f6..2c3ac0edf6ad3 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -480,6 +480,7 @@ int bpf_map_lookup_and_delete_elem(int fd, const void *key, void *value)
 int bpf_map_lookup_and_delete_elem_flags(int fd, const void *key, void *value, __u64 flags)
 {
 	union bpf_attr attr;
+	int ret;
 
 	memset(&attr, 0, sizeof(attr));
 	attr.map_fd = fd;
@@ -487,7 +488,8 @@ int bpf_map_lookup_and_delete_elem_flags(int fd, const void *key, void *value, _
 	attr.value = ptr_to_u64(value);
 	attr.flags = flags;
 
-	return sys_bpf(BPF_MAP_LOOKUP_AND_DELETE_ELEM, &attr, sizeof(attr));
+	ret = sys_bpf(BPF_MAP_LOOKUP_AND_DELETE_ELEM, &attr, sizeof(attr));
+	return libbpf_err_errno(ret);
 }
 
 int bpf_map_delete_elem(int fd, const void *key)
-- 
2.33.0



