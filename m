Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 000F163DDB5
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbiK3S3s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:29:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbiK3S3o (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:29:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A1678D679
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:29:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00016B81B41
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:29:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 549E0C433D7;
        Wed, 30 Nov 2022 18:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669832980;
        bh=h/l+CoPqcrDuwkROOkJYTZNIOs5kf0Nh00+fu9NG14U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uqf7llNtbjRXxOB+KEk1MVTPqdToTL08YmdM/ZTPCQNFMo5wpuSkQvj5T5lkiSqJP
         fcSeP6Jm8XZAEu1c4coN+psnMoAMXdV0k2VCvjnhlzRA0XRivWvGy3f25qW+u7L300
         QvIRyGKcwPBWcpX39UOI2D0gHtCfluzZy2+xoowM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xiubo Li <xiubli@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 109/162] ceph: flush mdlog before umounting
Date:   Wed, 30 Nov 2022 19:23:10 +0100
Message-Id: <20221130180531.444196192@linuxfoundation.org>
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

[ Upstream commit d095559ce4100f0c02aea229705230deac329c97 ]

Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Stable-dep-of: 5bd76b8de5b7 ("ceph: fix NULL pointer dereference for req->r_session")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/mds_client.c         | 25 +++++++++++++++++++++++++
 fs/ceph/mds_client.h         |  1 +
 fs/ceph/strings.c            |  1 +
 include/linux/ceph/ceph_fs.h |  1 +
 4 files changed, 28 insertions(+)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 45587b3025e4..fa51872ff850 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4664,6 +4664,30 @@ static void wait_requests(struct ceph_mds_client *mdsc)
 	dout("wait_requests done\n");
 }
 
+void send_flush_mdlog(struct ceph_mds_session *s)
+{
+	struct ceph_msg *msg;
+
+	/*
+	 * Pre-luminous MDS crashes when it sees an unknown session request
+	 */
+	if (!CEPH_HAVE_FEATURE(s->s_con.peer_features, SERVER_LUMINOUS))
+		return;
+
+	mutex_lock(&s->s_mutex);
+	dout("request mdlog flush to mds%d (%s)s seq %lld\n", s->s_mds,
+	     ceph_session_state_name(s->s_state), s->s_seq);
+	msg = ceph_create_session_msg(CEPH_SESSION_REQUEST_FLUSH_MDLOG,
+				      s->s_seq);
+	if (!msg) {
+		pr_err("failed to request mdlog flush to mds%d (%s) seq %lld\n",
+		       s->s_mds, ceph_session_state_name(s->s_state), s->s_seq);
+	} else {
+		ceph_con_send(&s->s_con, msg);
+	}
+	mutex_unlock(&s->s_mutex);
+}
+
 /*
  * called before mount is ro, and before dentries are torn down.
  * (hmm, does this still race with new lookups?)
@@ -4673,6 +4697,7 @@ void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc)
 	dout("pre_umount\n");
 	mdsc->stopping = 1;
 
+	ceph_mdsc_iterate_sessions(mdsc, send_flush_mdlog, true);
 	ceph_mdsc_iterate_sessions(mdsc, lock_unlock_session, false);
 	ceph_flush_dirty_caps(mdsc);
 	wait_requests(mdsc);
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 88fc80832016..a92e42e8a9f8 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -518,6 +518,7 @@ static inline void ceph_mdsc_put_request(struct ceph_mds_request *req)
 	kref_put(&req->r_kref, ceph_mdsc_release_request);
 }
 
+extern void send_flush_mdlog(struct ceph_mds_session *s);
 extern void ceph_mdsc_iterate_sessions(struct ceph_mds_client *mdsc,
 				       void (*cb)(struct ceph_mds_session *),
 				       bool check_state);
diff --git a/fs/ceph/strings.c b/fs/ceph/strings.c
index 4a79f3632260..573bb9556fb5 100644
--- a/fs/ceph/strings.c
+++ b/fs/ceph/strings.c
@@ -46,6 +46,7 @@ const char *ceph_session_op_name(int op)
 	case CEPH_SESSION_FLUSHMSG_ACK: return "flushmsg_ack";
 	case CEPH_SESSION_FORCE_RO: return "force_ro";
 	case CEPH_SESSION_REJECT: return "reject";
+	case CEPH_SESSION_REQUEST_FLUSH_MDLOG: return "flush_mdlog";
 	}
 	return "???";
 }
diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
index 455e9b9e2adf..8287382d3d1d 100644
--- a/include/linux/ceph/ceph_fs.h
+++ b/include/linux/ceph/ceph_fs.h
@@ -288,6 +288,7 @@ enum {
 	CEPH_SESSION_FLUSHMSG_ACK,
 	CEPH_SESSION_FORCE_RO,
 	CEPH_SESSION_REJECT,
+	CEPH_SESSION_REQUEST_FLUSH_MDLOG,
 };
 
 extern const char *ceph_session_op_name(int op);
-- 
2.35.1



