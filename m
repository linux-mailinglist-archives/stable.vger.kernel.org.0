Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB855412596
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383517AbhITSq3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:46:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:56444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1383235AbhITSoR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:44:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0448663352;
        Mon, 20 Sep 2021 17:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159146;
        bh=++P4j04yCqS3g1hj7do2i9wlBMgZSdq1e4y6ILLc2xA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JVKBJw9RJ6AWSwJuy9kR1W7L88wU9o+EnKe5dw9/WePKRhFPGnCPE1QeQ4bPdRU6c
         ytKcJt0U505ltfddRbl2X5vuCrGO2fJD/hVjVM60v9FgwbnMLkWR19g7L8Cd0eiuTj
         gK894XWCg0nfEYcR86VrGeomrleRkIyK7vGmFqZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrea Claudi <aclaudi@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.14 065/168] selftest: net: fix typo in altname test
Date:   Mon, 20 Sep 2021 18:43:23 +0200
Message-Id: <20210920163923.775059056@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrea Claudi <aclaudi@redhat.com>

commit 1b704b27beb11ce147d64b21c914e57afbfb5656 upstream.

If altname deletion of the short alternative name fails, the error
message printed is: "Failed to add short alternative name".
This is obviously a typo, as we are testing altname deletion.

Fix this using a proper error message.

Fixes: f95e6c9c4617 ("selftest: net: add alternative names test")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/altnames.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/net/altnames.sh
+++ b/tools/testing/selftests/net/altnames.sh
@@ -45,7 +45,7 @@ altnames_test()
 	check_err $? "Got unexpected long alternative name from link show JSON"
 
 	ip link property del $DUMMY_DEV altname $SHORT_NAME
-	check_err $? "Failed to add short alternative name"
+	check_err $? "Failed to delete short alternative name"
 
 	ip -j -p link show $SHORT_NAME &>/dev/null
 	check_fail $? "Unexpected success while trying to do link show with deleted short alternative name"


