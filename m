Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B730E370CB0
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233119AbhEBOHM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:07:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:51698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233116AbhEBOG0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:06:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49737613C5;
        Sun,  2 May 2021 14:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964331;
        bh=jjYT6PyU7yG8aquzb9tT0Ra7w/2baInNjO74QmhVsss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g8vEmINJQxfOEQ5RvKZZ4iKvAb3B5/bJCJ+Jwpeq4HUlIbnCge42XQ3pVX/WVXjGr
         0z0su99f6PUXQxZ688Yeirdu7kwYSgrIoMMVN7sOXovjo/WInr8uhnXS1bpqpqcpSE
         j8G9p62CXrsFbMqGauSThCRPkhHrqcmLI56gcMUpwqVqzrHBfZMEki46xo6NKlQSu5
         YmqzlxVfz6dfzom2XCcA9WU63m+WcfKu0oO3AhT8xvj+I8gbPQ67+6dhJHn/DW5QVe
         MwWs6TJZrV1g+TJY7W78blbO/havOUb0mOJqV03JqmxwGE9+2i1/G80MZHDZrWjR3H
         QCeG1xZ61sFEQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jerome Forissier <jerome@forissier.org>,
        Sumit Garg <sumit.garg@linaro.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        op-tee@lists.trustedfirmware.org
Subject: [PATCH AUTOSEL 4.19 10/21] tee: optee: do not check memref size on return from Secure World
Date:   Sun,  2 May 2021 10:05:06 -0400
Message-Id: <20210502140517.2719912-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140517.2719912-1-sashal@kernel.org>
References: <20210502140517.2719912-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jerome Forissier <jerome@forissier.org>

[ Upstream commit c650b8dc7a7910eb25af0aac1720f778b29e679d ]

When Secure World returns, it may have changed the size attribute of the
memory references passed as [in/out] parameters. The GlobalPlatform TEE
Internal Core API specification does not restrict the values that this
size can take. In particular, Secure World may increase the value to be
larger than the size of the input buffer to indicate that it needs more.

Therefore, the size check in optee_from_msg_param() is incorrect and
needs to be removed. This fixes a number of failed test cases in the
GlobalPlatform TEE Initial Configuratiom Test Suite v2_0_0_0-2017_06_09
when OP-TEE is compiled without dynamic shared memory support
(CFG_CORE_DYN_SHM=n).

Reviewed-by: Sumit Garg <sumit.garg@linaro.org>
Suggested-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Jerome Forissier <jerome@forissier.org>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tee/optee/core.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/tee/optee/core.c b/drivers/tee/optee/core.c
index 2f254f957b0a..1d71fcb13dba 100644
--- a/drivers/tee/optee/core.c
+++ b/drivers/tee/optee/core.c
@@ -87,16 +87,6 @@ int optee_from_msg_param(struct tee_param *params, size_t num_params,
 				return rc;
 			p->u.memref.shm_offs = mp->u.tmem.buf_ptr - pa;
 			p->u.memref.shm = shm;
-
-			/* Check that the memref is covered by the shm object */
-			if (p->u.memref.size) {
-				size_t o = p->u.memref.shm_offs +
-					   p->u.memref.size - 1;
-
-				rc = tee_shm_get_pa(shm, o, NULL);
-				if (rc)
-					return rc;
-			}
 			break;
 		case OPTEE_MSG_ATTR_TYPE_RMEM_INPUT:
 		case OPTEE_MSG_ATTR_TYPE_RMEM_OUTPUT:
-- 
2.30.2

