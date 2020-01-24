Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A142148107
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390373AbgAXLQa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:16:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:53304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390369AbgAXLQa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:16:30 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 385812075D;
        Fri, 24 Jan 2020 11:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864589;
        bh=uho0PhkFgWD3meAJb5Lb5p+FMs+MeRiijl34yQ14bYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=StboQCEM8F3kTKetMbEtCiezwdUHyLbwDqqhBUwtqtNkIQMjWdGIWVPiRleyA55Bc
         JYycvhyf2Xjrg21mVB6iyO13pSW6KbIoE8sQz6DKInk+TOSN/J0UX32Q/mTH/l4eSL
         3jrfqi4msT9Ybk4pTMBvEiAJz/vlsiC6EIsmOWls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrey Ignatov <rdna@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 295/639] bpf: Add missed newline in verifier verbose log
Date:   Fri, 24 Jan 2020 10:27:45 +0100
Message-Id: <20200124093123.850706284@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Ignatov <rdna@fb.com>

[ Upstream commit 1fbd20f8b77b366ea4aeb92ade72daa7f36a7e3b ]

check_stack_access() that prints verbose log is used in
adjust_ptr_min_max_vals() that prints its own verbose log and now they
stick together, e.g.:

  variable stack access var_off=(0xfffffffffffffff0; 0x4) off=-16
  size=1R2 stack pointer arithmetic goes out of range, prohibited for
  !root

Add missing newline so that log is more readable:
  variable stack access var_off=(0xfffffffffffffff0; 0x4) off=-16 size=1
  R2 stack pointer arithmetic goes out of range, prohibited for !root

Fixes: f1174f77b50c ("bpf/verifier: rework value tracking")
Signed-off-by: Andrey Ignatov <rdna@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 9bbfb1ff4ac94..e85636fb81b9c 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1253,7 +1253,7 @@ static int check_stack_access(struct bpf_verifier_env *env,
 		char tn_buf[48];
 
 		tnum_strn(tn_buf, sizeof(tn_buf), reg->var_off);
-		verbose(env, "variable stack access var_off=%s off=%d size=%d",
+		verbose(env, "variable stack access var_off=%s off=%d size=%d\n",
 			tn_buf, off, size);
 		return -EACCES;
 	}
-- 
2.20.1



