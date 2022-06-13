Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7265A548C31
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385515AbiFMOpv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386068AbiFMOo2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:44:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B0C7B5797;
        Mon, 13 Jun 2022 04:51:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0E57B80EDD;
        Mon, 13 Jun 2022 11:50:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22905C34114;
        Mon, 13 Jun 2022 11:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655121050;
        bh=k+/pVrIT8QfqIWbATLK3wlWEq5hh0GwRx7H7a3D01Zw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2qJKPbi2sd55ww31qqX5xUI8c5guD7y4dKXQzxEOxe+lWwSD1/oQrY7alrMTqBSEf
         nX4FEoTA7Dm9D9zC0Cv1Pmi9pxPocfUEGucSEn7VvIXIU5/3pSVZJJ990ADzeKcUFz
         XFPpXyoQ53ZimJZKojJF24Ck3i5O2QIoVlgvE7qA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 254/298] scripts/gdb: change kernel config dumping method
Date:   Mon, 13 Jun 2022 12:12:28 +0200
Message-Id: <20220613094932.783737782@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
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

From: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>

[ Upstream commit 1f7a6cf6b07c74a17343c2559cd5f5018a245961 ]

MAGIC_START("IKCFG_ST") and MAGIC_END("IKCFG_ED") are moved out
from the kernel_config_data variable.

Thus, we parse kernel_config_data directly instead of considering
offset of MAGIC_START and MAGIC_END.

Fixes: 13610aa908dc ("kernel/configs: use .incbin directive to embed config_data.gz")
Signed-off-by: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/gdb/linux/config.py | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/gdb/linux/config.py b/scripts/gdb/linux/config.py
index 90e1565b1967..8843ab3cbadd 100644
--- a/scripts/gdb/linux/config.py
+++ b/scripts/gdb/linux/config.py
@@ -24,9 +24,9 @@ class LxConfigDump(gdb.Command):
             filename = arg
 
         try:
-            py_config_ptr = gdb.parse_and_eval("kernel_config_data + 8")
-            py_config_size = gdb.parse_and_eval(
-                    "sizeof(kernel_config_data) - 1 - 8 * 2")
+            py_config_ptr = gdb.parse_and_eval("&kernel_config_data")
+            py_config_ptr_end = gdb.parse_and_eval("&kernel_config_data_end")
+            py_config_size = py_config_ptr_end - py_config_ptr
         except gdb.error as e:
             raise gdb.GdbError("Can't find config, enable CONFIG_IKCONFIG?")
 
-- 
2.35.1



