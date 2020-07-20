Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D79B2266A2
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732924AbgGTQE7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:04:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:40164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732921AbgGTQE7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:04:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BD092064B;
        Mon, 20 Jul 2020 16:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261098;
        bh=kg2cfYSlACz1h2UN+y3/6qgPaDJ7uw3fZNv6Tmy/Qzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o06LTC3mwcQEThL3Ks1KL8Dyi+Kc7THSnz5sQ25CSKqn7jp2QBqTyLGM1k3pU6grZ
         zou4BLTn3P9NmKRIJdjbW4Y9XhtS6YHZobDlbY5d3mNyQowQZgOA39HKSQNMkAbmn9
         6i3lq2E+fq5h36Ts2/ymA0FPzXL+fD6Ldjps+gSo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 5.4 209/215] libceph: dont omit recovery_deletes in target_copy()
Date:   Mon, 20 Jul 2020 17:38:11 +0200
Message-Id: <20200720152830.097537004@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Dryomov <idryomov@gmail.com>

commit 2f3fead62144002557f322c2a7c15e1255df0653 upstream.

Currently target_copy() is used only for sending linger pings, so
this doesn't come up, but generally omitting recovery_deletes can
result in unneeded resends (force_resend in calc_target()).

Fixes: ae78dd8139ce ("libceph: make RECOVERY_DELETES feature create a new interval")
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ceph/osd_client.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -445,6 +445,7 @@ static void target_copy(struct ceph_osd_
 	dest->size = src->size;
 	dest->min_size = src->min_size;
 	dest->sort_bitwise = src->sort_bitwise;
+	dest->recovery_deletes = src->recovery_deletes;
 
 	dest->flags = src->flags;
 	dest->paused = src->paused;


