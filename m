Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 912E079447
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728379AbfG2T3v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:29:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:42518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728828AbfG2T3u (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:29:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57CF621655;
        Mon, 29 Jul 2019 19:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428589;
        bh=rEXX59c7Rsq38IWTPHKRNw6o8S78//6z/w9uAWHg0lk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oLvRsCeV9JA59m1eGWGH4WfXzc0VoADwGzOBTwlZeVHaT1R1uVonhuOBN/2RMx/Mo
         S3n7KWXUbWbcqJ6QLvPjp9gaOyORzgGu9eYDSSfwyAS2bU8n9zIAi8W4nSc8MCtosc
         T7zBrlEk4i3zQf2Whjb00+V2Ya+9mFoTEXC2cLdo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gary R Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.14 124/293] crypto: ccp - memset structure fields to zero before reuse
Date:   Mon, 29 Jul 2019 21:20:15 +0200
Message-Id: <20190729190834.086896039@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hook, Gary <Gary.Hook@amd.com>

commit 20e833dc36355ed642d00067641a679c618303fa upstream.

The AES GCM function reuses an 'op' data structure, which members
contain values that must be cleared for each (re)use.

This fix resolves a crypto self-test failure:
alg: aead: gcm-aes-ccp encryption test failed (wrong result) on test vector 2, cfg="two even aligned splits"

Fixes: 36cf515b9bbe ("crypto: ccp - Enable support for AES GCM on v5 CCPs")
Cc: <stable@vger.kernel.org>
Signed-off-by: Gary R Hook <gary.hook@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/ccp/ccp-ops.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -612,6 +612,7 @@ static int ccp_run_aes_gcm_cmd(struct cc
 
 	unsigned long long *final;
 	unsigned int dm_offset;
+	unsigned int jobid;
 	unsigned int ilen;
 	bool in_place = true; /* Default value */
 	int ret;
@@ -650,9 +651,11 @@ static int ccp_run_aes_gcm_cmd(struct cc
 		p_tag = scatterwalk_ffwd(sg_tag, p_inp, ilen);
 	}
 
+	jobid = CCP_NEW_JOBID(cmd_q->ccp);
+
 	memset(&op, 0, sizeof(op));
 	op.cmd_q = cmd_q;
-	op.jobid = CCP_NEW_JOBID(cmd_q->ccp);
+	op.jobid = jobid;
 	op.sb_key = cmd_q->sb_key; /* Pre-allocated */
 	op.sb_ctx = cmd_q->sb_ctx; /* Pre-allocated */
 	op.init = 1;
@@ -797,6 +800,13 @@ static int ccp_run_aes_gcm_cmd(struct cc
 	final[0] = cpu_to_be64(aes->aad_len * 8);
 	final[1] = cpu_to_be64(ilen * 8);
 
+	memset(&op, 0, sizeof(op));
+	op.cmd_q = cmd_q;
+	op.jobid = jobid;
+	op.sb_key = cmd_q->sb_key; /* Pre-allocated */
+	op.sb_ctx = cmd_q->sb_ctx; /* Pre-allocated */
+	op.init = 1;
+	op.u.aes.type = aes->type;
 	op.u.aes.mode = CCP_AES_MODE_GHASH;
 	op.u.aes.action = CCP_AES_GHASHFINAL;
 	op.src.type = CCP_MEMTYPE_SYSTEM;


