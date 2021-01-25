Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60931304AB4
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729917AbhAZE6Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:58:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:36732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730580AbhAYStq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:49:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DA89206FA;
        Mon, 25 Jan 2021 18:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600546;
        bh=2YjE+dp1Alo2bwhA1p1z4ef8RTwtUwdJCJy5Ptv4S98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wKdLGFI48KwbKDApHhsmaTpydvnw8LZ3H07I3lMpmzwq3iuo7RC+Gk7t4Zl0G/M0w
         B6U1BzgZ3YWAtqxZmMd5Y1zupapR40f++/ayRkQNrfJNQNgGXpMMNYCm4tZ4UT1XRT
         OlYkC6O+vPri7uopuHATAbYMrh9C2lWn6jNxmeKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.10 026/199] dm integrity: fix a crash if "recalculate" used without "internal_hash"
Date:   Mon, 25 Jan 2021 19:37:28 +0100
Message-Id: <20210125183217.362508220@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit 2d06dfecb132a1cc2e374a44eae83b5c4356b8b4 upstream.

Recalculate can only be specified with internal_hash.

Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-integrity.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -4235,6 +4235,12 @@ try_smaller_buffer:
 			r = -ENOMEM;
 			goto bad;
 		}
+	} else {
+		if (ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING)) {
+			ti->error = "Recalculate can only be specified with internal_hash";
+			r = -EINVAL;
+			goto bad;
+		}
 	}
 
 	ic->bufio = dm_bufio_client_create(ic->meta_dev ? ic->meta_dev->bdev : ic->dev->bdev,


