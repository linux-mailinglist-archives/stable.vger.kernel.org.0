Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C43904F70ED
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 03:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239211AbiDGBXU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 21:23:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238843AbiDGBSi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 21:18:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4691A1A1281;
        Wed,  6 Apr 2022 18:13:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFECF61DB0;
        Thu,  7 Apr 2022 01:13:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E1B7C385A3;
        Thu,  7 Apr 2022 01:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649294021;
        bh=ssJYHvkpscxFMbUpBVyB4ceTVTGzImrTC1CGpjG5HWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jH5hi8qd6TU6B/t2r2BuTuLE9LQrfe7cJaNHyXfLco0ly50kVoLqmbM6xiU7KLGnv
         2sync81WJVzMRtsPz8nELaudbi81tMeltzAOzmjoj+6SZEg3qZ5wVo7ucJULbMMdGk
         gzcfM3GN5ko3SpLnqa0avTDfxyjzzR7DZQioX7E3j6UrnMGPi9Om3iwEtSzF9YuMRj
         XCdGiZB4q5PRyw3Eyjb79KFzLxrZbFOIBgApEUtcpLhrz6Lo4puT0fU00Ravq65O22
         8bdGwhBbhZne/UhVw2GryMoP7Pv8LSOxEvDh05zBFLM99hT0iEylIoy8IQ9Z8wqGT4
         7/Vk2Fap9YFxw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sasha Levin <sashal@kernel.org>, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.15 17/27] tools/virtio: compile with -pthread
Date:   Wed,  6 Apr 2022 21:12:47 -0400
Message-Id: <20220407011257.114287-17-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220407011257.114287-1-sashal@kernel.org>
References: <20220407011257.114287-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>

[ Upstream commit f03560a57c1f60db6ac23ffd9714e1c69e2f95c7 ]

When using pthreads, one has to compile and link with -lpthread,
otherwise e.g. glibc is not guaranteed to be reentrant.

This replaces -lpthread.

Reported-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/virtio/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/virtio/Makefile b/tools/virtio/Makefile
index 0d7bbe49359d..1b25cc7c64bb 100644
--- a/tools/virtio/Makefile
+++ b/tools/virtio/Makefile
@@ -5,7 +5,8 @@ virtio_test: virtio_ring.o virtio_test.o
 vringh_test: vringh_test.o vringh.o virtio_ring.o
 
 CFLAGS += -g -O2 -Werror -Wno-maybe-uninitialized -Wall -I. -I../include/ -I ../../usr/include/ -Wno-pointer-sign -fno-strict-overflow -fno-strict-aliasing -fno-common -MMD -U_FORTIFY_SOURCE -include ../../include/linux/kconfig.h
-LDFLAGS += -lpthread
+CFLAGS += -pthread
+LDFLAGS += -pthread
 vpath %.c ../../drivers/virtio ../../drivers/vhost
 mod:
 	${MAKE} -C `pwd`/../.. M=`pwd`/vhost_test V=${V}
-- 
2.35.1

