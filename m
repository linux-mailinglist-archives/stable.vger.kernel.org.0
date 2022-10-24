Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 120C660A3D1
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232403AbiJXMAc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232670AbiJXL7c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 07:59:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C08787C1B6;
        Mon, 24 Oct 2022 04:48:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBC336122D;
        Mon, 24 Oct 2022 11:48:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7B2AC433D6;
        Mon, 24 Oct 2022 11:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612099;
        bh=UMm37vhx2Pm1xPMwjWbO6ZLH1cF6XvpSLwvokmNXpfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=it0mRzUAeDhB6etket/FKuDDKgt42F7aX4gP7X9WWiHmhfLVklRCxQYY4gL7HAkQt
         spl5b6/Gk8n5YuGzTEBVmoQKX3NarpehHfrk9rPnPpkCuEyjMk0fLuXLQiyUtnwQq6
         xcyLPwBhZDc2FUItJvlcaiJTyIUV5A0Qn6/5m1/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        syzbot+fbb3e0b24e8dae5a16ee@syzkaller.appspotmail.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4.14 038/210] nilfs2: replace WARN_ONs by nilfs_error for checkpoint acquisition failure
Date:   Mon, 24 Oct 2022 13:29:15 +0200
Message-Id: <20221024112958.222143094@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -890,9 +890,11 @@ static int nilfs_segctor_create_checkpoi
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
 
@@ -906,7 +908,11 @@ static int nilfs_segctor_fill_in_checkpo
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


