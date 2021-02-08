Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D657313702
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233444AbhBHPSo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:18:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:56402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233390AbhBHPNJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:13:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4689C64EA4;
        Mon,  8 Feb 2021 15:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796983;
        bh=06UISuueafKnvCsvOUKs4efLyGgYir3jjkFATP7Lw/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BN6m4VfzjqjEzXIvLhLd0Lu88rVjVT6rGcW5AqaT3oEkvrypVKSFdzRzqqLaf5AFB
         uaRWk4viW75hfsq+hcqf3vsf9OBzStFx0a+su8i1bQeOvzrhSDkROwdz7pGPNhN8/7
         W5TF5ZI/hPCTelbCxjSPaIiJ4iq2SSa06/d09w68=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Loris Reiff <loris.reiff@liblor.ch>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 09/65] bpf, cgroup: Fix problematic bounds check
Date:   Mon,  8 Feb 2021 16:00:41 +0100
Message-Id: <20210208145810.599465221@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145810.230485165@linuxfoundation.org>
References: <20210208145810.230485165@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Loris Reiff <loris.reiff@liblor.ch>

[ Upstream commit f4a2da755a7e1f5d845c52aee71336cee289935a ]

Since ctx.optlen is signed, a larger value than max_value could be
passed, as it is later on used as unsigned, which causes a WARN_ON_ONCE
in the copy_to_user.

Fixes: 0d01da6afc54 ("bpf: implement getsockopt and setsockopt hooks")
Signed-off-by: Loris Reiff <loris.reiff@liblor.ch>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Stanislav Fomichev <sdf@google.com>
Link: https://lore.kernel.org/bpf/20210122164232.61770-2-loris.reiff@liblor.ch
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 5b2413eb79db4..c2f0aa818b7af 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1131,7 +1131,7 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
 		goto out;
 	}
 
-	if (ctx.optlen > max_optlen) {
+	if (ctx.optlen > max_optlen || ctx.optlen < 0) {
 		ret = -EFAULT;
 		goto out;
 	}
-- 
2.27.0



