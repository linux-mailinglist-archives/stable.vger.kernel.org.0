Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44F5A6B411E
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:49:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbjCJNtk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:49:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbjCJNti (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:49:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DE8F856B0
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:49:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 159C46182F
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:49:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 146F3C4339B;
        Fri, 10 Mar 2023 13:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456176;
        bh=sCja9kFKxvazSSIFNujiaQJCWOT4abt5tKVj4rRGjiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e9YXKpIEDU6ALbZQiCWnEzOgpim1pZkO+GBy5FifxYAd2tcWVF8g0JNpTDLsrW3nT
         GyiGZOXefb1PGQjlszfKKYwEAMEA7Dmlnay5lvB/ZMZ4L2px5mXjofua5st16qap+3
         wCpF5Nj8I00U6+weoXZZPGNvFzLOY9ziWMQbDVBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jan Kara <jack@suse.cz>
Subject: [PATCH 4.14 107/193] udf: Truncate added extents on failed expansion
Date:   Fri, 10 Mar 2023 14:38:09 +0100
Message-Id: <20230310133714.833504019@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
References: <20230310133710.926811681@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 70bfb3a8d661d4fdc742afc061b88a7f3fc9f500 upstream.

When a file expansion failed because we didn't have enough space for
indirect extents make sure we truncate extents created so far so that we
don't leave extents beyond EOF.

CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/inode.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -521,8 +521,10 @@ static int udf_do_extend_file(struct ino
 	}
 
 	if (fake) {
-		udf_add_aext(inode, last_pos, &last_ext->extLocation,
-			     last_ext->extLength, 1);
+		err = udf_add_aext(inode, last_pos, &last_ext->extLocation,
+				   last_ext->extLength, 1);
+		if (err < 0)
+			goto out_err;
 		count++;
 	} else {
 		struct kernel_lb_addr tmploc;
@@ -556,7 +558,7 @@ static int udf_do_extend_file(struct ino
 		err = udf_add_aext(inode, last_pos, &last_ext->extLocation,
 				   last_ext->extLength, 1);
 		if (err)
-			return err;
+			goto out_err;
 		count++;
 	}
 	if (new_block_bytes) {
@@ -565,7 +567,7 @@ static int udf_do_extend_file(struct ino
 		err = udf_add_aext(inode, last_pos, &last_ext->extLocation,
 				   last_ext->extLength, 1);
 		if (err)
-			return err;
+			goto out_err;
 		count++;
 	}
 
@@ -579,6 +581,11 @@ out:
 		return -EIO;
 
 	return count;
+out_err:
+	/* Remove extents we've created so far */
+	udf_clear_extent_cache(inode);
+	udf_truncate_extents(inode);
+	return err;
 }
 
 /* Extend the final block of the file to final_block_len bytes */


