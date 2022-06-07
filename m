Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDE60540849
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348738AbiFGR5f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348686AbiFGR42 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:56:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A8CE147822;
        Tue,  7 Jun 2022 10:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D2526137B;
        Tue,  7 Jun 2022 17:40:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14B43C385A5;
        Tue,  7 Jun 2022 17:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623604;
        bh=YONjxaeXJNfdjI6X1ZBJqFnOHU4P3dRFG2L57MY6MtM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K4Z4Ni/632sVWTFkDnNAd7YyyI6Y20aP1ymyrz44ol1eaOToA0oTfx1prknCw1PIy
         JqlPr/XiAEC2Yoq/oiRKnf8l5VeTTeiu1wAfxoTws10SFwOBu6JLhiDSaVn33aeWuE
         69oIjWgUylvkyx4R2y4ie4490z116caySnOhiwQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 5.15 025/667] fs/ntfs3: Fix some memory leaks in an error handling path of log_replay()
Date:   Tue,  7 Jun 2022 18:54:50 +0200
Message-Id: <20220607164935.552060945@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit e589f9b7078e1c0191613cd736f598e81d2390de upstream.

All error handling paths lead to 'out' where many resources are freed.

Do it as well here instead of a direct return, otherwise 'log', 'ra' and
'log->one_page_buf' (at least) will leak.

Fixes: b46acd6a6a62 ("fs/ntfs3: Add NTFS journal")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/fslog.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -4085,8 +4085,10 @@ process_log:
 		if (client == LFS_NO_CLIENT_LE) {
 			/* Insert "NTFS" client LogFile. */
 			client = ra->client_idx[0];
-			if (client == LFS_NO_CLIENT_LE)
-				return -EINVAL;
+			if (client == LFS_NO_CLIENT_LE) {
+				err = -EINVAL;
+				goto out;
+			}
 
 			t16 = le16_to_cpu(client);
 			cr = ca + t16;


