Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D992253CFA9
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345373AbiFCRzx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:55:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346357AbiFCRvG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:51:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB41C54BF2;
        Fri,  3 Jun 2022 10:47:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E5FE60F36;
        Fri,  3 Jun 2022 17:47:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 192C1C385A9;
        Fri,  3 Jun 2022 17:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278465;
        bh=q0pXpUrywR1EhwQ+Bo3vKia0ydjXRDE8ufJ1eppQkXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wAvBSg1Hwnz26JUeU1t2qpYzhwDqsSDaEiOjW3BYXZD5tKYFDxCrJGA7dkX6hvif/
         u+CpYVx/yjwlDfm7gIiyttBSRPlN6QPASmGQN2G7tfP650YnpzgUDAWbZAv1EnTDFh
         pOB0YaCrl5kgb9qJUsLp0HqcS5nnXF4vULnSN6So=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Milan Broz <gmazyland@gmail.com>,
        Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 5.10 41/53] dm crypt: make printing of the key constant-time
Date:   Fri,  3 Jun 2022 19:43:26 +0200
Message-Id: <20220603173819.915827409@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173818.716010877@linuxfoundation.org>
References: <20220603173818.716010877@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

commit 567dd8f34560fa221a6343729474536aa7ede4fd upstream.

The device mapper dm-crypt target is using scnprintf("%02x", cc->key[i]) to
report the current key to userspace. However, this is not a constant-time
operation and it may leak information about the key via timing, via cache
access patterns or via the branch predictor.

Change dm-crypt's key printing to use "%c" instead of "%02x". Also
introduce hex2asc() that carefully avoids any branching or memory
accesses when converting a number in the range 0 ... 15 to an ascii
character.

Cc: stable@vger.kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Tested-by: Milan Broz <gmazyland@gmail.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-crypt.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -3404,6 +3404,11 @@ static int crypt_map(struct dm_target *t
 	return DM_MAPIO_SUBMITTED;
 }
 
+static char hex2asc(unsigned char c)
+{
+	return c + '0' + ((unsigned)(9 - c) >> 4 & 0x27);
+}
+
 static void crypt_status(struct dm_target *ti, status_type_t type,
 			 unsigned status_flags, char *result, unsigned maxlen)
 {
@@ -3422,9 +3427,12 @@ static void crypt_status(struct dm_targe
 		if (cc->key_size > 0) {
 			if (cc->key_string)
 				DMEMIT(":%u:%s", cc->key_size, cc->key_string);
-			else
-				for (i = 0; i < cc->key_size; i++)
-					DMEMIT("%02x", cc->key[i]);
+			else {
+				for (i = 0; i < cc->key_size; i++) {
+					DMEMIT("%c%c", hex2asc(cc->key[i] >> 4),
+					       hex2asc(cc->key[i] & 0xf));
+				}
+			}
 		} else
 			DMEMIT("-");
 


