Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E22973F67E3
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239857AbhHXRig (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:38:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:40664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240349AbhHXRgh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:36:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2CA361BE5;
        Tue, 24 Aug 2021 17:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824817;
        bh=WCfseJ+9r+IKuHwaKDZrYboBqJqWWqfCwNONAY6Uwnw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CjaWHjP2FCOEdWDuLCoeBJmfs1kcFOUA2isGlFKMu2XbMopMyjgaZrYOk7RCOLL02
         tOP4O/EPkfSTQcM0FVoQvhLwc/eamoQTiohoL/4yuyjirvaZjbVkonCyAOo5onIdxw
         Px+ccZ/j25+u1yhX1EeCRsiamCocTslYsCxLKMsQgSQKw1AR2NwON+A+/SL19vqZXO
         9t0h1DemGXMP2duxFM3EgxMPsxrNoVNe9OWBlHM+M2DfYvqUxgh/+YeTjLTzSmsDz+
         Ig7POirO+xGSe+BrXx9yr3uMSC/+ymBTBfi1wLMIJWqM5L/EzijMwoqGv7k20nUud6
         ZkLdo+vFntJMQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 42/43] fs: warn about impending deprecation of mandatory locks
Date:   Tue, 24 Aug 2021 13:06:13 -0400
Message-Id: <20210824170614.710813-43-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170614.710813-1-sashal@kernel.org>
References: <20210824170614.710813-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.281-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.281-rc1
X-KernelTest-Deadline: 2021-08-26T17:06+00:00
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
index 68457fa2f981..b9e30a385c01 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1670,8 +1670,12 @@ static inline bool may_mount(void)
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

