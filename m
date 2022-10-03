Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 469855F2ABB
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231833AbiJCHkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232114AbiJCHjM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:39:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B196D4AD4B;
        Mon,  3 Oct 2022 00:23:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD20660F82;
        Mon,  3 Oct 2022 07:23:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1951C433D6;
        Mon,  3 Oct 2022 07:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781833;
        bh=GMND+JiP6FfH47il0s75PdswpseBf98pFHTC8n6weQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YiDvTgcAl4a3jQysI6EVYjB0a6mJOpo9Jn0OEFt7GTU0TzDLOaKsJ+OQUy/FbCVvx
         DJY5lDkt/07tClRIsYYIiMvAOJrvZrzbE9pkfSsBnLy24zy80XwVqDm2aom6mXxLij
         gQGUXmpuBqMttzEuCTSK67WbUWVKY2hieleqG3IA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marcin Wojtas <mw@semihalf.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, stable@kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 08/30] Revert "net: mvpp2: debugfs: fix memory leak when using debugfs_lookup()"
Date:   Mon,  3 Oct 2022 09:11:50 +0200
Message-Id: <20221003070716.514054987@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070716.269502440@linuxfoundation.org>
References: <20221003070716.269502440@linuxfoundation.org>
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

From: Sasha Levin <sashal@kernel.org>

commit 6052a4c11fd893234e085edf7bf2e00a33a79d4e upstream.

This reverts commit fe2c9c61f668cde28dac2b188028c5299cedcc1e.

On Tue, Sep 13, 2022 at 05:48:58PM +0100, Russell King (Oracle) wrote:
>What happens if this is built as a module, and the module is loaded,
>binds (and creates the directory), then is removed, and then re-
>inserted?  Nothing removes the old directory, so doesn't
>debugfs_create_dir() fail, resulting in subsequent failure to add
>any subsequent debugfs entries?
>
>I don't think this patch should be backported to stable trees until
>this point is addressed.

Revert until a proper fix is available as the original behavior was
better.

Cc: Marcin Wojtas <mw@semihalf.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: stable@kernel.org
Reported-by: Russell King <linux@armlinux.org.uk>
Fixes: fe2c9c61f668 ("net: mvpp2: debugfs: fix memory leak when using debugfs_lookup()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lore.kernel.org/r/20220923234736.657413-1-sashal@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c
@@ -700,10 +700,10 @@ void mvpp2_dbgfs_cleanup(struct mvpp2 *p
 
 void mvpp2_dbgfs_init(struct mvpp2 *priv, const char *name)
 {
-	static struct dentry *mvpp2_root;
-	struct dentry *mvpp2_dir;
+	struct dentry *mvpp2_dir, *mvpp2_root;
 	int ret, i;
 
+	mvpp2_root = debugfs_lookup(MVPP2_DRIVER_NAME, NULL);
 	if (!mvpp2_root)
 		mvpp2_root = debugfs_create_dir(MVPP2_DRIVER_NAME, NULL);
 


