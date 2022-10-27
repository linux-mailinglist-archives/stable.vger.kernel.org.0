Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8208F60FDEF
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236802AbiJ0RAk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236813AbiJ0RAh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:00:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A51669A9DE
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:00:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5ED17B82716
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:00:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84E3EC433C1;
        Thu, 27 Oct 2022 17:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890032;
        bh=Oi1jB9Jw+/DVaB0saZxYPOBsOtlsKlEB7czpAU3SAl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xJASCkJJxS7Q8ccRq6LGan8puEHct64LIxueCZ4KaGtd6POSSB5R80LyOdREkOPS4
         V320Hr+khBdx0aeob+RNiLwOyZuu4ZzLCcFQhP9i8Pv/2nADbNcUAhMQciLMRpl/uJ
         wZCZmJecCwVf4tSDk1hMl8B+yhgbnO2jjEVO/Igg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 61/94] cifs: Fix xid leak in cifs_ses_add_channel()
Date:   Thu, 27 Oct 2022 18:55:03 +0200
Message-Id: <20221027165059.637673173@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
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
index 3af3b05b6c74..11cd06aa74f0 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -496,6 +496,7 @@ cifs_ses_add_channel(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses,
 		cifs_put_tcp_session(chan->server, 0);
 	}
 
+	free_xid(xid);
 	return rc;
 }
 
-- 
2.35.1



