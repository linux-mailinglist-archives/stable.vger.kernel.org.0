Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1783A551BD6
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345030AbiFTN0M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346453AbiFTNYj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:24:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A32F1AD9D;
        Mon, 20 Jun 2022 06:10:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A5C3B811E6;
        Mon, 20 Jun 2022 13:09:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC8DBC3411B;
        Mon, 20 Jun 2022 13:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730586;
        bh=FRIHHuVh15uysefwcHw6kzr8sXWetG0k9h7RAVWZX90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HBxBsijeJFJV9fLF/tEB8Q/5QhqVC+p6uchc5nCOWF+QlCrfN+e9bG3LP0FAOHwTe
         PLGJMoKIyK8FUb8U9Br5HIbPgNsb+6U0CnK+jsiQW4cdHv+LJ4eW6Ks9zMR+5kr1RX
         zhTzdLo2RjdTeI/LyWn88ZAStBho6hLDjnbwNE7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Ding Xiang <dingxiang@cmss.chinamobile.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.15 100/106] ext4: make variable "count" signed
Date:   Mon, 20 Jun 2022 14:51:59 +0200
Message-Id: <20220620124727.346842923@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124724.380838401@linuxfoundation.org>
References: <20220620124724.380838401@linuxfoundation.org>
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
@@ -1929,7 +1929,8 @@ static struct ext4_dir_entry_2 *do_split
 			struct dx_hash_info *hinfo)
 {
 	unsigned blocksize = dir->i_sb->s_blocksize;
-	unsigned count, continued;
+	unsigned continued;
+	int count;
 	struct buffer_head *bh2;
 	ext4_lblk_t newblock;
 	u32 hash2;


