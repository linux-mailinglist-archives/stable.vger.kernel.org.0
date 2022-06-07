Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E162541D6C
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378603AbiFGWO0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353209AbiFGWM4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:12:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C465F25D5E3;
        Tue,  7 Jun 2022 12:19:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E7B661929;
        Tue,  7 Jun 2022 19:19:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E182C385A2;
        Tue,  7 Jun 2022 19:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629576;
        bh=I/AxesGm+UuH/LfTjxhIW+yj0CyrQKwGuT/W633gWPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wbqViWYb9tLy7QAPvZbPu1Z175C0NLltnVvD89gvduqiLLoWBuUMWhPfb/in3MQnL
         OGp/MdXOk3Ecm6x7gqZcxXVvkzWDrpnjHTgPklNTVmkZ8UP2AHqA+wZ32RvQgwO/Fd
         hfXXjwHUo9u3f8smBwZTAb7brqY2ckHMAnGITAJU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Ritesh Harjani <ritesh.list@gmail.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.18 741/879] ext4: fix memory leak in parse_apply_sb_mount_options()
Date:   Tue,  7 Jun 2022 19:04:19 +0200
Message-Id: <20220607165024.366221861@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@google.com>

commit c069db76ed7b681c69159f44be96d2137e9ca989 upstream.

If processing the on-disk mount options fails after any memory was
allocated in the ext4_fs_context, e.g. s_qf_names, then this memory is
leaked.  Fix this by calling ext4_fc_free() instead of kfree() directly.

Reproducer:

    mkfs.ext4 -F /dev/vdc
    tune2fs /dev/vdc -E mount_opts=usrjquota=file
    echo clear > /sys/kernel/debug/kmemleak
    mount /dev/vdc /vdc
    echo scan > /sys/kernel/debug/kmemleak
    sleep 5
    echo scan > /sys/kernel/debug/kmemleak
    cat /sys/kernel/debug/kmemleak

Fixes: 7edfd85b1ffd ("ext4: Completely separate options parsing and sb setup")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Tested-by: Ritesh Harjani <ritesh.list@gmail.com>
Link: https://lore.kernel.org/r/20220513231605.175121-2-ebiggers@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2626,8 +2626,10 @@ parse_failed:
 	ret = ext4_apply_options(fc, sb);
 
 out_free:
-	kfree(s_ctx);
-	kfree(fc);
+	if (fc) {
+		ext4_fc_free(fc);
+		kfree(fc);
+	}
 	kfree(s_mount_opts);
 	return ret;
 }


