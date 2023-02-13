Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 479F469492F
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbjBMO5D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:57:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbjBMO4p (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:56:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 871621C7C3
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:56:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E9C8B81262
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:56:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 741D1C433EF;
        Mon, 13 Feb 2023 14:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300173;
        bh=nVVntslMhMB/Pw4Qdn+4/dzNgAdoTjHzhuG42oa/aJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ePHM76rRJgv436VTEOn7VotDwR7ql84ICDXCpHwEjemvOsm7MZ66dmsf9CDuSE5b1
         RRpzjOe2pwCYucDveJMma6HCzEBNMkbVnYqYTOi5TvzGdz37gjLNQcodTUx9Qy06ez
         HWJiZc5GjHBsjNtvqU29BS6ixI95G/Ea8dVTNZR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xiubo Li <xiubli@redhat.com>,
        Venky Shankar <vshankar@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.1 092/114] ceph: flush cap releases when the session is flushed
Date:   Mon, 13 Feb 2023 15:48:47 +0100
Message-Id: <20230213144746.917475280@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

commit e7d84c6a1296d059389f7342d9b4b7defb518d3a upstream.

MDS expects the completed cap release prior to responding to the
session flush for cache drop.

Cc: stable@vger.kernel.org
Link: http://tracker.ceph.com/issues/38009
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Venky Shankar <vshankar@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/mds_client.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -3662,6 +3662,12 @@ static void handle_session(struct ceph_m
 		break;
 
 	case CEPH_SESSION_FLUSHMSG:
+		/* flush cap releases */
+		spin_lock(&session->s_cap_lock);
+		if (session->s_num_cap_releases)
+			ceph_flush_cap_releases(mdsc, session);
+		spin_unlock(&session->s_cap_lock);
+
 		send_flushmsg_ack(mdsc, session, seq);
 		break;
 


