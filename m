Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 094C512EE63
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731233AbgABWiO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:38:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:51876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731281AbgABWiO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:38:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10E22222C3;
        Thu,  2 Jan 2020 22:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004693;
        bh=srK+AwUov53SvNhhGdeEi7tX841wok/s60+s1aXhuaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vlBwve8irORoQVtd7C5ZqOOU8gtHprZcIP3JZizjBm3e7OCzHkz4HfSdJVxLLTCAx
         MNoQBdlSMFidkiAhGz3wVwMfLrvBvkPsTop86FRqYH7JQBBGuNOvo8igQxLrFibDHf
         untPmMuqbybm3ehzbag2Kzcq32K0HAw0jCFUDDek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.4 086/137] ext4: check for directory entries too close to block end
Date:   Thu,  2 Jan 2020 23:07:39 +0100
Message-Id: <20200102220558.244529402@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220546.618583146@linuxfoundation.org>
References: <20200102220546.618583146@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 109ba779d6cca2d519c5dd624a3276d03e21948e upstream.

ext4_check_dir_entry() currently does not catch a case when a directory
entry ends so close to the block end that the header of the next
directory entry would not fit in the remaining space. This can lead to
directory iteration code trying to access address beyond end of current
buffer head leading to oops.

CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20191202170213.4761-3-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/dir.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -75,6 +75,11 @@ int __ext4_check_dir_entry(const char *f
 		error_msg = "rec_len is too small for name_len";
 	else if (unlikely(((char *) de - buf) + rlen > size))
 		error_msg = "directory entry overrun";
+	else if (unlikely(((char *) de - buf) + rlen >
+			  size - EXT4_DIR_REC_LEN(1) &&
+			  ((char *) de - buf) + rlen != size)) {
+		error_msg = "directory entry too close to block end";
+	}
 	else if (unlikely(le32_to_cpu(de->inode) >
 			le32_to_cpu(EXT4_SB(dir->i_sb)->s_es->s_inodes_count)))
 		error_msg = "inode out of bounds";


