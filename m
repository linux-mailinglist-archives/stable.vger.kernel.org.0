Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D42514F2F5F
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238405AbiDEIoG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241244AbiDEIc5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F70F1014;
        Tue,  5 Apr 2022 01:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 159C4B81BC5;
        Tue,  5 Apr 2022 08:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AB45C385A1;
        Tue,  5 Apr 2022 08:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147412;
        bh=Fk7dGV1XNcf85J/QIpn+aGzWIVRLnxGOtlxA3lFhd0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CmP01pywYClc6jB0WS+OTcLhdcHByT/p99gwnUZWFz7vMngCr2pQN1sI3/WzL8TA3
         GFPBQb6NHsGrArAsFBSLb5VCLLgFDQaA6aYoZbHSceSyGelyk6Fwv1pmM5MwquvddV
         Ha2mpZcPxJmwK3T8nE7BUkyIM2RdHmI7NiqudWTM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.17 1114/1126] xsk: Do not write NULL in SW ring at allocation failure
Date:   Tue,  5 Apr 2022 09:31:01 +0200
Message-Id: <20220405070440.130828569@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Magnus Karlsson <magnus.karlsson@intel.com>

commit a95a4d9b39b0324402569ed7395aae59b8fd2b11 upstream.

For the case when xp_alloc_batch() is used but the batched allocation
cannot be used, there is a slow path that uses the non-batched
xp_alloc(). When it fails to allocate an entry, it returns NULL. The
current code wrote this NULL into the entry of the provided results
array (pointer to the driver SW ring usually) and returned. This might
not be what the driver expects and to make things simpler, just write
successfully allocated xdp_buffs into the SW ring,. The driver might
have information in there that is still important after an allocation
failure.

Note that at this point in time, there are no drivers using
xp_alloc_batch() that could trigger this slow path. But one might get
added.

Fixes: 47e4075df300 ("xsk: Batched buffer allocation for the pool")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20220328142123.170157-2-maciej.fijalkowski@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xdp/xsk_buff_pool.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -584,9 +584,13 @@ u32 xp_alloc_batch(struct xsk_buff_pool
 	u32 nb_entries1 = 0, nb_entries2;
 
 	if (unlikely(pool->dma_need_sync)) {
+		struct xdp_buff *buff;
+
 		/* Slow path */
-		*xdp = xp_alloc(pool);
-		return !!*xdp;
+		buff = xp_alloc(pool);
+		if (buff)
+			*xdp = buff;
+		return !!buff;
 	}
 
 	if (unlikely(pool->free_list_cnt)) {


