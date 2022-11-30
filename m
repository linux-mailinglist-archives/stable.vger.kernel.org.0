Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4351563DDBD
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbiK3SaH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:30:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbiK3S37 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:29:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91B588DFC6
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:29:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3FAE5B81B41
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:29:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4B45C433D6;
        Wed, 30 Nov 2022 18:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669832992;
        bh=znRJbUmv+wwknGW70xiegCD89z+SP01c/rJ5PIHJQzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bg+W8eef4YGo9W5jbnASYuXQ0tj3fuBQPwENWiPLPkrPTcqHDH7JIUrXx/d/8rHoF
         +19IG+SJNBlTtaV2tYnTVA5weYRqXYNgWJz1bKUsYxo+wydQ3aeBZS+WB9AHRgG8QD
         gQnCTJ5cjEnApEGLf9yrlBtbs3SfShMdURZpivjM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xiubo Li <xiubli@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Aaron Tomlin <atomlin@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 113/162] ceph: fix possible NULL pointer dereference for req->r_session
Date:   Wed, 30 Nov 2022 19:23:14 +0100
Message-Id: <20221130180531.552731658@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
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

From: Xiubo Li <xiubli@redhat.com>

[ Upstream commit 7acae6183cf37c48b8da48bbbdb78820fb3913f3 ]

The request will be inserted into the ci->i_unsafe_dirops before
assigning the req->r_session, so it's possible that we will hit
NULL pointer dereference bug here.

Cc: stable@vger.kernel.org
URL: https://tracker.ceph.com/issues/55327
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Tested-by: Aaron Tomlin <atomlin@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Stable-dep-of: 5bd76b8de5b7 ("ceph: fix NULL pointer dereference for req->r_session")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/caps.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 4e2fada35808..ce6a858e765a 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2346,6 +2346,8 @@ static int unsafe_request_wait(struct inode *inode)
 			list_for_each_entry(req, &ci->i_unsafe_dirops,
 					    r_unsafe_dir_item) {
 				s = req->r_session;
+				if (!s)
+					continue;
 				if (unlikely(s->s_mds >= max_sessions)) {
 					spin_unlock(&ci->i_unsafe_lock);
 					for (i = 0; i < max_sessions; i++) {
@@ -2366,6 +2368,8 @@ static int unsafe_request_wait(struct inode *inode)
 			list_for_each_entry(req, &ci->i_unsafe_iops,
 					    r_unsafe_target_item) {
 				s = req->r_session;
+				if (!s)
+					continue;
 				if (unlikely(s->s_mds >= max_sessions)) {
 					spin_unlock(&ci->i_unsafe_lock);
 					for (i = 0; i < max_sessions; i++) {
-- 
2.35.1



