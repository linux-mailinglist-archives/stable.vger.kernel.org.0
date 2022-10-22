Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF026087F8
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233050AbiJVIIR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232818AbiJVIGQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:06:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B242D6549;
        Sat, 22 Oct 2022 00:53:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4F2960BA5;
        Sat, 22 Oct 2022 07:43:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E96C433C1;
        Sat, 22 Oct 2022 07:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424630;
        bh=sMlQcK6UppnZaZaiO1W30seCru7s+7kjiXGTuxdCF+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DaLmg7+u6qsqwqH++qf9UZcqWW9WLC4hALelF+0BNvZ14sxZf3Y6Bw6qYVMMFqXlS
         kDlRxEACDhq1nYw8+MJG585xVSzhanKUMo5uSNCtBEWVjMYT0DEYeWFHBWhYfQ5XR/
         SQNQ1fwARx0MRCFUY4JkDwkkcrndaTdU7HjT5JnY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 217/717] selftests/xsk: Add missing close() on netns fd
Date:   Sat, 22 Oct 2022 09:21:36 +0200
Message-Id: <20221022072453.646112428@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit 8a7d61bdc2fac2c460a2f32a062f5c6dbd21a764 ]

Commit 1034b03e54ac ("selftests: xsk: Simplify cleanup of ifobjects")
removed close on netns fd, which is not correct, so let us restore it.

Fixes: 1034b03e54ac ("selftests: xsk: Simplify cleanup of ifobjects")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Link: https://lore.kernel.org/bpf/20220830133905.9945-1-maciej.fijalkowski@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index e5992a6b5e09..92e466310e27 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -1589,6 +1589,8 @@ static struct ifobject *ifobject_create(void)
 	if (!ifobj->umem)
 		goto out_umem;
 
+	ifobj->ns_fd = -1;
+
 	return ifobj;
 
 out_umem:
@@ -1600,6 +1602,8 @@ static struct ifobject *ifobject_create(void)
 
 static void ifobject_delete(struct ifobject *ifobj)
 {
+	if (ifobj->ns_fd != -1)
+		close(ifobj->ns_fd);
 	free(ifobj->umem);
 	free(ifobj->xsk_arr);
 	free(ifobj);
-- 
2.35.1



