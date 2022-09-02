Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA5A5AB44F
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 16:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236202AbiIBOxC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 10:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236358AbiIBOwo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 10:52:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40A6E11BE23;
        Fri,  2 Sep 2022 07:16:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C90C621FA;
        Fri,  2 Sep 2022 12:36:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DA85C433D7;
        Fri,  2 Sep 2022 12:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662122160;
        bh=nGHRekiHJDUXn0sZHOOVP80X+BUueqVNywIyYa9X1NQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ff+JFKYOJ5Zbs+GHFF2G9bzwYh0M/ClJI6Vet5AOBYqVKX7dPVizJk1I3yrryQazG
         DRdJwtw+ac+V84OgIyzcb0hrO35pAq5KAAcbLzkuZqlW3elS/mXNT3ORzNOmGERDX+
         tml3vXge8xeZG/ipbX+JvDxwcltVSq9hDyNo289k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 32/72] fs/ntfs3: Fix work with fragmented xattr
Date:   Fri,  2 Sep 2022 14:19:08 +0200
Message-Id: <20220902121405.845761902@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.772492078@linuxfoundation.org>
References: <20220902121404.772492078@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 42f86b1226a42bfc79a7125af435432ad4680a32 ]

In some cases xattr is too fragmented,
so we need to load it before writing.

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/xattr.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/xattr.c b/fs/ntfs3/xattr.c
index 3629049decac1..e3d443ccb9be6 100644
--- a/fs/ntfs3/xattr.c
+++ b/fs/ntfs3/xattr.c
@@ -118,7 +118,7 @@ static int ntfs_read_ea(struct ntfs_inode *ni, struct EA_FULL **ea,
 
 		run_init(&run);
 
-		err = attr_load_runs(attr_ea, ni, &run, NULL);
+		err = attr_load_runs_range(ni, ATTR_EA, NULL, 0, &run, 0, size);
 		if (!err)
 			err = ntfs_read_run_nb(sbi, &run, 0, ea_p, size, NULL);
 		run_close(&run);
@@ -444,6 +444,11 @@ static noinline int ntfs_set_ea(struct inode *inode, const char *name,
 		/* Delete xattr, ATTR_EA */
 		ni_remove_attr_le(ni, attr, mi, le);
 	} else if (attr->non_res) {
+		err = attr_load_runs_range(ni, ATTR_EA, NULL, 0, &ea_run, 0,
+					   size);
+		if (err)
+			goto out;
+
 		err = ntfs_sb_write_run(sbi, &ea_run, 0, ea_all, size, 0);
 		if (err)
 			goto out;
-- 
2.35.1



