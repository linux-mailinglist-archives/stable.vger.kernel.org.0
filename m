Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58D5E6AF164
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233120AbjCGSnD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:43:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233165AbjCGSmc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:42:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B944298CA
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:33:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CCD261552
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:33:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54B0FC433D2;
        Tue,  7 Mar 2023 18:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213984;
        bh=swe+fv2gW2cv8UkPMJ5Wy5w9GKEuQATIBNcz8PXmWRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aDdiBd6Dl8GNoXLBUce+PWAW5tibPfznaG1q3B46FBDfoNoBuu6xg8xZwER9yjflP
         6WSUESCkZJIJiboWywSfsZ97GlQS2WX56UeyU/Vt4oc4TNUR8FVXg+3hZF2Qw8Xh5C
         91IBRwdF7q2536XSDJRUyMDaGtDwq6PngFP6BpKo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 684/885] ksmbd: do not allow the actual frame length to be smaller than the rfc1002 length
Date:   Tue,  7 Mar 2023 18:00:18 +0100
Message-Id: <20230307170031.838189634@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

commit fb533473d1595fe79ecb528fda1de33552b07178 upstream.

ksmbd allowed the actual frame length to be smaller than the rfc1002
length. If allowed, it is possible to allocates a large amount of memory
that can be limited by credit management and can eventually cause memory
exhaustion problem. This patch do not allow it except SMB2 Negotiate
request which will be validated when message handling proceeds.
Also, Allow a message that padded to 8byte boundary.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2misc.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

--- a/fs/ksmbd/smb2misc.c
+++ b/fs/ksmbd/smb2misc.c
@@ -408,20 +408,19 @@ int ksmbd_smb2_check_message(struct ksmb
 			goto validate_credit;
 
 		/*
-		 * windows client also pad up to 8 bytes when compounding.
-		 * If pad is longer than eight bytes, log the server behavior
-		 * (once), since may indicate a problem but allow it and
-		 * continue since the frame is parseable.
+		 * SMB2 NEGOTIATE request will be validated when message
+		 * handling proceeds.
 		 */
-		if (clc_len < len) {
-			ksmbd_debug(SMB,
-				    "cli req padded more than expected. Length %d not %d for cmd:%d mid:%llu\n",
-				    len, clc_len, command,
-				    le64_to_cpu(hdr->MessageId));
+		if (command == SMB2_NEGOTIATE_HE)
 			goto validate_credit;
-		}
 
-		ksmbd_debug(SMB,
+		/*
+		 * Allow a message that padded to 8byte boundary.
+		 */
+		if (clc_len < len && (len - clc_len) < 8)
+			goto validate_credit;
+
+		pr_err_ratelimited(
 			    "cli req too short, len %d not %d. cmd:%d mid:%llu\n",
 			    len, clc_len, command,
 			    le64_to_cpu(hdr->MessageId));


