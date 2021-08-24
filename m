Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A74D3F66DD
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240475AbhHXR2I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:28:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:60514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240580AbhHXR0B (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:26:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E0B061B42;
        Tue, 24 Aug 2021 17:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824650;
        bh=kKv6uW8+t7LQ+dTAdr6TIEt1tITtiHvP3bcAeazDqx4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LTGGNUOXnGL6cKRU5w+L9/n31SsQr1qd63xxdON4gu0WqVFO1urNWJdugBDDMf6gI
         UMV/pO7m4+Ad9jXEldxeB6QqsMew7A6jeFCbNxqTh38BxtO+NznmQrqq0xEtM7jbUt
         o0tfzL6CxK5h+xo2FfWMzS6uEis6EgQcWgAx/ShNkz9OMh7liOsOvWp/adhp2HhSRj
         Iv8Mcu9dxvhmWhjb6ni/jbMagHdcSWtorc3dZ6xTjLAguhuEKW1zEoYSdqZrmtBaCH
         vwHmfmMFWpU8GdgKgQO/RYHojA6H5kHMkXKQgic+5a6laW0iD7rE6XN14ACphA0kma
         dL75jA1VJ2ytw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 82/84] fs: warn about impending deprecation of mandatory locks
Date:   Tue, 24 Aug 2021 13:02:48 -0400
Message-Id: <20210824170250.710392-83-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170250.710392-1-sashal@kernel.org>
References: <20210824170250.710392-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.205-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.205-rc1
X-KernelTest-Deadline: 2021-08-26T17:02+00:00
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
index 8d2bf350e7c6..2f3c6a0350a8 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1611,8 +1611,12 @@ static inline bool may_mount(void)
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

