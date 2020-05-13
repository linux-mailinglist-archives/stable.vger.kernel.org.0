Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A14381D0D60
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387808AbgEMJwd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:52:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:53952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387805AbgEMJwb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:52:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29C1620575;
        Wed, 13 May 2020 09:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363550;
        bh=YolsKuG7VLjfBorjfwxATK010IzrZyYTau88vE0mZXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dt6PamYzkBv9whvUP033+hKbVDcVWNdAUe2zvJVx4+8cyDcxpp66oypc+YVhUSWHG
         eL/cqJ05iLCpRgimEG7UdJIE7S0Tgl1sMjYM7qIE+bNu5ec9mNuhqahb/tGfstJePN
         yYJRbJjuAtOTi0kY01Ny/OIqVb09XJN2iA1B2dSA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Whitney <enwlinux@gmail.com>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 008/118] ext4: disable dioread_nolock whenever delayed allocation is disabled
Date:   Wed, 13 May 2020 11:43:47 +0200
Message-Id: <20200513094418.386785975@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094417.618129545@linuxfoundation.org>
References: <20200513094417.618129545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Whitney <enwlinux@gmail.com>

[ Upstream commit c8980e1980ccdc2229aa2218d532ddc62e0aabe5 ]

The patch "ext4: make dioread_nolock the default" (244adf6426ee) causes
generic/422 to fail when run in kvm-xfstests' ext3conv test case.  This
applies both the dioread_nolock and nodelalloc mount options, a
combination not previously tested by kvm-xfstests.  The failure occurs
because the dioread_nolock code path splits a previously fallocated
multiblock extent into a series of single block extents when overwriting
a portion of that extent.  That causes allocation of an extent tree leaf
node and a reshuffling of extents.  Once writeback is completed, the
individual extents are recombined into a single extent, the extent is
moved again, and the leaf node is deleted.  The difference in block
utilization before and after writeback due to the leaf node triggers the
failure.

The original reason for this behavior was to avoid ENOSPC when handling
I/O completions during writeback in the dioread_nolock code paths when
delayed allocation is disabled.  It may no longer be necessary, because
code was added in the past to reserve extra space to solve this problem
when delayed allocation is enabled, and this code may also apply when
delayed allocation is disabled.  Until this can be verified, don't use
the dioread_nolock code paths if delayed allocation is disabled.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
Link: https://lore.kernel.org/r/20200319150028.24592-1-enwlinux@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ext4_jbd2.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index 7ea4f6fa173b4..4b9002f0e84c0 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -512,6 +512,9 @@ static inline int ext4_should_dioread_nolock(struct inode *inode)
 		return 0;
 	if (ext4_should_journal_data(inode))
 		return 0;
+	/* temporary fix to prevent generic/422 test failures */
+	if (!test_opt(inode->i_sb, DELALLOC))
+		return 0;
 	return 1;
 }
 
-- 
2.20.1



