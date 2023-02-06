Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 264F668CAD0
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 00:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbjBFXwv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Feb 2023 18:52:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjBFXwu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Feb 2023 18:52:50 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAA942F7A1
        for <stable@vger.kernel.org>; Mon,  6 Feb 2023 15:52:49 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-4fa63c84621so131525407b3.20
        for <stable@vger.kernel.org>; Mon, 06 Feb 2023 15:52:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MUvPZxd7kzBQNUJRIDnP8L1InSjbM6ersdH/SiDuQl4=;
        b=EVLeZ0A8IEAhMPFLFXdlVmPactMWdgTJcmTW2ixmAwNbPaMLwh1Wci+xloCt4S+HQ2
         Jh0qDewyw5jS6ENOmw0RJnyLCUTUSTk2FKbldkESaA2pGzrRdr1neHMabAKXRdgFH8Yu
         5YdEYyBmpvt4pKu0+WYkPCYArJLcpD3ARmzpRkaV1qnbRqOunY4oGu/T9CQYGZMdRJ6F
         VQBnb6pCbVtb3y3Goj+0JvbpYgc9wZKyGkuwBmej0UTcLEI68npaXIm1XpRQA+ZM9Cc8
         NQY3l6RikT7s/hKdce1KevtWDrQpiVIrF/AK3Jt1pXvJebrCNRwffiDAA+xoJxHGQ5dL
         KNPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MUvPZxd7kzBQNUJRIDnP8L1InSjbM6ersdH/SiDuQl4=;
        b=oBq3bNWqQTwT/mL9qEzAa+NwmpJuucqMGH8vZkLqKyh5KXO+6dNpem71zJQ6TjKDoh
         y+hz79+E7LS8ssB5AhjiLU0IIUAA0Y0LSIinYxIBO88+FKDyxlrDTc93BYJgikIrVZQe
         huQZHHKxLUsMcpUkpw2ZY2jVi6+GcLiK94EkUACkO4AMA5clLG4Yg6lE5abM8C5EgPum
         0/e74LifjDO5BDxzzC1vdhgh3wrbhcPTzH/P8TLYp29Q4Vys8GwMoyNcaGkC/GQoM74l
         ToJneOCSiCqKik7U8M6S1cUkmkTTet0hFz/gyj1udhClC5zffl9Fz0UIbS8CHocJ9+AF
         /scA==
X-Gm-Message-State: AO0yUKU1Xev9ATMFnvWgLC45GwrPaRf/8vmWgw+THAHX4gTKuHiZvpRJ
        kBdzewL6wJpvhzDGZ8qIwwVpRTaWimssdZXBD5n17HgcFNeT8uGaChH7v2NcbyrANftC7coSsBY
        yZ9Gn63V/GWlywBchU1H5d+zA0Cw3lbGa1RSCLzoWf7J678OpA8iXBOS6EUz6lmvTHxH5eF+k4Q
        +BWw==
X-Google-Smtp-Source: AK7set9YEoMpKvrJyur4QU/65vd5ej6n9GTynxCQ/VL6xW+9Qk81JuvfpGvoRppSbArLml8SWcJQ/0NFRw3/lEtIBvQ=
X-Received: from nobelbarakat.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:62d])
 (user=nobelbarakat job=sendgmr) by 2002:a5b:5cb:0:b0:80b:9566:d574 with SMTP
 id w11-20020a5b05cb000000b0080b9566d574mr173287ybp.83.1675727568771; Mon, 06
 Feb 2023 15:52:48 -0800 (PST)
Date:   Mon,  6 Feb 2023 23:52:44 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230206235244.3659905-1-nobelbarakat@google.com>
Subject: [PATCH 5.10] udf: Avoid using stale lengthOfImpUse
From:   Nobel Barakat <nobelbarakat@google.com>
To:     stable@vger.kernel.org
Cc:     Jan Kara <jack@suse.cz>,
        butt3rflyh4ck <butterflyhuangxx@gmail.com>,
        Nobel Barakat <nobelbarakat@google.com>
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
