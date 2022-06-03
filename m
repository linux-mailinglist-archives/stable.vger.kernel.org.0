Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0FD53CE72
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344659AbiFCRm2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344801AbiFCRmI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:42:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB09F53A79;
        Fri,  3 Jun 2022 10:41:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42582B8241E;
        Fri,  3 Jun 2022 17:41:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97AB4C385B8;
        Fri,  3 Jun 2022 17:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278086;
        bh=5DLh3zfwqkuKS/K1n4AvAGFzOB5krvK1ROtUZvkNdoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FC4bWCNvWYoP6zcb12VGP/HM1Gtyj/LFusqdLmagxg5YK6phPCTQhfV0db39bFK7D
         T9SulEH9c2cXF0H4Mcv1r1NP6rhEg61YL8fLT84daW++2Py3HBUPgfs9hzHeEb2ZSp
         Z8MjoY+/hK5RqmbZWyRO4W2MCYNL7DSF63X4IHAY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiu Jianfeng <xiujianfeng@huawei.com>,
        Stefan Berger <stefanb@linux.ibm.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 4.14 20/23] tpm: ibmvtpm: Correct the return value in tpm_ibmvtpm_probe()
Date:   Fri,  3 Jun 2022 19:39:47 +0200
Message-Id: <20220603173814.974445103@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173814.362515009@linuxfoundation.org>
References: <20220603173814.362515009@linuxfoundation.org>
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
@@ -692,6 +692,7 @@ static int tpm_ibmvtpm_probe(struct vio_
 	if (!wait_event_timeout(ibmvtpm->crq_queue.wq,
 				ibmvtpm->rtce_buf != NULL,
 				HZ)) {
+		rc = -ENODEV;
 		dev_err(dev, "CRQ response timed out\n");
 		goto init_irq_cleanup;
 	}


