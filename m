Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9FAA37C861
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235466AbhELQIV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:08:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:50152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236141AbhELQCX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:02:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8E7761CE1;
        Wed, 12 May 2021 15:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833617;
        bh=h6kKy5Bw8PiMHDI5BTRnI12X0Lbo4WoT8QcKwrw64UA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jJdEsR2tp6tNMkj6Uju30opcc68LTsdbgitg201IXzTzxk7K8R+IuovVpsr8E84/K
         5RsPptuKlGaF4yEtqeZbi+T4HWHj8fGE2NM5y/TA1uIaeDUE+krNsDxJlBj0vSL2Qt
         LFjBdGO081Ly/m7V59rhFINZ8B6vKFpwT5cFYQLA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 187/601] selftests/x86: Add a missing .note.GNU-stack section to thunks_32.S
Date:   Wed, 12 May 2021 16:44:24 +0200
Message-Id: <20210512144833.998728680@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Lutomirski <luto@kernel.org>

[ Upstream commit f706bb59204ba1c47e896b456c97977fc97b7964 ]

test_syscall_vdso_32 ended up with an executable stacks because the asm
was missing the annotation that says that it is modern and doesn't need
an executable stack. Add the annotation.

This was missed in commit aeaaf005da1d ("selftests/x86: Add missing
.note.GNU-stack sections").

Fixes: aeaaf005da1d ("selftests/x86: Add missing .note.GNU-stack sections")
Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/487ed5348a43c031b816fa7e9efedb75dc324299.1614877299.git.luto@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/x86/thunks_32.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/x86/thunks_32.S b/tools/testing/selftests/x86/thunks_32.S
index a71d92da8f46..f3f56e681e9f 100644
--- a/tools/testing/selftests/x86/thunks_32.S
+++ b/tools/testing/selftests/x86/thunks_32.S
@@ -45,3 +45,5 @@ call64_from_32:
 	ret
 
 .size call64_from_32, .-call64_from_32
+
+.section .note.GNU-stack,"",%progbits
-- 
2.30.2



