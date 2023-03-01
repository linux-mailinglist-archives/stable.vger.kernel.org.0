Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA2B86A72C7
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 19:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbjCASJd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 13:09:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230130AbjCASJ0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 13:09:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCBA14BE84
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 10:09:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8DBA5B810DB
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 18:09:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F380DC433EF;
        Wed,  1 Mar 2023 18:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677694154;
        bh=/tqhBr78bcSui9bM1khBVdsrHGX3cKbNcIv3aXYs4sc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kze/lfGlz/9L1Kkxt5sBSstHSXm6mNsIobEyW+qimc2c0vquMdsGQS579yvMqif6l
         xJA5XatNjsrvb39QNzcVcjDARH/h4nxU2ydRWhijdU1WtMnUCxWFuyKAHfJOeeq24k
         TMRoAAlFhYqzibvbAmAcloRsbOQlwoYSxA+20SxU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Storm Dragon <stormdragon2976@gmail.com>,
        =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.2 04/16] vc_screen: dont clobber return value in vcs_read
Date:   Wed,  1 Mar 2023 19:07:40 +0100
Message-Id: <20230301180653.432076305@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180653.263532453@linuxfoundation.org>
References: <20230301180653.263532453@linuxfoundation.org>
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

From: Thomas Weißschuh <linux@weissschuh.net>

commit ae3419fbac845b4d3f3a9fae4cc80c68d82cdf6e upstream.

Commit 226fae124b2d ("vc_screen: move load of struct vc_data pointer in
vcs_read() to avoid UAF") moved the call to vcs_vc() into the loop.

While doing this it also moved the unconditional assignment of

	ret = -ENXIO;

This unconditional assignment was valid outside the loop but within it
it clobbers the actual value of ret.

To avoid this only assign "ret = -ENXIO" when actually needed.

[ Also, the 'goto unlock_out" needs to be just a "break", so that it
  does the right thing when it exits on later iterations when partial
  success has happened - Linus ]

Reported-by: Storm Dragon <stormdragon2976@gmail.com>
Link: https://lore.kernel.org/lkml/Y%2FKS6vdql2pIsCiI@hotmail.com/
Fixes: 226fae124b2d ("vc_screen: move load of struct vc_data pointer in vcs_read() to avoid UAF")
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://lore.kernel.org/lkml/64981d94-d00c-4b31-9063-43ad0a384bde@t-8ch.de/
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vc_screen.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/tty/vt/vc_screen.c
+++ b/drivers/tty/vt/vc_screen.c
@@ -403,10 +403,11 @@ vcs_read(struct file *file, char __user
 		unsigned int this_round, skip = 0;
 		int size;
 
-		ret = -ENXIO;
 		vc = vcs_vc(inode, &viewed);
-		if (!vc)
-			goto unlock_out;
+		if (!vc) {
+			ret = -ENXIO;
+			break;
+		}
 
 		/* Check whether we are above size each round,
 		 * as copy_to_user at the end of this loop


