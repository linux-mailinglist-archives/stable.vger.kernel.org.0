Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6556D2D60
	for <lists+stable@lfdr.de>; Sat,  1 Apr 2023 03:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbjDABuU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 21:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233592AbjDABt0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 21:49:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A07524AC7;
        Fri, 31 Mar 2023 18:46:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1AC07B83312;
        Sat,  1 Apr 2023 01:44:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D2BDC433A7;
        Sat,  1 Apr 2023 01:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680313493;
        bh=COtBPWd792pj4wDo6QCmYmv27EpEeD8uoH4fJakfhLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DjENa+A4TY2SY+Bt/t+iRbxo3eTK+/j16K+YntqVPInRDRI+hSf1hUtfkWRrq0liT
         R5le7hMhIIIUQMxKhscZ6UiGdEz1daHtMwJFiX5fr3eheHJWxbELf8W/qCBq9k7hvS
         twlNR0DUp7qthgC7b+HIRyBHh3PHo3/I5sAWOMghjkPulyBT4SDvrvbiJnV2ZMLqGX
         c23iItNDedYB0npbIxB7i6h+GHcHhiLwOKDMH5YEff7gnm9Qlq80podA8WAFftj32W
         MkJ2KrKCRYuxvS3ZmjxErJsjgjWg4E3drL3/3NcxwGmQUk3a1NF71EjCwzT7u8Fngg
         rmv1Es0WkLfcg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Robbie Harwood <rharwood@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Eric Biederman <ebiederm@xmission.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        kexec@lists.infradead.org, Sasha Levin <sashal@kernel.org>,
        davem@davemloft.net
Subject: [PATCH AUTOSEL 4.19 4/4] verify_pefile: relax wrapper length check
Date:   Fri, 31 Mar 2023 21:44:44 -0400
Message-Id: <20230401014444.3357427-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230401014444.3357427-1-sashal@kernel.org>
References: <20230401014444.3357427-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robbie Harwood <rharwood@redhat.com>

[ Upstream commit 4fc5c74dde69a7eda172514aaeb5a7df3600adb3 ]

The PE Format Specification (section "The Attribute Certificate Table
(Image Only)") states that `dwLength` is to be rounded up to 8-byte
alignment when used for traversal.  Therefore, the field is not required
to be an 8-byte multiple in the first place.

Accordingly, pesign has not performed this alignment since version
0.110.  This causes kexec failure on pesign'd binaries with "PEFILE:
Signature wrapper len wrong".  Update the comment and relax the check.

Signed-off-by: Robbie Harwood <rharwood@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Jarkko Sakkinen <jarkko@kernel.org>
cc: Eric Biederman <ebiederm@xmission.com>
cc: Herbert Xu <herbert@gondor.apana.org.au>
cc: keyrings@vger.kernel.org
cc: linux-crypto@vger.kernel.org
cc: kexec@lists.infradead.org
Link: https://learn.microsoft.com/en-us/windows/win32/debug/pe-format#the-attribute-certificate-table-image-only
Link: https://github.com/rhboot/pesign
Link: https://lore.kernel.org/r/20230220171254.592347-2-rharwood@redhat.com/ # v2
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/asymmetric_keys/verify_pefile.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/crypto/asymmetric_keys/verify_pefile.c b/crypto/asymmetric_keys/verify_pefile.c
index d178650fd524c..411977947adbe 100644
--- a/crypto/asymmetric_keys/verify_pefile.c
+++ b/crypto/asymmetric_keys/verify_pefile.c
@@ -139,11 +139,15 @@ static int pefile_strip_sig_wrapper(const void *pebuf,
 	pr_debug("sig wrapper = { %x, %x, %x }\n",
 		 wrapper.length, wrapper.revision, wrapper.cert_type);
 
-	/* Both pesign and sbsign round up the length of certificate table
-	 * (in optional header data directories) to 8 byte alignment.
+	/* sbsign rounds up the length of certificate table (in optional
+	 * header data directories) to 8 byte alignment.  However, the PE
+	 * specification states that while entries are 8-byte aligned, this is
+	 * not included in their length, and as a result, pesign has not
+	 * rounded up since 0.110.
 	 */
-	if (round_up(wrapper.length, 8) != ctx->sig_len) {
-		pr_debug("Signature wrapper len wrong\n");
+	if (wrapper.length > ctx->sig_len) {
+		pr_debug("Signature wrapper bigger than sig len (%x > %x)\n",
+			 ctx->sig_len, wrapper.length);
 		return -ELIBBAD;
 	}
 	if (wrapper.revision != WIN_CERT_REVISION_2_0) {
-- 
2.39.2

