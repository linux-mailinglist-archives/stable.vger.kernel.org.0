Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A37F63DD65
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbiK3S1D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:27:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbiK3S0u (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:26:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E79801C407
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:26:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C368061B43
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:26:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D38FFC433C1;
        Wed, 30 Nov 2022 18:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669832796;
        bh=ex35Ym+SjGq5A08TtxO4bLLtXTo7vLymLfxusPR0OHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hIMxKTNT3JRxOwCi3SOEPX7f6f+Uo6K8bxKu+JOQRemu4ZDg4Q90Bxi7Vjp15zYuz
         fd/rumNDbsFNW/Z2UZS/FhUze5Mgsk8Vc5GxstpzIauVwwkbgfNts82hQVuUSUewZV
         3jD6SQSprr0tI8+EVOE3COyIYWzPHuuxtYnyyy0U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xiubo Li <xiubli@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 014/162] ceph: avoid putting the realm twice when decoding snaps fails
Date:   Wed, 30 Nov 2022 19:21:35 +0100
Message-Id: <20221130180528.881085274@linuxfoundation.org>
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

[ Upstream commit 51884d153f7ec85e18d607b2467820a90e0f4359 ]

When decoding the snaps fails it maybe leaving the 'first_realm'
and 'realm' pointing to the same snaprealm memory. And then it'll
put it twice and could cause random use-after-free, BUG_ON, etc
issues.

Cc: stable@vger.kernel.org
Link: https://tracker.ceph.com/issues/57686
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/snap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index e779f0e2bdb8..734873be56a7 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -697,7 +697,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 	struct ceph_mds_snap_realm *ri;    /* encoded */
 	__le64 *snaps;                     /* encoded */
 	__le64 *prior_parent_snaps;        /* encoded */
-	struct ceph_snap_realm *realm = NULL;
+	struct ceph_snap_realm *realm;
 	struct ceph_snap_realm *first_realm = NULL;
 	struct ceph_snap_realm *realm_to_rebuild = NULL;
 	int rebuild_snapcs;
@@ -708,6 +708,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 
 	dout("update_snap_trace deletion=%d\n", deletion);
 more:
+	realm = NULL;
 	rebuild_snapcs = 0;
 	ceph_decode_need(&p, e, sizeof(*ri), bad);
 	ri = p;
-- 
2.35.1



