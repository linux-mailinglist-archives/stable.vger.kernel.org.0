Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC5C54B940
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 20:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357305AbiFNSoe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 14:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357290AbiFNSoK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 14:44:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E4F04B1F1;
        Tue, 14 Jun 2022 11:42:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB6CB6123C;
        Tue, 14 Jun 2022 18:42:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E122AC3411B;
        Tue, 14 Jun 2022 18:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655232177;
        bh=RnmCG4OsvJt2eoM8PLaM8TYlAXhqkJ+2MBbSQA+5vK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OA+nMiwsVZ3qWHOB0SIEpXL2SLVemVF7e2QLcIIcX8MCUxwwf91ekmySyaVshGhCW
         9kj8H5agT3udmpdRV+53NPzo8KI5Hhoxdrh9Sdhdv+nIHT/8FzyVABbCCGXCeE+uhL
         Etr4eSPNlM2qphMr7/Hwy8b0ZZk1b8pvcFTcc/Ds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 4.19 02/16] cpu/speculation: Add prototype for cpu_show_srbds()
Date:   Tue, 14 Jun 2022 20:40:03 +0200
Message-Id: <20220614183721.488403634@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220614183720.928818645@linuxfoundation.org>
References: <20220614183720.928818645@linuxfoundation.org>
User-Agent: quilt/0.66
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
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
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


