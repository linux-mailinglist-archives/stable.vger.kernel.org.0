Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D57762FA9E4
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 20:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437100AbhARTQE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 14:16:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:34044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390461AbhARLi0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:38:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B787229C6;
        Mon, 18 Jan 2021 11:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610969868;
        bh=ENVLNOqj0eTrZwuzUbNzxO6zY2cwzklf75lRbogYaEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VrGzFYw8dYedC7BpSzRnGCESOjcSUezr1soJzj83HJ6QDefT/MVMarnPTv99YLdl3
         t8KuAKbLbLEOB7Jcv4XsOHF6pqb2ooClOuw9rhDXmGP2/Yu4tfAtHcaODbiAy0kUWg
         E9NZrPhvIWZDmYRl1rszto4YVTXXY6FpM7OejYAE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.4 16/76] dm integrity: fix the maximum number of arguments
Date:   Mon, 18 Jan 2021 12:34:16 +0100
Message-Id: <20210118113341.767314386@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113340.984217512@linuxfoundation.org>
References: <20210118113340.984217512@linuxfoundation.org>
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
@@ -3585,7 +3585,7 @@ static int dm_integrity_ctr(struct dm_ta
 	unsigned extra_args;
 	struct dm_arg_set as;
 	static const struct dm_arg _args[] = {
-		{0, 9, "Invalid number of feature args"},
+		{0, 15, "Invalid number of feature args"},
 	};
 	unsigned journal_sectors, interleave_sectors, buffer_sectors, journal_watermark, sync_msec;
 	bool should_write_sb;


