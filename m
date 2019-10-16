Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43E1BDA17D
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730775AbfJPVwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:52:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:41238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436896AbfJPVww (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:52:52 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC420218DE;
        Wed, 16 Oct 2019 21:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262771;
        bh=nc5ULy0TFrTcGfOM1GDNpdTbbJKQWQYLHky46hqyIBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PAyu9tOMTlt5jCJ6JxDIA92pVFw6YWJqcryYEQp6qsQgeNSzmQWvkq0kKICgcY9Uh
         F0RhaLKZxzUOSgL7zmMOt6fALybOhyCf1rHyFI0glUh/xnkBmxbA/eD8a9pcQegpQS
         1yTbQ7LecidbgmjgQ+sIqLoTEyGdBFPUVdjPTsyU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 12/79] ima: always return negative code for error
Date:   Wed, 16 Oct 2019 14:49:47 -0700
Message-Id: <20191016214741.083694872@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214729.758892904@linuxfoundation.org>
References: <20191016214729.758892904@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



