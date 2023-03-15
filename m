Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC5BA6BB153
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232481AbjCOM0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232483AbjCOM0L (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:26:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 298C499D55
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:25:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C559B61D49
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:24:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEAA3C433D2;
        Wed, 15 Mar 2023 12:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883090;
        bh=fFxqEhm8dXNgEEsfJ8IsbnkMeIDNMJOncIRmJ4/BUHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qw0zvRhnT1Z7NmaBLpZFnHLOAD+0yw2YdShBxelbvLIXxOx1Tc0DKalet154uRy+9
         +AP0lKM7CwuKM9O6htqqj5rmK12mzD+zD0tpmZIsyF3HKGJSvi1JL41Zdde6sHf6N7
         ojWYec0F5DsDLqRAlcapLT6/kekrJT7m2CUZxaS4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andrey Vagin <avagin@openvz.org>,
        Christian Brauner <brauner@kernel.org>,
        Tobias Klauser <tklauser@distanz.ch>
Subject: [PATCH 5.15 004/145] fork: allow CLONE_NEWTIME in clone3 flags
Date:   Wed, 15 Mar 2023 13:11:10 +0100
Message-Id: <20230315115739.123920723@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
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
@@ -2829,7 +2829,7 @@ static bool clone3_args_valid(struct ker
 	 * - make the CLONE_DETACHED bit reusable for clone3
 	 * - make the CSIGNAL bits reusable for clone3
 	 */
-	if (kargs->flags & (CLONE_DETACHED | CSIGNAL))
+	if (kargs->flags & (CLONE_DETACHED | (CSIGNAL & (~CLONE_NEWTIME))))
 		return false;
 
 	if ((kargs->flags & (CLONE_SIGHAND | CLONE_CLEAR_SIGHAND)) ==


