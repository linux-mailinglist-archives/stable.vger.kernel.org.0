Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A54C5FE080
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 20:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbiJMSKy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 14:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231476AbiJMSKM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 14:10:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECBAC9DDBC;
        Thu, 13 Oct 2022 11:07:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B22661A33;
        Thu, 13 Oct 2022 18:01:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44103C433D6;
        Thu, 13 Oct 2022 18:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665684118;
        bh=T5hUlJubGs9iN1Cr22GehC2ffTzgTKc0wkupXsH0j3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=olOTxqoRN6lLR20A+z7lFF36e9GdfYYhtgF1xCiJfSPZffOBI6mwZyErODhUbIizR
         JqfYOstJ1r9au824fbwDqrLvCkoQr7ehC8SEAOd/zYBedhfQrmJQ3OMsVH5P9IwAtF
         5c6QuO4s1dT0578S4GWMjeb/qySdFnIyM19Icme4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        syzbot+fbb3e0b24e8dae5a16ee@syzkaller.appspotmail.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.0 04/34] nilfs2: replace WARN_ONs by nilfs_error for checkpoint acquisition failure
Date:   Thu, 13 Oct 2022 19:52:42 +0200
Message-Id: <20221013175146.634269087@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221013175146.507746257@linuxfoundation.org>
References: <20221013175146.507746257@linuxfoundation.org>
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

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

commit 723ac751208f6d6540191689cfbf6c77135a7a1b upstream.

If creation or finalization of a checkpoint fails due to anomalies in the
checkpoint metadata on disk, a kernel warning is generated.

This patch replaces the WARN_ONs by nilfs_error, so that a kernel, booted
with panic_on_warn, does not panic.  A nilfs_error is appropriate here to
handle the abnormal filesystem condition.

This also replaces the detected error codes with an I/O error so that
neither of the internal error codes is returned to callers.

Link: https://lkml.kernel.org/r/20220929123330.19658-1-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+fbb3e0b24e8dae5a16ee@syzkaller.appspotmail.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/segment.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -875,9 +875,11 @@ static int nilfs_segctor_create_checkpoi
 		nilfs_mdt_mark_dirty(nilfs->ns_cpfile);
 		nilfs_cpfile_put_checkpoint(
 			nilfs->ns_cpfile, nilfs->ns_cno, bh_cp);
-	} else
-		WARN_ON(err == -EINVAL || err == -ENOENT);
-
+	} else if (err == -EINVAL || err == -ENOENT) {
+		nilfs_error(sci->sc_super,
+			    "checkpoint creation failed due to metadata corruption.");
+		err = -EIO;
+	}
 	return err;
 }
 
@@ -891,7 +893,11 @@ static int nilfs_segctor_fill_in_checkpo
 	err = nilfs_cpfile_get_checkpoint(nilfs->ns_cpfile, nilfs->ns_cno, 0,
 					  &raw_cp, &bh_cp);
 	if (unlikely(err)) {
-		WARN_ON(err == -EINVAL || err == -ENOENT);
+		if (err == -EINVAL || err == -ENOENT) {
+			nilfs_error(sci->sc_super,
+				    "checkpoint finalization failed due to metadata corruption.");
+			err = -EIO;
+		}
 		goto failed_ibh;
 	}
 	raw_cp->cp_snapshot_list.ssl_next = 0;


