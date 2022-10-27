Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7177160FE2F
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236870AbiJ0RC5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236869AbiJ0RC4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:02:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0218219046F
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:02:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF7DDB82716
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:02:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D426C433D7;
        Thu, 27 Oct 2022 17:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890172;
        bh=Xn75xEIOAju8zbTqT/LrTBiXrn1l6X2RK9VC5/E9egk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rro+06hcrZK9a5/MHUGBzPPUOKtWjC0O90JV5HtDoQ8Y2XT+1sog7NUAWQukwU0qw
         3P591cedYUK9YRJZFRvX+dQLrS6TUEAhcYIvpCY3r2veaaCrPhJGq96ZZedySfZGyc
         z4l+RgL0nt+tk8inTwRbHyorvybvFtaXRd5wINtI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 49/79] cifs: Fix xid leak in cifs_ses_add_channel()
Date:   Thu, 27 Oct 2022 18:55:47 +0200
Message-Id: <20221027165056.537401449@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.917467648@linuxfoundation.org>
References: <20221027165054.917467648@linuxfoundation.org>
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
index 5500ea783784..0fbd0f78f361 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -320,6 +320,7 @@ cifs_ses_add_channel(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses,
 	if (rc && chan->server)
 		cifs_put_tcp_session(chan->server, 0);
 
+	free_xid(xid);
 	return rc;
 }
 
-- 
2.35.1



