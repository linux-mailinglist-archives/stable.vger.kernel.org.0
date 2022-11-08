Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD04262137D
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234656AbiKHNuq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:50:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234661AbiKHNup (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:50:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5910C1BEA4
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:50:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18B3EB81AF7
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:50:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 231F4C433D6;
        Tue,  8 Nov 2022 13:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915441;
        bh=PDreTqukr3x3dAhFef1QS0svsQxz1l5sFVYNKoVT3sM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tpjbo3mnFqOgVVrHwJuYv7iMaWImvnZy0KEF1PkZSV6JOAS82zHoYXg/QzWYzI627
         Bujyva4yhq8MfLebJTK5V5HhPHLoX7sKQiqX9LesHC0qyFJL8p5ine9yGbIbVHu+Zc
         Xu/31xz1jNy61MxHLF0/Nv+GmhLHu4FmoIVKNRJo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable@kernel.org,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.4 63/74] ext4: fix BUG_ON() when directory entry has invalid rec_len
Date:   Tue,  8 Nov 2022 14:39:31 +0100
Message-Id: <20221108133336.344562559@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133333.659601604@linuxfoundation.org>
References: <20221108133333.659601604@linuxfoundation.org>
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

From: Luís Henriques <lhenriques@suse.de>

commit 17a0bc9bd697f75cfdf9b378d5eb2d7409c91340 upstream.

The rec_len field in the directory entry has to be a multiple of 4.  A
corrupted filesystem image can be used to hit a BUG() in
ext4_rec_len_to_disk(), called from make_indexed_dir().

 ------------[ cut here ]------------
 kernel BUG at fs/ext4/ext4.h:2413!
 ...
 RIP: 0010:make_indexed_dir+0x53f/0x5f0
 ...
 Call Trace:
  <TASK>
  ? add_dirent_to_buf+0x1b2/0x200
  ext4_add_entry+0x36e/0x480
  ext4_add_nondir+0x2b/0xc0
  ext4_create+0x163/0x200
  path_openat+0x635/0xe90
  do_filp_open+0xb4/0x160
  ? __create_object.isra.0+0x1de/0x3b0
  ? _raw_spin_unlock+0x12/0x30
  do_sys_openat2+0x91/0x150
  __x64_sys_open+0x6c/0xa0
  do_syscall_64+0x3c/0x80
  entry_SYSCALL_64_after_hwframe+0x46/0xb0

The fix simply adds a call to ext4_check_dir_entry() to validate the
directory entry, returning -EFSCORRUPTED if the entry is invalid.

CC: stable@kernel.org
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216540
Signed-off-by: Luís Henriques <lhenriques@suse.de>
Link: https://lore.kernel.org/r/20221012131330.32456-1-lhenriques@suse.de
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/namei.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2141,8 +2141,16 @@ static int make_indexed_dir(handle_t *ha
 	memcpy(data2, de, len);
 	de = (struct ext4_dir_entry_2 *) data2;
 	top = data2 + len;
-	while ((char *)(de2 = ext4_next_entry(de, blocksize)) < top)
+	while ((char *)(de2 = ext4_next_entry(de, blocksize)) < top) {
+		if (ext4_check_dir_entry(dir, NULL, de, bh2, data2, len,
+					 (data2 + (blocksize - csum_size) -
+					  (char *) de))) {
+			brelse(bh2);
+			brelse(bh);
+			return -EFSCORRUPTED;
+		}
 		de = de2;
+	}
 	de->rec_len = ext4_rec_len_to_disk(data2 + (blocksize - csum_size) -
 					   (char *) de, blocksize);
 


