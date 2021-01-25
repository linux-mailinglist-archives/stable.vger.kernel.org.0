Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D939303337
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 05:48:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbhAZEsS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:48:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:33404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729890AbhAYSpc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:45:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C941C207B3;
        Mon, 25 Jan 2021 18:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600291;
        bh=5J84VumJ6d+AwkyH0Kkn0pbME9b2qF/uyBsinMi3Yd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AZf+U9uBW3lBoe7V2ucoqKdRSIux5lQeBzL9uykg5dew6kf6yMgOqRoPT9yCsCE7t
         3hZ0NqONxD27hwLE65w73YZNqer9DoB/wLfGhDvBlJv6gw2tvJJ+uyEsC+A0mqvrF+
         0tS1mznTiN4y438a/oQAAq9NnSXTMtZk/qgUFyHo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.4 14/86] dm integrity: fix a crash if "recalculate" used without "internal_hash"
Date:   Mon, 25 Jan 2021 19:38:56 +0100
Message-Id: <20210125183201.641281627@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183201.024962206@linuxfoundation.org>
References: <20210125183201.024962206@linuxfoundation.org>
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
@@ -4059,6 +4059,12 @@ try_smaller_buffer:
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


