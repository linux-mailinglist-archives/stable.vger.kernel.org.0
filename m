Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD8F1328605
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236825AbhCARCw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:02:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:54004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235441AbhCAQz3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:55:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84AC564FD0;
        Mon,  1 Mar 2021 16:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616528;
        bh=WlV5+OSr93RxHk3rUdejhc3nuG5sTkjRR7WPr9MnB8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=drp7HOMMfrOa0Jz5oQZkpmRVUhpoKuemT6ulZy9RnAKTrARwnMU6DnVkKYsDUkELq
         bEMJIsj642wUZbTxlNO79npVVxaDFdIFK9795BFttKxb30FLl5zsJZtQAXxQo2LuFi
         VGC98DKGPUP86JYaGgemnIeY3/JbLER/FBw5i520=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikos Tsironis <ntsironis@arrikto.com>,
        Ming-Hung Tsai <mtsai@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.14 166/176] dm era: Fix bitset memory leaks
Date:   Mon,  1 Mar 2021 17:13:59 +0100
Message-Id: <20210301161029.277278930@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161020.931630716@linuxfoundation.org>
References: <20210301161020.931630716@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikos Tsironis <ntsironis@arrikto.com>

commit 904e6b266619c2da5c58b5dce14ae30629e39645 upstream.

Deallocate the memory allocated for the in-core bitsets when destroying
the target and in error paths.

Fixes: eec40579d84873 ("dm: add era target")
Cc: stable@vger.kernel.org # v3.15+
Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
Reviewed-by: Ming-Hung Tsai <mtsai@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-era-target.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -46,6 +46,7 @@ struct writeset {
 static void writeset_free(struct writeset *ws)
 {
 	vfree(ws->bits);
+	ws->bits = NULL;
 }
 
 static int setup_on_disk_bitset(struct dm_disk_bitset *info,
@@ -810,6 +811,8 @@ static struct era_metadata *metadata_ope
 
 static void metadata_close(struct era_metadata *md)
 {
+	writeset_free(&md->writesets[0]);
+	writeset_free(&md->writesets[1]);
 	destroy_persistent_data_objects(md);
 	kfree(md);
 }
@@ -847,6 +850,7 @@ static int metadata_resize(struct era_me
 	r = writeset_alloc(&md->writesets[1], *new_size);
 	if (r) {
 		DMERR("%s: writeset_alloc failed for writeset 1", __func__);
+		writeset_free(&md->writesets[0]);
 		return r;
 	}
 
@@ -857,6 +861,8 @@ static int metadata_resize(struct era_me
 			    &value, &md->era_array_root);
 	if (r) {
 		DMERR("%s: dm_array_resize failed", __func__);
+		writeset_free(&md->writesets[0]);
+		writeset_free(&md->writesets[1]);
 		return r;
 	}
 


