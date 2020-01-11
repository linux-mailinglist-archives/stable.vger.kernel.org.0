Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28D0A137DDF
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:02:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728996AbgAKKCZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:02:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:60856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729034AbgAKKCZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:02:25 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 617CA20842;
        Sat, 11 Jan 2020 10:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578736945;
        bh=rqh2HQ0MrSBQu+Rjr4Pxb85MCFGCTcTehbCzdEyqgR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TRG/XuyfsD288rV3uTzn7J3YczCbFSNjGC0FV2mVsg94+iR7bQPq9dru4a9CqBcUh
         IyNPIfs3d6d9yOQpn0GhtGeUyXv3c3//Xw2wvNXuP6AS9Y/LTIhbDH1XWn93qX51jD
         ++bmAkr6Ghw/BL1mrSnG7s0dLP1kfHhN8n5IzXYo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Scott Mayhew <smayhew@redhat.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 4.9 35/91] nfsd4: fix up replay_matches_cache()
Date:   Sat, 11 Jan 2020 10:49:28 +0100
Message-Id: <20200111094858.163637835@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094844.748507863@linuxfoundation.org>
References: <20200111094844.748507863@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Scott Mayhew <smayhew@redhat.com>

commit 6e73e92b155c868ff7fce9d108839668caf1d9be upstream.

When running an nfs stress test, I see quite a few cached replies that
don't match up with the actual request.  The first comment in
replay_matches_cache() makes sense, but the code doesn't seem to
match... fix it.

This isn't exactly a bugfix, as the server isn't required to catch every
case of a false retry.  So, we may as well do this, but if this is
fixing a problem then that suggests there's a client bug.

Fixes: 53da6a53e1d4 ("nfsd4: catch some false session retries")
Signed-off-by: Scott Mayhew <smayhew@redhat.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4state.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -3067,12 +3067,17 @@ static bool replay_matches_cache(struct
 	    (bool)seq->cachethis)
 		return false;
 	/*
-	 * If there's an error than the reply can have fewer ops than
-	 * the call.  But if we cached a reply with *more* ops than the
-	 * call you're sending us now, then this new call is clearly not
-	 * really a replay of the old one:
+	 * If there's an error then the reply can have fewer ops than
+	 * the call.
 	 */
-	if (slot->sl_opcnt < argp->opcnt)
+	if (slot->sl_opcnt < argp->opcnt && !slot->sl_status)
+		return false;
+	/*
+	 * But if we cached a reply with *more* ops than the call you're
+	 * sending us now, then this new call is clearly not really a
+	 * replay of the old one:
+	 */
+	if (slot->sl_opcnt > argp->opcnt)
 		return false;
 	/* This is the only check explicitly called by spec: */
 	if (!same_creds(&rqstp->rq_cred, &slot->sl_cred))


