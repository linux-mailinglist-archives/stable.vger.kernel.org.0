Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C76017FA22
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:03:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730185AbgCJNCx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:02:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:46824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730484AbgCJNCx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:02:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D7E924696;
        Tue, 10 Mar 2020 13:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845372;
        bh=Dz80d63uOmyK71ppUHVER6aN2T9E8bc13m3WbnjNPyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BNnz8+KTKjizXIwWfLNGMNXml1MVDTPLu+Ne6oFNWrER8RUxxLmjrrE9Z5AOp6puq
         b/MOnjOeRvaQRRLNZ1t2EleDpsz8SYfi8dBwxfcL10P71PpXajEDgdgZiKc3bBtdzw
         CbM3PWOFdGbbdRTHvGsORXbrtego6pJpJppUGp9E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ondrej Kozina <okozina@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.5 120/189] dm integrity: fix invalid table returned due to argument count mismatch
Date:   Tue, 10 Mar 2020 13:39:17 +0100
Message-Id: <20200310123651.904055477@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
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
@@ -2975,7 +2975,7 @@ static void dm_integrity_status(struct d
 			DMEMIT(" meta_device:%s", ic->meta_dev->name);
 		if (ic->sectors_per_block != 1)
 			DMEMIT(" block_size:%u", ic->sectors_per_block << SECTOR_SHIFT);
-		if (ic->recalculate_flag)
+		if (ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING))
 			DMEMIT(" recalculate");
 		DMEMIT(" journal_sectors:%u", ic->initial_sectors - SB_SECTORS);
 		DMEMIT(" interleave_sectors:%u", 1U << ic->sb->log2_interleave_sectors);


