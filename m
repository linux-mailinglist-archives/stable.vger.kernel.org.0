Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFBCC6AEC23
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbjCGRws (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:52:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232241AbjCGRwS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:52:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35123A5910
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:46:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85E67B819C2
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:46:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF055C433D2;
        Tue,  7 Mar 2023 17:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211201;
        bh=uVl/eah+6h8ysObM2Lge6bkmzbjcFM3n5bfX/rW/rmc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EQXo8Ht3jC2BZr7Ki/fn0Lo+7VSpy3pJEk5Vh5PuZzXKvyeGCwrBU8fZ1PSQvciQv
         EEdukp8GAktF7aVNfmMlPNciyfwCV1/s1px8PXp5fdOth5vuFWuciiFBKI2HWIAMze
         z2dgWDzpwX1Su+rJjV92v7lCk3ty6+Qsx+DycSFs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.2 0785/1001] ksmbd: fix wrong data area length for smb2 lock request
Date:   Tue,  7 Mar 2023 17:59:17 +0100
Message-Id: <20230307170055.810591784@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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
@@ -149,15 +149,11 @@ static int smb2_get_data_area_len(unsign
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


