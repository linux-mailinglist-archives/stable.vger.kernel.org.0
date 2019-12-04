Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6B1A1133CB
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:20:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729872AbfLDSHz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:07:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:58748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730825AbfLDSHy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:07:54 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9952320675;
        Wed,  4 Dec 2019 18:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482874;
        bh=QApcd85KJGu+VIAEdaq2EaYQKmtUl3gmpV+llI2BE+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hg9rSd+endKIW5Y2rY3fLhDf9NecJi0XHKHgjNNuwKiNg4ezNiyq4zEzOjOuWLr5h
         +332D6DiY7MW0Eo+s5XhPv4DnnzTZYgsyQ3as4BAE1kdd2Lhidc2IN1aD4Tc3eGWmV
         RwcFfFC3+a/rWvM5i2GjmsSsGH3Bhkwx4t6cWfL8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Sun <sironhide0null@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 142/209] bpf: decrease usercnt if bpf_map_new_fd() fails in bpf_map_get_fd_by_id()
Date:   Wed,  4 Dec 2019 18:55:54 +0100
Message-Id: <20191204175333.088896488@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Sun <sironhide0null@gmail.com>

[ Upstream commit 781e62823cb81b972dc8652c1827205cda2ac9ac ]

In bpf/syscall.c, bpf_map_get_fd_by_id() use bpf_map_inc_not_zero()
to increase the refcount, both map->refcnt and map->usercnt. Then, if
bpf_map_new_fd() fails, should handle map->usercnt too.

Fixes: bd5f5f4ecb78 ("bpf: Add BPF_MAP_GET_FD_BY_ID")
Signed-off-by: Peng Sun <sironhide0null@gmail.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 59d2e94ecb798..34110450a78f2 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1354,7 +1354,7 @@ static int bpf_map_get_fd_by_id(const union bpf_attr *attr)
 
 	fd = bpf_map_new_fd(map);
 	if (fd < 0)
-		bpf_map_put(map);
+		bpf_map_put_with_uref(map);
 
 	return fd;
 }
-- 
2.20.1



