Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 035824E7794
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 16:28:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376536AbiCYP26 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 11:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376822AbiCYPX1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 11:23:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CB7EE1247;
        Fri, 25 Mar 2022 08:16:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D11C60DE3;
        Fri, 25 Mar 2022 15:16:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F75DC340E9;
        Fri, 25 Mar 2022 15:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648221409;
        bh=8SAhyuG4jGlA+wi+EXKjrX7dlF5Y3pT/GEqS0lcPxAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L9IjlYw3W0l28TqXxJCl7XRnXwPhNaZTgt9JFUkZ2vaQ+yTAtzZKt+5jkJCQAtucE
         GRusRpJrUMHOaDVybkiSR+Eh2RrNQIId5jatdIWEPttOjKQ+TL1DQOQMT1q5PLOxJW
         LdnhGHAxHXzQpfwzQBhIFLvGDHfsHyD+UiUPVBlc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jarkko Sakkinen <jarkko@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        linux-integrity@vger.kernel.org, Tadeusz Struk <tstruk@gmail.com>,
        Tadeusz Struk <tadeusz.struk@linaro.org>
Subject: [PATCH 5.16 14/37] tpm: Fix error handling in async work
Date:   Fri, 25 Mar 2022 16:14:24 +0100
Message-Id: <20220325150420.455042317@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220325150420.046488912@linuxfoundation.org>
References: <20220325150420.046488912@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tadeusz Struk <tstruk@gmail.com>

commit 2e8e4c8f6673247e22efc7985ce5497accd16f88 upstream.

When an invalid (non existing) handle is used in a TPM command,
that uses the resource manager interface (/dev/tpmrm0) the resource
manager tries to load it from its internal cache, but fails and
the tpm_dev_transmit returns an -EINVAL error to the caller.
The existing async handler doesn't handle these error cases
currently and the condition in the poll handler never returns
mask with EPOLLIN set.
The result is that the poll call blocks and the application gets stuck
until the user_read_timer wakes it up after 120 sec.
Change the tpm_dev_async_work function to handle error conditions
returned from tpm_dev_transmit they are also reflected in the poll mask
and a correct error code could passed back to the caller.

Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: <linux-integrity@vger.kernel.org>
Cc: <stable@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>

Fixes: 9e1b74a63f77 ("tpm: add support for nonblocking operation")
Tested-by: Jarkko Sakkinen<jarkko@kernel.org>
Signed-off-by: Tadeusz Struk <tstruk@gmail.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Tadeusz Struk <tadeusz.struk@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm-dev-common.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/char/tpm/tpm-dev-common.c
+++ b/drivers/char/tpm/tpm-dev-common.c
@@ -69,7 +69,13 @@ static void tpm_dev_async_work(struct wo
 	ret = tpm_dev_transmit(priv->chip, priv->space, priv->data_buffer,
 			       sizeof(priv->data_buffer));
 	tpm_put_ops(priv->chip);
-	if (ret > 0) {
+
+	/*
+	 * If ret is > 0 then tpm_dev_transmit returned the size of the
+	 * response. If ret is < 0 then tpm_dev_transmit failed and
+	 * returned an error code.
+	 */
+	if (ret != 0) {
 		priv->response_length = ret;
 		mod_timer(&priv->user_read_timer, jiffies + (120 * HZ));
 	}


