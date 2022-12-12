Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF7C964A235
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233064AbiLLNvW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:51:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233101AbiLLNu7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:50:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 677FA15FC9
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:50:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D1B4B80D50
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1935AC433F0;
        Mon, 12 Dec 2022 13:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670853009;
        bh=32GjUSZO50TOChG3Q65SYtHR5kPbYpCnzVf68che8L0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B8AeolKtI7m1Gx0q/FV5RJ0QuAjE7rpTvlwOvEBBIMxUbLZLc0iU1SRYhnjIu07ka
         N60Myg4gs1+VDxXWXCEAoq6V4sqOiPHfc7TBrJOYKrsx0H/0hk8wkrc/OG12VBLtGj
         mdgVNGxqL5FozGeTw71S8wmWa2q1KvI99wd53FZo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+210e196cef4711b65139@syzkaller.appspotmail.com,
        Kees Cook <keescook@chromium.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 38/49] NFC: nci: Bounds check struct nfc_target arrays
Date:   Mon, 12 Dec 2022 14:19:16 +0100
Message-Id: <20221212130915.555054531@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130913.666185567@linuxfoundation.org>
References: <20221212130913.666185567@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit e329e71013c9b5a4535b099208493c7826ee4a64 ]

While running under CONFIG_FORTIFY_SOURCE=y, syzkaller reported:

  memcpy: detected field-spanning write (size 129) of single field "target->sensf_res" at net/nfc/nci/ntf.c:260 (size 18)

This appears to be a legitimate lack of bounds checking in
nci_add_new_protocol(). Add the missing checks.

Reported-by: syzbot+210e196cef4711b65139@syzkaller.appspotmail.com
Link: https://lore.kernel.org/lkml/0000000000001c590f05ee7b3ff4@google.com
Fixes: 019c4fbaa790 ("NFC: Add NCI multiple targets support")
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20221202214410.never.693-kees@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/nci/ntf.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/nfc/nci/ntf.c b/net/nfc/nci/ntf.c
index 1e8c1a12aaec..4f75453c07aa 100644
--- a/net/nfc/nci/ntf.c
+++ b/net/nfc/nci/ntf.c
@@ -230,6 +230,8 @@ static int nci_add_new_protocol(struct nci_dev *ndev,
 		target->sens_res = nfca_poll->sens_res;
 		target->sel_res = nfca_poll->sel_res;
 		target->nfcid1_len = nfca_poll->nfcid1_len;
+		if (target->nfcid1_len > ARRAY_SIZE(target->nfcid1))
+			return -EPROTO;
 		if (target->nfcid1_len > 0) {
 			memcpy(target->nfcid1, nfca_poll->nfcid1,
 			       target->nfcid1_len);
@@ -238,6 +240,8 @@ static int nci_add_new_protocol(struct nci_dev *ndev,
 		nfcb_poll = (struct rf_tech_specific_params_nfcb_poll *)params;
 
 		target->sensb_res_len = nfcb_poll->sensb_res_len;
+		if (target->sensb_res_len > ARRAY_SIZE(target->sensb_res))
+			return -EPROTO;
 		if (target->sensb_res_len > 0) {
 			memcpy(target->sensb_res, nfcb_poll->sensb_res,
 			       target->sensb_res_len);
@@ -246,6 +250,8 @@ static int nci_add_new_protocol(struct nci_dev *ndev,
 		nfcf_poll = (struct rf_tech_specific_params_nfcf_poll *)params;
 
 		target->sensf_res_len = nfcf_poll->sensf_res_len;
+		if (target->sensf_res_len > ARRAY_SIZE(target->sensf_res))
+			return -EPROTO;
 		if (target->sensf_res_len > 0) {
 			memcpy(target->sensf_res, nfcf_poll->sensf_res,
 			       target->sensf_res_len);
-- 
2.35.1



