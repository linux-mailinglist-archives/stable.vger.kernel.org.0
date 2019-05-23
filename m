Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 752D728922
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391769AbfEWTbB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:31:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:44654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392212AbfEWTa7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:30:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2AA9217D9;
        Thu, 23 May 2019 19:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639858;
        bh=/lZTweBW81hb+YjBSmF1dONvupQjZjJDzP6SgXt1RdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tCKG9ZcxD28pZrhNl8x85PhhBrUyAGXSF2TVmESnP7t/HaKnf64LNqCmLz1T7hHUJ
         Sa9jIIKo4fodUXwqVOYGUKwNAlu3PWFQsm4ofBpACOTB42PIsYaDqKt0XigMj5bL+m
         LoDOgBx0GSA5AsRT9n9YqE7tARPmLnxREjegjtGI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikos Tsironis <ntsironis@arrikto.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.1 102/122] dm cache metadata: Fix loading discard bitset
Date:   Thu, 23 May 2019 21:07:04 +0200
Message-Id: <20190523181718.801467912@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181705.091418060@linuxfoundation.org>
References: <20190523181705.091418060@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikos Tsironis <ntsironis@arrikto.com>

commit e28adc3bf34e434b30e8d063df4823ba0f3e0529 upstream.

Add missing dm_bitset_cursor_next() to properly advance the bitset
cursor.

Otherwise, the discarded state of all blocks is set according to the
discarded state of the first block.

Fixes: ae4a46a1f6 ("dm cache metadata: use bitset cursor api to load discard bitset")
Cc: stable@vger.kernel.org
Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-cache-metadata.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -1167,11 +1167,18 @@ static int __load_discards(struct dm_cac
 		if (r)
 			return r;
 
-		for (b = 0; b < from_dblock(cmd->discard_nr_blocks); b++) {
+		for (b = 0; ; b++) {
 			r = fn(context, cmd->discard_block_size, to_dblock(b),
 			       dm_bitset_cursor_get_value(&c));
 			if (r)
 				break;
+
+			if (b >= (from_dblock(cmd->discard_nr_blocks) - 1))
+				break;
+
+			r = dm_bitset_cursor_next(&c);
+			if (r)
+				break;
 		}
 
 		dm_bitset_cursor_end(&c);


