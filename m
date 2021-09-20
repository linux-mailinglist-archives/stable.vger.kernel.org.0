Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1CB9412311
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377793AbhITSU6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:20:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:40990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344009AbhITSS5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:18:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6DF9632AB;
        Mon, 20 Sep 2021 17:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158593;
        bh=nFgCtX4TUZ4Is7S8X4Jxx5TU8pPnTOTTKO3PHLhqnzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RklfHSS0yBz1QEEi3ZNwrA9Lh9/qWxkf0TOOJjLMee1nR5ai/yxYzNpIwC2/sZw5t
         u7Z1bozKHIv9YIgoIqKS+rXhVRrpMUUzGzfyAk8hTWFEyP7vRG50ko/xSCGhaPLTL+
         kbE+nQVZnXb8fkcC6p4aBiFRnOi3hCGfjHz1i3yo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.4 195/260] arm64/sve: Use correct size when reinitialising SVE state
Date:   Mon, 20 Sep 2021 18:43:33 +0200
Message-Id: <20210920163937.737954530@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

commit e35ac9d0b56e9efefaeeb84b635ea26c2839ea86 upstream.

When we need a buffer for SVE register state we call sve_alloc() to make
sure that one is there. In order to avoid repeated allocations and frees
we keep the buffer around unless we change vector length and just memset()
it to ensure a clean register state. The function that deals with this
takes the task to operate on as an argument, however in the case where we
do a memset() we initialise using the SVE state size for the current task
rather than the task passed as an argument.

This is only an issue in the case where we are setting the register state
for a task via ptrace and the task being configured has a different vector
length to the task tracing it. In the case where the buffer is larger in
the traced process we will leak old state from the traced process to
itself, in the case where the buffer is smaller in the traced process we
will overflow the buffer and corrupt memory.

Fixes: bc0ee4760364 ("arm64/sve: Core task context handling")
Cc: <stable@vger.kernel.org> # 4.15.x
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20210909165356.10675-1-broonie@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/fpsimd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -498,7 +498,7 @@ size_t sve_state_size(struct task_struct
 void sve_alloc(struct task_struct *task)
 {
 	if (task->thread.sve_state) {
-		memset(task->thread.sve_state, 0, sve_state_size(current));
+		memset(task->thread.sve_state, 0, sve_state_size(task));
 		return;
 	}
 


