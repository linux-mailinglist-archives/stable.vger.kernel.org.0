Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6DAC17FDA0
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728146AbgCJN25 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:28:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:58382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727965AbgCJMwk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:52:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C07B24693;
        Tue, 10 Mar 2020 12:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844759;
        bh=bcQ9lGK78Ki5vv7p3bYLNxXnLDCW8M07zkAmfFI1IBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W5yb1PD8xmzP/ZvZAYoBpzCtGj9+Te6KpNfdHatsrBsXtbKdoJJ2vG1U+Fbd27X9A
         YxfBHeoBS40KxaTRRvzHBppJ62uuc4Kyz2zEkfy3SJFHU8zB2DKnc+MHizi60YlGap
         W3FBYKHOWiWjg8aq4VIamRTDRFBDGopp5S2YNgx8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ondrej Kozina <okozina@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.4 106/168] dm integrity: fix invalid table returned due to argument count mismatch
Date:   Tue, 10 Mar 2020 13:39:12 +0100
Message-Id: <20200310123646.111349496@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit 7fc2e47f40dd77ab1fcbda6db89614a0173d89c7 upstream.

If the flag SB_FLAG_RECALCULATE is present in the superblock, but it was
not specified on the command line (i.e. ic->recalculate_flag is false),
dm-integrity would return invalid table line - the reported number of
arguments would not match the real number.

Fixes: 468dfca38b1a ("dm integrity: add a bitmap mode")
Cc: stable@vger.kernel.org # v5.2+
Reported-by: Ondrej Kozina <okozina@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-integrity.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -2969,7 +2969,7 @@ static void dm_integrity_status(struct d
 			DMEMIT(" meta_device:%s", ic->meta_dev->name);
 		if (ic->sectors_per_block != 1)
 			DMEMIT(" block_size:%u", ic->sectors_per_block << SECTOR_SHIFT);
-		if (ic->recalculate_flag)
+		if (ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING))
 			DMEMIT(" recalculate");
 		DMEMIT(" journal_sectors:%u", ic->initial_sectors - SB_SECTORS);
 		DMEMIT(" interleave_sectors:%u", 1U << ic->sb->log2_interleave_sectors);


