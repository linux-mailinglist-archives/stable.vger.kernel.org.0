Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7962324D6E
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 11:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233794AbhBYKAu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 05:00:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:34824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235515AbhBYJ6a (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Feb 2021 04:58:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78DB364F17;
        Thu, 25 Feb 2021 09:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614246897;
        bh=U0yKkXXoyeOfOxGD+VHPoEYk+aqobOW6r/YYfpZGwVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ct/OoncVyvE4r7r7aGnJ7/FnI2eyM0edQfPgU/tBMMRQW3Yl9QAIhTeENOIXDKStr
         CYeBc2yF8mcq/T21a9FbvE5z12KgGG5R5Kgh9eVbYuBJtKI+e88JZrUTiw+9AsV3CW
         /GU95nz7ZxUHqutiHm45kXTqsckom0InT5ASdpNU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luis Henriques <lhenriques@suse.de>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.10 07/23] ceph: downgrade warning from mdsmap decode to debug
Date:   Thu, 25 Feb 2021 10:53:38 +0100
Message-Id: <20210225092516.889427128@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210225092516.531932232@linuxfoundation.org>
References: <20210225092516.531932232@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luis Henriques <lhenriques@suse.de>

commit ccd1acdf1c49b835504b235461fd24e2ed826764 upstream.

While the MDS cluster is unstable and changing state the client may get
mdsmap updates that will trigger warnings:

  [144692.478400] ceph: mdsmap_decode got incorrect state(up:standby-replay)
  [144697.489552] ceph: mdsmap_decode got incorrect state(up:standby-replay)
  [144697.489580] ceph: mdsmap_decode got incorrect state(up:standby-replay)

This patch downgrades these warnings to debug, as they may flood the logs
if the cluster is unstable for a while.

Signed-off-by: Luis Henriques <lhenriques@suse.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/mdsmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ceph/mdsmap.c
+++ b/fs/ceph/mdsmap.c
@@ -243,8 +243,8 @@ struct ceph_mdsmap *ceph_mdsmap_decode(v
 		}
 
 		if (state <= 0) {
-			pr_warn("mdsmap_decode got incorrect state(%s)\n",
-				ceph_mds_state_name(state));
+			dout("mdsmap_decode got incorrect state(%s)\n",
+			     ceph_mds_state_name(state));
 			continue;
 		}
 


