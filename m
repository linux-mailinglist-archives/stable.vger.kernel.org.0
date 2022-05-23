Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3C81531C13
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241273AbiEWRcy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241343AbiEWRaG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:30:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00A6443ADD;
        Mon, 23 May 2022 10:26:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2ABB861117;
        Mon, 23 May 2022 17:26:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05D0DC385AA;
        Mon, 23 May 2022 17:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326761;
        bh=cHKye3APs63Crox8rXLhOAyrVrl02kQX/7/MG+LcMoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j7GStGQjVVGHeoz416/6UN4moQsFlXukgPsXLQq24bUs3nwGUucMkDih9ZFHK4qXj
         qErZN6vVYsfdVeGgMxWYa9p2NoZwRxdY6OqduT2ZeoCd61pN5jtun75Pu3VxF7xIyj
         7uqZv7a3+XAwYd+6gA6w89AQV5oOz24A6DGt3d6c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wander Lairson Costa <wander@redhat.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.17 050/158] selinux: fix bad cleanup on error in hashtab_duplicate()
Date:   Mon, 23 May 2022 19:03:27 +0200
Message-Id: <20220523165838.999000773@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ondrej Mosnacek <omosnace@redhat.com>

commit 6254bd3db316c9ccb3b05caa8b438be63245466f upstream.

The code attempts to free the 'new' pointer using kmem_cache_free(),
which is wrong because this function isn't responsible of freeing it.
Instead, the function should free new->htable and clear the contents of
*new (to prevent double-free).

Cc: stable@vger.kernel.org
Fixes: c7c556f1e81b ("selinux: refactor changing booleans")
Reported-by: Wander Lairson Costa <wander@redhat.com>
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/ss/hashtab.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/security/selinux/ss/hashtab.c
+++ b/security/selinux/ss/hashtab.c
@@ -179,7 +179,8 @@ int hashtab_duplicate(struct hashtab *ne
 			kmem_cache_free(hashtab_node_cachep, cur);
 		}
 	}
-	kmem_cache_free(hashtab_node_cachep, new);
+	kfree(new->htable);
+	memset(new, 0, sizeof(*new));
 	return -ENOMEM;
 }
 


