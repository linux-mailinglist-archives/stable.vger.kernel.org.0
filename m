Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6AA866C877
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233535AbjAPQje (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:39:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233487AbjAPQjM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:39:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F069C2BF30
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:27:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F84461062
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:27:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79964C433D2;
        Mon, 16 Jan 2023 16:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886467;
        bh=zp5V+hBPDE1ddKmb/PSiM2t6XqB8A6P5AfH003LQ1jA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IkDscaHJvDEv4JT9+Prra7NFFVFJdIUH2umOoWQ8K8FFKANHM+EE4NtStrZ1ny/nd
         Z69dw+bZz+qOBi6pO0WwVmvC4vImhtULbr7ftcd8cFNUHq9b9EAtulY2/GP+HCnIJx
         p2F6YSYfH1y4PPVhcgDjcn8DXrtC4fum55+IIPgs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wei Wang <wvw@google.com>,
        Midas Chien <midaschieh@google.com>,
        Connor OBrien <connoro@google.com>,
        Kees Cook <keescook@chromium.org>,
        Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>,
        kernel test robot <lkp@intel.com>, kernel-team@android.com,
        John Stultz <jstultz@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 441/658] pstore: Make sure CONFIG_PSTORE_PMSG selects CONFIG_RT_MUTEXES
Date:   Mon, 16 Jan 2023 16:48:49 +0100
Message-Id: <20230116154929.706776420@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Stultz <jstultz@google.com>

[ Upstream commit 2f4fec5943407318b9523f01ce1f5d668c028332 ]

In commit 76d62f24db07 ("pstore: Switch pmsg_lock to an rt_mutex
to avoid priority inversion") I changed a lock to an rt_mutex.

However, its possible that CONFIG_RT_MUTEXES is not enabled,
which then results in a build failure, as the 0day bot detected:
  https://lore.kernel.org/linux-mm/202212211244.TwzWZD3H-lkp@intel.com/

Thus this patch changes CONFIG_PSTORE_PMSG to select
CONFIG_RT_MUTEXES, which ensures the build will not fail.

Cc: Wei Wang <wvw@google.com>
Cc: Midas Chien<midaschieh@google.com>
Cc: Connor O'Brien <connoro@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Anton Vorontsov <anton@enomsg.org>
Cc: Colin Cross <ccross@android.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: kernel test robot <lkp@intel.com>
Cc: kernel-team@android.com
Fixes: 76d62f24db07 ("pstore: Switch pmsg_lock to an rt_mutex to avoid priority inversion")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: John Stultz <jstultz@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20221221051855.15761-1-jstultz@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pstore/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/pstore/Kconfig b/fs/pstore/Kconfig
index 8f0369aad22a..9fe46cc26403 100644
--- a/fs/pstore/Kconfig
+++ b/fs/pstore/Kconfig
@@ -118,6 +118,7 @@ config PSTORE_CONSOLE
 config PSTORE_PMSG
 	bool "Log user space messages"
 	depends on PSTORE
+	select RT_MUTEXES
 	help
 	  When the option is enabled, pstore will export a character
 	  interface /dev/pmsg0 to log user space messages. On reboot
-- 
2.35.1



