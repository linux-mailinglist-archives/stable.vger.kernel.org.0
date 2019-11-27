Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA57210BF7D
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:45:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727560AbfK0Ugx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:36:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:39456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728447AbfK0Ugx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:36:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B273215A4;
        Wed, 27 Nov 2019 20:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887012;
        bh=N39DXQqu1coMpy96kBMWYb+Sz85DeuZUx59EONJN3I8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZzerHnDTW240N3vciIalPNqdt1YY5ZWfMs5r31T0gAXF15Rjw9N3R+QByhnG37beJ
         9fEHdRB1l+JTGrtijOuM0eI80sQY8oBBO8qWFAPr4dBTo9LrjYIkwEYU0yPlsJskBQ
         sZ7+7AqetbnbUAZ6OXYmR8Cy+kd7EiCjn6d3otCQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richard Guy Briggs <rgb@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 080/132] audit: print empty EXECVE args
Date:   Wed, 27 Nov 2019 21:31:11 +0100
Message-Id: <20191127203011.280284361@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202857.270233486@linuxfoundation.org>
References: <20191127202857.270233486@linuxfoundation.org>
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
index 0fe8b337291a3..87c43c92fb7d8 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1093,7 +1093,7 @@ static void audit_log_execve_info(struct audit_context *context,
 		}
 
 		/* write as much as we can to the audit log */
-		if (len_buf > 0) {
+		if (len_buf >= 0) {
 			/* NOTE: some magic numbers here - basically if we
 			 *       can't fit a reasonable amount of data into the
 			 *       existing audit buffer, flush it and start with
-- 
2.20.1



