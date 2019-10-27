Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE0DE67AD
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:23:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732313AbfJ0VXQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:23:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:44436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732323AbfJ0VXO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:23:14 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B112321783;
        Sun, 27 Oct 2019 21:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211394;
        bh=BHRVcFq2HirB146C5IWbnEoe+TZArmKjn+M2Y3ya+l8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V6sutr/jaSCYub0qT0W1glhiVFgVQGlwBQT8IgwYW8XKvXv1Fr+CK7waS98MHksG8
         /kL0OIB9HDqP2pn/CG6FXZXbGzbpgHqTQZ+pWCOsdfibH63minkXLyeqpmtwRVmJLV
         0bsPZh9nxVkinrgjXagWe8I44RViAcp24n7uRHEE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Micah Morton <mortonm@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 092/197] LSM: SafeSetID: Stop releasing uninitialized ruleset
Date:   Sun, 27 Oct 2019 22:00:10 +0100
Message-Id: <20191027203356.718370614@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Micah Morton <mortonm@chromium.org>

[ Upstream commit 21ab8580b383f27b7f59b84ac1699cb26d6c3d69 ]

The first time a rule set is configured for SafeSetID, we shouldn't be
trying to release the previously configured ruleset, since there isn't
one. Currently, the pointer that would point to a previously configured
ruleset is uninitialized on first rule set configuration, leading to a
crash when we try to call release_ruleset with that pointer.

Acked-by: Jann Horn <jannh@google.com>
Signed-off-by: Micah Morton <mortonm@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/safesetid/securityfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/security/safesetid/securityfs.c b/security/safesetid/securityfs.c
index d568e17dd7739..74a13d432ed80 100644
--- a/security/safesetid/securityfs.c
+++ b/security/safesetid/securityfs.c
@@ -187,7 +187,8 @@ static ssize_t handle_policy_update(struct file *file,
 out_free_buf:
 	kfree(buf);
 out_free_pol:
-	release_ruleset(pol);
+	if (pol)
+                release_ruleset(pol);
 	return err;
 }
 
-- 
2.20.1



