Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B266498E58
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244192AbiAXTkn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:40:43 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34544 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354633AbiAXTgy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:36:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D236E6141C;
        Mon, 24 Jan 2022 19:36:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC58C340E5;
        Mon, 24 Jan 2022 19:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053013;
        bh=N9z9CA+DDyeJ2G05kqCDHc2y8kstWZPWxKWqeGhvqvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C/4mcIM8BDORH1AMLuJUQcUCnZgzBmXUp9o28BnK96r5Mz0vv5zYtI/PAzUcXF3y6
         Dkebau1MxwmCTxu9FCNl0AZbkXUQod1dXm6eIup8fz6QAoWdRiuKXfIOiQ4k4EDDE/
         7lrOPL9lYOMVZZZClDoAEZuAvrd1IsrlMnuSQDLU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Meng Li <Meng.Li@windriver.com>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.4 248/320] crypto: caam - replace this_cpu_ptr with raw_cpu_ptr
Date:   Mon, 24 Jan 2022 19:43:52 +0100
Message-Id: <20220124184002.429181031@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
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
@@ -5421,7 +5421,7 @@ int dpaa2_caam_enqueue(struct device *de
 	dpaa2_fd_set_len(&fd, dpaa2_fl_get_len(&req->fd_flt[1]));
 	dpaa2_fd_set_flc(&fd, req->flc_dma);
 
-	ppriv = this_cpu_ptr(priv->ppriv);
+	ppriv = raw_cpu_ptr(priv->ppriv);
 	for (i = 0; i < (priv->dpseci_attr.num_tx_queues << 1); i++) {
 		err = dpaa2_io_service_enqueue_fq(ppriv->dpio, ppriv->req_fqid,
 						  &fd);


