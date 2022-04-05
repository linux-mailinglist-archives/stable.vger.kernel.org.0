Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 567EB4F31F4
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347303AbiDEKKN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346785AbiDEJYm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:24:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73E6C939C9;
        Tue,  5 Apr 2022 02:14:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0B4FB81C6A;
        Tue,  5 Apr 2022 09:13:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EED13C385A0;
        Tue,  5 Apr 2022 09:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150033;
        bh=Sa1kMv1sdCnfZFoBz5fJjwVY0FENvkmbuFF3lGAys4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rR2vOWusEU25Dawl6iF844zOiJr37U8Ic8m9IB+JscoSKqxkdh+LKa5vbUl7G3/gj
         8j75GjOPBFzPT7b/SzSV99SC5f1iRC7ier/U0oXc7bhAWcy9fM7JthqLn61XtP9BDE
         UrmPZ5kFJL6+oC5EelRz8eVAekh3K7/3Q5WxtKYQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 5.16 0931/1017] gfs2: Fix gfs2_file_buffered_write endless loop workaround
Date:   Tue,  5 Apr 2022 09:30:44 +0200
Message-Id: <20220405070421.850675722@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

commit 46f3e0421ccb5474b5c006b0089b9dfd42534bb6 upstream.

Since commit 554c577cee95b, gfs2_file_buffered_write() can accidentally
return a truncated iov_iter, which might confuse callers.  Fix that.

Fixes: 554c577cee95b ("gfs2: Prevent endless loops in gfs2_file_buffered_write")
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/gfs2/file.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -1083,6 +1083,7 @@ out_uninit:
 	gfs2_holder_uninit(gh);
 	if (statfs_gh)
 		kfree(statfs_gh);
+	from->count = orig_count - read;
 	return read ? read : ret;
 }
 


