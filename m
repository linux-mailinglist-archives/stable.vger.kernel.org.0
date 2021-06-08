Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A87B3A0326
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234896AbhFHTNd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:13:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:58760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236890AbhFHTLc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:11:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1358361460;
        Tue,  8 Jun 2021 18:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178136;
        bh=n5tBM1JDehct6Cw7E6PCpVT+Ew808yQHibPN7Nr+1wo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eHjYt6cAIWm+1QiIACSsid03QY2sG5pX65vyrEwt1WcYJfKM7eM+/bGk17lFbYGA5
         SL37mdYmfrunJAwQodLRdPxg2VjL0I5LXrsbjwxINnwM/qmVdvIWL4U7KLWwdg/eh0
         YVgaIdYSEsp5js/hf+B7W64EF92rCG7RpyJcb+yA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>,
        Sage Weil <sage@redhat.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 083/161] libceph: dont set global_id until we get an auth ticket
Date:   Tue,  8 Jun 2021 20:26:53 +0200
Message-Id: <20210608175948.243493420@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Dryomov <idryomov@gmail.com>

[ Upstream commit 61ca49a9105faefa003b37542cebad8722f8ae22 ]

With the introduction of enforcing mode, setting global_id as soon
as we get it in the first MAuth reply will result in EACCES if the
connection is reset before we get the second MAuth reply containing
an auth ticket -- because on retry we would attempt to reclaim that
global_id with no auth ticket at hand.

Neither ceph_auth_client nor ceph_mon_client depend on global_id
being set ealy, so just delay the setting until we get and process
the second MAuth reply.  While at it, complain if the monitor sends
a zero global_id or changes our global_id as the session is likely
to fail after that.

Cc: stable@vger.kernel.org # needs backporting for < 5.11
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Sage Weil <sage@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ceph/auth.c | 36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/net/ceph/auth.c b/net/ceph/auth.c
index eb261aa5fe18..de407e8feb97 100644
--- a/net/ceph/auth.c
+++ b/net/ceph/auth.c
@@ -36,6 +36,20 @@ static int init_protocol(struct ceph_auth_client *ac, int proto)
 	}
 }
 
+static void set_global_id(struct ceph_auth_client *ac, u64 global_id)
+{
+	dout("%s global_id %llu\n", __func__, global_id);
+
+	if (!global_id)
+		pr_err("got zero global_id\n");
+
+	if (ac->global_id && global_id != ac->global_id)
+		pr_err("global_id changed from %llu to %llu\n", ac->global_id,
+		       global_id);
+
+	ac->global_id = global_id;
+}
+
 /*
  * setup, teardown.
  */
@@ -222,11 +236,6 @@ int ceph_handle_auth_reply(struct ceph_auth_client *ac,
 
 	payload_end = payload + payload_len;
 
-	if (global_id && ac->global_id != global_id) {
-		dout(" set global_id %lld -> %lld\n", ac->global_id, global_id);
-		ac->global_id = global_id;
-	}
-
 	if (ac->negotiating) {
 		/* server does not support our protocols? */
 		if (!protocol && result < 0) {
@@ -253,11 +262,16 @@ int ceph_handle_auth_reply(struct ceph_auth_client *ac,
 
 	ret = ac->ops->handle_reply(ac, result, payload, payload_end,
 				    NULL, NULL, NULL, NULL);
-	if (ret == -EAGAIN)
+	if (ret == -EAGAIN) {
 		ret = build_request(ac, true, reply_buf, reply_len);
-	else if (ret)
+		goto out;
+	} else if (ret) {
 		pr_err("auth protocol '%s' mauth authentication failed: %d\n",
 		       ceph_auth_proto_name(ac->protocol), result);
+		goto out;
+	}
+
+	set_global_id(ac, global_id);
 
 out:
 	mutex_unlock(&ac->mutex);
@@ -484,15 +498,11 @@ int ceph_auth_handle_reply_done(struct ceph_auth_client *ac,
 	int ret;
 
 	mutex_lock(&ac->mutex);
-	if (global_id && ac->global_id != global_id) {
-		dout("%s global_id %llu -> %llu\n", __func__, ac->global_id,
-		     global_id);
-		ac->global_id = global_id;
-	}
-
 	ret = ac->ops->handle_reply(ac, 0, reply, reply + reply_len,
 				    session_key, session_key_len,
 				    con_secret, con_secret_len);
+	if (!ret)
+		set_global_id(ac, global_id);
 	mutex_unlock(&ac->mutex);
 	return ret;
 }
-- 
2.30.2



