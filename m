Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9773DDB10
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233959AbhHBOas (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:30:48 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:40532 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233940AbhHBOas (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Aug 2021 10:30:48 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 4155721FE6;
        Mon,  2 Aug 2021 14:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1627914638; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:  in-reply-to:in-reply-to;
        bh=NjvpAjoFBYe9D+dB4v+AvePEna9rAzGtj8gkRcMltWw=;
        b=d6kOSX3sNKQeShJWXyCihmygEHE3UogtRurtGqmN8ww4Ml2sRLl2nK4YVVuZsBlBt9Da8n
        YGBgMp2Tmj8tXddbUbc2mDL6/cpxDQ+GSfnHCj0FvuQ+4ZdeR3xY/tLrO/5p+fHsCuZgCI
        WIdfv7cmh11E5mZ6PDloVy65v4wuxwQ=
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id BB76713B30;
        Mon,  2 Aug 2021 14:30:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id jfkKFo0BCGFBeQAAGKfGzw
        (envelope-from <rgoldwyn@suse.com>); Mon, 02 Aug 2021 14:30:37 +0000
Date:   Mon, 2 Aug 2021 09:30:34 -0500
From:   Goldwyn Rodrigues <rgoldwyn@suse.com>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, dsterba@suse.com
Subject: [PATCH] btrfs: mark compressed range uptodate only if all bio succeed
Message-ID: <20210802143034.e2cg65wuemgzg2ne@fiona>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16277132073194@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Git-commit: 240246f6b913b0c23733cfd2def1d283f8cc9bbe
For: v4.4

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
index bae05c5c75ba..92601775ec5e 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -290,7 +290,7 @@ static void end_compressed_bio_write(struct bio *bio)
 					 cb->start,
 					 cb->start + cb->len - 1,
 					 NULL,
-					 bio->bi_error ? 0 : 1);
+					 !cb->errors);
 	cb->compressed_pages[0]->mapping = NULL;
 
 	end_compressed_writeback(inode, cb);

-- 
Goldwyn
