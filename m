Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E633354B950
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 20:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357441AbiFNSpt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 14:45:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357465AbiFNSpS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 14:45:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85296BCA;
        Tue, 14 Jun 2022 11:43:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46C87B81AEF;
        Tue, 14 Jun 2022 18:43:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1EF2C3411B;
        Tue, 14 Jun 2022 18:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655232222;
        bh=8JHjulThWdYpSXpcMC7/ftnEiVywMATYxrFG+7e5xzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ua2reheGHSmAM6nifiTsb8Kxu703iRt9Q7MkN3KxtbSOlEOtGDsHZNIRcfL/od8oN
         YxNepG09HGAcZwxsaFbXO5TMY4pJrYyrKJa0kvIaO8x6LGj+sibRPVa3LV9SUQO+AI
         ZCmXdU8vi5f+B+qs7LDQVrvJIYDwvSrflnJmNVS8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.4 01/15] cpu/speculation: Add prototype for cpu_show_srbds()
Date:   Tue, 14 Jun 2022 20:40:10 +0200
Message-Id: <20220614183722.001376874@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220614183721.656018793@linuxfoundation.org>
References: <20220614183721.656018793@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

commit 2accfa69050c2a0d6fc6106f609208b3e9622b26 upstream.

0-day is not happy that there is no prototype for cpu_show_srbds():

drivers/base/cpu.c:565:16: error: no previous prototype for 'cpu_show_srbds'

Fixes: 7e5b3c267d25 ("x86/speculation: Add Special Register Buffer Data Sampling (SRBDS) mitigation")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20200617141410.93338-1-linux@roeck-us.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/cpu.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -64,6 +64,7 @@ extern ssize_t cpu_show_tsx_async_abort(
 					char *buf);
 extern ssize_t cpu_show_itlb_multihit(struct device *dev,
 				      struct device_attribute *attr, char *buf);
+extern ssize_t cpu_show_srbds(struct device *dev, struct device_attribute *attr, char *buf);
 
 extern __printf(4, 5)
 struct device *cpu_device_create(struct device *parent, void *drvdata,


