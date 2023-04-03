Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 368C66D47AF
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233128AbjDCOWg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233134AbjDCOWf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:22:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E682E2D7C2
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:22:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80864B81BAE
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:22:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA72C433EF;
        Mon,  3 Apr 2023 14:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531730;
        bh=RuYnVTJwWCkgS5pZsTRyfgbm1jPX/9A6YF9I++YlZ7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v/AoAcL6EcbkustODWHvPwUsLshbrIgBvjr1ufw6WvpLAtFqJcpWIOf5YfUojoS1y
         TDGJQQS9nPYpodigjHNaMZ/nh5pjYiA6ctwc1+H0LhFLSBcWux1LJ9apymPlkOliLp
         64tvevt5BBK/b0ONa6NfLK0ACjJ6SSCtdDxUk/BU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <error27@gmail.com>,
        NeilBrown <neilb@suse.de>, Song Liu <song@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 062/104] md: avoid signed overflow in slot_store()
Date:   Mon,  3 Apr 2023 16:08:54 +0200
Message-Id: <20230403140406.686598036@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140403.549815164@linuxfoundation.org>
References: <20230403140403.549815164@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: NeilBrown <neilb@suse.de>

[ Upstream commit 3bc57292278a0b6ac4656cad94c14f2453344b57 ]

slot_store() uses kstrtouint() to get a slot number, but stores the
result in an "int" variable (by casting a pointer).
This can result in a negative slot number if the unsigned int value is
very large.

A negative number means that the slot is empty, but setting a negative
slot number this way will not remove the device from the array.  I don't
think this is a serious problem, but it could cause confusion and it is
best to fix it.

Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index aa2993d5d5d38..64558991ce0a0 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3082,6 +3082,9 @@ slot_store(struct md_rdev *rdev, const char *buf, size_t len)
 		err = kstrtouint(buf, 10, (unsigned int *)&slot);
 		if (err < 0)
 			return err;
+		if (slot < 0)
+			/* overflow */
+			return -ENOSPC;
 	}
 	if (rdev->mddev->pers && slot == -1) {
 		/* Setting 'slot' on an active array requires also
-- 
2.39.2



