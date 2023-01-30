Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C278D680FB7
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 14:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236571AbjA3N4N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 08:56:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236608AbjA3N4M (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 08:56:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D62438EBF
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 05:56:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF03B6101C
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 13:56:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE5FAC433EF;
        Mon, 30 Jan 2023 13:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675086970;
        bh=JM45I2fdT6mOTmZK1pKVbXIFfVWOizKcUivhoEtHPEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IllxO/LTrQbKV9rRFPRcxPJGNvyOlDkAUU9GDSlEol5ZHE79wvMqljvgrjfNKFdTX
         OBvyp7PQJlSWr8/xp83hCPKe+SV3Wqn+saoYgspKgt5ql1SYeXbktbg7Qw2SnflT07
         P5vpvkkCAdOSpBBcz6oJoG65GnE6+UYNFFP4RZDU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 056/313] kbuild: fix make modules error when CONFIG_DEBUG_INFO_BTF_MODULES=y
Date:   Mon, 30 Jan 2023 14:48:11 +0100
Message-Id: <20230130134339.295051171@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 74d3320f6f7cf72de88a7e8df573821f6db90239 ]

When CONFIG_DEBUG_INFO_BTF_MODULES=y, running 'make modules'
in the clean kernel tree will get the following error.

  $ grep CONFIG_DEBUG_INFO_BTF_MODULES .config
  CONFIG_DEBUG_INFO_BTF_MODULES=y
  $ make -s clean
  $ make modules
    [snip]
    AR      vmlinux.a
  ar: ./built-in.a: No such file or directory
  make: *** [Makefile:1241: vmlinux.a] Error 1

'modules' depends on 'vmlinux', but builtin objects are not built.

Define KBUILD_BUILTIN.

Fixes: f73edc8951b2 ("kbuild: unify two modpost invocations")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Makefile b/Makefile
index 770e509d4da4..0904b82905d9 100644
--- a/Makefile
+++ b/Makefile
@@ -1529,6 +1529,7 @@ endif
 # *.ko are usually independent of vmlinux, but CONFIG_DEBUG_INFOBTF_MODULES
 # is an exception.
 ifdef CONFIG_DEBUG_INFO_BTF_MODULES
+KBUILD_BUILTIN := 1
 modules: vmlinux
 endif
 
-- 
2.39.0



