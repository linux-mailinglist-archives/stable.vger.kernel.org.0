Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6441153CE49
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344689AbiFCRko (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344662AbiFCRkT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:40:19 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EBC553702;
        Fri,  3 Jun 2022 10:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 55EE5CE247C;
        Fri,  3 Jun 2022 17:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 309F4C385A9;
        Fri,  3 Jun 2022 17:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278014;
        bh=Hk3/f2nNv92H8r0dP39kp+bBvl8z1V6g6xqfAm88exk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hBdsJFp0Jg3aHyjBwvzgYa6uzenDsWxvsslncRRkcReGNm62oGcJMxNFGQMJ/18H3
         /VKfTFabyXseaOoNl8p1GABlDYwLi7YcsZzCZLjIW/zPr9vBCjjCf+eMvE+Y1oIhDX
         iUiHnc9vIGr0OcXf3V1mVr2YaqUeHiS9wgKGafgI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Milan Broz <gmazyland@gmail.com>,
        Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 4.9 07/12] dm crypt: make printing of the key constant-time
Date:   Fri,  3 Jun 2022 19:39:33 +0200
Message-Id: <20220603173812.742968160@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173812.524184588@linuxfoundation.org>
References: <20220603173812.524184588@linuxfoundation.org>
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
 drivers/md/dm-crypt.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1943,6 +1943,11 @@ static int crypt_map(struct dm_target *t
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
@@ -1958,10 +1963,12 @@ static void crypt_status(struct dm_targe
 	case STATUSTYPE_TABLE:
 		DMEMIT("%s ", cc->cipher_string);
 
-		if (cc->key_size > 0)
-			for (i = 0; i < cc->key_size; i++)
-				DMEMIT("%02x", cc->key[i]);
-		else
+		if (cc->key_size > 0) {
+			for (i = 0; i < cc->key_size; i++) {
+				DMEMIT("%c%c", hex2asc(cc->key[i] >> 4),
+				       hex2asc(cc->key[i] & 0xf));
+			}
+		} else
 			DMEMIT("-");
 
 		DMEMIT(" %llu %s %llu", (unsigned long long)cc->iv_offset,


