Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E11110BF06
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbfK0UnD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:43:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:50142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727985AbfK0UnC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:43:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86369217BA;
        Wed, 27 Nov 2019 20:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887382;
        bh=0NAakbf0aFFUr3C1ssYzRRr9w/w1NNglKrosxTZzK+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WamoV0JqFOmtx6ME1e3D1xKO9o36JA1A2dc+3QsD8dNP9gv1kksWy0gPrNRIWKbce
         Dfgy1gIs95ooqQF2i1EiW4TqFjJeTHxL6WspF4gYgPVU2W+oyX8K+KnqRnkvnl1vFM
         PMYa8aQA9sBgSguxaZj6MVdNCEEe9myUiRWpxzwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richard Guy Briggs <rgb@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 089/151] audit: print empty EXECVE args
Date:   Wed, 27 Nov 2019 21:31:12 +0100
Message-Id: <20191127203037.037579187@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203000.773542911@linuxfoundation.org>
References: <20191127203000.773542911@linuxfoundation.org>
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
index c2aaf539728fb..854e90be1a023 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1096,7 +1096,7 @@ static void audit_log_execve_info(struct audit_context *context,
 		}
 
 		/* write as much as we can to the audit log */
-		if (len_buf > 0) {
+		if (len_buf >= 0) {
 			/* NOTE: some magic numbers here - basically if we
 			 *       can't fit a reasonable amount of data into the
 			 *       existing audit buffer, flush it and start with
-- 
2.20.1



