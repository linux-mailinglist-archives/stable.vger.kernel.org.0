Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC2244FCFA3
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349335AbiDLGgy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349108AbiDLGgI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:36:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4B7035DE2;
        Mon, 11 Apr 2022 23:33:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44671618DC;
        Tue, 12 Apr 2022 06:33:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54C65C385A6;
        Tue, 12 Apr 2022 06:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745216;
        bh=b4QnvRsKEKn1wn//dgDzAOcbGkrbaHGztOICLGZamFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tx3mrBSqj8/45chf7Rv6ItPE93TkMrI0Ha3lMhPVjqqgXFRW/6xT5JFTJs6tNFyJg
         htv6H1hVQcCzq4Z2+k+YqpeHsnGghJOEJcBfu7HwcJHZm0tw2oHy5ujUuiRwbcVc1I
         Sy7K6gqzwbeohJErDJXJ8W+cFqcEk8/L+oMA5Xek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 002/171] gfs2: Check for active reservation in gfs2_release
Date:   Tue, 12 Apr 2022 08:28:13 +0200
Message-Id: <20220412062927.946485133@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062927.870347203@linuxfoundation.org>
References: <20220412062927.870347203@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 0ec9b9ea4f83303bfd8f052a3d8b2bd179b002e1 ]

In gfs2_release, check if the inode has an active reservation to avoid
unnecessary lock taking.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index cfd9d03f604f..59318b1eaa60 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -716,10 +716,10 @@ static int gfs2_release(struct inode *inode, struct file *file)
 	kfree(file->private_data);
 	file->private_data = NULL;
 
-	if (file->f_mode & FMODE_WRITE) {
+	if (gfs2_rs_active(&ip->i_res))
 		gfs2_rs_delete(ip, &inode->i_writecount);
+	if (file->f_mode & FMODE_WRITE)
 		gfs2_qa_put(ip);
-	}
 	return 0;
 }
 
-- 
2.35.1



