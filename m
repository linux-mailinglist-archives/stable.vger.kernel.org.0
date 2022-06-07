Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8AB54258F
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 08:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232107AbiFHBN0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 21:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1588057AbiFGXyE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 19:54:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D1E024585;
        Tue,  7 Jun 2022 12:25:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A6D69609D0;
        Tue,  7 Jun 2022 19:25:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5119C385A2;
        Tue,  7 Jun 2022 19:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629946;
        bh=i2aBAC+nkmqctlRSusmxse0DlTK5H314CzgX7Q94to0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=twn5HbOgRJlHMjdCq/w7NgQIS503LaFWIo0/9cXWN4kCz+El4Jo06DpqrAhc81bbk
         16SXKcyp+1J7fNXKDJrElp7blaLGg2zWxxaW4tRQt+rE0o8SvhL397fCNkYlbliPpV
         Uq5y5R+p5B+7XqIqh8c4Bs9HS9mTAUnqBDz05gRI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gerald Lee <sundaywind2004@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 5.18 874/879] fs/ntfs3: Fix invalid free in log_replay
Date:   Tue,  7 Jun 2022 19:06:32 +0200
Message-Id: <20220607165028.226911354@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

commit f26967b9f7a830e228bb13fb41bd516ddd9d789d upstream.

log_read_rst() returns ENOMEM error when there is not enough memory.
In this case, if info is returned without initialization,
it attempts to kfree the uninitialized info->r_page pointer. This patch
moves the memset initialization code to before log_read_rst() is called.

Reported-by: Gerald Lee <sundaywind2004@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/fslog.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -1185,8 +1185,6 @@ static int log_read_rst(struct ntfs_log
 	if (!r_page)
 		return -ENOMEM;
 
-	memset(info, 0, sizeof(struct restart_info));
-
 	/* Determine which restart area we are looking for. */
 	if (first) {
 		vbo = 0;
@@ -3791,10 +3789,11 @@ int log_replay(struct ntfs_inode *ni, bo
 	if (!log)
 		return -ENOMEM;
 
+	memset(&rst_info, 0, sizeof(struct restart_info));
+
 	log->ni = ni;
 	log->l_size = l_size;
 	log->one_page_buf = kmalloc(page_size, GFP_NOFS);
-
 	if (!log->one_page_buf) {
 		err = -ENOMEM;
 		goto out;
@@ -3842,6 +3841,7 @@ int log_replay(struct ntfs_inode *ni, bo
 	if (rst_info.vbo)
 		goto check_restart_area;
 
+	memset(&rst_info2, 0, sizeof(struct restart_info));
 	err = log_read_rst(log, l_size, false, &rst_info2);
 
 	/* Determine which restart area to use. */


