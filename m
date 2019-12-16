Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD7C21213C8
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:05:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729736AbfLPSEy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:04:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:42482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729361AbfLPSEw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:04:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA4A520700;
        Mon, 16 Dec 2019 18:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519492;
        bh=ONcg6CTAx3FqBRp5JTfX2yR3lHqPGYWNzzkOB9RhOLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YUtpz3uz+hbfFBIXPlUlO6ayKMjuE4NYFhfQrBvN94HyNpEZhBjsUyHTUIUMTk6ff
         w6Y7k9EjPhnyW+u9y9uREctNjji61WRLW+Ni1aPxG0UXope1gpDTRjwRJPveBEKAYj
         SYTScCgWoLb1tO5BpOz3c8+p9KPzGRTSlSgE/UE4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maged Mokhtar <mmokhtar@petasan.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.19 051/140] dm writecache: handle REQ_FUA
Date:   Mon, 16 Dec 2019 18:48:39 +0100
Message-Id: <20191216174802.558576404@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174747.111154704@linuxfoundation.org>
References: <20191216174747.111154704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maged Mokhtar <mmokhtar@petasan.org>

commit c1005322ff02110a4df7f0033368ea015062b583 upstream.

Call writecache_flush() on REQ_FUA in writecache_map().

Cc: stable@vger.kernel.org # 4.18+
Signed-off-by: Maged Mokhtar <mmokhtar@petasan.org>
Acked-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-writecache.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -1223,7 +1223,8 @@ bio_copy:
 			}
 		} while (bio->bi_iter.bi_size);
 
-		if (unlikely(wc->uncommitted_blocks >= wc->autocommit_blocks))
+		if (unlikely(bio->bi_opf & REQ_FUA ||
+			     wc->uncommitted_blocks >= wc->autocommit_blocks))
 			writecache_flush(wc);
 		else
 			writecache_schedule_autocommit(wc);


