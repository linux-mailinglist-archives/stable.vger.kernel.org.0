Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F74A491789
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344854AbiARCmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:42:10 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48498 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345488AbiARCbf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:31:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82A41611D4;
        Tue, 18 Jan 2022 02:31:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A1F5C36AEF;
        Tue, 18 Jan 2022 02:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473095;
        bh=f3jC77ynaSTB8B4PFcxF+om2SUl/1JBzStOOMLauPeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ELNds69ppMV9Pvg66ovZcZT9p2Xr3xD8G4op6HY1pVFciqZIRSx9gQT98qvMGjm1M
         27bXL/rJ+K8CNMZxpVJVntHQ659Yf0eT6FRy/97YJOLPsKdlhHR/1HF/DfY4BskhOX
         LPII5zFyGpLyOJGsYUPTvck+CzF9bNXccp285bvyYRuBpVCbYEKAJbJCYJH7/sxgYQ
         UoKY960aBzJo3DL8KdSkw2uRSGQH8LFAzXcJk+TD/cUBY4LfKmx6gZbhZ5M/S0L3/p
         EmaKSam/gB05fMYE75AQUIxipjmhHY7r05xFn4EDaZUKDTJaHPTTXXZJ7WkFtlS5kl
         HVDmcM0CWanmg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Akira Yokosawa <akiyks@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sasha Levin <sashal@kernel.org>, linux-doc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 212/217] scripts: sphinx-pre-install: Fix ctex support on Debian
Date:   Mon, 17 Jan 2022 21:19:35 -0500
Message-Id: <20220118021940.1942199-212-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab@kernel.org>

[ Upstream commit 87d6576ddf8ac25f36597bc93ca17f6628289c16 ]

The name of the package with ctexhook.sty is different on
Debian/Ubuntu.

Reported-by: Akira Yokosawa <akiyks@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Tested-by: Akira Yokosawa <akiyks@gmail.com>
Link: https://lore.kernel.org/r/63882425609a2820fac78f5e94620abeb7ed5f6f.1641429634.git.mchehab@kernel.org
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/sphinx-pre-install | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/scripts/sphinx-pre-install b/scripts/sphinx-pre-install
index 288e86a9d1e58..61a79ce705ccf 100755
--- a/scripts/sphinx-pre-install
+++ b/scripts/sphinx-pre-install
@@ -369,6 +369,9 @@ sub give_debian_hints()
 	);
 
 	if ($pdf) {
+		check_missing_file(["/usr/share/texlive/texmf-dist/tex/latex/ctex/ctexhook.sty"],
+				   "texlive-lang-chinese", 2);
+
 		check_missing_file(["/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf"],
 				   "fonts-dejavu", 2);
 
-- 
2.34.1

