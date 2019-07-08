Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2087762543
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732490AbfGHPQK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:16:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:38972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732485AbfGHPQJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:16:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F211E2166E;
        Mon,  8 Jul 2019 15:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562598969;
        bh=4Kk/spa2hF0gjWj0ksSjSFLkAF7rqXT7hdSaVHL1Gi8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fJFNQ9PLZZFhPElQCfZNncbGrTqA2elLITfQBILMnFc6H/UEKeqL6BPVYV3yIDgdz
         zP9Ba0dn4BkSF3/GjfIOr9eFE756wmntZYp1SQ6jOowXDxWZlrVFGhblfDa/GSEymU
         Ce6CXI41T8zHORk2+U7mUWPN7ac+YZRP8ELsSt10=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+7fddca22578bc67c3fe4@syzkaller.appspotmail.com,
        Eric Biggers <ebiggers@google.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.4 27/73] cfg80211: fix memory leak of wiphy device name
Date:   Mon,  8 Jul 2019 17:12:37 +0200
Message-Id: <20190708150522.423940950@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150513.136580595@linuxfoundation.org>
References: <20190708150513.136580595@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 4f488fbca2a86cc7714a128952eead92cac279ab upstream.

In wiphy_new_nm(), if an error occurs after dev_set_name() and
device_initialize() have already been called, it's necessary to call
put_device() (via wiphy_free()) to avoid a memory leak.

Reported-by: syzbot+7fddca22578bc67c3fe4@syzkaller.appspotmail.com
Fixes: 1f87f7d3a3b4 ("cfg80211: add rfkill support")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -447,7 +447,7 @@ use_default_name:
 				   &rdev->rfkill_ops, rdev);
 
 	if (!rdev->rfkill) {
-		kfree(rdev);
+		wiphy_free(&rdev->wiphy);
 		return NULL;
 	}
 


