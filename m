Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E96DF12F0BE
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:55:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727511AbgABWzT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:55:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:35750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728605AbgABWTa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:19:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6304421582;
        Thu,  2 Jan 2020 22:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003569;
        bh=L+Pr4KaWWePHS/ARhpT5PkchyA1n1K5Ej5ew12Jliww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o/ft4bX7L7RVi4y7wd05LR96gXl4p02jChd8DWZnDUShhSfgcwp6YHzQ60z9xg7Qz
         AlqGw1B7VCES7rZYJdrRt6yPKKpXiBSs6VM0ahlsV6DaMuHVzta527PKDO2t5ZjcKh
         uZ+B4dLMTNZ6YdheR6g3WtwW0Cs/r9df3ReRVaY0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lee Duncan <lduncan@suse.com>,
        Mike Christie <mchristi@redhat.com>,
        David Disseldorp <ddiss@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 009/114] scsi: target: compare full CHAP_A Algorithm strings
Date:   Thu,  2 Jan 2020 23:06:21 +0100
Message-Id: <20200102220030.096331221@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220029.183913184@linuxfoundation.org>
References: <20200102220029.183913184@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Disseldorp <ddiss@suse.de>

[ Upstream commit 9cef2a7955f2754257a7cddedec16edae7b587d0 ]

RFC 2307 states:

  For CHAP [RFC1994], in the first step, the initiator MUST send:

      CHAP_A=<A1,A2...>

   Where A1,A2... are proposed algorithms, in order of preference.
...
   For the Algorithm, as stated in [RFC1994], one value is required to
   be implemented:

       5     (CHAP with MD5)

LIO currently checks for this value by only comparing a single byte in
the tokenized Algorithm string, which means that any value starting with
a '5' (e.g. "55") is interpreted as "CHAP with MD5". Fix this by
comparing the entire tokenized string.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Reviewed-by: Mike Christie <mchristi@redhat.com>
Signed-off-by: David Disseldorp <ddiss@suse.de>
Link: https://lore.kernel.org/r/20190912095547.22427-2-ddiss@suse.de
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/iscsi/iscsi_target_auth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/iscsi/iscsi_target_auth.c
index e2fa3a3bc81d..b6bf605fa5c1 100644
--- a/drivers/target/iscsi/iscsi_target_auth.c
+++ b/drivers/target/iscsi/iscsi_target_auth.c
@@ -78,7 +78,7 @@ static int chap_check_algorithm(const char *a_str)
 		if (!token)
 			goto out;
 
-		if (!strncmp(token, "5", 1)) {
+		if (!strcmp(token, "5")) {
 			pr_debug("Selected MD5 Algorithm\n");
 			kfree(orig);
 			return CHAP_DIGEST_MD5;
-- 
2.20.1



