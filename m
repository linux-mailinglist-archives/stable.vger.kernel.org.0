Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5C5469CE91
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 15:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232698AbjBTOA0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 09:00:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232783AbjBTOAX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 09:00:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 773621EBCC
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:59:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6607A60E9D
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:59:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7985BC4339B;
        Mon, 20 Feb 2023 13:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901592;
        bh=RiEeSUvFkY3kOEeY2GLpWPlwhdvURfzsd7JvUKii6BE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OPip6g8WtLFEc5XO2Zn9hsuL4Qyq78E/UQnEFGhYiYGuGrIzgXwEk9WEfstM19b5g
         gbPg/SQTRIh1QmsHxIIIhd9NQIh3vxmJGHTV65OGIm98+F4xVMkqYzgBAhQNAfQ0BO
         MZ4F+7DEIX3HlnshzttjWhCo5+uMEqCN0fPJl2FI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Fedor Pchelkin <pchelkin@ispras.ru>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 077/118] revert "squashfs: harden sanity check in squashfs_read_xattr_id_table"
Date:   Mon, 20 Feb 2023 14:36:33 +0100
Message-Id: <20230220133603.507484471@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>

commit a5b21d8d791cd4db609d0bbcaa9e0c7e019888d1 upstream.

This fix was nacked by Philip, for reasons identified in the email linked
below.

Link: https://lkml.kernel.org/r/68f15d67-8945-2728-1f17-5b53a80ec52d@squashfs.org.uk
Fixes: 72e544b1b28325 ("squashfs: harden sanity check in squashfs_read_xattr_id_table")
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Fedor Pchelkin <pchelkin@ispras.ru>
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/squashfs/xattr_id.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/squashfs/xattr_id.c
+++ b/fs/squashfs/xattr_id.c
@@ -76,7 +76,7 @@ __le64 *squashfs_read_xattr_id_table(str
 	/* Sanity check values */
 
 	/* there is always at least one xattr id */
-	if (*xattr_ids <= 0)
+	if (*xattr_ids == 0)
 		return ERR_PTR(-EINVAL);
 
 	len = SQUASHFS_XATTR_BLOCK_BYTES(*xattr_ids);


