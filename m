Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB69405B8E
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 18:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239706AbhIIQzp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 12:55:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:38348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239011AbhIIQzo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 12:55:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4659961100;
        Thu,  9 Sep 2021 16:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631206474;
        bh=NyhqwFXFDvlt69k+Qs0IGRTqIoLZfrQ3rHOSi8PkHn8=;
        h=From:To:Cc:Subject:Date:From;
        b=o8RKBBVf3SISU4KpilH7ZtCLGfLpAfa4ID54sZtkdG9GJJaIvFudTnamSCGkhG2uN
         jFZXgOoPLCnVa1jqJSLruWaLnKwspby0f583Gg3YwcYOuX8Lu8wA6PuZWYpNwFlg0M
         cpdM4DjfDNYAdLU+wTIGcQRpjhx425fIqO/znAFEfIvz4Dh8jhEn6t0i5e+V+xo/kj
         5RmQx8IAuWBq7VihEfldzJhquoUrf4Nbio7BRf+GW2KEXUiKxVzcyJe0jKs91HBP2w
         VoGeg+jJbG6TKpiGj0Wv0hr+YqxTvEsxa68JUTHpWw2+q2emgGmiN9BhNOeJgi+kDu
         svshRLlW/G09g==
From:   Mark Brown <broonie@kernel.org>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] arm64/sve: Use correct size when reinitialising SVE state
Date:   Thu,  9 Sep 2021 17:53:56 +0100
Message-Id: <20210909165356.10675-1-broonie@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1631; h=from:subject; bh=NyhqwFXFDvlt69k+Qs0IGRTqIoLZfrQ3rHOSi8PkHn8=; b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBhOjswYfKo1aT2/gRSLg+WC7LhYNeBGm9DX4JRX5tr Guc0JHqJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYTo7MAAKCRAk1otyXVSH0MV5B/ 464gq60JX0BC/90yiGZmi4JlxWNEez2vE9+gXaeNA3eh9ajPGO8YMknU4likmnbLV9RJEHWS7hrXuM zznfJ2w+tn/4ek1mjGYi+Zqa5mjJXRHEDkBarF8JTsqumIa9aASz2bUHXJxSWlHFvEdZSVtlXhCv/c fk1DSyn2EImQMslGvllt05VBTrGI+jUgOskT02CYmp6+bJ26vmDuFUcM5heTPEwGTqD9/Zn4qpPvW3 9S7jO8rjGb0ERkIJ/VoQ+Ej2eukFZnhNu8n2FcmnRyoYt+tvlEgmZfv7UcTGt5xT8p25FmgAiouoRH 978hVNTk42CD5rcA47Lxftp31lb/GE
X-Developer-Key: i=broonie@kernel.org; a=openpgp; fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Fixes: bc0ee47603647 (arm64/sve: Core task context handling)
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
---
 arch/arm64/kernel/fpsimd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 5a294f20e9de..ff4962750b3d 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -513,7 +513,7 @@ size_t sve_state_size(struct task_struct const *task)
 void sve_alloc(struct task_struct *task)
 {
 	if (task->thread.sve_state) {
-		memset(task->thread.sve_state, 0, sve_state_size(current));
+		memset(task->thread.sve_state, 0, sve_state_size(task));
 		return;
 	}
 
-- 
2.20.1

