Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABFCB50541C
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240968AbiDRNEM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241735AbiDRND0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:03:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5090028E24;
        Mon, 18 Apr 2022 05:44:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01E56B80E4E;
        Mon, 18 Apr 2022 12:44:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F23FC385A7;
        Mon, 18 Apr 2022 12:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285848;
        bh=W8Qgew+xVsT4zAeS8SnOsUkxaVYgAcTrbSpslSyck9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wn+PJ0Kl+ANRs63R0wiqn5d/r6eAZewk+q+NfRkKD50wZqzos+XWJLSikT2tWJZ85
         2iAJe40i/CkTfgDLHameIRChcfTZAHnAamOSNHFe9UajT0xUdwgxfNxxKUVx6N3I3d
         nkFsj+jzj92go77YnVFj6CaUWs7Uly1kWflQTJoQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 44/63] btrfs: mark resumed async balance as writing
Date:   Mon, 18 Apr 2022 14:13:41 +0200
Message-Id: <20220418121137.174176151@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121134.149115109@linuxfoundation.org>
References: <20220418121134.149115109@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naohiro Aota <naohiro.aota@wdc.com>

commit a690e5f2db4d1dca742ce734aaff9f3112d63764 upstream.

When btrfs balance is interrupted with umount, the background balance
resumes on the next mount. There is a potential deadlock with FS freezing
here like as described in commit 26559780b953 ("btrfs: zoned: mark
relocation as writing"). Mark the process as sb_writing to avoid it.

Reviewed-by: Filipe Manana <fdmanana@suse.com>
CC: stable@vger.kernel.org # 4.9+
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/volumes.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4320,10 +4320,12 @@ static int balance_kthread(void *data)
 	struct btrfs_fs_info *fs_info = data;
 	int ret = 0;
 
+	sb_start_write(fs_info->sb);
 	mutex_lock(&fs_info->balance_mutex);
 	if (fs_info->balance_ctl)
 		ret = btrfs_balance(fs_info, fs_info->balance_ctl, NULL);
 	mutex_unlock(&fs_info->balance_mutex);
+	sb_end_write(fs_info->sb);
 
 	return ret;
 }


