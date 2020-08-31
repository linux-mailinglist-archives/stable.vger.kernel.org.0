Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F10B2576B6
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 11:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726042AbgHaJkP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 05:40:15 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:33643 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726106AbgHaJkM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Aug 2020 05:40:12 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 5D60D891;
        Mon, 31 Aug 2020 05:40:07 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 31 Aug 2020 05:40:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=NEbKNe
        b4hxBJMysarnMMMf4V+sOAyL0UN+2CQexQmzk=; b=M4rsyvgpFAkCd+AoByQXyy
        HZtcdJle18LQ7KxgilTycKv7ZgV/nDpeYm+bYDAbJ8KCwpd0vZgg6TKxsuRInM94
        zTvfHlrIjBcw0CsscJheU+pa8gtyJtywVyzwqNuTaFz8egVuDeA3DwtaotJ9mVqm
        hW8mIMi3Ll8EtyGRQdLY+dHjMVW5owbDsTgguGmEn/63bvjazGOiA3CyU1tBX8E5
        rFafCg1xY5szcRuXR5h8J6LUBxNgqENX66zc9j6t1GXlW+sY0Py8OU5wlqYz8GxA
        RvxkQfIBoUQxvay+SSkKU50I6xNdc33Yv+0RX0hE/ppbllpgb/no6jcy4vp4VuLg
        ==
X-ME-Sender: <xms:dsVMX4Ex8jUaQ6o-HOIcyGzc__WCgl4ZAY6zp0gOuMM26xFnCi9siQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudefhedgudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:dsVMXxUWe1lBMVa-2WN-QI-eW9k_rIlN1bk_zs3SjHP8p1344qpt_Q>
    <xmx:dsVMXyKd-zcNkhks0_i1N0Z3jlb7kni77qQVGQ6VW5L5x2bTrQgO_A>
    <xmx:dsVMX6HfiYGZT7K5YV_cZe8EfTOtpkuBZGJNnjMDscAoVq-S8pSwIQ>
    <xmx:dsVMX5AWYqfoPWilrmBfzSmFm1pIO0D0tm4rntqcm9Z74MfQC9AbzGtnDVA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3915330600A6;
        Mon, 31 Aug 2020 05:40:06 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: reset compression level for lzo on remount" failed to apply to 4.14-stable tree
To:     mpdesouza@suse.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Aug 2020 11:40:14 +0200
Message-ID: <1598866814224116@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 282dd7d7718444679b046b769d872b188818ca35 Mon Sep 17 00:00:00 2001
From: Marcos Paulo de Souza <mpdesouza@suse.com>
Date: Mon, 3 Aug 2020 16:55:01 -0300
Subject: [PATCH] btrfs: reset compression level for lzo on remount

Currently a user can set mount "-o compress" which will set the
compression algorithm to zlib, and use the default compress level for
zlib (3):

  relatime,compress=zlib:3,space_cache

If the user remounts the fs using "-o compress=lzo", then the old
compress_level is used:

  relatime,compress=lzo:3,space_cache

But lzo does not expose any tunable compression level. The same happens
if we set any compress argument with different level, also with zstd.

Fix this by resetting the compress_level when compress=lzo is
specified.  With the fix applied, lzo is shown without compress level:

  relatime,compress=lzo,space_cache

CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index e529ddb35b87..25967ecaaf0a 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -625,6 +625,7 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 			} else if (strncmp(args[0].from, "lzo", 3) == 0) {
 				compress_type = "lzo";
 				info->compress_type = BTRFS_COMPRESS_LZO;
+				info->compress_level = 0;
 				btrfs_set_opt(info->mount_opt, COMPRESS);
 				btrfs_clear_opt(info->mount_opt, NODATACOW);
 				btrfs_clear_opt(info->mount_opt, NODATASUM);

