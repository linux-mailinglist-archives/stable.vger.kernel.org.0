Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA32D5901C6
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236933AbiHKPyL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:54:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236485AbiHKPxg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:53:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21E2C9F1A9;
        Thu, 11 Aug 2022 08:45:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8B89B82123;
        Thu, 11 Aug 2022 15:45:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2EB8C433C1;
        Thu, 11 Aug 2022 15:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232707;
        bh=GLdBc2h5Tcvr10jZvvlTIeKGec1FDDwOLUf9VmUKEkA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=daIud4bv9MBiXTC65KwyM4NyIlTjV5PJ9Q15YPGqF7kgwnXanZ8fmR0ZM8p1jnNTD
         TkgOhQSxUxc8UsMrUVmr6S+unep/QSslc4jza/j+np38evI7guwGWQukQgu9SYU9VL
         Oz2QyXpSOyBgg1EEXmywI7sw2NUfx3Douuyq9ziUwkaX4+wSAYBcZseb+CsFL/Jc16
         dWVyBLYupJ5B+z/TVTnckBKC6XMKlREy4CGwb0leZsWhZdG4HArVeWGkJZP/mGVzjr
         ano2hqiRm3v2b1fnm/byVRJMWcNH6GiuesKtAd97cOoej2PTigIUORG9nJMK6Yw+z2
         twu05E5yIs1xQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shijith Thotton <sthotton@marvell.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, bbrezillon@kernel.org,
        arno@natisbad.org, schalla@marvell.com, davem@davemloft.net,
        dan.carpenter@oracle.com, keescook@chromium.org,
        jiapeng.chong@linux.alibaba.com, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 21/93] crypto: octeontx2 - fix potential null pointer access
Date:   Thu, 11 Aug 2022 11:41:15 -0400
Message-Id: <20220811154237.1531313-21-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811154237.1531313-1-sashal@kernel.org>
References: <20220811154237.1531313-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Shijith Thotton <sthotton@marvell.com>

[ Upstream commit b03c0dc0788abccc7a25ef7dff5818f4123bb992 ]

Added missing checks to avoid null pointer dereference.

The patch fixes below issue reported by klocwork tool:
. Pointer 'strsep( &val, ":" )' returned from call to function 'strsep'
  at line 1608 may be NULL and will be dereferenced at line 1608. Also
  there are 2 similar errors on lines 1620, 1632 in otx2_cptpf_ucode.c.

Signed-off-by: Shijith Thotton <sthotton@marvell.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../crypto/marvell/octeontx2/otx2_cptpf_ucode.c   | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
index 9cba2f714c7e..080cbfa093ec 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
@@ -1605,7 +1605,10 @@ int otx2_cpt_dl_custom_egrp_create(struct otx2_cptpf_dev *cptpf,
 		if (!strncasecmp(val, "se", 2) && strchr(val, ':')) {
 			if (has_se || ucode_idx)
 				goto err_print;
-			tmp = strim(strsep(&val, ":"));
+			tmp = strsep(&val, ":");
+			if (!tmp)
+				goto err_print;
+			tmp = strim(tmp);
 			if (!val)
 				goto err_print;
 			if (strlen(tmp) != 2)
@@ -1617,7 +1620,10 @@ int otx2_cpt_dl_custom_egrp_create(struct otx2_cptpf_dev *cptpf,
 		} else if (!strncasecmp(val, "ae", 2) && strchr(val, ':')) {
 			if (has_ae || ucode_idx)
 				goto err_print;
-			tmp = strim(strsep(&val, ":"));
+			tmp = strsep(&val, ":");
+			if (!tmp)
+				goto err_print;
+			tmp = strim(tmp);
 			if (!val)
 				goto err_print;
 			if (strlen(tmp) != 2)
@@ -1629,7 +1635,10 @@ int otx2_cpt_dl_custom_egrp_create(struct otx2_cptpf_dev *cptpf,
 		} else if (!strncasecmp(val, "ie", 2) && strchr(val, ':')) {
 			if (has_ie || ucode_idx)
 				goto err_print;
-			tmp = strim(strsep(&val, ":"));
+			tmp = strsep(&val, ":");
+			if (!tmp)
+				goto err_print;
+			tmp = strim(tmp);
 			if (!val)
 				goto err_print;
 			if (strlen(tmp) != 2)
-- 
2.35.1

