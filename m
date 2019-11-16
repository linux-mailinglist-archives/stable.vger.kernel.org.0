Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6330CFF262
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728567AbfKPQS5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 11:18:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:52690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729356AbfKPPqV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:46:21 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3534D20855;
        Sat, 16 Nov 2019 15:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919181;
        bh=huh3IRdKqGi5hDvKHS1LXuAEpu3NxCzkYXsQqRKcB2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MYdPWd+31hBcaRVJKysLtxBgKpnrlyjREWww4B/py2LFt1/ZtQLuZP9VZxYXXZ5ZC
         T3mm5z2xh8JZL4Qb3ZTl76ITv2QEvdghSkYjaXK1FtRBO+5j0AUUWoSIUvZlL7GlQJ
         Ss4GtYEWN8OTiinQsg8SV9Q2f/StEfU+Z/hUxxUc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Richard Guy Briggs <rgb@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 190/237] audit: print empty EXECVE args
Date:   Sat, 16 Nov 2019 10:40:25 -0500
Message-Id: <20191116154113.7417-190-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Guy Briggs <rgb@redhat.com>

[ Upstream commit ea956d8be91edc702a98b7fe1f9463e7ca8c42ab ]

Empty executable arguments were being skipped when printing out the list
of arguments in an EXECVE record, making it appear they were somehow
lost.  Include empty arguments as an itemized empty string.

Reproducer:
	autrace /bin/ls "" "/etc"
	ausearch --start recent -m execve -i | grep EXECVE
	type=EXECVE msg=audit(10/03/2018 13:04:03.208:1391) : argc=3 a0=/bin/ls a2=/etc

With fix:
	type=EXECVE msg=audit(10/03/2018 21:51:38.290:194) : argc=3 a0=/bin/ls a1= a2=/etc
	type=EXECVE msg=audit(1538617898.290:194): argc=3 a0="/bin/ls" a1="" a2="/etc"

Passes audit-testsuite.  GH issue tracker at
https://github.com/linux-audit/audit-kernel/issues/99

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
[PM: cleaned up the commit metadata]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/auditsc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index b2d1f043f17fb..1513873e23bd1 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1107,7 +1107,7 @@ static void audit_log_execve_info(struct audit_context *context,
 		}
 
 		/* write as much as we can to the audit log */
-		if (len_buf > 0) {
+		if (len_buf >= 0) {
 			/* NOTE: some magic numbers here - basically if we
 			 *       can't fit a reasonable amount of data into the
 			 *       existing audit buffer, flush it and start with
-- 
2.20.1

