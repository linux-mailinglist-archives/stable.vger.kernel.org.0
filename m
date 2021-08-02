Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A10223DDB13
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234050AbhHBObV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:31:21 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:40546 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233940AbhHBObU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Aug 2021 10:31:20 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 1EF8222013;
        Mon,  2 Aug 2021 14:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1627914670; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:  in-reply-to:in-reply-to;
        bh=LtbK4ukpf4aR4ht7gFXZtGMmdtl3aosgd+92bQ60GMA=;
        b=c0YPTpvE5gQn/wLM97pZ6hIQ/2oETd2cb2WeMNdMZxCrnhz+8H3rE/ASzMGfJlS2J7Uj52
        rBvzA/ARLVkXZwJeNHYx224bbbB8S+zIcMZQS3S7sbFvyQEzYrqCbZ44Rnyajgsd3BpX4q
        A52svs4Gu0g6p7ezvrUqfeTbrDzpnUw=
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id C49C813B30;
        Mon,  2 Aug 2021 14:31:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id OLW0Jq0BCGF1eQAAGKfGzw
        (envelope-from <rgoldwyn@suse.com>); Mon, 02 Aug 2021 14:31:09 +0000
Date:   Mon, 2 Aug 2021 09:31:07 -0500
From:   Goldwyn Rodrigues <rgoldwyn@suse.com>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, dsterba@suse.com
Subject: [PATCH] btrfs: mark compressed range uptodate only if all bio succeed
Message-ID: <20210802143107.d5qglh642bh4uktg@fiona>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162771320782111@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Git-commit: 240246f6b913b0c23733cfd2def1d283f8cc9bbe
For: v4.9

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
index d4d8b7e36b2f..2534e44cfd40 100644
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
