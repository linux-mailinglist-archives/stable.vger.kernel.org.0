Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58F3153D03F
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 20:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345814AbiFCSBd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 14:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346106AbiFCR7x (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:59:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AA7A34B87;
        Fri,  3 Jun 2022 10:55:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1576611F3;
        Fri,  3 Jun 2022 17:55:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADFC2C385A9;
        Fri,  3 Jun 2022 17:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278938;
        bh=x5kV3Z+YxJqaxbkJ5fOTbYmq3aXHfxYboSUuniNqq7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SRoP0Nwd3Yy3kpVwIAcKZ9igbADyy5rcjAeulXFiOuphNJpGvdG3mR5Tzc7HEuBpM
         M2/wu8tFqEunjDfL/N51i7dfCjzEgj4Znj08RBTOeY3PCHN5//BE3Soph2YxKEgebt
         WatsxfZB9PNPzFjAkzi7xr0TZhstzxjMf8kDO4ao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiu Jianfeng <xiujianfeng@huawei.com>,
        Stefan Berger <stefanb@linux.ibm.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.17 65/75] tpm: ibmvtpm: Correct the return value in tpm_ibmvtpm_probe()
Date:   Fri,  3 Jun 2022 19:43:49 +0200
Message-Id: <20220603173823.576669772@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173821.749019262@linuxfoundation.org>
References: <20220603173821.749019262@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiu Jianfeng <xiujianfeng@huawei.com>

commit d0dc1a7100f19121f6e7450f9cdda11926aa3838 upstream.

Currently it returns zero when CRQ response timed out, it should return
an error code instead.

Fixes: d8d74ea3c002 ("tpm: ibmvtpm: Wait for buffer to be set before proceeding")
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>
Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm_ibmvtpm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/char/tpm/tpm_ibmvtpm.c
+++ b/drivers/char/tpm/tpm_ibmvtpm.c
@@ -681,6 +681,7 @@ static int tpm_ibmvtpm_probe(struct vio_
 	if (!wait_event_timeout(ibmvtpm->crq_queue.wq,
 				ibmvtpm->rtce_buf != NULL,
 				HZ)) {
+		rc = -ENODEV;
 		dev_err(dev, "CRQ response timed out\n");
 		goto init_irq_cleanup;
 	}


