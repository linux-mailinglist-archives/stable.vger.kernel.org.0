Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4496DEEF2
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbjDLIqb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:46:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbjDLIq3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:46:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D61583E5
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:46:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E10E1630FA
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:46:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 023A3C433D2;
        Wed, 12 Apr 2023 08:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289166;
        bh=9jh4Wsyk0CX4D55AfrFbuDaWosDMOx4uwsUkGlHZO4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aO7OsyR04v/N3DLdjlzSbG2IPj9BMyhMnor1N//4AasdmHKgplRIsBv0vHQNLmurH
         5RTrwl+yjMceTWWdHAq0FK3oRAdJK/0S+KP7poAQoIJQOrY3SibuTGQD2G5+d7g5EX
         IeGfStWb/pw/15WAol28USIyzLrNJrCqEFlPwBWY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Liam Howlett <Liam.Howlett@oracle.com>
Subject: [PATCH 6.1 161/164] maple_tree: remove extra smp_wmb() from mas_dead_leaves()
Date:   Wed, 12 Apr 2023 10:34:43 +0200
Message-Id: <20230412082843.476610743@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
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
@@ -5495,7 +5495,6 @@ unsigned char mas_dead_leaves(struct ma_
 			break;
 
 		mte_set_node_dead(entry);
-		smp_wmb(); /* Needed for RCU */
 		node->type = type;
 		rcu_assign_pointer(slots[offset], node);
 	}


