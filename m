Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A49C055CE9C
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238666AbiF0LwS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238404AbiF0LvA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:51:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C6EF2655;
        Mon, 27 Jun 2022 04:44:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F371361192;
        Mon, 27 Jun 2022 11:44:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01D9CC341C7;
        Mon, 27 Jun 2022 11:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330242;
        bh=8GWOuV/TkliZCMmfzY6sCs4GDqU6Wk0+fQ/NyL1eARQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2rDT4BlBKgwLICsQGpEyX8h1WFzEbEkbyeAr5B9q3g+rW8ZpJ9Gqa/gCC85u1wIhC
         FiwB3k/L9szmYa/8mC9i9QAtqxjedZPz6UcljLZi9W0JafOyXQT0UaPez3udqoRTq3
         0+7+2M5FErn9ITWl/Ar4sJY9MxyGYsBJHrdVE1xE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.18 129/181] f2fs: do not count ENOENT for error case
Date:   Mon, 27 Jun 2022 13:21:42 +0200
Message-Id: <20220627111948.431830642@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@kernel.org>

commit 82c7863ed95d0914f02c7c8c011200a763bc6725 upstream.

Otherwise, we can get a wrong cp_error mark.

Cc: <stable@vger.kernel.org>
Fixes: a7b8618aa2f0 ("f2fs: avoid infinite loop to flush node pages")
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/node.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1454,7 +1454,9 @@ page_hit:
 out_err:
 	ClearPageUptodate(page);
 out_put_err:
-	f2fs_handle_page_eio(sbi, page->index, NODE);
+	/* ENOENT comes from read_node_page which is not an error. */
+	if (err != -ENOENT)
+		f2fs_handle_page_eio(sbi, page->index, NODE);
 	f2fs_put_page(page, 1);
 	return ERR_PTR(err);
 }


