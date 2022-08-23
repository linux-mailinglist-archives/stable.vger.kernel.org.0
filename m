Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94DAA59D59F
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346716AbiHWImf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:42:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347604AbiHWIlA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:41:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E9B15F234;
        Tue, 23 Aug 2022 01:19:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2930661360;
        Tue, 23 Aug 2022 08:17:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D8A3C433D6;
        Tue, 23 Aug 2022 08:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242670;
        bh=Rb8RqMWonuLosEt81hl+n3DDIYofEdVxfe5kXGS+gVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OYT7Djebl8/ySjAl7YMKNXWh7UvmaPlL4DVuK55d6HLL2Ft9obw55m+mIXkLuxCvC
         6QDWkqD9WAqaZv92EaQjmw5OTCVfO1fcKgjKvIRm+SG9L8VuO0yqI/n0+CIhBO+Eq8
         zj39QPTEOxgF+UWfdo2THaCevitfzhsbGB6YZCbg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yan Lei <chinayanlei2002@163.com>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 5.19 160/365] fs/ntfs3: Fix using uninitialized value n when calling indx_read
Date:   Tue, 23 Aug 2022 10:01:01 +0200
Message-Id: <20220823080124.909853406@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yan Lei <chinayanlei2002@163.com>

commit ae5a4e46916fc307288227b64c1d062352eb93b7 upstream.

This value is checked in indx_read, so it must be initialized
Fixes: 82cae269cfa9 ("fs/ntfs3: Add initialization of super block")

Signed-off-by: Yan Lei <chinayanlei2002@163.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/index.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ntfs3/index.c
+++ b/fs/ntfs3/index.c
@@ -1994,7 +1994,7 @@ static int indx_free_children(struct ntf
 			      const struct NTFS_DE *e, bool trim)
 {
 	int err;
-	struct indx_node *n;
+	struct indx_node *n = NULL;
 	struct INDEX_HDR *hdr;
 	CLST vbn = de_get_vbn(e);
 	size_t i;


