Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D88D5C3E1A
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 19:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbfJAREg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 13:04:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:50352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727670AbfJAQj0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 12:39:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAB5421872;
        Tue,  1 Oct 2019 16:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569947966;
        bh=uOi64M7D10KweumGcEk7pWtgTYT8TAKC8lUsJlYhmAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vWboagiD+P2IhT7gOaPDHpZfsjH4akDoCvpn8AIVxTe1UuSD8ct6qFNY35Twp38Pp
         1kT2zIniwtPqIol7veeJQ2hOMpeQZVy21wmLTMgxQWOlWTvLSDPUYxeSqj8qPZfWo1
         SOItGf4NlbwOR8qDJ4AVy/WMDVQC7AslFurN+UGY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sascha Hauer <s.hauer@pengutronix.de>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 03/71] ima: fix freeing ongoing ahash_request
Date:   Tue,  1 Oct 2019 12:38:13 -0400
Message-Id: <20191001163922.14735-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001163922.14735-1-sashal@kernel.org>
References: <20191001163922.14735-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sascha Hauer <s.hauer@pengutronix.de>

[ Upstream commit 4ece3125f21b1d42b84896c5646dbf0e878464e1 ]

integrity_kernel_read() can fail in which case we forward to call
ahash_request_free() on a currently running request. We have to wait
for its completion before we can free the request.

This was observed by interrupting a "find / -type f -xdev -print0 | xargs -0
cat 1>/dev/null" with ctrl-c on an IMA enabled filesystem.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima_crypto.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index 7532b062be594..73044fc6a9521 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -271,6 +271,11 @@ static int ima_calc_file_hash_atfm(struct file *file,
 		if (rc != rbuf_len) {
 			if (rc >= 0)
 				rc = -EINVAL;
+			/*
+			 * Forward current rc, do not overwrite with return value
+			 * from ahash_wait()
+			 */
+			ahash_wait(ahash_rc, &wait);
 			goto out3;
 		}
 
-- 
2.20.1

