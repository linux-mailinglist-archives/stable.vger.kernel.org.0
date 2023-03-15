Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 438B76BB220
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:33:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232545AbjCOMdU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232658AbjCOMdC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:33:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B34479E309
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:32:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73471B81DF6
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:32:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1C49C433EF;
        Wed, 15 Mar 2023 12:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883520;
        bh=QhYMsPxVN7sLTahaZdmEOE43AfATqhV27/TwAaBnIg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qe5E3d41H/4ajUlR7H+q3izAmgEu2deb73HBhayaMaHqZhmM4l6wdwHx+vV+HAMcf
         lUEeIoONb6R1jX0fZtQVKHGtsq5vLxXXdYtre+iuIcvImX1EHj97OxnHhV/7QwJxtk
         pfEtgWUw8KyFjzyHcbqfkA22driU6Fkb2/tP+yRQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 030/143] fs: dlm: fix log of lowcomms vs midcomms
Date:   Wed, 15 Mar 2023 13:11:56 +0100
Message-Id: <20230315115741.423246507@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
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

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 3e54c9e80e68b765d8877023d93f1eea1b9d1c54 ]

This patch will fix a small issue when printing out that
dlm_midcomms_start() failed to start and it was printing out that the
dlm subcomponent lowcomms was failed but lowcomms is behind the midcomms
layer.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Stable-dep-of: aad633dc0cf9 ("fs: dlm: start midcomms before scand")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lockspace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index bae050df7abff..04e1b4fe366dc 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -391,7 +391,7 @@ static int threads_start(void)
 	/* Thread for sending/receiving messages for all lockspace's */
 	error = dlm_midcomms_start();
 	if (error) {
-		log_print("cannot start dlm lowcomms %d", error);
+		log_print("cannot start dlm midcomms %d", error);
 		goto scand_fail;
 	}
 
-- 
2.39.2



