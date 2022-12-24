Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9B165572A
	for <lists+stable@lfdr.de>; Sat, 24 Dec 2022 02:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236600AbiLXBcg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Dec 2022 20:32:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236605AbiLXBb6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Dec 2022 20:31:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C57149588;
        Fri, 23 Dec 2022 17:30:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9156DB821BA;
        Sat, 24 Dec 2022 01:30:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F37EC433EF;
        Sat, 24 Dec 2022 01:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671845430;
        bh=DfOg0MeNK9vqD6Q+lI5LXysBvJ+WQsbYuUS6GqR3FNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=scIxe646cOLm0B1B6VPzYuVmc5f2chN47Z6GaTzsy+QAdjdP0OfMk2VaW5PiHdre0
         andb7GV9MOsw8kRJqUik2QuL5ViQQ+C3beaXBRSHpZ6wyab51o6537ywREesX5Wp8l
         Jir7oTiyrNvUhgzKD3/WPAcdeApSnU8VDyBK+u66t7g1xEydxwoF3n0BoKYrJiXpXz
         td0O+pFZe3FTOCUldsah7phrVdn5Ke4wlWANQSxRp+zoHAFi4AJV1qtVGGTSHJ501O
         KYblBl/PKNE/CmT2nWQvAwE0FnT6JH4NxLRcadWX6T8agKbqpQwBubNdwln8mWMGRQ
         fN/cRo3SboJqA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marios Makassikis <mmakassikis@freebox.fr>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, sfrench@samba.org,
        linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 23/26] ksmbd: Fix resource leak in smb2_lock()
Date:   Fri, 23 Dec 2022 20:29:27 -0500
Message-Id: <20221224012930.392358-23-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221224012930.392358-1-sashal@kernel.org>
References: <20221224012930.392358-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marios Makassikis <mmakassikis@freebox.fr>

[ Upstream commit 01f6c61bae3d658058ee6322af77acea26a5ee3a ]

"flock" is leaked if an error happens before smb2_lock_init(), as the
lock is not added to the lock_list to be cleaned up.

Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index b2fc85d440d0..58da085413a6 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -6855,6 +6855,7 @@ int smb2_lock(struct ksmbd_work *work)
 		if (lock_start > U64_MAX - lock_length) {
 			pr_err("Invalid lock range requested\n");
 			rsp->hdr.Status = STATUS_INVALID_LOCK_RANGE;
+			locks_free_lock(flock);
 			goto out;
 		}
 
@@ -6874,6 +6875,7 @@ int smb2_lock(struct ksmbd_work *work)
 				    "the end offset(%llx) is smaller than the start offset(%llx)\n",
 				    flock->fl_end, flock->fl_start);
 			rsp->hdr.Status = STATUS_INVALID_LOCK_RANGE;
+			locks_free_lock(flock);
 			goto out;
 		}
 
@@ -6885,6 +6887,7 @@ int smb2_lock(struct ksmbd_work *work)
 				    flock->fl_type != F_UNLCK) {
 					pr_err("conflict two locks in one request\n");
 					err = -EINVAL;
+					locks_free_lock(flock);
 					goto out;
 				}
 			}
@@ -6893,6 +6896,7 @@ int smb2_lock(struct ksmbd_work *work)
 		smb_lock = smb2_lock_init(flock, cmd, flags, &lock_list);
 		if (!smb_lock) {
 			err = -EINVAL;
+			locks_free_lock(flock);
 			goto out;
 		}
 	}
-- 
2.35.1

