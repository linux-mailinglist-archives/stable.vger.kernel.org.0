Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C49A7289F9
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389424AbfEWTR3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:17:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:52628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389422AbfEWTR3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:17:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1335621871;
        Thu, 23 May 2019 19:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639048;
        bh=/lZTweBW81hb+YjBSmF1dONvupQjZjJDzP6SgXt1RdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jqGD1K5+/vQmvBug2uc8UqgcT6pQkYAUXntvmY8D8ALGPo9P18LsdDXMueas1O8YO
         p9CA56mEb/+zt3bPoRcGQZPsSn0ECYp1ClPstm/yZz5o8rlJbKjAYi5WbMxsTXBViL
         LFOENFRgEh2zo6FA0bhN1+cON4lO5sPxMlT5Q6Ew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikos Tsironis <ntsironis@arrikto.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.19 077/114] dm cache metadata: Fix loading discard bitset
Date:   Thu, 23 May 2019 21:06:16 +0200
Message-Id: <20190523181738.722126723@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181731.372074275@linuxfoundation.org>
References: <20190523181731.372074275@linuxfoundation.org>
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


