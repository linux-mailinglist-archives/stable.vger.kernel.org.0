Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D43149A9A1
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:27:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1310903AbiAYDZ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:25:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359346AbiAXVDK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:03:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76CDFC06B59A;
        Mon, 24 Jan 2022 12:03:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16FDA61028;
        Mon, 24 Jan 2022 20:03:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D99C340E7;
        Mon, 24 Jan 2022 20:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054601;
        bh=6xbJmd6f01+fZLlPBClTdRN12VoLGcHc5990lZQbkJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M1mB4GP8Qng3KR9rsaznkilHLKrJUN2nOhPHJuU/WapKOdDQdQ/RHru5TPOcLOqOC
         0BJ+f/ZvBr3twbi0+R/BzHNjmDmV0k33Pj0Jj2reTBCH9cqkzSq4iaanCJhcx/xuej
         GkvRsg3iEfF7J0ECWxcDOyWDzJtGcFwv1HTG6KyM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Meng Li <Meng.Li@windriver.com>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.10 443/563] crypto: caam - replace this_cpu_ptr with raw_cpu_ptr
Date:   Mon, 24 Jan 2022 19:43:28 +0100
Message-Id: <20220124184039.770132103@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Meng Li <Meng.Li@windriver.com>

commit efd21e10fc3bf4c6da122470a5ae89ec4ed8d180 upstream.

When enable the kernel debug config, there is below calltrace detected:
BUG: using smp_processor_id() in preemptible [00000000] code: cryptomgr_test/339
caller is debug_smp_processor_id+0x20/0x30
CPU: 9 PID: 339 Comm: cryptomgr_test Not tainted 5.10.63-yocto-standard #1
Hardware name: NXP Layerscape LX2160ARDB (DT)
Call trace:
 dump_backtrace+0x0/0x1a0
 show_stack+0x24/0x30
 dump_stack+0xf0/0x13c
 check_preemption_disabled+0x100/0x110
 debug_smp_processor_id+0x20/0x30
 dpaa2_caam_enqueue+0x10c/0x25c
 ......
 cryptomgr_test+0x38/0x60
 kthread+0x158/0x164
 ret_from_fork+0x10/0x38
According to the comment in commit ac5d15b4519f("crypto: caam/qi2
 - use affine DPIOs "), because preemption is no longer disabled
while trying to enqueue an FQID, it might be possible to run the
enqueue on a different CPU(due to migration, when in process context),
however this wouldn't be a functionality issue. But there will be
above calltrace when enable kernel debug config. So, replace this_cpu_ptr
with raw_cpu_ptr to avoid above call trace.

Fixes: ac5d15b4519f ("crypto: caam/qi2 - use affine DPIOs")
Cc: stable@vger.kernel.org
Signed-off-by: Meng Li <Meng.Li@windriver.com>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/caam/caamalg_qi2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -5467,7 +5467,7 @@ int dpaa2_caam_enqueue(struct device *de
 	dpaa2_fd_set_len(&fd, dpaa2_fl_get_len(&req->fd_flt[1]));
 	dpaa2_fd_set_flc(&fd, req->flc_dma);
 
-	ppriv = this_cpu_ptr(priv->ppriv);
+	ppriv = raw_cpu_ptr(priv->ppriv);
 	for (i = 0; i < (priv->dpseci_attr.num_tx_queues << 1); i++) {
 		err = dpaa2_io_service_enqueue_fq(ppriv->dpio, ppriv->req_fqid,
 						  &fd);


