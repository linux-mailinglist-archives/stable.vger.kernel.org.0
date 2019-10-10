Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 071B2D25DF
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388074AbfJJJCq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 05:02:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:42760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387811AbfJJIjT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:39:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C938D21D80;
        Thu, 10 Oct 2019 08:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696759;
        bh=c7WJh+EJ+vLVCVWgY959mfZeB3g+LV991TNwgJT3s/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yzEppY5AuX7fvxcH/MpUHcJDdOK6ea5l4K9mfu49PPtcdVO8wRUfxT/XKDBEl5mv8
         aGwP6/UY9uac7ecQoq5Y3RYKQ5A4XVkg5mVqk/zBUCpi8bSVmND5d2z1J8yL2geqjC
         HVhuaL7ET5zDShFdukb7/rDsvRhRy0idNDU2bdKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.3 043/148] crypto: caam/qi - fix error handling in ERN handler
Date:   Thu, 10 Oct 2019 10:35:04 +0200
Message-Id: <20191010083613.739344414@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Horia Geantă <horia.geanta@nxp.com>

commit 51fab3d73054ca5b06b26e20edac0486b052c6f4 upstream.

ERN handler calls the caam/qi frontend "done" callback with a status
of -EIO. This is incorrect, since the callback expects a status value
meaningful for the crypto engine - hence the cryptic messages
like the one below:
platform caam_qi: 15: unknown error source

Fix this by providing the callback with:
-the status returned by the crypto engine (fd[status]) in case
it contains an error, OR
-a QI "No error" code otherwise; this will trigger the message:
platform caam_qi: 50000000: Queue Manager Interface: No error
which is fine, since QMan driver provides details about the cause of
failure

Cc: <stable@vger.kernel.org> # v5.1+
Fixes: 67c2315def06 ("crypto: caam - add Queue Interface (QI) backend support")
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
Reviewed-by: Iuliana Prodan <iuliana.prodan@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/caam/error.c |    1 +
 drivers/crypto/caam/qi.c    |    5 ++++-
 drivers/crypto/caam/regs.h  |    1 +
 3 files changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/crypto/caam/error.c
+++ b/drivers/crypto/caam/error.c
@@ -118,6 +118,7 @@ static const struct {
 	u8 value;
 	const char *error_text;
 } qi_error_list[] = {
+	{ 0x00, "No error" },
 	{ 0x1F, "Job terminated by FQ or ICID flush" },
 	{ 0x20, "FD format error"},
 	{ 0x21, "FD command format error"},
--- a/drivers/crypto/caam/qi.c
+++ b/drivers/crypto/caam/qi.c
@@ -163,7 +163,10 @@ static void caam_fq_ern_cb(struct qman_p
 	dma_unmap_single(drv_req->drv_ctx->qidev, qm_fd_addr(fd),
 			 sizeof(drv_req->fd_sgt), DMA_BIDIRECTIONAL);
 
-	drv_req->cbk(drv_req, -EIO);
+	if (fd->status)
+		drv_req->cbk(drv_req, be32_to_cpu(fd->status));
+	else
+		drv_req->cbk(drv_req, JRSTA_SSRC_QI);
 }
 
 static struct qman_fq *create_caam_req_fq(struct device *qidev,
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -641,6 +641,7 @@ struct caam_job_ring {
 #define JRSTA_SSRC_CCB_ERROR        0x20000000
 #define JRSTA_SSRC_JUMP_HALT_USER   0x30000000
 #define JRSTA_SSRC_DECO             0x40000000
+#define JRSTA_SSRC_QI               0x50000000
 #define JRSTA_SSRC_JRERROR          0x60000000
 #define JRSTA_SSRC_JUMP_HALT_CC     0x70000000
 


