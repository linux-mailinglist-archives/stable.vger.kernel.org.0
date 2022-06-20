Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD72B551E1E
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 16:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350413AbiFTOCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 10:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352638AbiFTN4r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:56:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC03C36B5F;
        Mon, 20 Jun 2022 06:22:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A6BCA6128E;
        Mon, 20 Jun 2022 13:22:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B13F2C3411C;
        Mon, 20 Jun 2022 13:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655731349;
        bh=2246pl0aHmA9Na/fC+5BJYUI9FwNM43K4wCJVz02Ypk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BiS3YERNzC0n9YPD6lWnsdvPg6okxoMzWhdgCFtRAtOcXFTa/qrXiCrfdIRGTVrSr
         /iN1yNMTO4/Q3gUYL9LMBZAGZIbVSGzb081w8LflT9bQjgqrz+2QpP5pp/KpLw2d8+
         ctHItS4t0GEkqQHK4uLHv/dl1ufX2jGzus+Raoow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Ding Xiang <dingxiang@cmss.chinamobile.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.4 229/240] ext4: make variable "count" signed
Date:   Mon, 20 Jun 2022 14:52:10 +0200
Message-Id: <20220620124745.593862410@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124737.799371052@linuxfoundation.org>
References: <20220620124737.799371052@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ding Xiang <dingxiang@cmss.chinamobile.com>

commit bc75a6eb856cb1507fa907bf6c1eda91b3fef52f upstream.

Since dx_make_map() may return -EFSCORRUPTED now, so change "count" to
be a signed integer so we can correctly check for an error code returned
by dx_make_map().

Fixes: 46c116b920eb ("ext4: verify dir block before splitting it")
Cc: stable@kernel.org
Signed-off-by: Ding Xiang <dingxiang@cmss.chinamobile.com>
Link: https://lore.kernel.org/r/20220530100047.537598-1-dingxiang@cmss.chinamobile.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/namei.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1836,7 +1836,8 @@ static struct ext4_dir_entry_2 *do_split
 			struct dx_hash_info *hinfo)
 {
 	unsigned blocksize = dir->i_sb->s_blocksize;
-	unsigned count, continued;
+	unsigned continued;
+	int count;
 	struct buffer_head *bh2;
 	ext4_lblk_t newblock;
 	u32 hash2;


