Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49D736BB2F1
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232985AbjCOMk2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233094AbjCOMkG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:40:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 685A7A1FF6
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:38:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2442661D5C
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:38:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38DBFC4339B;
        Wed, 15 Mar 2023 12:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883915;
        bh=Knfqm61g8WyM5794wDVLrz+z6TXvHv91vD9Au2PUBvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fh3MazMCTRX9thSG2LvL8ROqMtuuwe+Kjr0fwZhW9OsZWSgpuepwF4KIMDjEIlavT
         zHPZz25aR5DT07aGGRoEmGcOO9Xij8QZkGn9Aw1ZCK/XRahkZ7mYEi4UQDgoM/h2En
         z2dG/ob8OK8oCfOeMqLu+lrA6A8+rG0uh4naogH4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andrey Vagin <avagin@openvz.org>,
        Christian Brauner <brauner@kernel.org>,
        Tobias Klauser <tklauser@distanz.ch>
Subject: [PATCH 6.2 008/141] fork: allow CLONE_NEWTIME in clone3 flags
Date:   Wed, 15 Mar 2023 13:11:51 +0100
Message-Id: <20230315115740.218293382@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
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

From: Tobias Klauser <tklauser@distanz.ch>

commit a402f1e35313fc7ce2ca60f543c4402c2c7c3544 upstream.

Currently, calling clone3() with CLONE_NEWTIME in clone_args->flags
fails with -EINVAL. This is because CLONE_NEWTIME intersects with
CSIGNAL. However, CSIGNAL was deprecated when clone3 was introduced in
commit 7f192e3cd316 ("fork: add clone3"), allowing re-use of that part
of clone flags.

Fix this by explicitly allowing CLONE_NEWTIME in clone3_args_valid. This
is also in line with the respective check in check_unshare_flags which
allow CLONE_NEWTIME for unshare().

Fixes: 769071ac9f20 ("ns: Introduce Time Namespace")
Cc: Andrey Vagin <avagin@openvz.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/fork.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2933,7 +2933,7 @@ static bool clone3_args_valid(struct ker
 	 * - make the CLONE_DETACHED bit reusable for clone3
 	 * - make the CSIGNAL bits reusable for clone3
 	 */
-	if (kargs->flags & (CLONE_DETACHED | CSIGNAL))
+	if (kargs->flags & (CLONE_DETACHED | (CSIGNAL & (~CLONE_NEWTIME))))
 		return false;
 
 	if ((kargs->flags & (CLONE_SIGHAND | CLONE_CLEAR_SIGHAND)) ==


