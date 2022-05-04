Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F227C51AA21
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345773AbiEDRVo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357709AbiEDRPL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:15:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8DD455371;
        Wed,  4 May 2022 09:58:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2ECFDB827A5;
        Wed,  4 May 2022 16:58:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD3FFC385AF;
        Wed,  4 May 2022 16:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683532;
        bh=nGLJ71aZM7M+usue7fy/bT1qAY3btYDEdT4Yeh0Ev5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wsc7E1aTnLV+J/2b4PLxM8vRucXwApLovOJI9CvzKXSYDfTGmtu3jSJ/EnTKZOiFu
         Q8R5datEYemLur3UlUJY++YGJ6jZwuER16bKMtTiG0V+NndRnfhRC3YSWXTt85bdey
         ZIOsdOBpKu+INL6l4uxXV4fv0M3QW/cACfm80qEI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Joao Moreira <joao@overdrivepizza.com>
Subject: [PATCH 5.17 190/225] thermal: int340x: Fix attr.show callback prototype
Date:   Wed,  4 May 2022 18:47:08 +0200
Message-Id: <20220504153127.239181450@linuxfoundation.org>
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

From: Kees Cook <keescook@chromium.org>

commit d0f6cfb2bd165b0aa307750e07e03420859bd554 upstream.

Control Flow Integrity (CFI) instrumentation of the kernel noticed that
the caller, dev_attr_show(), and the callback, odvp_show(), did not have
matching function prototypes, which would cause a CFI exception to be
raised. Correct the prototype by using struct device_attribute instead
of struct kobj_attribute.

Reported-and-tested-by: Joao Moreira <joao@overdrivepizza.com>
Link: https://lore.kernel.org/lkml/067ce8bd4c3968054509831fa2347f4f@overdrivepizza.com/
Fixes: 006f006f1e5c ("thermal/int340x_thermal: Export OEM vendor variables")
Cc: 5.8+ <stable@vger.kernel.org> # 5.8+
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/intel/int340x_thermal/int3400_thermal.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
+++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
@@ -67,7 +67,7 @@ static int evaluate_odvp(struct int3400_
 struct odvp_attr {
 	int odvp;
 	struct int3400_thermal_priv *priv;
-	struct kobj_attribute attr;
+	struct device_attribute attr;
 };
 
 static ssize_t data_vault_read(struct file *file, struct kobject *kobj,
@@ -271,7 +271,7 @@ static int int3400_thermal_run_osc(acpi_
 	return result;
 }
 
-static ssize_t odvp_show(struct kobject *kobj, struct kobj_attribute *attr,
+static ssize_t odvp_show(struct device *dev, struct device_attribute *attr,
 			 char *buf)
 {
 	struct odvp_attr *odvp_attr;


