Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA5C3AEDDB
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232006AbhFUQXW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:23:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:42100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230028AbhFUQWE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:22:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9ABCD6124B;
        Mon, 21 Jun 2021 16:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292385;
        bh=FdBuja15jXd1e5GdfkHlQY2YUsroQZp+BQFsPaFQ/7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q7TZFsROxxRwbkvGoxWTioSpzTaS2AVSZl3835oa4JM3FWolobG3O/Us88HwHJU8j
         K40og7k2mRW3Z5ZzeXaY3H+BykpHMZHZ7UZqziXePCOxTdMbNd0orpiBDX8MI1sv9w
         avO9Zv60uQJmy54R/92CRIlf5ZBfM3grztfHMpPU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: [PATCH 5.4 70/90] cfg80211: make certificate generation more robust
Date:   Mon, 21 Jun 2021 18:15:45 +0200
Message-Id: <20210621154906.524503400@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154904.159672728@linuxfoundation.org>
References: <20210621154904.159672728@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 net/wireless/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/wireless/Makefile
+++ b/net/wireless/Makefile
@@ -28,7 +28,7 @@ $(obj)/shipped-certs.c: $(wildcard $(src
 	@$(kecho) "  GEN     $@"
 	@(echo '#include "reg.h"'; \
 	  echo 'const u8 shipped_regdb_certs[] = {'; \
-	  cat $^ ; \
+	  echo | cat - $^ ; \
 	  echo '};'; \
 	  echo 'unsigned int shipped_regdb_certs_len = sizeof(shipped_regdb_certs);'; \
 	 ) > $@


