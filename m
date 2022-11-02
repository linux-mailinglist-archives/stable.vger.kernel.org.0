Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 077866157D4
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbiKBCjr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbiKBCjq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:39:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D25F11C04
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:39:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17B91B82070
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:39:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94ECAC433D6;
        Wed,  2 Nov 2022 02:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667356782;
        bh=vTkrxMsWLS2rRfBdrgJ0SlwPiJKsD7WhWaG+iFQD+as=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TlaCyKryuAg0Lw4DFCOgjQa411zAgXf9VQeasfLvkyBd3n9hZcmpSwB9zFVmv24v4
         nF23xpsrLuutwR51r45PfogJCouxWtiMhOnK/f7FKGLWaMcYN0TXH3NrTmnclero2r
         a3H0sSG/SaMfDYAGQ3OTTI9m4Ak89h3pIMOHI4FY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable <stable@kernel.org>,
        Jerome Audu <jerome.audu@st.com>,
        Felipe Balbi <felipe@balbi.sh>,
        Patrice Chotard <patrice.chotard@foss.st.com>
Subject: [PATCH 6.0 031/240] usb: dwc3: st: Rely on childs compatible instead of name
Date:   Wed,  2 Nov 2022 03:30:06 +0100
Message-Id: <20221102022112.107984167@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Patrice Chotard <patrice.chotard@foss.st.com>

commit 3f53c329b31d53b2a2e7992819242fc0d4f883e0 upstream.

To ensure that child node is found, don't rely on child's node name
which can take different value, but on child's compatible name.

Fixes: f5c5936d6b4d ("usb: dwc3: st: Fix node's child name")
Cc: stable <stable@kernel.org>
Cc: Jerome Audu <jerome.audu@st.com>
Reported-by: Felipe Balbi <felipe@balbi.sh>
Signed-off-by: Patrice Chotard <patrice.chotard@foss.st.com>
Link: https://lore.kernel.org/r/20220930142018.890535-1-patrice.chotard@foss.st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-st.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/dwc3/dwc3-st.c
+++ b/drivers/usb/dwc3/dwc3-st.c
@@ -251,7 +251,7 @@ static int st_dwc3_probe(struct platform
 	/* Manage SoftReset */
 	reset_control_deassert(dwc3_data->rstc_rst);
 
-	child = of_get_child_by_name(node, "usb");
+	child = of_get_compatible_child(node, "snps,dwc3");
 	if (!child) {
 		dev_err(&pdev->dev, "failed to find dwc3 core node\n");
 		ret = -ENODEV;


