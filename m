Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5835D157A11
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728861AbgBJMhm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:37:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:59942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728853AbgBJMhl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:37:41 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BF9F20733;
        Mon, 10 Feb 2020 12:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338261;
        bh=FOHZbTGAvBk6lJvEzRP0bkJy0m/poj8G8okJ9yEAMds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YuXAbVngdZXeZtOcQjVMn26vYgVmEeakUNf8Zgdtz4OqhamoR2F6TRTwSwMfoQs7U
         UcE0UJjQ6zYNH1V3xQAwHanvBK0V0DoGH4b+GA/7afpQyNcguB1ToJNefbxicNRIbQ
         Ls4tgS+2TWGIlBg0C63iP6vumnso+kYsZoUZWGZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>
Subject: [PATCH 5.4 092/309] ubifs: dont trigger assertion on invalid no-key filename
Date:   Mon, 10 Feb 2020 04:30:48 -0800
Message-Id: <20200210122414.886993175@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit f0d07a98a070bb5e443df19c3aa55693cbca9341 upstream.

If userspace provides an invalid fscrypt no-key filename which encodes a
hash value with any of the UBIFS node type bits set (i.e. the high 3
bits), gracefully report ENOENT rather than triggering ubifs_assert().

Test case with kvm-xfstests shell:

    . fs/ubifs/config
    . ~/xfstests/common/encrypt
    dev=$(__blkdev_to_ubi_volume /dev/vdc)
    ubiupdatevol $dev -t
    mount $dev /mnt -t ubifs
    mkdir /mnt/edir
    xfs_io -c set_encpolicy /mnt/edir
    rm /mnt/edir/_,,,,,DAAAAAAAAAAAAAAAAAAAAAAAAAA

With the bug, the following assertion fails on the 'rm' command:

    [   19.066048] UBIFS error (ubi0:0 pid 379): ubifs_assert_failed: UBIFS assert failed: !(hash & ~UBIFS_S_KEY_HASH_MASK), in fs/ubifs/key.h:170

Fixes: f4f61d2cc6d8 ("ubifs: Implement encrypted filenames")
Cc: <stable@vger.kernel.org> # v4.10+
Link: https://lore.kernel.org/r/20200120223201.241390-5-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ubifs/dir.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -228,6 +228,8 @@ static struct dentry *ubifs_lookup(struc
 	if (nm.hash) {
 		ubifs_assert(c, fname_len(&nm) == 0);
 		ubifs_assert(c, fname_name(&nm) == NULL);
+		if (nm.hash & ~UBIFS_S_KEY_HASH_MASK)
+			goto done; /* ENOENT */
 		dent_key_init_hash(c, &key, dir->i_ino, nm.hash);
 		err = ubifs_tnc_lookup_dh(c, &key, dent, nm.minor_hash);
 	} else {


