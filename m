Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF8559DB71
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358621AbiHWLwa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358553AbiHWLtl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:49:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A7EB92F46;
        Tue, 23 Aug 2022 02:31:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D1C561381;
        Tue, 23 Aug 2022 09:30:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F131C433D7;
        Tue, 23 Aug 2022 09:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247059;
        bh=Ne3K/j/VipnKWLDZjV6LfWdx25jnEHJrWPEorkBP+LE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xv28e3cr6+STdr61F12VT6ky+Smacik9H5NktWzx5wQEJCVOpmP9FTRqe7bh34DPM
         yIJrmRlBgJWwLP3w8TjUy2BnhWj3aywk0jNbwhTz/3bQSV68Hz4iBNcE9rpW53XrOM
         VKdIQ/jsAu2QXz9vJYxl4ElSQDKfFvyCTSsEnexc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.4 306/389] NFSv4/pnfs: Fix a use-after-free bug in open
Date:   Tue, 23 Aug 2022 10:26:24 +0200
Message-Id: <20220823080128.365239472@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit 2135e5d56278ffdb1c2e6d325dc6b87f669b9dac upstream.

If someone cancels the open RPC call, then we must not try to free
either the open slot or the layoutget operation arguments, since they
are likely still in use by the hung RPC call.

Fixes: 6949493884fe ("NFSv4: Don't hold the layoutget locks across multiple RPC calls")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/nfs4proc.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3039,12 +3039,13 @@ static int _nfs4_open_and_get_state(stru
 	}
 
 out:
-	if (opendata->lgp) {
-		nfs4_lgopen_release(opendata->lgp);
-		opendata->lgp = NULL;
-	}
-	if (!opendata->cancelled)
+	if (!opendata->cancelled) {
+		if (opendata->lgp) {
+			nfs4_lgopen_release(opendata->lgp);
+			opendata->lgp = NULL;
+		}
 		nfs4_sequence_free_slot(&opendata->o_res.seq_res);
+	}
 	return ret;
 }
 


