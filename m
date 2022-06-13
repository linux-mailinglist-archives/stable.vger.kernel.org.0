Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5414548BA8
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380758AbiFMN73 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380468AbiFMN67 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:58:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07DE744A39;
        Mon, 13 Jun 2022 04:37:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24B3A612E9;
        Mon, 13 Jun 2022 11:37:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E4F7C3411E;
        Mon, 13 Jun 2022 11:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120262;
        bh=k+/pVrIT8QfqIWbATLK3wlWEq5hh0GwRx7H7a3D01Zw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pt7/PxBJ8vIghaHcInJoBRCWyUDHy0C4r2dPPVF5WyC5bpMXES32tNN4B4X4Ccbk4
         Rdo9q/671imw2wwFhMU2P5hnJn/R3BGcRvE385sxvhl2d0L6LKtLrilQb66NvekXWx
         q9a7a9q9aLNddDRJOdbOeXjqDB1oOhSItFmDHpJU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 290/339] scripts/gdb: change kernel config dumping method
Date:   Mon, 13 Jun 2022 12:11:55 +0200
Message-Id: <20220613094935.433054160@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
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



