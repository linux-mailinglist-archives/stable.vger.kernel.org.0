Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0317C3C61
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 18:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387808AbfJAQu7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 12:50:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:56684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387946AbfJAQoZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 12:44:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 638D82168B;
        Tue,  1 Oct 2019 16:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569948265;
        bh=LZt8K+pFKJyJFvN9uH562Rpkc7q8eYhurxMZU2lrw3c=;
        h=From:To:Cc:Subject:Date:From;
        b=KQicYPU7tCpO6RgyukFheSM3oBPMY4a8QotJ4F4hNFQPlaZ5BDOHRdisvsGFzqXgt
         NkFdRDj9o/hj9aEyPd2cwrh3b0+ISiZvwozdK/O4LPl6+T8arr3iJysp6aPdykfMKG
         MRo5pOlzfMknMr3HlSkzw47w5sIihVxHjpdw0hvc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sascha Hauer <s.hauer@pengutronix.de>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 01/29] ima: always return negative code for error
Date:   Tue,  1 Oct 2019 12:43:55 -0400
Message-Id: <20191001164423.16406-1-sashal@kernel.org>
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
index af680b5b678a4..06b0ee75f34fb 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -293,8 +293,11 @@ static int ima_calc_file_hash_atfm(struct file *file,
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

