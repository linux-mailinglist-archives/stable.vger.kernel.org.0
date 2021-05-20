Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7D638A293
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233351AbhETJnT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:43:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:41940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233370AbhETJlS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:41:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4366B61425;
        Thu, 20 May 2021 09:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503117;
        bh=jjYT6PyU7yG8aquzb9tT0Ra7w/2baInNjO74QmhVsss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z3TUDXSlb2DLp1RJLz4d9eLA3cIXJHijCdVkTO8TGg2rL3P5nbp7kYQIzbKGrVscO
         FQlyDsoYxJaq6oncpZAeHi1Si8oIfAJOijc5C5Rt+HMoSrdNFd8kB2W3/aftLP2FK9
         ljN2W8wITltIoDh40q0dlTzSyEjJn7wH5HczjqYI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sumit Garg <sumit.garg@linaro.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Jerome Forissier <jerome@forissier.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 032/425] tee: optee: do not check memref size on return from Secure World
Date:   Thu, 20 May 2021 11:16:41 +0200
Message-Id: <20210520092132.459160725@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



