Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F04014FCFC7
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349541AbiDLGij (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:38:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350274AbiDLGhw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:37:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D9CD13F9B;
        Mon, 11 Apr 2022 23:34:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97D6AB81B43;
        Tue, 12 Apr 2022 06:34:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8299C385A1;
        Tue, 12 Apr 2022 06:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745265;
        bh=0Xvo/FYcifaVUfTs3/xwXHOJ7VYRQ1FCx50940HjPqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sst5qVTl7aw/ph+DlTd3GG3IfrRUhX0ahBqRbZ1O3RokDFqZPxMlRCgzIL5oIC4rj
         OFCgQLzkaKKBtlYHLbI5monpAaAjdpQyOjJpxQAjfSSH6rE7hDI9cj1a7qVXcrRqBi
         J4pX7CfpWQKq43CLxn+Npe11xXA2jcy2BFhtwrdw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jordy Zomer <jordy@pwning.systems>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 037/171] dm ioctl: prevent potential spectre v1 gadget
Date:   Tue, 12 Apr 2022 08:28:48 +0200
Message-Id: <20220412062928.961467864@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062927.870347203@linuxfoundation.org>
References: <20220412062927.870347203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jordy Zomer <jordy@jordyzomer.github.io>

[ Upstream commit cd9c88da171a62c4b0f1c70e50c75845969fbc18 ]

It appears like cmd could be a Spectre v1 gadget as it's supplied by a
user and used as an array index. Prevent the contents of kernel memory
from being leaked to userspace via speculative execution by using
array_index_nospec.

Signed-off-by: Jordy Zomer <jordy@pwning.systems>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-ioctl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 1ca65b434f1f..b839705654d4 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -17,6 +17,7 @@
 #include <linux/dm-ioctl.h>
 #include <linux/hdreg.h>
 #include <linux/compat.h>
+#include <linux/nospec.h>
 
 #include <linux/uaccess.h>
 
@@ -1696,6 +1697,7 @@ static ioctl_fn lookup_ioctl(unsigned int cmd, int *ioctl_flags)
 	if (unlikely(cmd >= ARRAY_SIZE(_ioctls)))
 		return NULL;
 
+	cmd = array_index_nospec(cmd, ARRAY_SIZE(_ioctls));
 	*ioctl_flags = _ioctls[cmd].flags;
 	return _ioctls[cmd].fn;
 }
-- 
2.35.1



