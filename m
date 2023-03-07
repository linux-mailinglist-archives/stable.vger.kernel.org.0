Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC4256AF4DF
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:20:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233952AbjCGTU5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:20:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233954AbjCGTU3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:20:29 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F03D00B1
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:04:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 849DDCE1C5D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:04:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72C1DC433EF;
        Tue,  7 Mar 2023 19:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215853;
        bh=cTTTpAImm4spEbGfphMmFMfPxetuJ0aXloV/irLSgCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vNd0xojFEpm/WWFZyLYy0Tdxo8OXpK3CscioNZFHEYczde8Y8HV4MacBC5W+QMWkd
         jcAuQBsBlSGL/e4+t32NCIxNFI9ZdVACuFXRvHf0VJ89bg7ZXOPVyXoOO1lwbYo0du
         2rGDKIsxa7iBgZkfPKZWL3DG9wgHuRDuKP2YvDzQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jan Harkes <jaharkes@cs.cmu.edu>,
        coda@cs.cmu.edu, codalist@coda.cs.cmu.edu,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 394/567] coda: Avoid partial allocation of sig_inputArgs
Date:   Tue,  7 Mar 2023 18:02:10 +0100
Message-Id: <20230307165922.927945294@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 48df133578c70185a95a49390d42df1996ddba2a ]

GCC does not like having a partially allocated object, since it cannot
reason about it for bounds checking when it is passed to other code.
Instead, fully allocate sig_inputArgs. (Alternatively, sig_inputArgs
should be defined as a struct coda_in_hdr, if it is actually not using
any other part of the union.) Seen under GCC 13:

../fs/coda/upcall.c: In function 'coda_upcall':
../fs/coda/upcall.c:801:22: warning: array subscript 'union inputArgs[0]' is partly outside array bounds of 'unsigned char[20]' [-Warray-bounds=]
  801 |         sig_inputArgs->ih.opcode = CODA_SIGNAL;
      |                      ^~

Cc: Jan Harkes <jaharkes@cs.cmu.edu>
Cc: coda@cs.cmu.edu
Cc: codalist@coda.cs.cmu.edu
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20230127223921.never.882-kees@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/coda/upcall.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/coda/upcall.c b/fs/coda/upcall.c
index eb3b1898da462..610484c90260b 100644
--- a/fs/coda/upcall.c
+++ b/fs/coda/upcall.c
@@ -790,7 +790,7 @@ static int coda_upcall(struct venus_comm *vcp,
 	sig_req = kmalloc(sizeof(struct upc_req), GFP_KERNEL);
 	if (!sig_req) goto exit;
 
-	sig_inputArgs = kvzalloc(sizeof(struct coda_in_hdr), GFP_KERNEL);
+	sig_inputArgs = kvzalloc(sizeof(*sig_inputArgs), GFP_KERNEL);
 	if (!sig_inputArgs) {
 		kfree(sig_req);
 		goto exit;
-- 
2.39.2



