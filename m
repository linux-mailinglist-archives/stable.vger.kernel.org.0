Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 307846AECEA
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbjCGR72 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:59:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbjCGR7C (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:59:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02C3C2A145
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:53:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9318E6150F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:53:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8854CC433D2;
        Tue,  7 Mar 2023 17:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211601;
        bh=sk93iu3UgsiXLgJobRJEo0Akf3m8wVokf5WZjYAjJMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZAng8tFjn4q1vm54bsibb3NVWC5umWwvea0whkzphwQXHtz0YUNJpn5wNSW+mCVrb
         tc6VJZMkB6+A+RCYYtsgiwQxHjsULzecJwXI4Xx2+XpXtFjs8dJHNOXpTZSXSyo9bi
         07mFaHwFVW9PQZtSkIGVyC2HRPlut1LtacANzPTg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zev Weiss <zev@bewilderbeest.net>,
        Iwona Winiarska <iwona.winiarska@intel.com>,
        Guenter Roeck <linux@roeck-us.net>, stable@kernel.org
Subject: [PATCH 6.2 0915/1001] hwmon: (peci/cputemp) Fix off-by-one in coretemp_label allocation
Date:   Tue,  7 Mar 2023 18:01:27 +0100
Message-Id: <20230307170101.759368179@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zev Weiss <zev@bewilderbeest.net>

commit f00093608fa790580da309bb9feb5108fbe7c331 upstream.

The find_last_bit() call produces the index of the highest-numbered
core in core_mask; because cores are numbered from zero, the number of
elements we need to allocate is one more than that.

Signed-off-by: Zev Weiss <zev@bewilderbeest.net>
Cc: stable@kernel.org # v5.18
Fixes: bf3608f338e9 ("hwmon: peci: Add cputemp driver")
Reviewed-by: Iwona Winiarska <iwona.winiarska@intel.com>
Link: https://lore.kernel.org/r/20230202021825.21486-1-zev@bewilderbeest.net
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/peci/cputemp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/peci/cputemp.c
+++ b/drivers/hwmon/peci/cputemp.c
@@ -402,7 +402,7 @@ static int create_temp_label(struct peci
 	unsigned long core_max = find_last_bit(priv->core_mask, CORE_NUMS_MAX);
 	int i;
 
-	priv->coretemp_label = devm_kzalloc(priv->dev, core_max * sizeof(char *), GFP_KERNEL);
+	priv->coretemp_label = devm_kzalloc(priv->dev, (core_max + 1) * sizeof(char *), GFP_KERNEL);
 	if (!priv->coretemp_label)
 		return -ENOMEM;
 


