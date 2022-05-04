Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 247DE51AA0A
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355707AbiEDRU4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358085AbiEDRPj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:15:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E2CC56419;
        Wed,  4 May 2022 09:59:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C3D9B8279A;
        Wed,  4 May 2022 16:59:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8847BC385AA;
        Wed,  4 May 2022 16:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683559;
        bh=1RwLgbW1uY65NWobAxBjbLTwzhjAH6mhVMDFan1/tXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DNjYAW8Qlt4jAm8/ufZQbVkmvZ3xaG05YqRIYyAzuCFhjJofYPRAv14R6wcOWQKqN
         LvSbTVdJmVEiTXXJgDGlfC9Ov9A+HxCRKRG8YSfLN3J16m1+d11nqRNL2HnpUNd46r
         rEVmtBUxzZMudR1Rqm5rAUidQpAHSPfsIGQp98+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Daniel Starke <daniel.starke@siemens.com>
Subject: [PATCH 5.17 222/225] tty: n_gsm: fix sometimes uninitialized warning in gsm_dlci_modem_output()
Date:   Wed,  4 May 2022 18:47:40 +0200
Message-Id: <20220504153129.674725357@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
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

From: Daniel Starke <daniel.starke@siemens.com>

commit 19317433057dc1f2ca9a975e4e6b547282c2a5ef upstream.

'size' may be used uninitialized in gsm_dlci_modem_output() if called with
an adaption that is neither 1 nor 2. The function is currently only called
by gsm_modem_upd_via_data() and only for adaption 2.
Properly handle every invalid case by returning -EINVAL to silence the
compiler warning and avoid future regressions.

Fixes: c19ffe00fed6 ("tty: n_gsm: fix invalid use of MSC in advanced option")
Cc: stable@vger.kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20220425104726.7986-1-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/n_gsm.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -932,18 +932,21 @@ static int gsm_dlci_modem_output(struct
 {
 	u8 *dp = NULL;
 	struct gsm_msg *msg;
-	int size;
+	int size = 0;
 
 	/* for modem bits without break data */
-	if (dlci->adaption == 1) {
-		size = 0;
-	} else if (dlci->adaption == 2) {
-		size = 1;
+	switch (dlci->adaption) {
+	case 1: /* Unstructured */
+		break;
+	case 2: /* Unstructured with modem bits. */
+		size++;
 		if (brk > 0)
 			size++;
-	} else {
+		break;
+	default:
 		pr_err("%s: unsupported adaption %d\n", __func__,
 		       dlci->adaption);
+		return -EINVAL;
 	}
 
 	msg = gsm_data_alloc(gsm, dlci->addr, size, gsm->ftype);


