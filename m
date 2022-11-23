Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D77C6358F5
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 11:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236171AbiKWKFA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 05:05:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235735AbiKWKEK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 05:04:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81AB759863
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:55:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35884B81EE5
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:55:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 050E1C433C1;
        Wed, 23 Nov 2022 09:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197326;
        bh=KqBdRgd8GuoJrm8d69kRWRWV8L8holBx0ci/0UsLcM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VSBvPzoMTM0hEADmwgBd9P2abN9k4DS/vHEGy09Ne2yVAfEyN+43DQXdWLnWrZWjy
         MzNNfwxJzpM9UsVx3j8UDO0oizPGnplUGoRWvCV5rHrajDbDv/r4et8gv3w4WChc6b
         +mrzuzDe7keY4aRJn2+keb8Iy6hh9aJ6dIC0ToZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xiubo Li <xiubli@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.0 261/314] ceph: avoid putting the realm twice when decoding snaps fails
Date:   Wed, 23 Nov 2022 09:51:46 +0100
Message-Id: <20221123084637.346671339@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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

commit 51884d153f7ec85e18d607b2467820a90e0f4359 upstream.

When decoding the snaps fails it maybe leaving the 'first_realm'
and 'realm' pointing to the same snaprealm memory. And then it'll
put it twice and could cause random use-after-free, BUG_ON, etc
issues.

Cc: stable@vger.kernel.org
Link: https://tracker.ceph.com/issues/57686
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/snap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -763,7 +763,7 @@ int ceph_update_snap_trace(struct ceph_m
 	struct ceph_mds_snap_realm *ri;    /* encoded */
 	__le64 *snaps;                     /* encoded */
 	__le64 *prior_parent_snaps;        /* encoded */
-	struct ceph_snap_realm *realm = NULL;
+	struct ceph_snap_realm *realm;
 	struct ceph_snap_realm *first_realm = NULL;
 	struct ceph_snap_realm *realm_to_rebuild = NULL;
 	int rebuild_snapcs;
@@ -774,6 +774,7 @@ int ceph_update_snap_trace(struct ceph_m
 
 	dout("%s deletion=%d\n", __func__, deletion);
 more:
+	realm = NULL;
 	rebuild_snapcs = 0;
 	ceph_decode_need(&p, e, sizeof(*ri), bad);
 	ri = p;


