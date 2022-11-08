Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C61B6214E4
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235084AbiKHOGL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:06:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235072AbiKHOGI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:06:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1E4E70548
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:06:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D75560025
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:06:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57DB1C433C1;
        Tue,  8 Nov 2022 14:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916366;
        bh=ZCg15C5V/EsyDptHy/1mzEKrJ/OKpxRTZ73ERj4aWpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kXQZ68SkVCG11FExn4Keo7VE9Cy2PhPBdoNvotmVYz0XudEUtmqVDVH7owbC4HxM/
         EAXh721hD8xjeJ4tUWodR3feFCkWOUbvnvvM0fa3UT5zG/etKf0qa0O/lRIjFxACTI
         JKFGfnpuoFg1dv8pxSTDltspaJtjS4XN4Pa9CYZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.15 113/144] fuse: add file_modified() to fallocate
Date:   Tue,  8 Nov 2022 14:39:50 +0100
Message-Id: <20221108133350.081314621@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit 4a6f278d4827b59ba26ceae0ff4529ee826aa258 upstream.

Add missing file_modified() call to fuse_file_fallocate().  Without this
fallocate on fuse failed to clear privileges.

Fixes: 05ba1f082300 ("fuse: add FALLOCATE operation")
Cc: <stable@vger.kernel.org>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/file.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2975,6 +2975,10 @@ static long fuse_file_fallocate(struct f
 			goto out;
 	}
 
+	err = file_modified(file);
+	if (err)
+		goto out;
+
 	if (!(mode & FALLOC_FL_KEEP_SIZE))
 		set_bit(FUSE_I_SIZE_UNSTABLE, &fi->state);
 


