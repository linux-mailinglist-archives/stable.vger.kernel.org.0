Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9379657A77
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232944AbiL1PLi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:11:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233702AbiL1PLX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:11:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 904BC13E0C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:11:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D5E1B81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:11:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E8CDC433D2;
        Wed, 28 Dec 2022 15:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240279;
        bh=XhIkxpjGl+KN0Xta15eL1+uI4jJqKZPhMhOir7GTUos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1+bLYbDad4XNa05tvXFqumpuxZWhXBNw+Y9uu4fMTKpqMuAqanG+jtknV6sAXGRcz
         GHqL2ndx6tkxJQ9JWtDot9yxWmmQMPbxzi8npHXru33UOsVpIuSUKadpFcmu7AeXmN
         OCOHwseZFsNmS2a/WMCeiaZpZIMp75329SCZeZi4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhi Li <yieli@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0142/1073] nfsd: dont call nfsd_file_put from client states seqfile display
Date:   Wed, 28 Dec 2022 15:28:50 +0100
Message-Id: <20221228144331.885472634@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit e0aa651068bfd520afcd357af8ecd2de005fc83d ]

We had a report of this:

    BUG: sleeping function called from invalid context at fs/nfsd/filecache.c:440

...with a stack trace showing nfsd_file_put being called from
nfs4_show_open. This code has always tried to call fput while holding a
spinlock, but we recently changed this to use the filecache, and that
started triggering the might_sleep() in nfsd_file_put.

states_start takes and holds the cl_lock while iterating over the
client's states, and we can't sleep with that held.

Have the various nfs4_show_* functions instead hold the fi_lock instead
of taking a nfsd_file reference.

Fixes: 78599c42ae3c ("nfsd4: add file to display list of client's opens")
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2138357
Reported-by: Zhi Li <yieli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 51 +++++++++++++++++++++++++++++----------------
 1 file changed, 33 insertions(+), 18 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index ddb2bf078fda..94420fad4c41 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -664,15 +664,26 @@ find_any_file(struct nfs4_file *f)
 	return ret;
 }
 
-static struct nfsd_file *find_deleg_file(struct nfs4_file *f)
+static struct nfsd_file *find_any_file_locked(struct nfs4_file *f)
 {
-	struct nfsd_file *ret = NULL;
+	lockdep_assert_held(&f->fi_lock);
+
+	if (f->fi_fds[O_RDWR])
+		return f->fi_fds[O_RDWR];
+	if (f->fi_fds[O_WRONLY])
+		return f->fi_fds[O_WRONLY];
+	if (f->fi_fds[O_RDONLY])
+		return f->fi_fds[O_RDONLY];
+	return NULL;
+}
+
+static struct nfsd_file *find_deleg_file_locked(struct nfs4_file *f)
+{
+	lockdep_assert_held(&f->fi_lock);
 
-	spin_lock(&f->fi_lock);
 	if (f->fi_deleg_file)
-		ret = nfsd_file_get(f->fi_deleg_file);
-	spin_unlock(&f->fi_lock);
-	return ret;
+		return f->fi_deleg_file;
+	return NULL;
 }
 
 static atomic_long_t num_delegations;
@@ -2606,9 +2617,11 @@ static int nfs4_show_open(struct seq_file *s, struct nfs4_stid *st)
 	ols = openlockstateid(st);
 	oo = ols->st_stateowner;
 	nf = st->sc_file;
-	file = find_any_file(nf);
+
+	spin_lock(&nf->fi_lock);
+	file = find_any_file_locked(nf);
 	if (!file)
-		return 0;
+		goto out;
 
 	seq_printf(s, "- ");
 	nfs4_show_stateid(s, &st->sc_stateid);
@@ -2630,8 +2643,8 @@ static int nfs4_show_open(struct seq_file *s, struct nfs4_stid *st)
 	seq_printf(s, ", ");
 	nfs4_show_owner(s, oo);
 	seq_printf(s, " }\n");
-	nfsd_file_put(file);
-
+out:
+	spin_unlock(&nf->fi_lock);
 	return 0;
 }
 
@@ -2645,9 +2658,10 @@ static int nfs4_show_lock(struct seq_file *s, struct nfs4_stid *st)
 	ols = openlockstateid(st);
 	oo = ols->st_stateowner;
 	nf = st->sc_file;
-	file = find_any_file(nf);
+	spin_lock(&nf->fi_lock);
+	file = find_any_file_locked(nf);
 	if (!file)
-		return 0;
+		goto out;
 
 	seq_printf(s, "- ");
 	nfs4_show_stateid(s, &st->sc_stateid);
@@ -2667,8 +2681,8 @@ static int nfs4_show_lock(struct seq_file *s, struct nfs4_stid *st)
 	seq_printf(s, ", ");
 	nfs4_show_owner(s, oo);
 	seq_printf(s, " }\n");
-	nfsd_file_put(file);
-
+out:
+	spin_unlock(&nf->fi_lock);
 	return 0;
 }
 
@@ -2680,9 +2694,10 @@ static int nfs4_show_deleg(struct seq_file *s, struct nfs4_stid *st)
 
 	ds = delegstateid(st);
 	nf = st->sc_file;
-	file = find_deleg_file(nf);
+	spin_lock(&nf->fi_lock);
+	file = find_deleg_file_locked(nf);
 	if (!file)
-		return 0;
+		goto out;
 
 	seq_printf(s, "- ");
 	nfs4_show_stateid(s, &st->sc_stateid);
@@ -2698,8 +2713,8 @@ static int nfs4_show_deleg(struct seq_file *s, struct nfs4_stid *st)
 	seq_printf(s, ", ");
 	nfs4_show_fname(s, file);
 	seq_printf(s, " }\n");
-	nfsd_file_put(file);
-
+out:
+	spin_unlock(&nf->fi_lock);
 	return 0;
 }
 
-- 
2.35.1



