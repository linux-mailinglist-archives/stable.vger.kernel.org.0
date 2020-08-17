Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C71D2246ED5
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 19:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387746AbgHQRhb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 13:37:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:55382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731131AbgHQQRN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:17:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F1CC207DE;
        Mon, 17 Aug 2020 16:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597681011;
        bh=6DHbHLVvao1IOlB/zt8+RprsouiSiHG/qkIEQ1H8n/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HelnaL+RM3F+4oac+7zzOXqQzpWhQYkd2nAIkz6E16dTP33/swpCKKIvti3KgG6pN
         m0DQ5okmutpx8D4pIEOGElderr+qI0bXRwy/VhHJIsc+beDtxfU72JtN76wyOyQcCU
         RhVYEfBP5nri/AsGh0FX/8k1pb+aCSHNZ+GHGv84=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.19 148/168] crypto: cpt - dont sleep of CRYPTO_TFM_REQ_MAY_SLEEP was not specified
Date:   Mon, 17 Aug 2020 17:17:59 +0200
Message-Id: <20200817143741.059298855@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143733.692105228@linuxfoundation.org>
References: <20200817143733.692105228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit 9e27c99104707f083dccd3b4d79762859b5a0614 upstream.

There is this call chain:
cvm_encrypt -> cvm_enc_dec -> cptvf_do_request -> process_request -> kzalloc
where we call sleeping allocator function even if CRYPTO_TFM_REQ_MAY_SLEEP
was not specified.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org	# v4.11+
Fixes: c694b233295b ("crypto: cavium - Add the Virtual Function driver for CPT")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/cavium/cpt/cptvf_algs.c       |    1 +
 drivers/crypto/cavium/cpt/cptvf_reqmanager.c |   12 ++++++------
 drivers/crypto/cavium/cpt/request_manager.h  |    2 ++
 3 files changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/crypto/cavium/cpt/cptvf_algs.c
+++ b/drivers/crypto/cavium/cpt/cptvf_algs.c
@@ -205,6 +205,7 @@ static inline int cvm_enc_dec(struct abl
 	int status;
 
 	memset(req_info, 0, sizeof(struct cpt_request_info));
+	req_info->may_sleep = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) != 0;
 	memset(fctx, 0, sizeof(struct fc_context));
 	create_input_list(req, enc, enc_iv_len);
 	create_output_list(req, enc_iv_len);
--- a/drivers/crypto/cavium/cpt/cptvf_reqmanager.c
+++ b/drivers/crypto/cavium/cpt/cptvf_reqmanager.c
@@ -136,7 +136,7 @@ static inline int setup_sgio_list(struct
 
 	/* Setup gather (input) components */
 	g_sz_bytes = ((req->incnt + 3) / 4) * sizeof(struct sglist_component);
-	info->gather_components = kzalloc(g_sz_bytes, GFP_KERNEL);
+	info->gather_components = kzalloc(g_sz_bytes, req->may_sleep ? GFP_KERNEL : GFP_ATOMIC);
 	if (!info->gather_components) {
 		ret = -ENOMEM;
 		goto  scatter_gather_clean;
@@ -153,7 +153,7 @@ static inline int setup_sgio_list(struct
 
 	/* Setup scatter (output) components */
 	s_sz_bytes = ((req->outcnt + 3) / 4) * sizeof(struct sglist_component);
-	info->scatter_components = kzalloc(s_sz_bytes, GFP_KERNEL);
+	info->scatter_components = kzalloc(s_sz_bytes, req->may_sleep ? GFP_KERNEL : GFP_ATOMIC);
 	if (!info->scatter_components) {
 		ret = -ENOMEM;
 		goto  scatter_gather_clean;
@@ -170,7 +170,7 @@ static inline int setup_sgio_list(struct
 
 	/* Create and initialize DPTR */
 	info->dlen = g_sz_bytes + s_sz_bytes + SG_LIST_HDR_SIZE;
-	info->in_buffer = kzalloc(info->dlen, GFP_KERNEL);
+	info->in_buffer = kzalloc(info->dlen, req->may_sleep ? GFP_KERNEL : GFP_ATOMIC);
 	if (!info->in_buffer) {
 		ret = -ENOMEM;
 		goto  scatter_gather_clean;
@@ -198,7 +198,7 @@ static inline int setup_sgio_list(struct
 	}
 
 	/* Create and initialize RPTR */
-	info->out_buffer = kzalloc(COMPLETION_CODE_SIZE, GFP_KERNEL);
+	info->out_buffer = kzalloc(COMPLETION_CODE_SIZE, req->may_sleep ? GFP_KERNEL : GFP_ATOMIC);
 	if (!info->out_buffer) {
 		ret = -ENOMEM;
 		goto scatter_gather_clean;
@@ -434,7 +434,7 @@ int process_request(struct cpt_vf *cptvf
 	struct cpt_vq_command vq_cmd;
 	union cpt_inst_s cptinst;
 
-	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	info = kzalloc(sizeof(*info), req->may_sleep ? GFP_KERNEL : GFP_ATOMIC);
 	if (unlikely(!info)) {
 		dev_err(&pdev->dev, "Unable to allocate memory for info_buffer\n");
 		return -ENOMEM;
@@ -456,7 +456,7 @@ int process_request(struct cpt_vf *cptvf
 	 * Get buffer for union cpt_res_s response
 	 * structure and its physical address
 	 */
-	info->completion_addr = kzalloc(sizeof(union cpt_res_s), GFP_KERNEL);
+	info->completion_addr = kzalloc(sizeof(union cpt_res_s), req->may_sleep ? GFP_KERNEL : GFP_ATOMIC);
 	if (unlikely(!info->completion_addr)) {
 		dev_err(&pdev->dev, "Unable to allocate memory for completion_addr\n");
 		ret = -ENOMEM;
--- a/drivers/crypto/cavium/cpt/request_manager.h
+++ b/drivers/crypto/cavium/cpt/request_manager.h
@@ -65,6 +65,8 @@ struct cpt_request_info {
 	union ctrl_info ctrl; /* User control information */
 	struct cptvf_request req; /* Request Information (Core specific) */
 
+	bool may_sleep;
+
 	struct buf_ptr in[MAX_BUF_CNT];
 	struct buf_ptr out[MAX_BUF_CNT];
 


