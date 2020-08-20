Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC6724BD85
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729453AbgHTNHM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:07:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:56306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728839AbgHTJib (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:38:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A802C2173E;
        Thu, 20 Aug 2020 09:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916311;
        bh=Sc+dJRzIybQxELrEsnAJ8I+605+1r7Gbwe/S4Gebl78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wLkAvAWCaGRDEOaJT76Jprt58k/sYzCqm4p1uJiafGITqRW3ZTpHTTCaDIxrNYO03
         XsA8TDyEICD9Il1l/24KVFs+PjLcPMIhpz+Wagi0x3ROp0m8yl7r9Or4cgf4qpLbtc
         Fwh2rgFnuR6ko7OIOuAvYkQOxfulsXekUDaX9C3Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Patrick Donnelly <pdonnell@redhat.com>
Subject: [PATCH 5.7 084/204] ceph: handle zero-length feature mask in session messages
Date:   Thu, 20 Aug 2020 11:19:41 +0200
Message-Id: <20200820091610.538859326@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

commit 02e37571f9e79022498fd0525c073b07e9d9ac69 upstream.

Most session messages contain a feature mask, but the MDS will
routinely send a REJECT message with one that is zero-length.

Commit 0fa8263367db ("ceph: fix endianness bug when handling MDS
session feature bits") fixed the decoding of the feature mask,
but failed to account for the MDS sending a zero-length feature
mask. This causes REJECT message decoding to fail.

Skip trying to decode a feature mask if the word count is zero.

Cc: stable@vger.kernel.org
URL: https://tracker.ceph.com/issues/46823
Fixes: 0fa8263367db ("ceph: fix endianness bug when handling MDS session feature bits")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Tested-by: Patrick Donnelly <pdonnell@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ceph/mds_client.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -3270,8 +3270,10 @@ static void handle_session(struct ceph_m
 			goto bad;
 		/* version >= 3, feature bits */
 		ceph_decode_32_safe(&p, end, len, bad);
-		ceph_decode_64_safe(&p, end, features, bad);
-		p += len - sizeof(features);
+		if (len) {
+			ceph_decode_64_safe(&p, end, features, bad);
+			p += len - sizeof(features);
+		}
 	}
 
 	mutex_lock(&mdsc->mutex);


