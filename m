Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9CE1D0EC3
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387451AbgEMJuK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:50:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:49826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387448AbgEMJuJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:50:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED8A9206D6;
        Wed, 13 May 2020 09:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363409;
        bh=YoXHFMlvuBDLbaC0h6kGRTwYbgdqwB7bsZo21oJfg20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U/d3MjjDIldbEH7tyEeMzbDw8CNYJzunGGQBFQ3/NmOdFIp7zi8ZcKW0UwMx49ldW
         0SIvYKdZLNWlDwOs35xLOyVSuZNaSfbqDxhhurB4+B2Tj+DOBrMODBCoNMdo+RnEvy
         ++XopfF0mvS1JgcrEWxh8WFHaXN+tpoh2qWCEaww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        "Yan, Zheng" <zyan@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        Eduard Shishkin <edward6@linux.ibm.com>
Subject: [PATCH 5.4 62/90] ceph: fix endianness bug when handling MDS session feature bits
Date:   Wed, 13 May 2020 11:44:58 +0200
Message-Id: <20200513094416.106484588@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094408.810028856@linuxfoundation.org>
References: <20200513094408.810028856@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

commit 0fa8263367db9287aa0632f96c1a5f93cc478150 upstream.

Eduard reported a problem mounting cephfs on s390 arch. The feature
mask sent by the MDS is little-endian, so we need to convert it
before storing and testing against it.

Cc: stable@vger.kernel.org
Reported-and-Tested-by: Eduard Shishkin <edward6@linux.ibm.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: "Yan, Zheng" <zyan@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ceph/mds_client.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -3072,8 +3072,7 @@ static void handle_session(struct ceph_m
 	void *end = p + msg->front.iov_len;
 	struct ceph_mds_session_head *h;
 	u32 op;
-	u64 seq;
-	unsigned long features = 0;
+	u64 seq, features = 0;
 	int wake = 0;
 	bool blacklisted = false;
 
@@ -3092,9 +3091,8 @@ static void handle_session(struct ceph_m
 			goto bad;
 		/* version >= 3, feature bits */
 		ceph_decode_32_safe(&p, end, len, bad);
-		ceph_decode_need(&p, end, len, bad);
-		memcpy(&features, p, min_t(size_t, len, sizeof(features)));
-		p += len;
+		ceph_decode_64_safe(&p, end, features, bad);
+		p += len - sizeof(features);
 	}
 
 	mutex_lock(&mdsc->mutex);


