Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9192603CE8
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231869AbiJSIxr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231840AbiJSIxI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:53:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AC8084E6D;
        Wed, 19 Oct 2022 01:50:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D19461847;
        Wed, 19 Oct 2022 08:49:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BFC1C433D6;
        Wed, 19 Oct 2022 08:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169373;
        bh=EQlopx31BUyrGQu0oSTme+DKanTOBlcrCtNgTG0TuYw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=spyKqjnAMoV7cSajhGgG0miGWeh5vw0bNnC/ztKfEV8jheLQOplUpaLdy+7xV574A
         4+MseAQeZhGVAoOYNC2oL1MRr7hAlEyPlYL+f/aNd+2a0cZdz4/O3h+qTqvRQEIrgT
         KJN8BDhCjGjteGN1Ge6d8zmMf9Jo16z5teTbv5qs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 252/862] selftests/xsk: Add missing close() on netns fd
Date:   Wed, 19 Oct 2022 10:25:39 +0200
Message-Id: <20221019083301.174955152@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 tools/testing/selftests/bpf/xskxceiver.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index 74d56d971baf..091402dc5390 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -1606,6 +1606,8 @@ static struct ifobject *ifobject_create(void)
 	if (!ifobj->umem)
 		goto out_umem;
 
+	ifobj->ns_fd = -1;
+
 	return ifobj;
 
 out_umem:
@@ -1617,6 +1619,8 @@ static struct ifobject *ifobject_create(void)
 
 static void ifobject_delete(struct ifobject *ifobj)
 {
+	if (ifobj->ns_fd != -1)
+		close(ifobj->ns_fd);
 	free(ifobj->umem);
 	free(ifobj->xsk_arr);
 	free(ifobj);
-- 
2.35.1



