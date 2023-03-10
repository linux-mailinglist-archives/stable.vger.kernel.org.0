Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C356A6B461F
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbjCJOkV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:40:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232686AbjCJOkT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:40:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A9C67DD2A
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:40:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EACA5617B4
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD646C4339C;
        Fri, 10 Mar 2023 14:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459214;
        bh=YMhqX6C/YupTdxYUJbs1W5Sgg6QuNyNZja+Sqq+eLGM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GnJts50fTsB3i8YsX7vELZvDXT/BO+NJAQCDhAhZg17gCpG+Ao3kB/cxEz4S8pG5D
         24lY/pH+XQuX1Ke9UhKw78RG9DbVWSId6R2hMnqW1s131GOXhSO4LGD+H/cCALplho
         mZci5noiFRociDOdgNofAQ3qvZCcfYhJmtleU+oc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mikulas Patocka <mpatocka@redhat.com>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 5.4 255/357] dm flakey: fix logic when corrupting a bio
Date:   Fri, 10 Mar 2023 14:39:04 +0100
Message-Id: <20230310133746.006719122@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit aa56b9b75996ff4c76a0a4181c2fa0206c3d91cc upstream.

If "corrupt_bio_byte" is set to corrupt reads and corrupt_bio_flags is
used, dm-flakey would erroneously return all writes as errors. Likewise,
if "corrupt_bio_byte" is set to corrupt writes, dm-flakey would return
errors for all reads.

Fix the logic so that if fc->corrupt_bio_byte is non-zero, dm-flakey
will not abort reads on writes with an error.

Cc: stable@vger.kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-flakey.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -360,9 +360,11 @@ static int flakey_map(struct dm_target *
 		/*
 		 * Corrupt matching writes.
 		 */
-		if (fc->corrupt_bio_byte && (fc->corrupt_bio_rw == WRITE)) {
-			if (all_corrupt_bio_flags_match(bio, fc))
-				corrupt_bio_data(bio, fc);
+		if (fc->corrupt_bio_byte) {
+			if (fc->corrupt_bio_rw == WRITE) {
+				if (all_corrupt_bio_flags_match(bio, fc))
+					corrupt_bio_data(bio, fc);
+			}
 			goto map_bio;
 		}
 
@@ -388,13 +390,14 @@ static int flakey_end_io(struct dm_targe
 		return DM_ENDIO_DONE;
 
 	if (!*error && pb->bio_submitted && (bio_data_dir(bio) == READ)) {
-		if (fc->corrupt_bio_byte && (fc->corrupt_bio_rw == READ) &&
-		    all_corrupt_bio_flags_match(bio, fc)) {
-			/*
-			 * Corrupt successful matching READs while in down state.
-			 */
-			corrupt_bio_data(bio, fc);
-
+		if (fc->corrupt_bio_byte) {
+			if ((fc->corrupt_bio_rw == READ) &&
+			    all_corrupt_bio_flags_match(bio, fc)) {
+				/*
+				 * Corrupt successful matching READs while in down state.
+				 */
+				corrupt_bio_data(bio, fc);
+			}
 		} else if (!test_bit(DROP_WRITES, &fc->flags) &&
 			   !test_bit(ERROR_WRITES, &fc->flags)) {
 			/*


