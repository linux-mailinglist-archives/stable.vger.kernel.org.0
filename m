Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE2759D4CF
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243734AbiHWIcu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:32:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346772AbiHWIcD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:32:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 114DF753A2;
        Tue, 23 Aug 2022 01:16:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ECDE2B81C3B;
        Tue, 23 Aug 2022 08:16:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D5EFC433C1;
        Tue, 23 Aug 2022 08:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242559;
        bh=yqioFLrizC8M8c2foLHq0k3WOiVIEJzln4BUfFhPahY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x0BAJAEN/vFXHCuKhgKIZhRfYABcsW0ur5fCO06TY6LA5xPZZguTgKzYuLX//OHTY
         4YsnAO7FmHFIqGjG0QEHuO01iGH2Z1tG9sQcMh2EU5B0zpRr0GCBJlWBqivumkioKM
         xBqkjBv9LZpjDEkYXMHsBPdlaFjhieeDTxr2fEj0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>,
        Jeff Layton <jlayton@kernel.org>, Xiubo Li <xiubli@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.19 137/365] ceph: use correct index when encoding client supported features
Date:   Tue, 23 Aug 2022 10:00:38 +0200
Message-Id: <20220823080123.937414439@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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

From: Luís Henriques <lhenriques@suse.de>

commit fea013e020e6ecc7be75bea0d61697b7e916b44d upstream.

Feature bits have to be encoded into the correct locations.  This hasn't
been an issue so far because the only hole in the feature bits was in bit
10 (CEPHFS_FEATURE_RECLAIM_CLIENT), which is located in the 2nd byte.  When
adding more bits that go beyond the this 2nd byte, the bug will show up.

[xiubli: remove incorrect comment for CEPHFS_FEATURES_CLIENT_SUPPORTED]

Fixes: 9ba1e224538a ("ceph: allocate the correct amount of extra bytes for the session features")
Signed-off-by: Luís Henriques <lhenriques@suse.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/mds_client.c |    7 +++++--
 fs/ceph/mds_client.h |    6 ------
 2 files changed, 5 insertions(+), 8 deletions(-)

--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1220,14 +1220,17 @@ static int encode_supported_features(voi
 	if (count > 0) {
 		size_t i;
 		size_t size = FEATURE_BYTES(count);
+		unsigned long bit;
 
 		if (WARN_ON_ONCE(*p + 4 + size > end))
 			return -ERANGE;
 
 		ceph_encode_32(p, size);
 		memset(*p, 0, size);
-		for (i = 0; i < count; i++)
-			((unsigned char*)(*p))[i / 8] |= BIT(feature_bits[i] % 8);
+		for (i = 0; i < count; i++) {
+			bit = feature_bits[i];
+			((unsigned char *)(*p))[bit / 8] |= BIT(bit % 8);
+		}
 		*p += size;
 	} else {
 		if (WARN_ON_ONCE(*p + 4 > end))
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -33,10 +33,6 @@ enum ceph_feature_type {
 	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_METRIC_COLLECT,
 };
 
-/*
- * This will always have the highest feature bit value
- * as the last element of the array.
- */
 #define CEPHFS_FEATURES_CLIENT_SUPPORTED {	\
 	0, 1, 2, 3, 4, 5, 6, 7,			\
 	CEPHFS_FEATURE_MIMIC,			\
@@ -45,8 +41,6 @@ enum ceph_feature_type {
 	CEPHFS_FEATURE_MULTI_RECONNECT,		\
 	CEPHFS_FEATURE_DELEG_INO,		\
 	CEPHFS_FEATURE_METRIC_COLLECT,		\
-						\
-	CEPHFS_FEATURE_MAX,			\
 }
 #define CEPHFS_FEATURES_CLIENT_REQUIRED {}
 


