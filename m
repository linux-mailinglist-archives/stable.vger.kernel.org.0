Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFAFF4514C0
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344273AbhKOUMv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:12:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:45212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344943AbhKOTZr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66349636FD;
        Mon, 15 Nov 2021 19:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003243;
        bh=C8gM2fcdLMFlozC0N5gpMU6z5lj/cT4un22z9qSwOqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TRpb93K5S+S2C5mLjHzoPzoNKjuVYWcdhkjDutxlRQnu+ZtNKNwpL91+jWxjFPPam
         6QDyKCJCeFOLS4lKPzCgYdXoUe602NoZcrLFIALgqKKk+d3M+00eyQzoDg7K2x2x45
         Gr+blmtN4iPTCG7DFGtfOJmaVkEo5JjwoAkDXdqc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiubo Li <xiubli@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.15 863/917] ceph: fix mdsmap decode when there are MDSs beyond max_mds
Date:   Mon, 15 Nov 2021 18:05:58 +0100
Message-Id: <20211115165458.290802129@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

commit 0e24421ac431e7af62d4acef6c638b85aae51728 upstream.

If the max_mds is decreased in a cephfs cluster, there is a window
of time before the MDSs are removed. If a map goes out during this
period, the mdsmap may show the decreased max_mds but still shows
those MDSes as in or in the export target list.

Ensure that we don't fail the map decode in that case.

Cc: stable@vger.kernel.org
URL: https://tracker.ceph.com/issues/52436
Fixes: d517b3983dd3 ("ceph: reconnect to the export targets on new mdsmaps")
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/mdsmap.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/fs/ceph/mdsmap.c
+++ b/fs/ceph/mdsmap.c
@@ -263,10 +263,6 @@ struct ceph_mdsmap *ceph_mdsmap_decode(v
 				goto nomem;
 			for (j = 0; j < num_export_targets; j++) {
 				target = ceph_decode_32(&pexport_targets);
-				if (target >= m->possible_max_rank) {
-					err = -EIO;
-					goto corrupt;
-				}
 				info->export_targets[j] = target;
 			}
 		} else {


