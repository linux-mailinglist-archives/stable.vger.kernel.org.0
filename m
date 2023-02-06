Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C11C68C9C6
	for <lists+stable@lfdr.de>; Mon,  6 Feb 2023 23:49:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjBFWtX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Feb 2023 17:49:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjBFWtX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Feb 2023 17:49:23 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08DB610F6
        for <stable@vger.kernel.org>; Mon,  6 Feb 2023 14:49:22 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-4cddba76f55so130304807b3.23
        for <stable@vger.kernel.org>; Mon, 06 Feb 2023 14:49:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MUvPZxd7kzBQNUJRIDnP8L1InSjbM6ersdH/SiDuQl4=;
        b=qBUqAZokjHVOEfabOk6680b5JRbiM9YEwsQ9Gcf7odN0Nyg8TRBqvcRRNEy5CGn0VE
         3co8lIAXFcyiWpKZht+EtLNB5dC1+YEj7UjPkworoIxbf/+yESS3nsi0w4awJL3yJDt4
         bHBBpM9irvqIz1OLvZG8MROHSIa7+aK7FSB0RHP70hk2hNcg43M/Kt4durvtOR8HKquI
         KLYmoSLZtE2/DPl8eL1wjBc3lX+z1vrMpHvrLkPZjyahOK/svaaz83BvEBHmjBTRUH3p
         XDw5r7iHKNYryFI2mydv81h/3y6gXdAsddF1Ie0/sXJTNRdtKwCQweBQ3s7tSCri0G9O
         ZLKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MUvPZxd7kzBQNUJRIDnP8L1InSjbM6ersdH/SiDuQl4=;
        b=aAjRCJ3ssE/9x8ClqLnCsIsLHSMX8d5vo0Iadjhl8hcnmPNdUskqxAN4aMs9H4PvnY
         wgmBkWUihvSyN9YFK5KNRywZhpEGwNFGTez32KU+gLTV5MADj6dMynR1ORURBZehOJ5J
         k1Bid5YFVZcXFhvCeLdcrGsdz3W/RYKlzdaKYlt6oZrx7vMACjQGZoPOk1wwHQOehssL
         SkMYN3S6xrgcBKxqBZ1mGQvdw0lOpHGGfk/m6nfz10yeD0MVYER+v1iISOTFgUNf+ixE
         usLfx8eVHvHCw/akAEb/kpspAt/tTTxNJxW0PpZFwKIhlRbpNFtQYCS38foeDtw670ok
         Wzmw==
X-Gm-Message-State: AO0yUKWxkk33KlEPQdMN48lawN4tXm+hF1/97nCpa5x4k2TPT/Wm5tqh
        jR6REm/jMgEb1Rpzox084Iu0nAz7xEbUvFTNErk=
X-Google-Smtp-Source: AK7set9KUjADJj9ZpP+HVK4Fc+ofsRQ4oJJzejbtgwE3nFKddsIt2l3SN/SWiEopCxsZcMXylIXtd4lqyMc/MjKPfgk=
X-Received: from nobelbarakat.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:62d])
 (user=nobelbarakat job=sendgmr) by 2002:a25:4188:0:b0:888:f55b:b550 with SMTP
 id o130-20020a254188000000b00888f55bb550mr2yba.4.1675723760538; Mon, 06 Feb
 2023 14:49:20 -0800 (PST)
Date:   Mon,  6 Feb 2023 22:49:18 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230206224918.3636940-1-nobelbarakat@google.com>
Subject: [PATCH 5.4] udf: Avoid using stale lengthOfImpUse
From:   Nobel Barakat <nobelbarakat@google.com>
To:     nobelbarakat@google.com
Cc:     gregkh@linuxfoundation.org, Jan Kara <jack@suse.cz>,
        butt3rflyh4ck <butterflyhuangxx@gmail.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit c1ad35dd0548ce947d97aaf92f7f2f9a202951cf upstream

udf_write_fi() uses lengthOfImpUse of the entry it is writing to.
However this field has not yet been initialized so it either contains
completely bogus value or value from last directory entry at that place.
In either case this is wrong and can lead to filesystem corruption or
kernel crashes.

This patch deviates from the original upstream patch because in the original
upstream patch, udf_get_fi_ident(sfi) was being used instead of (uint8_t *)sfi->fileIdent + liu
as the first arg to memcpy at line 77 and line 81. Those subsequent lines have been
replaced with what the upstream patch passes in to memcpy.


Reported-by: butt3rflyh4ck <butterflyhuangxx@gmail.com>
CC: stable@vger.kernel.org
Fixes: 979a6e28dd96 ("udf: Get rid of 0-length arrays in struct fileIdentDesc")
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Nobel Barakat <nobelbarakat@google.com>
---
 fs/udf/namei.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index 77b6d89b9bcd..cbd6ad54a23b 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -74,12 +74,11 @@ int udf_write_fi(struct inode *inode, struct fileIdentDesc *cfi,

 	if (fileident) {
 		if (adinicb || (offset + lfi < 0)) {
-			memcpy((uint8_t *)sfi->fileIdent + liu, fileident, lfi);
+			memcpy(sfi->impUse + liu, fileident, lfi);
 		} else if (offset >= 0) {
 			memcpy(fibh->ebh->b_data + offset, fileident, lfi);
 		} else {
-			memcpy((uint8_t *)sfi->fileIdent + liu, fileident,
-				-offset);
+			memcpy(sfi->impUse + liu, fileident, -offset);
 			memcpy(fibh->ebh->b_data, fileident - offset,
 				lfi + offset);
 		}
@@ -88,11 +87,11 @@ int udf_write_fi(struct inode *inode, struct fileIdentDesc *cfi,
 	offset += lfi;

 	if (adinicb || (offset + padlen < 0)) {
-		memset((uint8_t *)sfi->padding + liu + lfi, 0x00, padlen);
+		memset(sfi->impUse + liu + lfi, 0x00, padlen);
 	} else if (offset >= 0) {
 		memset(fibh->ebh->b_data + offset, 0x00, padlen);
 	} else {
-		memset((uint8_t *)sfi->padding + liu + lfi, 0x00, -offset);
+		memset(sfi->impUse + liu + lfi, 0x00, -offset);
 		memset(fibh->ebh->b_data, 0x00, padlen + offset);
 	}

--
2.39.1.519.gcb327c4b5f-goog
