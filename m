Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87E8451A8A7
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355427AbiEDRLf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:11:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356954AbiEDRJv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:09:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32317473AE;
        Wed,  4 May 2022 09:56:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12E39617A6;
        Wed,  4 May 2022 16:56:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 605A4C385AA;
        Wed,  4 May 2022 16:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683401;
        bh=hdoWo2RhsqsWgZIRmPbb7DxC3aFuG2ViZhr8JO9X6t8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TfI2kci8w3n/CelDbJEuhjXDVi7WZVLr2gWrl6ZzJ6twWj7zbmMuASsQytOzgBk6o
         StMfh58fCKuyH3A1O0a6S/jUCwnOX+o93IW92k13sVTY38iKubzqIcsXJbMh/J4UVD
         fuSBuf4FvA2qrjMcDtSs5xT5dWvP5FJn0FDR5mrk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 072/225] iio:dac:ad3552r: Fix an IS_ERR() vs NULL check
Date:   Wed,  4 May 2022 18:45:10 +0200
Message-Id: <20220504153117.893992445@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit de3b9fe9609a05d3c354c6718ca657962d11d9fe ]

The fwnode_get_named_child_node() function does not return error
pointers.  It returns NULL.  Update the check accordingly.

Fixes: 8f2b54824b28 ("drivers:iio:dac: Add AD3552R driver support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220404114244.GA19201@kili
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/dac/ad3552r.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/dac/ad3552r.c b/drivers/iio/dac/ad3552r.c
index e0a93b27e0e8..d5ea1a1be122 100644
--- a/drivers/iio/dac/ad3552r.c
+++ b/drivers/iio/dac/ad3552r.c
@@ -809,10 +809,10 @@ static int ad3552r_configure_custom_gain(struct ad3552r_desc *dac,
 
 	gain_child = fwnode_get_named_child_node(child,
 						 "custom-output-range-config");
-	if (IS_ERR(gain_child)) {
+	if (!gain_child) {
 		dev_err(dev,
 			"mandatory custom-output-range-config property missing\n");
-		return PTR_ERR(gain_child);
+		return -EINVAL;
 	}
 
 	dac->ch_data[ch].range_override = 1;
-- 
2.35.1



