Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 890DB370C66
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232921AbhEBOGL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:06:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:50698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232900AbhEBOFq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:05:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CDE36147E;
        Sun,  2 May 2021 14:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964294;
        bh=bZfn7RF/27+V4ZX/wgyqz34JcBoVJgaQhz9oGSUgOJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iA3Oz6dpdFJSfSCA93ZPsTPaIwpkgotQ0GjzNeOEopt1V/KW5IBkyttchZBANsFM+
         lTXiLIkpSeiHcqN30NGG792wLfJ4N13M4erfnQsefjakJv8f0TGIdqD3Iv0eqqWqML
         TtT3s9La8fmDx4bhip6DHWrTYngwbYLHy0ps/WLq4W7xmwrAryfvZ6DuAtR2uUkabi
         ockOq/QwjcHR/mfxO+sPWuave5m4niBNslc/YyBtOILlnqvoHdUt/yZqygl5MImvHV
         FZV8JrcsTtbbHJD8gXulzphmUxhr9U+i8g3IBsRcxA2/bIHa88u1qSlt6dz4RAj5wf
         Kx8fB3Gp13xjQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jerome Forissier <jerome@forissier.org>,
        Sumit Garg <sumit.garg@linaro.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        op-tee@lists.trustedfirmware.org
Subject: [PATCH AUTOSEL 5.4 16/34] tee: optee: do not check memref size on return from Secure World
Date:   Sun,  2 May 2021 10:04:16 -0400
Message-Id: <20210502140434.2719553-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140434.2719553-1-sashal@kernel.org>
References: <20210502140434.2719553-1-sashal@kernel.org>
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

