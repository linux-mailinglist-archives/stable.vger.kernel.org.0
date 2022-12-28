Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC6C565848B
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:58:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235245AbiL1Q6A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:58:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235348AbiL1Q53 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:57:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08CF417E0A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:53:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9BA4CB8172A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:53:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0592EC433F1;
        Wed, 28 Dec 2022 16:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246425;
        bh=Lz6HFv6hB1O8SKx951OUDq9uAHb7zyKPj5Vcknuta0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sHMaQ7togh3UyJWbbQ9vy8k28Ns/wn2Oy/5sGqcmIC8vcJ1jlpTBqIwWocWX2mwPW
         L7dFJuXXdN0+id0wZr5a7n0Kz7M54WqwIgCBz8IOLzWR8Gyf5l1+7nJ0sJawixSnH5
         L9EbJR+VMjS4SB/devCQNuAaf3iH5ubPe+NMT0v8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Enzo Matsumiya <ematsumiya@suse.de>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.0 1070/1073] cifs: fix double-fault crash during ntlmssp
Date:   Wed, 28 Dec 2022 15:44:18 +0100
Message-Id: <20221228144357.303754026@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Paulo Alcantara <pc@cjr.nz>

commit b854b4ee66437e6e1622fda90529c814978cb4ca upstream.

The crash occurred because we were calling memzero_explicit() on an
already freed sess_data::iov[1] (ntlmsspblob) in sess_free_buffer().

Fix this by not calling memzero_explicit() on sess_data::iov[1] as
it's already by handled by callers.

Fixes: a4e430c8c8ba ("cifs: replace kfree() with kfree_sensitive() for sensitive data")
Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/sess.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -1214,16 +1214,18 @@ out_free_smb_buf:
 static void
 sess_free_buffer(struct sess_data *sess_data)
 {
-	int i;
+	struct kvec *iov = sess_data->iov;
 
-	/* zero the session data before freeing, as it might contain sensitive info (keys, etc) */
-	for (i = 0; i < 3; i++)
-		if (sess_data->iov[i].iov_base)
-			memzero_explicit(sess_data->iov[i].iov_base, sess_data->iov[i].iov_len);
+	/*
+	 * Zero the session data before freeing, as it might contain sensitive info (keys, etc).
+	 * Note that iov[1] is already freed by caller.
+	 */
+	if (sess_data->buf0_type != CIFS_NO_BUFFER && iov[0].iov_base)
+		memzero_explicit(iov[0].iov_base, iov[0].iov_len);
 
-	free_rsp_buf(sess_data->buf0_type, sess_data->iov[0].iov_base);
+	free_rsp_buf(sess_data->buf0_type, iov[0].iov_base);
 	sess_data->buf0_type = CIFS_NO_BUFFER;
-	kfree(sess_data->iov[2].iov_base);
+	kfree_sensitive(iov[2].iov_base);
 }
 
 static int


