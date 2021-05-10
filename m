Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B76363781D0
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbhEJKaF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:30:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:60168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230449AbhEJK2j (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:28:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4EBF361626;
        Mon, 10 May 2021 10:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642423;
        bh=bZfn7RF/27+V4ZX/wgyqz34JcBoVJgaQhz9oGSUgOJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jw20V4gCbmtHnKctRUnuARgrA1KG0IFBVV+qoMpnvTI3Vv3/gCl9yyivBf5HAiZk3
         HEWNrSnEVr01Cc0uf/0r9PSGk0zg+cPcLWPkrvL+YIkMXNjrK/BtlkQCpiaX7j9J4+
         0ehP2EXy+vJG4kzS06wW3I4B/vrQH05Lk5xULi4E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sumit Garg <sumit.garg@linaro.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Jerome Forissier <jerome@forissier.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 053/184] tee: optee: do not check memref size on return from Secure World
Date:   Mon, 10 May 2021 12:19:07 +0200
Message-Id: <20210510101951.950433153@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510101950.200777181@linuxfoundation.org>
References: <20210510101950.200777181@linuxfoundation.org>
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
index b830e0a87fba..ba6cfba589a6 100644
--- a/drivers/tee/optee/core.c
+++ b/drivers/tee/optee/core.c
@@ -78,16 +78,6 @@ int optee_from_msg_param(struct tee_param *params, size_t num_params,
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



