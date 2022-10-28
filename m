Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B43C611086
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 14:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbiJ1MG1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 08:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbiJ1MG0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 08:06:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8DA99E6A1
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 05:06:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 462CE62808
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 12:06:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AA3AC433C1;
        Fri, 28 Oct 2022 12:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666958783;
        bh=sW9IKrI9NVPD7ZPVxRBZWKXPK7U4cAFlLCbg7fXjIrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mFv9891aKVzkTqPvzTTnDX5/vDr31Ko5ing/Upe9FYQbO2LIKQ2FTZWrO8dvpXN67
         1lHrof9ZwkcWPZX0qkDY5yOIReRdFI+7tTryNc93I57XUl4TzfCH1uXNZJMxBZPYnZ
         +jfOeLpZLWyXI5a6xTqXMjZNF0UQ/fxDWJEEpD74=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 33/73] cifs: Fix xid leak in cifs_ses_add_channel()
Date:   Fri, 28 Oct 2022 14:03:30 +0200
Message-Id: <20221028120233.812850198@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221028120232.344548477@linuxfoundation.org>
References: <20221028120232.344548477@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>

[ Upstream commit e909d054bdea75ef1ec48c18c5936affdaecbb2c ]

Before return, should free the xid, otherwise, the
xid will be leaked.

Fixes: d70e9fa55884 ("cifs: try opening channels after mounting")
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/sess.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index d58c5ffeca0d..cf6fd138d8d5 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -306,6 +306,7 @@ cifs_ses_add_channel(struct cifs_ses *ses, struct cifs_server_iface *iface)
 		cifs_put_tcp_session(chan->server, 0);
 	unload_nls(vol.local_nls);
 
+	free_xid(xid);
 	return rc;
 }
 
-- 
2.35.1



