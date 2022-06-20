Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8C52551A64
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244626AbiFTNFr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244888AbiFTNEH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:04:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 664EE1704A;
        Mon, 20 Jun 2022 05:59:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 256FEB811B9;
        Mon, 20 Jun 2022 12:59:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69B1AC341C4;
        Mon, 20 Jun 2022 12:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729947;
        bh=6lvvz833Vj6N548GKBS9vgnbN0iGWG1CACzGXTabowE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VKAmi3j7tEbQ4BXgE+o6SpKJc8JGCaocE0ICmBkRHeybjH5n2GNKQF1oxkRcknCVp
         BBOawt/eOjzTEUdn0stLVc273mcoWgikssMDBPyg1YhIg2NXVC/ryLmKZ9GBqS2uB8
         z746kTos56oQ2XoMuYCgbyxVESEqp/MIFC7KcPKY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benjamin Marzinski <bmarzins@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 5.18 119/141] dm: fix race in dm_start_io_acct
Date:   Mon, 20 Jun 2022 14:50:57 +0200
Message-Id: <20220620124733.068967731@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Marzinski <bmarzins@redhat.com>

commit 10eb3a0d517fcc83eeea4242c149461205675eb4 upstream.

After commit 82f6cdcc3676c ("dm: switch dm_io booleans over to proper
flags") dm_start_io_acct stopped atomically checking and setting
was_accounted, which turned into the DM_IO_ACCOUNTED flag. This opened
the possibility for a race where IO accounting is started twice for
duplicate bios. To remove the race, check the flag while holding the
io->lock.

Fixes: 82f6cdcc3676c ("dm: switch dm_io booleans over to proper flags")
Cc: stable@vger.kernel.org
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -551,6 +551,10 @@ static void dm_start_io_acct(struct dm_i
 			return;
 		/* Can afford locking given DM_TIO_IS_DUPLICATE_BIO */
 		spin_lock_irqsave(&io->lock, flags);
+		if (dm_io_flagged(io, DM_IO_ACCOUNTED)) {
+			spin_unlock_irqrestore(&io->lock, flags);
+			return;
+		}
 		dm_io_set_flag(io, DM_IO_ACCOUNTED);
 		spin_unlock_irqrestore(&io->lock, flags);
 	}


