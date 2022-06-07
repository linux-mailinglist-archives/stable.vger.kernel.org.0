Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7015254170B
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377127AbiFGU5j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378195AbiFGUzl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:55:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 951C91E1758;
        Tue,  7 Jun 2022 11:44:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C501DB8237F;
        Tue,  7 Jun 2022 18:44:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40C3EC385A2;
        Tue,  7 Jun 2022 18:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627452;
        bh=xhwKDY0+F7XerJFPHVZJ/ecf6Vn4nsvoLVtrRM3144o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SJTrn3BrAayToj+j8iXh36uAHsd3QQg1XYGZCn1as59vGlxqBVgmu7xH74IUwR5SG
         uZDCcfWJ+/k1qpzw+wEAjCzDj4NrrhSb8hSv2AGipwzXwIMM81j2OvA7WhY0XiNcAO
         w2IpVrxEUdjfqdnnsiCdxdQ6EKDehtRGrw7gUBrE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.17 746/772] ceph: fix decoding of client session messages flags
Date:   Tue,  7 Jun 2022 19:05:38 +0200
Message-Id: <20220607165011.012168594@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luís Henriques <lhenriques@suse.de>

commit ea16567f11018e2f58e72b667b0c803ff92b8153 upstream.

The cephfs kernel client started to show  the message:

 ceph: mds0 session blocklisted

when mounting a filesystem.  This is due to the fact that the session
messages are being incorrectly decoded: the skip needs to take into
account the 'len'.

While there, fixed some whitespaces too.

Cc: stable@vger.kernel.org
Fixes: e1c9788cb397 ("ceph: don't rely on error_string to validate blocklisted session.")
Signed-off-by: Luís Henriques <lhenriques@suse.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/mds_client.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -3378,13 +3378,17 @@ static void handle_session(struct ceph_m
 	}
 
 	if (msg_version >= 5) {
-		u32 flags;
-		/* version >= 4, struct_v, struct_cv, len, metric_spec */
-	        ceph_decode_skip_n(&p, end, 2 + sizeof(u32) * 2, bad);
+		u32 flags, len;
+
+		/* version >= 4 */
+		ceph_decode_skip_16(&p, end, bad); /* struct_v, struct_cv */
+		ceph_decode_32_safe(&p, end, len, bad); /* len */
+		ceph_decode_skip_n(&p, end, len, bad); /* metric_spec */
+
 		/* version >= 5, flags   */
-                ceph_decode_32_safe(&p, end, flags, bad);
+		ceph_decode_32_safe(&p, end, flags, bad);
 		if (flags & CEPH_SESSION_BLOCKLISTED) {
-		        pr_warn("mds%d session blocklisted\n", session->s_mds);
+			pr_warn("mds%d session blocklisted\n", session->s_mds);
 			blocklisted = true;
 		}
 	}


