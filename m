Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF0B3A803
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 18:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732911AbfFIQ4H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:56:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:58484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732509AbfFIQ4G (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:56:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 997B2206DF;
        Sun,  9 Jun 2019 16:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099366;
        bh=iCD/0ykGHFDxqowjP4Y0ARdfqFeEjjyctTH8bpbesWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1efRWo+Kjcugia/VIITPurdMVVxBqqOFviVccMXGUoaI+ExUEabSLV8QEpBepSzRn
         PKlVi/Nkfu67anjW8Y1FNORJktIkmiEpvtxjNAdm7RX4KkGKq76ORYGVNf6mKPX4OP
         /sAU3Vm2GjQS2E5gFWktrxIuIiT6EgZeuGpszCcA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Debabrata Banerjee <dbanerje@akamai.com>,
        Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        stable@kernel.org
Subject: [PATCH 4.4 017/241] ext4: fix ext4_show_options for file systems w/o journal
Date:   Sun,  9 Jun 2019 18:39:19 +0200
Message-Id: <20190609164148.282293861@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Debabrata Banerjee <dbanerje@akamai.com>

commit 50b29d8f033a7c88c5bc011abc2068b1691ab755 upstream.

Instead of removing EXT4_MOUNT_JOURNAL_CHECKSUM from s_def_mount_opt as
I assume was intended, all other options were blown away leading to
_ext4_show_options() output being incorrect.

Fixes: 1e381f60dad9 ("ext4: do not allow journal_opts for fs w/o journal")
Signed-off-by: Debabrata Banerjee <dbanerje@akamai.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3867,7 +3867,7 @@ static int ext4_fill_super(struct super_
 				 "data=, fs mounted w/o journal");
 			goto failed_mount_wq;
 		}
-		sbi->s_def_mount_opt &= EXT4_MOUNT_JOURNAL_CHECKSUM;
+		sbi->s_def_mount_opt &= ~EXT4_MOUNT_JOURNAL_CHECKSUM;
 		clear_opt(sb, JOURNAL_CHECKSUM);
 		clear_opt(sb, DATA_FLAGS);
 		sbi->s_journal = NULL;


