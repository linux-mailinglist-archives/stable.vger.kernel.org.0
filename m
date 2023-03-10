Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF0D6B445E
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232285AbjCJOX0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:23:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232191AbjCJOWu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:22:50 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F4031E9D4
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:22:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8920BCE28F8
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:22:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C6CC433D2;
        Fri, 10 Mar 2023 14:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458135;
        bh=sHVyyNHYI5vjxby4TKYMDIHiTJ6KYSmWpyqJS2DRaPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tYFgj5f3h8oGE8mSrVNmFuSlhcDZmNZnP+lj9dgjiJi7F2UZWPN1zSJmgRYhO1p6+
         qryq4EuUdlUr3SjZGljN0SCK1J681CwJBOSz/HHi7y18wnEzRWJm8YVztf6eQuSojd
         jiIFZ/KhA+VK244UDWisgCgY6d0vhoJwS6qCfcfs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mikulas Patocka <mpatocka@redhat.com>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 4.19 175/252] dm flakey: fix logic when corrupting a bio
Date:   Fri, 10 Mar 2023 14:39:05 +0100
Message-Id: <20230310133724.156043993@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
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
@@ -364,9 +364,11 @@ static int flakey_map(struct dm_target *
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
 
@@ -397,13 +399,14 @@ static int flakey_end_io(struct dm_targe
 	}
 
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


