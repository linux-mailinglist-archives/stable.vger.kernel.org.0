Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DDCB4BDE4B
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354301AbiBUKD0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 05:03:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353503AbiBUJ53 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:57:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D832A1DA53;
        Mon, 21 Feb 2022 01:26:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7676D61016;
        Mon, 21 Feb 2022 09:26:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5395DC340E9;
        Mon, 21 Feb 2022 09:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435585;
        bh=3aV9bHzykKizB1J+5Ksl6TyTU0mBhVe4TvtLefKoCRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J9b2P5Yc4vLtSaDEOJIR1b9v9RQSP3gqUcQOShEUWJj3Ed62jOoVa/yU7saNX48wz
         EH19De4jQmphwjqixMUpsMQKhywnCcBs2v25X0KFI8q25j1fpOBf6X1L21FmuB02uO
         JsS+dxqX8r2hsmc2wLiG+Lx0BAabSdNzDjYyGRbg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
        Robert Foss <robert.foss@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 5.16 183/227] i2c: qcom-cci: dont delete an unregistered adapter
Date:   Mon, 21 Feb 2022 09:50:02 +0100
Message-Id: <20220221084940.903673948@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>

commit a0d48505a1d68e27220369e2dd1e3573a2f362d2 upstream.

If i2c_add_adapter() fails to add an I2C adapter found on QCOM CCI
controller, on error path i2c_del_adapter() is still called.

Fortunately there is a sanity check in the I2C core, so the only
visible implication is a printed debug level message:

    i2c-core: attempting to delete unregistered adapter [Qualcomm-CCI]

Nevertheless it would be reasonable to correct the probe error path.

Fixes: e517526195de ("i2c: Add Qualcomm CCI I2C driver")
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Reviewed-by: Robert Foss <robert.foss@linaro.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-qcom-cci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-qcom-cci.c
+++ b/drivers/i2c/busses/i2c-qcom-cci.c
@@ -655,7 +655,7 @@ static int cci_probe(struct platform_dev
 	return 0;
 
 error_i2c:
-	for (; i >= 0; i--) {
+	for (--i ; i >= 0; i--) {
 		if (cci->master[i].cci)
 			i2c_del_adapter(&cci->master[i].adap);
 	}


