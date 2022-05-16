Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75541528FCC
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346439AbiEPTyG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 15:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348648AbiEPTw7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:52:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6403746B0A;
        Mon, 16 May 2022 12:48:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E52BDB8160E;
        Mon, 16 May 2022 19:48:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F958C385AA;
        Mon, 16 May 2022 19:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730525;
        bh=4PtoM0jH0dr6HRuo2pxKWiy7vyVcTkZ9j6fBBFFi8o4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sike3JFFRIrya1ta/FlZbbtAYCX29o6OKTByvIlcN0Vsu8iuiyftHo6zs1lye0YSH
         46nLkLk5C8OfK0jFMyXHS8V1NjlaKtVsRqCz8zUfZddDE+4TtcF+4sPgEeKK+CkZaw
         DM+B6dd4kjXq/erd6LXv+FIyvABSNQwRRbXKC+B4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Florian Eckert <fe@dev.tdt.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Jean Delvare <jdelvare@suse.com>, linux-hwmon@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 027/102] hwmon: (ltq-cputemp) restrict it to SOC_XWAY
Date:   Mon, 16 May 2022 21:36:01 +0200
Message-Id: <20220516193624.779668928@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193623.989270214@linuxfoundation.org>
References: <20220516193623.989270214@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 151d6dcbed836270c6c240932da66f147950cbdb ]

Building with SENSORS_LTQ_CPUTEMP=y with SOC_FALCON=y causes build
errors since FALCON does not support the same features as XWAY.

Change this symbol to depend on SOC_XWAY since that provides the
necessary interfaces.

Repairs these build errors:

../drivers/hwmon/ltq-cputemp.c: In function 'ltq_cputemp_enable':
../drivers/hwmon/ltq-cputemp.c:23:9: error: implicit declaration of function 'ltq_cgu_w32'; did you mean 'ltq_ebu_w32'? [-Werror=implicit-function-declaration]
   23 |         ltq_cgu_w32(ltq_cgu_r32(CGU_GPHY1_CR) | CGU_TEMP_PD, CGU_GPHY1_CR);
../drivers/hwmon/ltq-cputemp.c:23:21: error: implicit declaration of function 'ltq_cgu_r32'; did you mean 'ltq_ebu_r32'? [-Werror=implicit-function-declaration]
   23 |         ltq_cgu_w32(ltq_cgu_r32(CGU_GPHY1_CR) | CGU_TEMP_PD, CGU_GPHY1_CR);
../drivers/hwmon/ltq-cputemp.c: In function 'ltq_cputemp_probe':
../drivers/hwmon/ltq-cputemp.c:92:31: error: 'SOC_TYPE_VR9_2' undeclared (first use in this function)
   92 |         if (ltq_soc_type() != SOC_TYPE_VR9_2)

Fixes: 7074d0a92758 ("hwmon: (ltq-cputemp) add cpu temp sensor driver")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Florian Eckert <fe@dev.tdt.de>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Jean Delvare <jdelvare@suse.com>
Cc: linux-hwmon@vger.kernel.org
Link: https://lore.kernel.org/r/20220509234740.26841-1-rdunlap@infradead.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index ccdaeafed0bb..51f1caa10d11 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -944,7 +944,7 @@ config SENSORS_LTC4261
 
 config SENSORS_LTQ_CPUTEMP
 	bool "Lantiq cpu temperature sensor driver"
-	depends on LANTIQ
+	depends on SOC_XWAY
 	help
 	  If you say yes here you get support for the temperature
 	  sensor inside your CPU.
-- 
2.35.1



