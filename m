Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76162541550
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378225AbiFGUfG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359481AbiFGU2v (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:28:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC6121DE2F6;
        Tue,  7 Jun 2022 11:34:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE5D260906;
        Tue,  7 Jun 2022 18:34:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCF40C385A2;
        Tue,  7 Jun 2022 18:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626849;
        bh=jqHGMCzx24qQKDPktTXW/vu9addVIfjBqKQ83UTvzSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O1dZTq+Axg4JH7LmSXkOLwjDvGFvKyRQsvDZX+tKo2o+O7OjZwQ15QWGtaM8fz0NF
         lavxyR1sZtII4IBABz0tla6qxEHqDw0NJx62rY4E0EhSXS0+GRr495fGlUg3T4OVzs
         FC/OCj7KsnAxUlt92iusQzGR0fUte6VRgQEmNnhU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Jessica Yu <jeyu@kernel.org>,
        Matthias Maennich <maennich@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 527/772] module.h: simplify MODULE_IMPORT_NS
Date:   Tue,  7 Jun 2022 19:01:59 +0200
Message-Id: <20220607165004.503229394@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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



