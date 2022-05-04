Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BABC51A722
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354548AbiEDRCL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355663AbiEDRAT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:00:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA59F4BBB3;
        Wed,  4 May 2022 09:52:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1E2461701;
        Wed,  4 May 2022 16:52:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4B75C385A5;
        Wed,  4 May 2022 16:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683120;
        bh=UvbEPPP0Phld+EI24rEyUua/Umh4MxaId4S52B0wD58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iXY5ZZqDPTaI8jANtx/IbxaGa4RRqtGNgeAIVVrULlA+FFzj+qW6FGe0TCOSKdt4Y
         glomw9NFJ2GDWPwMaamCx0WUHiHGn9ag6eihjCbXLSreOh1T2imBZmBRFjubNZnXAT
         TrleYsJfNTEw7BDMHq5PpU2nbr9vW7JlwUn3/NoU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Joao Moreira <joao@overdrivepizza.com>
Subject: [PATCH 5.10 111/129] thermal: int340x: Fix attr.show callback prototype
Date:   Wed,  4 May 2022 18:45:03 +0200
Message-Id: <20220504153030.088795829@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153021.299025455@linuxfoundation.org>
References: <20220504153021.299025455@linuxfoundation.org>
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
@@ -269,7 +269,7 @@ static int int3400_thermal_run_osc(acpi_
 	return result;
 }
 
-static ssize_t odvp_show(struct kobject *kobj, struct kobj_attribute *attr,
+static ssize_t odvp_show(struct device *dev, struct device_attribute *attr,
 			 char *buf)
 {
 	struct odvp_attr *odvp_attr;


