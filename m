Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16F873B6297
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233554AbhF1Osn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:48:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:51692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235665AbhF1Opc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:45:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA82C61D04;
        Mon, 28 Jun 2021 14:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890848;
        bh=SCIQqbUXqjLR3oFdEq2F2QswQmn+mdroBsp5TTtb8qY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CrK01kHBkjrnmaKjvNDrcS3X614wTLOVS0uicb4xFH5+yp8fQiZI48DN/JkrgZ8VY
         54KwzAqwkEi9gq6/UPqyoWLXmOIN3wlAR+Kcythk2MG3wISlUJLv/BIzL3A4xoRCmK
         Kw0N65C+El+3fdC34iSXbRkq3skb0iCzwrf97RcqdkluQdCxGWN3TRvmaCv/oeCjpZ
         oHEISYj7Bn0Q7VR7h47E4l1m8h0+VQT801VKOhBOJwF28HaV20jYEAeBVtbjJNNGzk
         8yQis9+Afb124CkIpzVev4Dtydzri+zCQfI0vqRrw5B/skrwUC994lsm8k0cYbsDkV
         jTFEymxkxB2qA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 070/109] cfg80211: make certificate generation more robust
Date:   Mon, 28 Jun 2021 10:32:26 -0400
Message-Id: <20210628143305.32978-71-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
References: <20210628143305.32978-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.196-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.196-rc1
X-KernelTest-Deadline: 2021-06-30T14:32+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit b5642479b0f7168fe16d156913533fe65ab4f8d5 upstream.

If all net/wireless/certs/*.hex files are deleted, the build
will hang at this point since the 'cat' command will have no
arguments. Do "echo | cat - ..." so that even if the "..."
part is empty, the whole thing won't hang.

Cc: stable@vger.kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210618133832.c989056c3664.Ic3b77531d00b30b26dcd69c64e55ae2f60c3f31e@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/Makefile b/net/wireless/Makefile
index 8158b375d170..4500ad5f2a61 100644
--- a/net/wireless/Makefile
+++ b/net/wireless/Makefile
@@ -27,7 +27,7 @@ $(obj)/shipped-certs.c: $(wildcard $(srctree)/$(src)/certs/*.hex)
 	@$(kecho) "  GEN     $@"
 	@(echo '#include "reg.h"'; \
 	  echo 'const u8 shipped_regdb_certs[] = {'; \
-	  cat $^ ; \
+	  echo | cat - $^ ; \
 	  echo '};'; \
 	  echo 'unsigned int shipped_regdb_certs_len = sizeof(shipped_regdb_certs);'; \
 	 ) > $@
-- 
2.30.2

