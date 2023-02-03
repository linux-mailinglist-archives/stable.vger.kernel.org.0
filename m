Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F362D689555
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232049AbjBCKSe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:18:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233278AbjBCKSI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:18:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D30D59D072
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:17:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83661B82A6B
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:17:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA1A5C4339B;
        Fri,  3 Feb 2023 10:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419472;
        bh=G/su3jtvzH9r0NThXvyHeCffHzpTOyo5BMuGrBz7T14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G4MleX5pO4T+oHF5JBL5hkSuLDFeLNUn57j6NsLcQ0vMl+Odc9IQdKxFlt3/f+85b
         /KhUpXGN0str83oTzNUqp48cfoEwhMJ5S81VyvOg/bHCJikFirTA+hxXRu48XRbMUz
         DfH7MlzAR0PX5Hpe9tf+ye3xLrTxXXDQe+yGzw9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Biggers <ebiggers@kernel.org>,
        Alexander Potapenko <glider@google.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 09/80] affs: initialize fsdata in affs_truncate()
Date:   Fri,  3 Feb 2023 11:12:03 +0100
Message-Id: <20230203101015.645939901@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101015.263854890@linuxfoundation.org>
References: <20230203101015.263854890@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Potapenko <glider@google.com>

[ Upstream commit eef034ac6690118c88f357b00e2b3239c9d8575d ]

When aops->write_begin() does not initialize fsdata, KMSAN may report
an error passing the latter to aops->write_end().

Fix this by unconditionally initializing fsdata.

Fixes: f2b6a16eb8f5 ("fs: affs convert to new aops")
Suggested-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Alexander Potapenko <glider@google.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/affs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/affs/file.c b/fs/affs/file.c
index ba084b0b214b..82bb38370aa9 100644
--- a/fs/affs/file.c
+++ b/fs/affs/file.c
@@ -878,7 +878,7 @@ affs_truncate(struct inode *inode)
 	if (inode->i_size > AFFS_I(inode)->mmu_private) {
 		struct address_space *mapping = inode->i_mapping;
 		struct page *page;
-		void *fsdata;
+		void *fsdata = NULL;
 		loff_t isize = inode->i_size;
 		int res;
 
-- 
2.39.0



