Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2FE6378570
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235209AbhEJLA0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:00:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:52982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234213AbhEJK4E (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:56:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7565B61139;
        Mon, 10 May 2021 10:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643477;
        bh=UjLchi33039/P+2VzbIfD80p4KMOiN1ExVFAIL89Kns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dUaNPMo1b2tWBl+Bw1AiZiFsYbFZX/xne/mMaOyxSL31MGxovq9gnpplMbfLee7ja
         oQxdy4j9KztQBJlDDSu38PIJdB/xp9o3hNZt3qUeUCQBrCrSw0nwwzK+sLWG1UeoxE
         zAZJ1EhjQZ3BhPO3L3RwWQK0obqxyE5wpMo8Bs6A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>,
        Sage Weil <sage@redhat.com>
Subject: [PATCH 5.11 031/342] libceph: bump CephXAuthenticate encoding version
Date:   Mon, 10 May 2021 12:17:01 +0200
Message-Id: <20210510102011.134876262@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Dryomov <idryomov@gmail.com>

commit 7807dafda21a549403d922da98dde0ddfeb70d08 upstream.

A dummy v3 encoding (exactly the same as v2) was introduced so that
the monitors can distinguish broken clients that may not include their
auth ticket in CEPHX_GET_AUTH_SESSION_KEY request on reconnects, thus
failing to prove previous possession of their global_id (one part of
CVE-2021-20288).

The kernel client has always included its auth ticket, so it is
compatible with enforcing mode as is.  However we want to bump the
encoding version to avoid having to authenticate twice on the initial
connect -- all legacy (CephXAuthenticate < v3) are now forced do so in
order to expose insecure global_id reclaim.

Marking for stable since at least for 5.11 and 5.12 it is trivial
(v2 -> v3).

Cc: stable@vger.kernel.org # 5.11+
URL: https://tracker.ceph.com/issues/50452
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Sage Weil <sage@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/auth_x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ceph/auth_x.c
+++ b/net/ceph/auth_x.c
@@ -526,7 +526,7 @@ static int ceph_x_build_request(struct c
 		if (ret < 0)
 			return ret;
 
-		auth->struct_v = 2;  /* nautilus+ */
+		auth->struct_v = 3;  /* nautilus+ */
 		auth->key = 0;
 		for (u = (u64 *)enc_buf; u + 1 <= (u64 *)(enc_buf + ret); u++)
 			auth->key ^= *(__le64 *)u;


