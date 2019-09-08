Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE42ACE27
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733294AbfIHMxE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:53:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:45774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733282AbfIHMxD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:53:03 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC9AC218AC;
        Sun,  8 Sep 2019 12:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567947183;
        bh=SHPKLkyJkeRbcX+FRqPqt5fBERaFbyTjQBQ+1tmaYwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2I2LPIRNQSXg19Pg/JPRCiG2NVz4s/pegRxm7LZmNhN7xU0z3pfVnsU5AacQjCjJC
         byvbS1/NhPfcMXgCA2kobfmlppjMbQXLWVVqraojLM7iiwLRJxgwwtsoD6R8redsqB
         L/81DQKI3vkPna9L9vHHSnx/7T2ddZ5GLNtOPsqg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luis Henriques <lhenriques@suse.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 91/94] libceph: allow ceph_buffer_put() to receive a NULL ceph_buffer
Date:   Sun,  8 Sep 2019 13:42:27 +0100
Message-Id: <20190908121153.033078574@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121150.420989666@linuxfoundation.org>
References: <20190908121150.420989666@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 5c498950f730aa17c5f8a2cdcb903524e4002ed2 ]

Signed-off-by: Luis Henriques <lhenriques@suse.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ceph/buffer.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/ceph/buffer.h b/include/linux/ceph/buffer.h
index 5e58bb29b1a36..11cdc7c60480f 100644
--- a/include/linux/ceph/buffer.h
+++ b/include/linux/ceph/buffer.h
@@ -30,7 +30,8 @@ static inline struct ceph_buffer *ceph_buffer_get(struct ceph_buffer *b)
 
 static inline void ceph_buffer_put(struct ceph_buffer *b)
 {
-	kref_put(&b->kref, ceph_buffer_release);
+	if (b)
+		kref_put(&b->kref, ceph_buffer_release);
 }
 
 extern int ceph_decode_buffer(struct ceph_buffer **b, void **p, void *end);
-- 
2.20.1



