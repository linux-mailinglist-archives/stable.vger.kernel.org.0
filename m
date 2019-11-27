Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6638D10BA80
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732082AbfK0VDt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:03:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:57064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731766AbfK0VDr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:03:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CE3B20637;
        Wed, 27 Nov 2019 21:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888626;
        bh=huh3IRdKqGi5hDvKHS1LXuAEpu3NxCzkYXsQqRKcB2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G5H/7Ybjhdg5m2+lfYODBXHgtXAqNlEj2/OyZ1jPOC0cty+b6104MVSgDQPno0pkx
         NCbcUeOb2bOxC/DOXB0+JrddcEB+OG1kddrbDzJAuBlRf1R4fm+JFAHC4BIrdGNHaj
         imcVymgC63XCUzy67J3CeKLya85DuIy+CbLT4yG8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richard Guy Briggs <rgb@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 207/306] audit: print empty EXECVE args
Date:   Wed, 27 Nov 2019 21:30:57 +0100
Message-Id: <20191127203130.256247291@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



