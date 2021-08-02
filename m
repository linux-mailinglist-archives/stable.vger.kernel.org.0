Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE12C3DDB17
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233940AbhHBObv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:31:51 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:52964 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233939AbhHBObu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Aug 2021 10:31:50 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 48A2620085;
        Mon,  2 Aug 2021 14:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1627914700; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:  in-reply-to:in-reply-to;
        bh=982aW7ZXV8uhjOeVWej9oSEsTcnSklo+3eSgf1adMaY=;
        b=FoWS2HAqaqtpsj/cDN0ejea2J+XlEegw0v2EVQwkMmwuiYUCLxByBmWYNoNge2nF39TNbF
        l+WaDqYNIdPB4mO5VzYjUREiNQoNPpbY7ZwffbOv0DsZxvsR9jdUrZBZv/byL6tdq1yNhJ
        uIPXw/Dj82QLDYoq4VXwJb0zDFCW9fA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1627914700;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:  in-reply-to:in-reply-to;
        bh=982aW7ZXV8uhjOeVWej9oSEsTcnSklo+3eSgf1adMaY=;
        b=ixc4Yb+xmph29ToxEMWUn/GRV8GCbR6W4RIoWiOpyQqQG1a5sujygspjfJZ8WkyUhnVoUq
        pH4MHGvo0N1FXjDA==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id D380F13B30;
        Mon,  2 Aug 2021 14:31:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id FQ6QJMsBCGGZeQAAGKfGzw
        (envelope-from <rgoldwyn@suse.de>); Mon, 02 Aug 2021 14:31:39 +0000
Date:   Mon, 2 Aug 2021 09:31:37 -0500
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, dsterba@suse.com
Subject: [PATCH] btrfs: mark compressed range uptodate only if all bio succeed
Message-ID: <20210802143137.iigsjghqwuq747d6@fiona>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16277132082290@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Git-commit: 240246f6b913b0c23733cfd2def1d283f8cc9bbe
For: v4.14

In compression write endio sequence, the range which the compressed_bio
writes is marked as uptodate if the last bio of the compressed (sub)bios
is completed successfully. There could be previous bio which may
have failed which is recorded in cb->errors.

Set the writeback range as uptodate only if cb->errors is zero, as opposed
to checking only the last bio's status.

Backporting notes: in all versions up to 4.4 the last argument is always
replaced by "!cb->errors".

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index ccd9c709375e..24341c97c13f 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -286,7 +286,7 @@ static void end_compressed_bio_write(struct bio *bio)
 					 cb->start,
 					 cb->start + cb->len - 1,
 					 NULL,
-					 bio->bi_status ? 0 : 1);
+					 !cb->errors);
 	cb->compressed_pages[0]->mapping = NULL;
 
 	end_compressed_writeback(inode, cb);

-- 
Goldwyn
