Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF10E87B9D
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 15:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405999AbfHINpo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 09:45:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:35194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726037AbfHINpn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Aug 2019 09:45:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B82D20B7C;
        Fri,  9 Aug 2019 13:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565358343;
        bh=vYrHU7Em3sK4QdBU/nAAU7PAM2WVowkqOO32qOfyNvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yMeRfa9tWfS8DvnHbIsYBfhciOckTfAPgCylHobHVroBw/+yFJkx7AH8G3mR2YbIK
         HU4NkiU+wwusg5+iciannmiI5xwpM59eKpgtT2kXo0Gsr/MEIO2yooSMRd9qe9VqWy
         PkVnXnMCVXZfDaIYRRqkdZj3D0cB3PE6B00CcQnE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shanker Donthineni <shankerd@codeaurora.org>,
        Will Deacon <will.deacon@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 01/21] arm64: cpufeature: Fix CTR_EL0 field definitions
Date:   Fri,  9 Aug 2019 15:45:05 +0200
Message-Id: <20190809134241.628430873@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809134241.565496442@linuxfoundation.org>
References: <20190809134241.565496442@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit be68a8aaf925aaf35574260bf820bb09d2f9e07f upstream.

Our field definitions for CTR_EL0 suffer from a number of problems:

  - The IDC and DIC fields are missing, which causes us to enable CTR
    trapping on CPUs with either of these returning non-zero values.

  - The ERG is FTR_LOWER_SAFE, whereas it should be treated like CWG as
    FTR_HIGHER_SAFE so that applications can use it to avoid false sharing.

  - [nit] A RES1 field is described as "RAO"

This patch updates the CTR_EL0 field definitions to fix these issues.

Cc: <stable@vger.kernel.org> # 4.4.y only
Cc: Shanker Donthineni <shankerd@codeaurora.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index c1eddc07d9968..fff0bf2f889e1 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -126,10 +126,12 @@ static struct arm64_ftr_bits ftr_id_aa64mmfr1[] = {
 };
 
 static struct arm64_ftr_bits ftr_ctr[] = {
-	U_ARM64_FTR_BITS(FTR_STRICT, FTR_EXACT, 31, 1, 1),	/* RAO */
-	ARM64_FTR_BITS(FTR_STRICT, FTR_EXACT, 28, 3, 0),
+	U_ARM64_FTR_BITS(FTR_STRICT, FTR_EXACT, 31, 1, 1),	/* RES1 */
+	ARM64_FTR_BITS(FTR_STRICT, FTR_EXACT, 30, 1, 0),
+	U_ARM64_FTR_BITS(FTR_STRICT, FTR_LOWER_SAFE, 29, 1, 1),	/* DIC */
+	U_ARM64_FTR_BITS(FTR_STRICT, FTR_LOWER_SAFE, 28, 1, 1),	/* IDC */
 	U_ARM64_FTR_BITS(FTR_STRICT, FTR_HIGHER_SAFE, 24, 4, 0),	/* CWG */
-	U_ARM64_FTR_BITS(FTR_STRICT, FTR_LOWER_SAFE, 20, 4, 0),	/* ERG */
+	U_ARM64_FTR_BITS(FTR_STRICT, FTR_HIGHER_SAFE, 20, 4, 0),	/* ERG */
 	U_ARM64_FTR_BITS(FTR_STRICT, FTR_LOWER_SAFE, 16, 4, 1),	/* DminLine */
 	/*
 	 * Linux can handle differing I-cache policies. Userspace JITs will
-- 
2.20.1



