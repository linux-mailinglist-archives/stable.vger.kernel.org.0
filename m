Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE3E6B4204
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbjCJN6w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:58:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231392AbjCJN6v (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:58:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4684BD4CA
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:58:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23606617B4
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:58:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37D1EC4339B;
        Fri, 10 Mar 2023 13:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456729;
        bh=CpiyB0KE4oedlvZbYzeZxrtOK5jpCAYmfI3DsnQgxOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dv+Dg2tB9DDH6WyNe1v2uAIlAo+sc2900lW/OIfxWCrX1hs4xlE1YRiqjBgyWZRvn
         6FNpDdWxSHhd2s7wx/gC505nY2AtI1db9V/x/3G8lrd8IAdiYzOie1yKZ+f75ykbz1
         bL/mrtZ44mxypA9IDkmv62JXstkASC7TMmzyWQF4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jiri Slaby <jirislaby@kernel.org>,
        George Kennedy <george.kennedy@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 103/211] vc_screen: modify vcs_size() handling in vcs_read()
Date:   Fri, 10 Mar 2023 14:38:03 +0100
Message-Id: <20230310133721.895926194@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
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

From: George Kennedy <george.kennedy@oracle.com>

[ Upstream commit 46d733d0efc79bc8430d63b57ab88011806d5180 ]

Restore the vcs_size() handling in vcs_read() to what
it had been in previous version.

Fixes: 226fae124b2d ("vc_screen: move load of struct vc_data pointer in vcs_read() to avoid UAF")
Suggested-by: Jiri Slaby <jirislaby@kernel.org>
Signed-off-by: George Kennedy <george.kennedy@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/vt/vc_screen.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/tty/vt/vc_screen.c b/drivers/tty/vt/vc_screen.c
index 71e091f879f0e..1dc07f9214d57 100644
--- a/drivers/tty/vt/vc_screen.c
+++ b/drivers/tty/vt/vc_screen.c
@@ -415,10 +415,8 @@ vcs_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 		 */
 		size = vcs_size(vc, attr, uni_mode);
 		if (size < 0) {
-			if (read)
-				break;
 			ret = size;
-			goto unlock_out;
+			break;
 		}
 		if (pos >= size)
 			break;
-- 
2.39.2



