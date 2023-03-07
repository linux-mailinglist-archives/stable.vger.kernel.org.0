Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C016B6AF516
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:22:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234052AbjCGTV7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:21:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233917AbjCGTVe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:21:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C5BBDD1C
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:06:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD0E661520
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:06:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2946C4339B;
        Tue,  7 Mar 2023 19:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215993;
        bh=3+hqFyXdgYMYYXh8L/weifftQoMrvDofd56QJCZw6VQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2iDyaihSt7wMuXyLGcO5WEvZCCmPMgo2G44lorlOsvO1KIj/qchnOETx9e/AayEnR
         mo6M0v5MOuMUnFPYxtPxVwPRiSLNPpSk+32IKna/3tQ85VreltatkTTSGdQZX+JmGX
         bMT4DrSJ+8rzkVwGpor6EvkGTdRg3FYrPHVOWXmk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 441/567] ksmbd: fix wrong data area length for smb2 lock request
Date:   Tue,  7 Mar 2023 18:02:57 +0100
Message-Id: <20230307165925.013453566@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namjae Jeon <linkinjeon@kernel.org>

commit 8f8c43b125882ac14372f8dca0c8e50a59e78d79 upstream.

When turning debug mode on, The following error message from
ksmbd_smb2_check_message() is coming.

ksmbd: cli req padded more than expected. Length 112 not 88 for cmd:10 mid:14

data area length calculation for smb2 lock request in smb2_get_data_area_len() is
incorrect.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2misc.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/fs/ksmbd/smb2misc.c
+++ b/fs/ksmbd/smb2misc.c
@@ -150,15 +150,11 @@ static int smb2_get_data_area_len(unsign
 		break;
 	case SMB2_LOCK:
 	{
-		int lock_count;
+		unsigned short lock_count;
 
-		/*
-		 * smb2_lock request size is 48 included single
-		 * smb2_lock_element structure size.
-		 */
-		lock_count = le16_to_cpu(((struct smb2_lock_req *)hdr)->LockCount) - 1;
+		lock_count = le16_to_cpu(((struct smb2_lock_req *)hdr)->LockCount);
 		if (lock_count > 0) {
-			*off = __SMB2_HEADER_STRUCTURE_SIZE + 48;
+			*off = offsetof(struct smb2_lock_req, locks);
 			*len = sizeof(struct smb2_lock_element) * lock_count;
 		}
 		break;


