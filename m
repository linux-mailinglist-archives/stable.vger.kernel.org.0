Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CADD5264BB
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 16:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381126AbiEMOel (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 10:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381295AbiEMOe2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 10:34:28 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB7F1B54AE;
        Fri, 13 May 2022 07:29:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AA0C8CE3237;
        Fri, 13 May 2022 14:29:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D0ABC34100;
        Fri, 13 May 2022 14:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652452160;
        bh=sDqknvl/Pn++QqE43sj1doJEwJZRrTv0llb3fsN2P1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UsmZJ1R/fkN7DCygOhWn58h7nAEe58xb2BY3SmFlNmHrbsiK5tXVZkpwUWeK+FyzL
         ULKUWFxc6vVjuqH47uqFuh3IE221PO3TT5HsuzL6iWgI32vL4vKFwAfkxmHSWwRXRx
         olFU19pZG4zxyGGwfF5KujfHiT5hTx/mGUxgVXmI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, butt3rflyh4ck <butterflyhuangxx@gmail.com>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 5.17 03/12] udf: Avoid using stale lengthOfImpUse
Date:   Fri, 13 May 2022 16:24:03 +0200
Message-Id: <20220513142228.753578790@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220513142228.651822943@linuxfoundation.org>
References: <20220513142228.651822943@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit c1ad35dd0548ce947d97aaf92f7f2f9a202951cf upstream.

udf_write_fi() uses lengthOfImpUse of the entry it is writing to.
However this field has not yet been initialized so it either contains
completely bogus value or value from last directory entry at that place.
In either case this is wrong and can lead to filesystem corruption or
kernel crashes.

Reported-by: butt3rflyh4ck <butterflyhuangxx@gmail.com>
CC: stable@vger.kernel.org
Fixes: 979a6e28dd96 ("udf: Get rid of 0-length arrays in struct fileIdentDesc")
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/namei.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -75,11 +75,11 @@ int udf_write_fi(struct inode *inode, st
 
 	if (fileident) {
 		if (adinicb || (offset + lfi < 0)) {
-			memcpy(udf_get_fi_ident(sfi), fileident, lfi);
+			memcpy(sfi->impUse + liu, fileident, lfi);
 		} else if (offset >= 0) {
 			memcpy(fibh->ebh->b_data + offset, fileident, lfi);
 		} else {
-			memcpy(udf_get_fi_ident(sfi), fileident, -offset);
+			memcpy(sfi->impUse + liu, fileident, -offset);
 			memcpy(fibh->ebh->b_data, fileident - offset,
 				lfi + offset);
 		}
@@ -88,11 +88,11 @@ int udf_write_fi(struct inode *inode, st
 	offset += lfi;
 
 	if (adinicb || (offset + padlen < 0)) {
-		memset(udf_get_fi_ident(sfi) + lfi, 0x00, padlen);
+		memset(sfi->impUse + liu + lfi, 0x00, padlen);
 	} else if (offset >= 0) {
 		memset(fibh->ebh->b_data + offset, 0x00, padlen);
 	} else {
-		memset(udf_get_fi_ident(sfi) + lfi, 0x00, -offset);
+		memset(sfi->impUse + liu + lfi, 0x00, -offset);
 		memset(fibh->ebh->b_data, 0x00, padlen + offset);
 	}
 


