Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF5CE54083B
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348797AbiFGR43 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348993AbiFGRzU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:55:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6D0E1455AC;
        Tue,  7 Jun 2022 10:39:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 892D161534;
        Tue,  7 Jun 2022 17:39:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99DF9C385A5;
        Tue,  7 Jun 2022 17:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623599;
        bh=CDdGFTqDcjOgUxt3mRGxFG+Aw9GKRvDcRCv+eL0Xggs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ENYKz1QogbJdFGiJg4pEIasQc2x+HIhrpOPIwyc58VhgxGbn60K+nAAmVvw5u+ZAu
         XObOZ1eUQsh2ir2juUGH3E/O3ampudUMz7b/iuwX8yMsqTs+ePWKYFUS+S0pPA4+59
         t8JuQI+z88uaMsdEEzJlztvnze6O2rWRQB4BCC2k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kari Argillander <kari.argillander@gmail.com>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 5.15 023/667] fs/ntfs3: Check new size for limits
Date:   Tue,  7 Jun 2022 18:54:48 +0200
Message-Id: <20220607164935.491753269@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

commit 114346978cf61de02832cc3cc68432a3de70fb38 upstream.

We must check size before trying to allocate.
Size can be set for example by "ulimit -f".
Fixes xfstest generic/228
Fixes: 4342306f0f0d ("fs/ntfs3: Add file operations and implementation")

Reviewed-by: Kari Argillander <kari.argillander@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/file.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -661,7 +661,13 @@ static long ntfs_fallocate(struct file *
 		/*
 		 * Normal file: Allocate clusters, do not change 'valid' size.
 		 */
-		err = ntfs_set_size(inode, max(end, i_size));
+		loff_t new_size = max(end, i_size);
+
+		err = inode_newsize_ok(inode, new_size);
+		if (err)
+			goto out;
+
+		err = ntfs_set_size(inode, new_size);
 		if (err)
 			goto out;
 


