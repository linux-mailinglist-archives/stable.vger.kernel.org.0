Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 730863F656D
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239545AbhHXRMr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:12:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:51088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239554AbhHXRKw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:10:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E73D61A64;
        Tue, 24 Aug 2021 17:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824444;
        bh=To40oEZF+AxZGbYWtmOTvxxJu29XONBQWHletcOm5qM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lZ+zJcMymJGqHdWjyAb76R3/JMEAe5cq8hRcSQsNn2k0qttrX71eqU17LmqHHKe+J
         5TNbssk/JBPUW2gOCmDA85nkuuFONmx4fIEaZslyaQ/jkVRSVyyku823X8l4Nn4u/P
         GKSBh+UbRyIRtBR5hJhoSvAAZxpLlTsgenGBdP+yTU2rRVwDiOk8piuabJgYjI53Kj
         72x2DZtjmx+Q6zyHQWi4pXg+Bm9ozwhUHCYOG1UFaqTBCDmbP452cuoYQzyPu2DY3d
         T1ICk0ixZV51NASQRbU2QWwyHe8Oe6mFeL/cQEu0th1A39M3Iu3gcp5bpdTruLaqm/
         q+VRXnQaffwJw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 95/98] fs: warn about impending deprecation of mandatory locks
Date:   Tue, 24 Aug 2021 12:59:05 -0400
Message-Id: <20210824165908.709932-96-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
References: <20210824165908.709932-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.61-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.61-rc1
X-KernelTest-Deadline: 2021-08-26T16:58+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit fdd92b64d15bc4aec973caa25899afd782402e68 ]

We've had CONFIG_MANDATORY_FILE_LOCKING since 2015 and a lot of distros
have disabled it. Warn the stragglers that still use "-o mand" that
we'll be dropping support for that mount option.

Cc: stable@vger.kernel.org
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 175312428cdf..046b084136c5 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1697,8 +1697,12 @@ static inline bool may_mount(void)
 }
 
 #ifdef	CONFIG_MANDATORY_FILE_LOCKING
-static inline bool may_mandlock(void)
+static bool may_mandlock(void)
 {
+	pr_warn_once("======================================================\n"
+		     "WARNING: the mand mount option is being deprecated and\n"
+		     "         will be removed in v5.15!\n"
+		     "======================================================\n");
 	return capable(CAP_SYS_ADMIN);
 }
 #else
-- 
2.30.2

