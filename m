Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF8412E067
	for <lists+stable@lfdr.de>; Wed,  1 Jan 2020 21:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727273AbgAAUlD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jan 2020 15:41:03 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:33305 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727170AbgAAUlD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jan 2020 15:41:03 -0500
Received: by mail-pl1-f196.google.com with SMTP id c13so17069434pls.0;
        Wed, 01 Jan 2020 12:41:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=x6s2wGBJpY7IwC8muBci3cdYeb7ZCd4x+NJXrfy+/w0=;
        b=U0wWfO8Mnvu6j2ImmRM6oPgBDtFB/lxDQpQKLcihHbFiBil/IW5o3et25Hd9c16OTL
         ki4IatTPzDJv+1lS3u742cOhJKUDkvdEOr3KZdXZwd3xBmPp+4IXK0ngABcxj2ahTQ7t
         gf+sEkEDA4A0nvzSpUQq21sUCMXG9fZ+4rC+76gAN6vyvlE5LVTNcEkoxvGIZeHxBi6x
         hMctrHvQS1yZDkOUo6p1BDZ6+TOXoMn4/KEMnJIhsxttlvd38xHZKz6C//k5wjo8SbrK
         AfddODoDb5wsulkU1YH4sYMpZ7J7iIa/IFv9YNMTzCfjUuMOM/1VkRPnWeAPT+sfaIm7
         CvEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=x6s2wGBJpY7IwC8muBci3cdYeb7ZCd4x+NJXrfy+/w0=;
        b=n3SMVHEDcQzfWTx0bi/mFnJ8PBVclhaSuZ9UvIpefO4DYSRsTshx4Go4cO2cUDITWz
         GCG3AtTzKRrKrB+upgU3agy1EZuXz7nfaInNr6I3sqE1lfgm/VRTzfVygizP7M+zo9n8
         c2sTUhYH+yflCHI+x/si7vxrYoFtU0Z1Qb3lGMJ47EevIP4CZIwHxOeRrglVNN7T+Ep8
         EBmw29ItrVkOSYLck0IYi3aVFFLxGFEb1DgxNzh61AKm54aJd2eiEcTsOqQLSzhp+p+D
         9DybuGyTSyxnAxDwY0MNhIJO64xB6Tvl+or7VLjnjF55Sp6LP/2NKy2ora6Tarw+QQL5
         tvcw==
X-Gm-Message-State: APjAAAV/ZRF29PxsfoCQbYEzvzikveeJD8d7Z9cYjHJsuvSWEi8PkqnX
        cnPnpsTN8ybB46QbTZKqhqRo+2rAkcg=
X-Google-Smtp-Source: APXvYqxya1GkOO+wy+zHyqk7ZUt5UdoTTGaVoVD03dnjVqN9FvQOJ8CTj+9kTEgLJOW6mRAG5p7Ezw==
X-Received: by 2002:a17:902:5a85:: with SMTP id r5mr82561148pli.222.1577911262811;
        Wed, 01 Jan 2020 12:41:02 -0800 (PST)
Received: from john-aspire.resnet.ucla.edu (s-149-142-223-238.resnet.ucla.edu. [149.142.223.238])
        by smtp.gmail.com with ESMTPSA id n188sm57234743pga.84.2020.01.01.12.41.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jan 2020 12:41:02 -0800 (PST)
From:   Boyan Ding <boyan.j.ding@gmail.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-gpio@vger.kernel.org
Cc:     Boyan Ding <boyan.j.ding@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] pinctrl: sunrisepoint: Add missing Interrupt Status register offset
Date:   Wed,  1 Jan 2020 12:41:20 -0800
Message-Id: <20200101204120.5873-1-boyan.j.ding@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 179e5a6114cc ("pinctrl: intel: Remove default Interrupt Status
offset") removes default interrupt status offset of GPIO controllers, 
with previous commits explicitly providing the previously default
offsets. However, the is_offset value in SPTH_COMMUNITY is missing,
preventing related irq from being properly detected and handled.

Fixes: f702e0b93cdb ("pinctrl: sunrisepoint: Provide Interrupt Status register offset")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=205745
Cc: stable@vger.kernel.org
Signed-off-by: Boyan Ding <boyan.j.ding@gmail.com>
---
 drivers/pinctrl/intel/pinctrl-sunrisepoint.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/intel/pinctrl-sunrisepoint.c b/drivers/pinctrl/intel/pinctrl-sunrisepoint.c
index 44d7f50bbc82..d936e7aa74c4 100644
--- a/drivers/pinctrl/intel/pinctrl-sunrisepoint.c
+++ b/drivers/pinctrl/intel/pinctrl-sunrisepoint.c
@@ -49,6 +49,7 @@
 		.padown_offset = SPT_PAD_OWN,		\
 		.padcfglock_offset = SPT_PADCFGLOCK,	\
 		.hostown_offset = SPT_HOSTSW_OWN,	\
+		.is_offset = SPT_GPI_IS,		\
 		.ie_offset = SPT_GPI_IE,		\
 		.pin_base = (s),			\
 		.npins = ((e) - (s) + 1),		\
-- 
2.24.0

