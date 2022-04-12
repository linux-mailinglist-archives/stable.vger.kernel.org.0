Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2F974FDA45
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354849AbiDLH54 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359132AbiDLHmd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:42:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74EF355233;
        Tue, 12 Apr 2022 00:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22AC7B81B58;
        Tue, 12 Apr 2022 07:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A91C385A5;
        Tue, 12 Apr 2022 07:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649748016;
        bh=sC+yelsbh94fJQss7tqpXVH0tAA6PB+cx7LgaWENbnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F7926cvITvgsM7pzN2cmXb5age+GG9m5FaxjF9f8r8C91Wwpdi9DaPYwaYdRbJkrP
         7V95HDvgtDHJmm66+NsBR2/lVRvobnnw4z92w3+SvkyuGdpfmjOmz3p8+LH1zdhVg8
         guOYYA1SZDYjo5cDrq5gQ9ZVJOyQg3xRM20Ervuk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tim Gardner <tim.gardner@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>,
        Alok Prasad <palok@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>
Subject: [PATCH 5.17 290/343] qed: fix ethtool register dump
Date:   Tue, 12 Apr 2022 08:31:48 +0200
Message-Id: <20220412062959.698888922@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
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

From: Manish Chopra <manishc@marvell.com>

commit 20921c0c86092b4082c91bd7c88305da74e5520b upstream.

To fix a coverity complain, commit d5ac07dfbd2b
("qed: Initialize debug string array") removed "sw-platform"
(one of the common global parameters) from the dump as this
was used in the dump with an uninitialized string, however
it did not reduce the number of common global parameters
which caused the incorrect (unable to parse) register dump

this patch fixes it with reducing NUM_COMMON_GLOBAL_PARAMS
bye one.

Cc: stable@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>
Cc: "David S. Miller" <davem@davemloft.net>
Fixes: d5ac07dfbd2b ("qed: Initialize debug string array")
Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
Signed-off-by: Alok Prasad <palok@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Manish Chopra <manishc@marvell.com>
Reviewed-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/qlogic/qed/qed_debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/qlogic/qed/qed_debug.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_debug.c
@@ -489,7 +489,7 @@ struct split_type_defs {
 
 #define STATIC_DEBUG_LINE_DWORDS	9
 
-#define NUM_COMMON_GLOBAL_PARAMS	11
+#define NUM_COMMON_GLOBAL_PARAMS	10
 
 #define MAX_RECURSION_DEPTH		10
 


