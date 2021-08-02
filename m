Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1A613DDB18
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233979AbhHBOcT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:32:19 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:52998 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233939AbhHBOcT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Aug 2021 10:32:19 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D6BC220086;
        Mon,  2 Aug 2021 14:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1627914728; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:  in-reply-to:in-reply-to;
        bh=d86ivqXbH7FXiJqvcETtjVW0+pBmGSpZLVGfCK1tDJ4=;
        b=m0okwJK8QBkec6xo44IsC88XoBm/qh047SWLVlPQmguGuGQyFLGz3h0YtjSdlDFX0b7GhJ
        ER/WGGQjIE/zMkbzABX82nrjop8WxR5k81xIisRLZJQBT090VS54lCY1JBJajo3CgZqNQV
        Tt0nffcz0EkZW2EzP5aTtq87H+UIfk0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1627914728;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:  in-reply-to:in-reply-to;
        bh=d86ivqXbH7FXiJqvcETtjVW0+pBmGSpZLVGfCK1tDJ4=;
        b=dgBNOoTr+av6IEUVlVglDExdAyszttkmtnqYigp2AtqemC4maE1fL+0p7qSqiRY7fR7zek
        T90p88kYpkdQYVBA==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 6922413B30;
        Mon,  2 Aug 2021 14:32:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id rqWZCugBCGHEeQAAGKfGzw
        (envelope-from <rgoldwyn@suse.de>); Mon, 02 Aug 2021 14:32:08 +0000
Date:   Mon, 2 Aug 2021 09:32:06 -0500
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, dsterba@suse.com
Subject: [PATCH] btrfs: mark compressed range uptodate only if all bio succeed
Message-ID: <20210802143206.bun3t2chwm7bghel@fiona>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1627713208284@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

For: v4.19
Git-commit: 240246f6b913b0c23733cfd2def1d283f8cc9bbe

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
index c71e534ca7ef..919c033b9e31 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -270,8 +270,7 @@ static void end_compressed_bio_write(struct bio *bio)
 					 cb->start,
 					 cb->start + cb->len - 1,
 					 NULL,
-					 bio->bi_status ?
-					 BLK_STS_OK : BLK_STS_NOTSUPP);
+					 !cb->errors);
 	cb->compressed_pages[0]->mapping = NULL;
 
 	end_compressed_writeback(inode, cb);

-- 
Goldwyn
