Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C40AC593F51
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345739AbiHOUu0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346463AbiHOUtr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:49:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 761C3B99C9;
        Mon, 15 Aug 2022 12:09:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9C8F6009B;
        Mon, 15 Aug 2022 19:09:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB00FC433C1;
        Mon, 15 Aug 2022 19:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590561;
        bh=qTrRxe6w0Z+uWcp4krLAZw9IEg3f36QngPy9the/PDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RR9n2RopVLfeNM5Coh0nIT70Pp5Xq5g19Km4hPIUPTSmMAIvZ3a9S4AHnFM9C1xUN
         8O0D4tR+aY75yZVAm53axqIPA8ksnYo7e4KHnobGTqvtsrDuY0QFYz3oDzzUNpF0Sn
         EqBV4VOVJ6wpZ04xa+BoJw11pZ+kntreS9w+VuIE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nandhini Srikandan <nandhini.srikandan@intel.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0268/1095] spi: dw: Fix IP-core versions macro
Date:   Mon, 15 Aug 2022 19:54:27 +0200
Message-Id: <20220815180440.831764142@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Nandhini Srikandan <nandhini.srikandan@intel.com>

[ Upstream commit 5d76b7509cb223e94ff73a672273e58f1957ac68 ]

Add the missing underscore in IP version macro to avoid compilation issue.
The macro is used for IP version comparison in the current patchset.

Fixes: 2cc8d9227bbb ("spi: dw: Introduce Synopsys IP-core versions interface")
Signed-off-by: Nandhini Srikandan <nandhini.srikandan@intel.com>
Acked-by: Serge Semin <fancer.lancer@gmail.com>
Link: https://lore.kernel.org/r/20220713042223.1458-2-nandhini.srikandan@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-dw.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-dw.h b/drivers/spi/spi-dw.h
index d5ee5130601e..79d853f6d192 100644
--- a/drivers/spi/spi-dw.h
+++ b/drivers/spi/spi-dw.h
@@ -23,7 +23,7 @@
 	((_dws)->ip == DW_ ## _ip ## _ID)
 
 #define __dw_spi_ver_cmp(_dws, _ip, _ver, _op) \
-	(dw_spi_ip_is(_dws, _ip) && (_dws)->ver _op DW_ ## _ip ## _ver)
+	(dw_spi_ip_is(_dws, _ip) && (_dws)->ver _op DW_ ## _ip ## _ ## _ver)
 
 #define dw_spi_ver_is(_dws, _ip, _ver) __dw_spi_ver_cmp(_dws, _ip, _ver, ==)
 
-- 
2.35.1



