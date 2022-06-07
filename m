Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C787541CA2
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382409AbiFGWCh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:02:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382872AbiFGWAZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:00:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8860E24DBCF;
        Tue,  7 Jun 2022 12:14:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FBA861846;
        Tue,  7 Jun 2022 19:13:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44454C385A2;
        Tue,  7 Jun 2022 19:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629238;
        bh=jqHGMCzx24qQKDPktTXW/vu9addVIfjBqKQ83UTvzSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YseMfbVCygYPUWfKreiZ9eHvU/RKhoBoQy8a/ur8UzBmNSxaWbVpBELq5IidBNutL
         oDKi9xMZj5UsbR6M8cy53Dv85AgIX7p6cjfym9TwCSPmqxh0m3kTH5R/FPFuveAPPH
         50S14spQ8KvsadfGtrDxpwZfvk3HPLN9YXdxR/N0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Jessica Yu <jeyu@kernel.org>,
        Matthias Maennich <maennich@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 618/879] module.h: simplify MODULE_IMPORT_NS
Date:   Tue,  7 Jun 2022 19:02:16 +0200
Message-Id: <20220607165020.786341119@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 80140a81f7f833998d732102eea0fea230b88067 ]

In commit ca321ec74322 ("module.h: allow #define strings to work with
MODULE_IMPORT_NS") I fixed up the MODULE_IMPORT_NS() macro to allow
defined strings to work with it.  Unfortunatly I did it in a two-stage
process, when it could just be done with the __stringify() macro as
pointed out by Masahiro Yamada.

Clean this up to only be one macro instead of two steps to achieve the
same end result.

Fixes: ca321ec74322 ("module.h: allow #define strings to work with MODULE_IMPORT_NS")
Reported-by: Masahiro Yamada <masahiroy@kernel.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Jessica Yu <jeyu@kernel.org>
Cc: Matthias Maennich <maennich@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/module.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 1e135fd5c076..d5e9066990ca 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -290,8 +290,7 @@ extern typeof(name) __mod_##type##__##name##_device_table		\
  * files require multiple MODULE_FIRMWARE() specifiers */
 #define MODULE_FIRMWARE(_firmware) MODULE_INFO(firmware, _firmware)
 
-#define _MODULE_IMPORT_NS(ns)	MODULE_INFO(import_ns, #ns)
-#define MODULE_IMPORT_NS(ns)	_MODULE_IMPORT_NS(ns)
+#define MODULE_IMPORT_NS(ns)	MODULE_INFO(import_ns, __stringify(ns))
 
 struct notifier_block;
 
-- 
2.35.1



