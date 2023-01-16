Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9E6A66CBFA
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234532AbjAPRU6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:20:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234418AbjAPRUl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:20:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE88556896
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:59:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8574A61058
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:59:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99011C433F1;
        Mon, 16 Jan 2023 16:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888361;
        bh=QkMRI/SgOyPz9Qyv4ptbzUf5Op7ZhmzVbMHW6MHTXoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i467D0KaS0Z+TdmJZuouLPD7hLz1pBMOmHpOXbTgPnkp3x45rogncdTEAlxRTPOBw
         R0xMcb/MsRdCY5TV8FYT8OqQfkVLbpE9q4dPLRixDw7MpHI/500l8aPK8BL9c0zi4F
         PriAv6CpiIb1+k/CVSJVfFaubYPkclOY+00Dr/do=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Ilia.Gavrilov" <Ilia.Gavrilov@infotecs.ru>,
        Simon Horman <simon.horman@corigine.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.19 500/521] netfilter: ipset: Fix overflow before widen in the bitmap_ip_create() function.
Date:   Mon, 16 Jan 2023 16:52:42 +0100
Message-Id: <20230116154909.557185550@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>

commit 9ea4b476cea1b7d461d16dda25ca3c7e616e2d15 upstream.

When first_ip is 0, last_ip is 0xFFFFFFFF, and netmask is 31, the value of
an arithmetic expression 2 << (netmask - mask_bits - 1) is subject
to overflow due to a failure casting operands to a larger data type
before performing the arithmetic.

Note that it's harmless since the value will be checked at the next step.

Found by InfoTeCS on behalf of Linux Verification Center
(linuxtesting.org) with SVACE.

Fixes: b9fed748185a ("netfilter: ipset: Check and reject crazy /0 input parameters")
Signed-off-by: Ilia.Gavrilov <Ilia.Gavrilov@infotecs.ru>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/ipset/ip_set_bitmap_ip.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/netfilter/ipset/ip_set_bitmap_ip.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ip.c
@@ -299,8 +299,8 @@ bitmap_ip_create(struct net *net, struct
 			return -IPSET_ERR_BITMAP_RANGE;
 
 		pr_debug("mask_bits %u, netmask %u\n", mask_bits, netmask);
-		hosts = 2 << (32 - netmask - 1);
-		elements = 2 << (netmask - mask_bits - 1);
+		hosts = 2U << (32 - netmask - 1);
+		elements = 2UL << (netmask - mask_bits - 1);
 	}
 	if (elements > IPSET_BITMAP_MAX_RANGE + 1)
 		return -IPSET_ERR_BITMAP_RANGE_SIZE;


