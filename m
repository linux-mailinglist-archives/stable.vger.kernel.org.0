Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01D7D497F6D
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 13:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239477AbiAXM0r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 07:26:47 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50750 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238412AbiAXM0q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 07:26:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1269960FED
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 12:26:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2038BC340E1;
        Mon, 24 Jan 2022 12:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643027205;
        bh=4Wlak066cziCa3vyB+GjQzjroZBr36YnPSYtTmagL0c=;
        h=Subject:To:Cc:From:Date:From;
        b=0JN7pNoCObxXAHsPJ9T4dnkmBlPc2qGIDt+IKffxqAvFuboYCj4MsqbB5l5faHt06
         SPj2T64PJt2o4/Q+H4T/If9T0qVXFmpavkGGUbhys5oyt6/hn5xGhnvr4DCrkxr6oZ
         Aqak46hU1hOmGnNd6+DniRfpUdvvikC42X1BhSCk=
Subject: FAILED: patch "[PATCH] crypto: hisilicon - cleanup warning in qm_get_qos_value()" failed to apply to 5.15-stable tree
To:     trix@redhat.com, herbert@gondor.apana.org.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 Jan 2022 13:26:35 +0100
Message-ID: <1643027195196213@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c5d692a2335d64ac390aeb8ab6c4ac9f662e1be4 Mon Sep 17 00:00:00 2001
From: Tom Rix <trix@redhat.com>
Date: Wed, 22 Dec 2021 09:29:23 -0800
Subject: [PATCH] crypto: hisilicon - cleanup warning in qm_get_qos_value()

Building with clang static analysis returns this warning:

qm.c:4382:11: warning: The left operand of '==' is a garbage value
        if (*val == 0 || *val > QM_QOS_MAX_VAL || ret) {
            ~~~~ ^

The call to qm_qos_value_init() can return an error without setting
*val.  So check ret before checking *val.

Fixes: 72b010dc33b9 ("crypto: hisilicon/qm - supports writing QoS int the host")
Signed-off-by: Tom Rix <trix@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index b731cb4ec294..c5b84a5ea350 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -4394,7 +4394,7 @@ static ssize_t qm_get_qos_value(struct hisi_qm *qm, const char *buf,
 		return -EINVAL;
 
 	ret = qm_qos_value_init(val_buf, val);
-	if (*val == 0 || *val > QM_QOS_MAX_VAL || ret) {
+	if (ret || *val == 0 || *val > QM_QOS_MAX_VAL) {
 		pci_err(qm->pdev, "input qos value is error, please set 1~1000!\n");
 		return -EINVAL;
 	}

