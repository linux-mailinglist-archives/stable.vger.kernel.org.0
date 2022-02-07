Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFA044ABDBA
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 13:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389056AbiBGLp6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:45:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386748AbiBGLgb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:36:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 026E9C043181;
        Mon,  7 Feb 2022 03:36:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8208A60A69;
        Mon,  7 Feb 2022 11:36:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4948FC004E1;
        Mon,  7 Feb 2022 11:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233790;
        bh=rrCuu477wj4X6lM0wC9UJqAp+SzH0iPa855DMsGM5eA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vG77KdU+pylEYjlWOPzMxMSbX14SwUoD5v7P5xZOLe/pWjKIHyCcXzjAAtITeRoGa
         X0c2tLjZ5MMEwWj8YHKKaWxNMZ3afwq8huyP6jLe8oPlxvEAhVrbNbVCsdujIvcBFd
         JI8OoSDS2Nk9KLPb+KutkijQ+6D6AWYBsA/AYKKA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        stable@kernel.org, Xin Yin <yinxin.x@bytedance.com>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.16 119/126] ext4: fix incorrect type issue during replay_del_range
Date:   Mon,  7 Feb 2022 12:07:30 +0100
Message-Id: <20220207103808.170434877@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103804.053675072@linuxfoundation.org>
References: <20220207103804.053675072@linuxfoundation.org>
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

From: Xin Yin <yinxin.x@bytedance.com>

commit 8fca8a2b0a822f7936130af7299d2fd7f0a66714 upstream.

should not use fast commit log data directly, add le32_to_cpu().

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 0b5b5a62b945 ("ext4: use ext4_ext_remove_space() for fast commit replay delete range")
Cc: stable@kernel.org
Signed-off-by: Xin Yin <yinxin.x@bytedance.com>
Reviewed-by: Ritesh Harjani <riteshh@linux.ibm.com>
Link: https://lore.kernel.org/r/20220126063146.2302-1-yinxin.x@bytedance.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/fast_commit.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -1819,8 +1819,9 @@ ext4_fc_replay_del_range(struct super_bl
 	}
 
 	down_write(&EXT4_I(inode)->i_data_sem);
-	ret = ext4_ext_remove_space(inode, lrange.fc_lblk,
-				lrange.fc_lblk + lrange.fc_len - 1);
+	ret = ext4_ext_remove_space(inode, le32_to_cpu(lrange.fc_lblk),
+				le32_to_cpu(lrange.fc_lblk) +
+				le32_to_cpu(lrange.fc_len) - 1);
 	up_write(&EXT4_I(inode)->i_data_sem);
 	if (ret)
 		goto out;


