Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 841FD6D5963
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 09:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233861AbjDDHWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 03:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233891AbjDDHWs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 03:22:48 -0400
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B76A62703
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 00:22:46 -0700 (PDT)
Received: by mail-pj1-f51.google.com with SMTP id lr16-20020a17090b4b9000b0023f187954acso33036029pjb.2
        for <stable@vger.kernel.org>; Tue, 04 Apr 2023 00:22:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680592966; x=1683184966;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=321YqDnSuehxPnWUbyYpciZ0sMxU1JX89/Zr4yQAoVQ=;
        b=oCvwiMxvt7e/SV4eEat5bl5/HYzbYn7z0PrFvy0r4vmOG2ddmkyTOfrUXl8cS8NCmx
         d6Nbcnx4g29vVRBDQWcxBknyMgCDNr4lsZyZo5Oa2bRjFQrhXahi9Txmu/G0gNzIfIE2
         3SpWTO1AdIl8r7AbouXx5SYaHoJDBw6/hDJTM0rmobMuSUD17WNJ+r7tq3zJ8rHfOSgI
         2gTDYV8Z3cjPCdsU7iKK4n4oWfYanT9yW3U87F5zSv3Sz1EYhn/rqH782CCnhP7/sc5g
         fM6FsNCg1QQiOz4ym6i6qK3Q72rpVc5BT4QDPma/Yu38XBAy2gvHzOl30GBhVt6gZwG4
         vc3g==
X-Gm-Message-State: AAQBX9dmxFp1bLDNrkOUH3xxAwpl77gkhD37aAjh/HfurUb4PTVBkpnY
        fqAVfFanuZQ2b25FkN9gar3JhbMQFyQ=
X-Google-Smtp-Source: AKy350bO9lopRx/m9nUw7XFOef0TBIzVqx6qsf32bju6RpD53lyQgfFGlEPpqYLsDY5WvROcQLD5kw==
X-Received: by 2002:a17:902:b68b:b0:19d:1e21:7f59 with SMTP id c11-20020a170902b68b00b0019d1e217f59mr1495566pls.0.1680592966036;
        Tue, 04 Apr 2023 00:22:46 -0700 (PDT)
Received: from tgsp-ThinkPad-X280.. ([116.128.244.169])
        by smtp.gmail.com with ESMTPSA id d6-20020a170902c18600b001a04d37a4acsm7773658pld.9.2023.04.04.00.22.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 00:22:45 -0700 (PDT)
From:   xiongxin <xiongxin@kylinos.cn>
To:     xiongxin@kylinos.cn
Cc:     stable@vger.kernel.org
Subject: [PATCH] powercap: intel_rapl: Optimize rp->domains memory allocation
Date:   Tue,  4 Apr 2023 15:22:09 +0800
Message-Id: <20230404072209.676132-1-xiongxin@kylinos.cn>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.8 required=5.0 tests=FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In the memory allocation of rp->domains in rapl_detect_domains(), there
is an additional memory of struct rapl_domain allocated to prevent the
pointer out of bounds called later.

Optimize the code here to save sizeof(struct rapl_domain) bytes of
memory.

Test in Intel NUC (i5-1135G7).

Cc: stable@vger.kernel.org
Signed-off-by: xiongxin <xiongxin@kylinos.cn>
Tested-by: xiongxin <xiongxin@kylinos.cn>
---
 drivers/powercap/intel_rapl_common.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/powercap/intel_rapl_common.c b/drivers/powercap/intel_rapl_common.c
index 8970c7b80884..f8971282498a 100644
--- a/drivers/powercap/intel_rapl_common.c
+++ b/drivers/powercap/intel_rapl_common.c
@@ -1171,13 +1171,14 @@ static int rapl_package_register_powercap(struct rapl_package *rp)
 {
 	struct rapl_domain *rd;
 	struct powercap_zone *power_zone = NULL;
-	int nr_pl, ret;
+	int nr_pl, ret, i;
 
 	/* Update the domain data of the new package */
 	rapl_update_domain_data(rp);
 
 	/* first we register package domain as the parent zone */
-	for (rd = rp->domains; rd < rp->domains + rp->nr_domains; rd++) {
+	for (i = 0; i < rp->nr_domains; i++) {
+		rd = &rp->domains[i];
 		if (rd->id == RAPL_DOMAIN_PACKAGE) {
 			nr_pl = find_nr_power_limit(rd);
 			pr_debug("register package domain %s\n", rp->name);
@@ -1201,8 +1202,9 @@ static int rapl_package_register_powercap(struct rapl_package *rp)
 		return -ENODEV;
 	}
 	/* now register domains as children of the socket/package */
-	for (rd = rp->domains; rd < rp->domains + rp->nr_domains; rd++) {
+	for (i = 0; i < rp->nr_domains; i++) {
 		struct powercap_zone *parent = rp->power_zone;
+		rd = &rp->domains[i];
 
 		if (rd->id == RAPL_DOMAIN_PACKAGE)
 			continue;
@@ -1302,7 +1304,6 @@ static void rapl_detect_powerlimit(struct rapl_domain *rd)
  */
 static int rapl_detect_domains(struct rapl_package *rp, int cpu)
 {
-	struct rapl_domain *rd;
 	int i;
 
 	for (i = 0; i < RAPL_DOMAIN_MAX; i++) {
@@ -1319,15 +1320,15 @@ static int rapl_detect_domains(struct rapl_package *rp, int cpu)
 	}
 	pr_debug("found %d domains on %s\n", rp->nr_domains, rp->name);
 
-	rp->domains = kcalloc(rp->nr_domains + 1, sizeof(struct rapl_domain),
+	rp->domains = kcalloc(rp->nr_domains, sizeof(struct rapl_domain),
 			      GFP_KERNEL);
 	if (!rp->domains)
 		return -ENOMEM;
 
 	rapl_init_domains(rp);
 
-	for (rd = rp->domains; rd < rp->domains + rp->nr_domains; rd++)
-		rapl_detect_powerlimit(rd);
+	for (i = 0; i < rp->nr_domains; i++)
+		rapl_detect_powerlimit(&rp->domains[i]);
 
 	return 0;
 }
-- 
2.34.1

