Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A07D2C3BEF
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 18:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388424AbfJAQq7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 12:46:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:58132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390334AbfJAQpf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 12:45:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42AA4205C9;
        Tue,  1 Oct 2019 16:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569948335;
        bh=nc5ULy0TFrTcGfOM1GDNpdTbbJKQWQYLHky46hqyIBk=;
        h=From:To:Cc:Subject:Date:From;
        b=RrKFp3HGKwMAeOeTcQVCvCaWUqb0qA+w6uZs/RFucHh1gMy5TnUcaSyOqL5cS2sfC
         Tg1LlQgKczfmQAEXviAksVo8OxuE0sZRkQ9R4n+F+5yCY5sGIgx70QykL/uXtS/tuS
         00Uy77CwgPyH/bscHxSF1/En3ySD61CDTBgnrEbc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sascha Hauer <s.hauer@pengutronix.de>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 01/15] ima: always return negative code for error
Date:   Tue,  1 Oct 2019 12:45:19 -0400
Message-Id: <20191001164533.16915-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sascha Hauer <s.hauer@pengutronix.de>

[ Upstream commit f5e1040196dbfe14c77ce3dfe3b7b08d2d961e88 ]

integrity_kernel_read() returns the number of bytes read. If this is
a short read then this positive value is returned from
ima_calc_file_hash_atfm(). Currently this is only indirectly called from
ima_calc_file_hash() and this function only tests for the return value
being zero or nonzero and also doesn't forward the return value.
Nevertheless there's no point in returning a positive value as an error,
so translate a short read into -EINVAL.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima_crypto.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index a29209fa56746..5c87baaefafb6 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -298,8 +298,11 @@ static int ima_calc_file_hash_atfm(struct file *file,
 		rbuf_len = min_t(loff_t, i_size - offset, rbuf_size[active]);
 		rc = integrity_kernel_read(file, offset, rbuf[active],
 					   rbuf_len);
-		if (rc != rbuf_len)
+		if (rc != rbuf_len) {
+			if (rc >= 0)
+				rc = -EINVAL;
 			goto out3;
+		}
 
 		if (rbuf[1] && offset) {
 			/* Using two buffers, and it is not the first
-- 
2.20.1

