Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2601D171A5D
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 14:53:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731239AbgB0Nw5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:52:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:52646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731597AbgB0Nw5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:52:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B54D21D7E;
        Thu, 27 Feb 2020 13:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811576;
        bh=b5rEC33m1hhUbs5bRijRXrNHiMu2UCHhoEVVOLBKnXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GGlQQvbj5EuI2J/rzyX1gdU3tKkL2oe0NcUJaB00S0hFNoz+MmqPyYepGJQeZ4CaO
         dLmFWDheDu6QDAS5Z4sTaR2mzhVF73fcuU5fyivjd0+f4te0hX1UiDsY06fbl+GAoD
         1zfulqlVDhaboLNAIIDQ2awfS11GI0DZwSjBVU+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Murphy <lists@colorremedies.com>,
        Anand Jain <anand.jain@oracle.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.14 020/237] btrfs: print message when tree-log replay starts
Date:   Thu, 27 Feb 2020 14:33:54 +0100
Message-Id: <20200227132257.629105494@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Sterba <dsterba@suse.com>

commit e8294f2f6aa6208ed0923aa6d70cea3be178309a upstream.

There's no logged information about tree-log replay although this is
something that points to previous unclean unmount. Other filesystems
report that as well.

Suggested-by: Chris Murphy <lists@colorremedies.com>
CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/disk-io.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2913,6 +2913,7 @@ retry_root_backup:
 	/* do not make disk changes in broken FS or nologreplay is given */
 	if (btrfs_super_log_root(disk_super) != 0 &&
 	    !btrfs_test_opt(fs_info, NOLOGREPLAY)) {
+		btrfs_info(fs_info, "start tree-log replay");
 		ret = btrfs_replay_log(fs_info, fs_devices);
 		if (ret) {
 			err = ret;


