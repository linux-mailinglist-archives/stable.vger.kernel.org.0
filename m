Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7592E6DEFDD
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbjDLIyo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231467AbjDLIym (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:54:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 149259007
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:54:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03149631CB
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:53:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12FC6C433D2;
        Wed, 12 Apr 2023 08:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289624;
        bh=3881UuZ4BoDLzMRCKa2SRC6G43q6RC6Vw50l3KLlNC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bdGbzyuk/rfHj3u4JGTzft5N8+uFPfWi8zjPSN0xRfhuSyPLEYlMvVY1nCGxBuuw2
         LVmNeuNUCEEaU2hj/IUMj1K77g+nOJcwmmruZORVgrr7iGw2a79psFlz/ecWwbnGgq
         3UrnRx2UNnEhbc8iyKklxtpU87Aa+GHLD45hQPV8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Liam Howlett <Liam.Howlett@oracle.com>
Subject: [PATCH 6.2 170/173] maple_tree: remove extra smp_wmb() from mas_dead_leaves()
Date:   Wed, 12 Apr 2023 10:34:56 +0200
Message-Id: <20230412082845.042823332@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>

commit 8372f4d83f96f35915106093cde4565836587123 upstream.

The call to mte_set_dead_node() before the smp_wmb() already calls
smp_wmb() so this is not needed.  This is an optimization for the RCU mode
of the maple tree.

Link: https://lkml.kernel.org/r/20230227173632.3292573-5-surenb@google.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Cc: stable@vger.kernel.org
Signed-off-by: Liam Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/maple_tree.c |    1 -
 1 file changed, 1 deletion(-)

--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -5500,7 +5500,6 @@ unsigned char mas_dead_leaves(struct ma_
 			break;
 
 		mte_set_node_dead(entry);
-		smp_wmb(); /* Needed for RCU */
 		node->type = type;
 		rcu_assign_pointer(slots[offset], node);
 	}


