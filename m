Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9A12FA8B3
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 19:26:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405533AbhARPGw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 10:06:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:38144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390301AbhARLmj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:42:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08813222BB;
        Mon, 18 Jan 2021 11:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970115;
        bh=5blLwrZ+U5yqjj/c5lyDMoOycH+O1g4L8/TOpLJGLMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HdgLH9dDpvNNEif5j2zcAp9svIHV5RrQYa6zGMRev1J9vfM0eP1mice8CPGV5sGEi
         AJCs5ktaFnAydUV0al5PG77AzS8++GOe92/awCCOQM7bmz3/lpYdb4xLxysvGQ7JY8
         4VO/LeAw5NFCuDJbxzPyuDqYnykQX/MgVs3oAX+E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.10 044/152] dm integrity: fix the maximum number of arguments
Date:   Mon, 18 Jan 2021 12:33:39 +0100
Message-Id: <20210118113354.893955103@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit 17ffc193cdc6dc7a613d00d8ad47fc1f801b9bf0 upstream.

Advance the maximum number of arguments from 9 to 15 to account for
all potential feature flags that may be supplied.

Linux 4.19 added "meta_device"
(356d9d52e1221ba0c9f10b8b38652f78a5298329) and "recalculate"
(a3fcf7253139609bf9ff901fbf955fba047e75dd) flags.

Commit 468dfca38b1a6fbdccd195d875599cb7c8875cd9 added
"sectors_per_bit" and "bitmap_flush_interval".

Commit 84597a44a9d86ac949900441cea7da0af0f2f473 added
"allow_discards".

And the commit d537858ac8aaf4311b51240893add2fc62003b97 added
"fix_padding".

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-integrity.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -3792,7 +3792,7 @@ static int dm_integrity_ctr(struct dm_ta
 	unsigned extra_args;
 	struct dm_arg_set as;
 	static const struct dm_arg _args[] = {
-		{0, 9, "Invalid number of feature args"},
+		{0, 15, "Invalid number of feature args"},
 	};
 	unsigned journal_sectors, interleave_sectors, buffer_sectors, journal_watermark, sync_msec;
 	bool should_write_sb;


