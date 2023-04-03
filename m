Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5506D4A0F
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233889AbjDCOnt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233891AbjDCOnl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:43:41 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 695687283
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:43:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AC525CE12DE
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:42:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77717C433EF;
        Mon,  3 Apr 2023 14:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532977;
        bh=nmz204XOkJG9uXQyQt9rWF57A+xCM4lATLzlpPjVCZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TwgDyhZaMHxgK+gwrKyUIJLDb45STdn0ZSZ1dSDm0dWCtO/pCTGM37Yvfx1xvWgDS
         bCQfGj5JpCWZLU+wZFCRjKAYOd/GvBKp934RUZQiqLddFHYanAWlB5mkhSbZ6eYPaM
         ibAbNcaBl6GWPv3+9cQE21YK3Wh28wmo9y3qKRmI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Haren Myneni <haren@linux.ibm.com>,
        Nathan Lynch <nathanl@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 6.1 149/181] powerpc/pseries/vas: Ignore VAS update for DLPAR if copy/paste is not enabled
Date:   Mon,  3 Apr 2023 16:09:44 +0200
Message-Id: <20230403140419.895131554@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haren Myneni <haren@linux.ibm.com>

commit eca9f6e6f83b6725b84e1c76fdde19b003cff0eb upstream.

The hypervisor supports user-mode NX from Power10.

pseries_vas_dlpar_cpu() is called from lparcfg_write() to update VAS
windows for DLPAR event in shared processor mode and the kernel gets
-ENOTSUPP for HCALLs if the user-mode NX is not supported. The current
VAS implementation also supports only with Radix page tables. Whereas in
dedicated processor mode, pseries_vas_notifier() is registered only if
the copy/paste feature is enabled. So instead of displaying HCALL error
messages, update VAS capabilities if the copy/paste feature is
available.

This patch ignores updating VAS capabilities in pseries_vas_dlpar_cpu()
and returns success if the copy/paste feature is not enabled. Then
lparcfg_write() completes the processor DLPAR operations without any
failures.

Fixes: 2147783d6bf0 ("powerpc/pseries: Use lparcfg to reconfig VAS windows for DLPAR CPU")
Cc: stable@vger.kernel.org # v6.1+
Signed-off-by: Haren Myneni <haren@linux.ibm.com>
Reviewed-by: Nathan Lynch <nathanl@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/1d0e727e7dbd9a28627ef08ca9df9c86a50175e2.camel@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/pseries/vas.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/powerpc/platforms/pseries/vas.c
+++ b/arch/powerpc/platforms/pseries/vas.c
@@ -857,6 +857,13 @@ int pseries_vas_dlpar_cpu(void)
 {
 	int new_nr_creds, rc;
 
+	/*
+	 * NX-GZIP is not enabled. Nothing to do for DLPAR event
+	 */
+	if (!copypaste_feat)
+		return 0;
+
+
 	rc = h_query_vas_capabilities(H_QUERY_VAS_CAPABILITIES,
 				      vascaps[VAS_GZIP_DEF_FEAT_TYPE].feat,
 				      (u64)virt_to_phys(&hv_cop_caps));
@@ -1013,6 +1020,7 @@ static int __init pseries_vas_init(void)
 	 * Linux supports user space COPY/PASTE only with Radix
 	 */
 	if (!radix_enabled()) {
+		copypaste_feat = false;
 		pr_err("API is supported only with radix page tables\n");
 		return -ENOTSUPP;
 	}


